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

local KillCounts = Roact.PureComponent:extend("KillCounts")

function KillCounts:init(props)
    self.Ref = Roact.createRef()
end

function KillCounts:didMount()

end

function KillCounts:render()
    local KillCount = self.props.KillCount

    return CreateElement("ImageLabel", {
        Size = UDim2.fromScale(0.9, 0.9),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        Image = Images.AddCoinsFrame.PurchaseButton,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(Vector2.new(50, 50), Vector2.new(50, 50)),
        BackgroundTransparency = 1,
        LayoutOrder = KillCount,
        [Roact.Ref] = self.Ref
    }, {
        SetButton = CreateElement("TextButton", {
            Size = UDim2.fromScale(0.8, 0.8),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Text = `{KillCount} Kills`,
            BackgroundTransparency = 1,
            [Roact.Event.Activated] = function()
                Stores.CreateCard:dispatch{
                    type = "Set KillCount",
                    KillCount = KillCount
                }
            end,
        }),
    })
end

return KillCounts