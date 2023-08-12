local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local TblUtil = require(Packages.TblUtil)

local BoothService = Knit.CreateService{
    Name = "BoothService",
    Client = {

    }
}


function BoothService:KnitStart()
    DataService = Knit.GetService("DataService")
end


function BoothService.Client:CreateBountyCard(Creator: Player, AttachedItem: number, KillCount: number, WantedFor: string)
    local StarCreator = if Creator:GetRankInGroup(4199740) > 0 then true else false
    local isVerified = Creator.HasVerifiedBadge

    local BountyCard = {
        Player = Creator.UserId,
        Pose = "Standard",
        BountyValue = 0,
        KillCount = KillCount,
        Verified = isVerified,
        StarCreator = StarCreator
    }

    local CurrentPersonalBounties = DataService:GetKey(Creator, "PersonalBounties"):await()
    table.insert(CurrentPersonalBounties, TblUtil.Copy(CurrentPersonalBounties, true)):await()

    return true
end

return BoothService