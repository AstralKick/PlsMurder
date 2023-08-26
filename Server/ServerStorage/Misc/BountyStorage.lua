local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local Knit = require(Packages.Knit)


local Requests = {
    "https://pls-murder-default-rtdb.firebaseio.com/users/6143375.json", -- Get player bounty number (returns number in string format)
    "https://pls-murder-default-rtdb.firebaseio.com/users/6143375.json", -- PUT with number (updates number just send the number as a string)
}

Knit.OnStart():await()

local BountiesSaved = {}

local BountyStore = {}

function BountyStore:UpdateBounty()

end

function BountyStore:GetBounty(UserId: number)

end

return BountyStore