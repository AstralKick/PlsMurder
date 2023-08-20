local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
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

    local function setBooth(Player: Player)
        local allBooths = BoothComponent:GetAll()
        local SortedBooths = {}
    
        for _,Comp in pairs (allBooths) do
            SortedBooths[Comp.loc] = Comp
        end

        for _,Comp in ipairs (SortedBooths) do
            if Comp.owner then continue end
            Comp:Claim(Player)
            break
        end
    end

    for i,v in ipairs (Players:GetPlayers()) do
        setBooth(v)
    end
    Players.PlayerAdded:Connect(setBooth)
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
    local BountyCards = select(2, DataService:GetKey(owner, "BountyCards"):await())

    return true, BountyCards
end

function BoothService.Client:CreateBountyCard(Creator: Player, AttachedItem: number, KillCount: number, WantedFor: string, PaperType: string)
    local StarCreator = if Creator:GetRankInGroup(4199740) > 0 then true else false
    local isVerified = Creator.HasVerifiedBadge

    local BountyCard = {
        UserId = Creator.UserId,
        Verified = isVerified,
        StarCreator = StarCreator,
        KillCount = KillCount,
        Message = WantedFor,
        PaperType = PaperType or "Basic",
        ItemId = 8825267035,
        SessionLocked = false,
        DisplayType = nil,
        DisplayNumber = nil,
    }

    local BountyCards = select(2, DataService:GetKey(Creator, "BountyCards"):await())
    local UniqueId = HttpService:GenerateGUID(false)
    BountyCards[UniqueId] = BountyCard

    DataService:SetKey(Player, "BountyCards", BountyCards):await()

    return true
end

return BoothService