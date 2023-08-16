local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local Comm = require(Packages.Comm)
local API = require(ServerStorage.Source.Components.Api)
local Trove = require(Packages.Trove)
local TblUtil = require(Packages.TblUtil)


local PurchaseService = Knit.CreateService{
    Name = "PurchaseService",
    Client = {
        SessionLocked = Knit.CreateProperty(false)
    },
    ActiveSessions = {},
}


--[[
    This service manages purchases of the items that players are selling. It will ultimately increase the worth of that item over time - it will also transfer the ownership of the card to another player.
]]


function PurchaseService:KnitStart()
    DataService = Knit.GetService("DataService")
    CardService = Knit.GetService("CardService")

    MarketplaceService.PromptPurchaseFinished:Connect(function(Player: Player, AssetId: number, isPurchased: boolean)
        if not self.ActiveSessions[Player] then return end
        local ItemUID = self.ActiveSessions[Player].BountyCardId
        local Seller = self.ActiveSessions[Player].Seller
        if isPurchased then
            warn(`{Player.Name} has successfully made a purchase of the asset {AssetId}`)
            self.Client.SessionLocked:SetFor(Player, false)
            self:TransferCard(Seller, Player, ItemUID)
            warn(`SESSION LOCK FOR {Player.Name} REMOVED`)
            
            -- SOMETHING HERE TO HANDLE INCREASE IN DONATION FIGURE-------
        else
            warn(`{Player.Name} has failed a purchase of the asset {AssetId}`)
            self.Client.SessionLocked:SetFor(Player, false)
            self:RemoveLock(Seller, ItemUID)
            warn(`SESSION LOCK FOR {Player.Name} REMOVED`)
        end
    end)

    Players.PlayerRemoving:Connect(function(Player: Player)
        if self.ActiveSessions[Player] then
            self:RemoveLock(self.ActiveSessions[Player].Seller, self.ActiveSessions[Player].BountyCardId)
            table.clear(self.ActiveSessions[Player])
            self.ActiveSessions[Player] = nil
        end
    end)
end

function PurchaseService:RemoveLock(Seller: Player, BountyCardId: string)
    local SellerStore = select(2, DataService:GetKey(Seller, "BountyCards"):await())
    SellerStore[BountyCardId].SessionLocked = false
    DataService:SetKey(Seller, "BountyCards", SellerStore):await()
end

function PurchaseService:TransferCard(previousOwner: Player, newOwner: Player, CardId: number)
    local previousOwnerStore = select(2, DataService:GetKey(previousOwner, "BountyCards"):await())
    local newOwnerStore = select(2, DataService:GetKey(newOwner, "BountyCards"):await())
    local CardToTransfer = TblUtil.Copy(previousOwnerStore[CardId], true)

    newOwnerStore = CardService:AddCard(newOwnerStore, CardToTransfer)
    previousOwnerStore = CardService:RemoveCard(previousOwnerStore, CardId)

    DataService:SetKey(previousOwner, "BountyCards", previousOwnerStore):catch(warn)
    DataService:SetKey(newOwner, "BountyCards", newOwnerStore):catch(warn)

end

function PurchaseService.Client:InitPurchase(Player: Player, Seller: Player, BountyCardId: number)
    if self.SessionLocked:GetFor(Player) then return false, `{Player.Name} is already session locked, must complete current transaction.` end
    
    local SellerStore = select(2, DataService:GetKey(Seller, "BountyCards"):await())

    if not SellerStore[BountyCardId] then return false, `Bounty Card doesn't exist in the seller's inventory` end
    if SellerStore[BountyCardId].SessionLocked then return false, `Bounty Card is session locked, someone else is purchasing` end

    local ItemId = SellerStore[BountyCardId].ItemId
    self.SessionLocked:SetFor(Player, true)
    SellerStore[BountyCardId].SessionLocked = true
    DataService:SetKey(Seller, "BountyCards", SellerStore):await()

    --Creates a session lock on the server table to stop the player from making any other purchase.
    self.Server.ActiveSessions[Player] = {
        Buyer = Player,
        Seller = Seller,
        BountyCardId = BountyCardId,
    }

    MarketplaceService:PromptPurchase(Player, ItemId)


    return true, `{Player.Name} can purchase the item.`
end

return PurchaseService