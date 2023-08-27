local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local HttpService = game:GetService("HttpService")
local TblUtil = require(Packages.TblUtil)
local Promise = require(Packages.Promise)

local CardService = Knit.CreateService{
    Name = "CardService",
    Client = {
        FavouriteCard = Knit.CreateSignal(),
        DeleteCard = Knit.CreateSignal(),
        UnfavouriteCard = Knit.CreateSignal(),
        CardProperty = Knit.CreateProperty({})
    },
    PlayerWantedLevels = {},
}

function CardService:KnitStart()
    DataService = Knit.GetService("DataService")

    self.Client.FavouriteCard:Connect(function(Player: Player, GUID: string)
        self:FavouriteCard(Player, GUID)
    end)
    self.Client.DeleteCard:Connect(function(Player: Player, GUID: string)
        self:DeleteCard(Player, GUID)
    end)
    self.Client.UnfavouriteCard:Connect(function(Player: Player, GUID: string)
        self:Unfavourite(Player, GUID)
    end)
end

function CardService:UpdateWantedLevel(UserId: number, WantedLevel: number)
    self.PlayerWantedLevels[UserId] = WantedLevel
    self.Client.CardProperty:Set(self.PlayerWantedLevels)
end

function CardService:AddCard(CardTable: {}, newCardTable: {})
    local newCardId = HttpService:GenerateGUID(false)

    CardTable[newCardId] = TblUtil.Copy(newCardTable, true)
    return CardTable
end

function CardService:FavouriteCard(Player: Player, GUID: string)
    local Cards = select(2, DataService:GetKey(Player, "BountyCards"):await())
    Cards[GUID].Favourited = true
    DataService:SetKey(Player, "BountyCards", Cards):await()
end

function CardService:Unfavourite(Player: Player, GUID: string)
    local Cards = select(2, DataService:GetKey(Player, "BountyCards"):await())
    Cards[GUID].Favourited = false
    DataService:SetKey(Player, "BountyCards", Cards):await()
end

function CardService:DeleteCard(Player: Player, GUID: string)
    local Cards = select(2, DataService:GetKey(Player, "BountyCards"):await())
    local Cards2 = select(2, DataService:GetKey(Player, "CompletedBounties"):await())
    Cards[GUID] = nil
    Cards2[GUID] = nil
    DataService:SetKey(Player, "BountyCards", Cards):await()
    DataService:SetKey(Player, "CompletedBounties", Cards2):await()
end

function CardService:RemoveCard(CardTable: {}, BountyCardId: string)
    CardTable[BountyCardId] = nil
    return CardTable
end

function CardService:CreateCard(Player: Player, CardTable: table)
    local Cards = select(2, DataService:GetKey(Player, "BountyCards"):await())

    local CardTableNew = {
        UserId = Player.UserId,
        Verified = Player.HasVerifiedBadge,
        StarCreator = Player:IsInGroup(4199740) or false,
        KillCount = CardTable.KillCount,
        Message = CardTable.Message,
        PaperType = "Basic", -- TBC?
        ItemId = CardTable.ProductId,
        SessionLocked = false,
        DisplayType = nil,
        DisplayNumber = nil
    }

    local newTbl = self:AddCard(Cards, CardTableNew)

    DataService:SetKey(Player, "BountyCards", newTbl):await()
end

function CardService.Client:CreateCard(Player: Player, CardTabl: {})
    self.Server:CreateCard(Player, CardTabl)
    return true
end


return CardService