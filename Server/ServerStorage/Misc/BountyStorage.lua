local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Knit = require(Packages.Knit)
local HttpService = require(ServerStorage.Source.Misc.HttpService)


Knit.OnStart():await()
local CardService = Knit.GetService('CardService')

local BountyStore = {}

function BountyStore:UpdateBounty()

end

function BountyStore:GetBounty(UserId: number, avoidCache: boolean)
    local Request = HttpService:GetAsync(`https://pls-murder-default-rtdb.firebaseio.com/users/{UserId}.json`)

    Request:andThen(function(Response)
        local BountyAmount = tonumber(Response.Body)
        CardService:UpdateWantedLevel(UserId, BountyAmount)
        return BountyAmount
    end, function(fail)
        return 0
    end):await()
end

function BountyStore:IncreaseBounty(UserId: number, Amount: number)
    local Bounty = self:GetBounty(UserId, true)
    Amount += Bounty
    HttpService:SetAsync(`https://pls-murder-default-rtdb.firebaseio.com/users/{UserId}.json`, tostring(Amount)):andThen(function(Result)
        print(Result)
    end):catch(warn)
end

return BountyStore