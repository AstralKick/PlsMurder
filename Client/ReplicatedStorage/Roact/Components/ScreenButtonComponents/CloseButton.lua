local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)

local CreateElement = Roact.createElement

-- Constants
local RoduxStores = ReplicatedStorage.Source.Roact.Rodux
local Images = require(ReplicatedStorage.Source.Roact.Data.Images)

-- RODUX STORES:
local Stores = {}
for _,Store in ipairs (RoduxStores:GetChildren()) do
    Stores[Store.Name] = require(Store)
end

local function CloseButton(props)
    return CreateElement("ImageButton", {
        Size = UDim2.fromScale(0.065, 0.065),
        SizeConstraint = Enum.SizeConstraint.RelativeXX,
        Position = UDim2.fromScale(0.975, -0.025),
        Image = Images.CloseButton,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        [Roact.Event.Activated] = function()
            SoundService.SFX.Close:Play()
            props.callback()
        end,
    })
end

return CloseButton