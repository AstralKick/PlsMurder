local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local TblUtil = require(Packages.TblUtil)

local BoothComponent = require(ServerStorage.Source.Components.Booth)

local BoothService = Knit.CreateService{
    Name = "BoothService",
    Client = {
        UpdateBooth = Knit.CreateSignal(), -- Sends signal with the BOOTH and the ITEMS, tells client component to update.
        ClaimBooth = Knit.CreateSignal(),
        ClearBooth = Knit.CreateSignal(),
    }
}


function BoothService:KnitStart()
    DataService = Knit.GetService("DataService")
end

function BoothService:Claimed(Player: Player)
    local BoothComps = BoothComponent:GetAll()
    for i,v in ipairs (BoothComps) do
        if v.owner == Player then
            v:Clear()
        end
    end
end

function BoothService.Client:GetOwner(Player: Player, Booth: Folder)
    local boothData = BoothComponent:FromInstance(Booth)
    return boothData.owner
end

function BoothService.Client:GetUpdatedItems(Player: Player, Booth: Folder)
    local boothData = BoothComponent:FromInstance(Booth)
    local owner = boothData.owner
    if not owner then return false end
    local BoothDisplay = select(2, DataService:GetKey(owner, "BoothDisplay"):await())
    local CabinetDisplay = select(2, DataService:GetKey(owner, "BoothDisplay"):await())
    local MostWantedDisplay = select(2, DataService:GetKey(owner, "BoothDisplay"):await())

    return true, BoothDisplay, CabinetDisplay, MostWantedDisplay
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

    local CurrentPersonalBounties = select(2, DataService:GetKey(Creator, "PersonalBounties"):await())
    table.insert(CurrentPersonalBounties, TblUtil.Copy(CurrentPersonalBounties, true))

    return true
end

return BoothService