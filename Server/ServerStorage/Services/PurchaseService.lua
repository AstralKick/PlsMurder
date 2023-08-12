local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local Comm = require(Packages.Comm)
local API = require(ServerStorage.Source.Components.Api)


local PurchaseService = Knit.CreateService{
    Name = "PurchaseService",
    Client = {

    },
}

function PurchaseService:KnitStart()

end

return PurchaseService