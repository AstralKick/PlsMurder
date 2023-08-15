local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local HttpService = game:GetService("HttpService")
local TblUtil = require(Packages.TblUtil)

local CardService = Knit.CreateService{
    Name = "CardService",
    Client = {},
}

function CardService:KnitStart()

end

function CardService:AddCard(CardTable: {}, newCardTable: {})
    local newCardId = HttpService:GenerateGUID(false)

    CardTable[newCardId] = TblUtil.Copy(newCardTable, true)
    return CardTable
end

function CardService:RemoveCard(CardTable: {}, BountyCardId: string)
    CardTable[BountyCardId] = nil
    return CardTable
end

return CardService