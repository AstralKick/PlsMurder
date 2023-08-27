local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local Images = require(ReplicatedStorage.Source.Roact.Data.Images)

local CreateElement = Roact.createElement

-- Constants
local RoduxStores = ReplicatedStorage.Source.Roact.Rodux

-- RODUX STORES:
local Stores = {}
for _,Store in ipairs (RoduxStores:GetChildren()) do
    Stores[Store.Name] = require(Store)
end

local RobuxItems = Roact.PureComponent:extend("RobuxItems")

function RobuxItems:init(props)

end

function RobuxItems:render()
    local AssetId = self.props.AssetId
    local Price = self.props.Price

    return CreateElement("ImageLabel", {
        Size = UDim2.fromScale(0.7, 0.7),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        Image = Images.AddCoinsFrame.PurchaseButton,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(Vector2.new(50, 50), Vector2.new(50, 50)),
        BackgroundTransparency = 1,
        LayoutOrder = -Price,
    }, {
        SetButton = CreateElement("TextButton", {
            Size = UDim2.fromScale(0.8, 0.8),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Text = ` {Price}`,
            BackgroundTransparency = 1,
            [Roact.Event.Activated] = function()
                Stores.CreateCard:dispatch{
                    type = "Set ProductId",
                    ProductId = AssetId
                }
            end,
        }),
    })
end

return RobuxItems