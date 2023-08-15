local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local Booth = require(ReplicatedStorage.Source.Components.Booth)

local BoothController = Knit.CreateController{
    Name = "BoothController",
}

function BoothController:KnitStart()
    BoothService = Knit.GetService("BoothService")

    BoothService.ClaimBooth:Connect(function(BoothFolder: Folder, BountyCards: {})
        local boothComponent = Booth:FromInstance(BoothFolder)
        boothComponent:Claimed(BountyCards)
    end)

    BoothService.ClearBooth:Connect(function(BoothFolder: Folder)
        local boothComponent = Booth:FromInstance(BoothFolder)
        boothComponent:Clear()
    end)
end

return BoothController