local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)
local Images = require(ReplicatedStorage.Source.Roact.Data.Images)


local CreateElement = Roact.createElement
local CreateRef = Roact.createRef

-- ROACT COMPONENTS
local FrameTitle = require(ReplicatedStorage.Source.Roact.Components.Titles.FrameTitle)
local RobuxItems2 = require(ReplicatedStorage.Source.Roact.Components.CreateCardComponents.RobuxItems)
-- Constants
local RoduxStores = ReplicatedStorage.Source.Roact.Rodux

-- RODUX STORES:
local Stores = {}
for _,Store in ipairs (RoduxStores:GetChildren()) do
    Stores[Store.Name] = require(Store)
end


local CreateCardFrame = Roact.Component:extend("CreateCardFrame")

function CreateCardFrame:init(Props)
    print(Props)
end

function CreateCardFrame:didMount()

end

function CreateCardFrame:render()
    -- ROBUX ITEMS --
    local RobuxItems = {}

    RobuxItems["UILayout"] = CreateElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0.025, 0),
    })

    for index, Gamepass in ipairs (self.props.Gamepasses) do
        local AssetId = Gamepass.Item.AssetId
        local Price = Gamepass.Product.PriceInRobux

        -- Create element.
        RobuxItems[index] = CreateElement(RobuxItems2, {
            Price = Price,
            AssetId = AssetId
        })
    end
    for index, TShirt in ipairs (self.props.TShirts) do
        local AssetId = TShirt.id
        local Price = TShirt.price

        -- Create element.
        -- Create element.
        RobuxItems[index] = CreateElement(RobuxItems2, {
            Price = Price,
            AssetId = AssetId
        })
    end

    return CreateElement("ImageLabel", {
        Size = UDim2.fromScale(0.5, 0.7),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = Images.BoothFrame.Background,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(Vector2.new(50, 50), Vector2.new(50, 50)),
        BackgroundTransparency = 1,
        Visible = false,
    }, {
        Title = CreateElement(FrameTitle, {
            Title = "create card",
        }),

        ChildHolder = CreateElement("Frame", {
            Size = UDim2.fromScale(0.9, 0.8),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
        }, {
            UIListLayout = CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Vertical,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.1, 0),
            }),

            PaperSkinFrame = CreateElement("ImageLabel", {
                Size = UDim2.fromScale(0.9, 0.3),
                Image = Images.BoothFrame.Rectangle,
                BackgroundTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(Vector2.new(50, 50), Vector2.new(50, 50))
            }),
    
            RobuxCostFrame = CreateElement("ImageLabel", {
                Size = UDim2.fromScale(0.9, 0.3),
                Image = Images.BoothFrame.Rectangle,
                BackgroundTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(Vector2.new(50, 50), Vector2.new(50, 50))
            }, {
                ScrollFrame = CreateElement("ScrollingFrame", {
                    Size = UDim2.fromScale(0.9, 0.9),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    ScrollingDirection = Enum.ScrollingDirection.X,
                    AutomaticCanvasSize = Enum.AutomaticSize.X,
                    ScrollingEnabled = true,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.fromScale(#RobuxItems*0.2, 0)
                }, RobuxItems)
            }),
        })
        

    })
end

function CreateCardFrame:didUpdate(PrevProps, PrevState)

end

CreateCardFrame = RoactRodux.connect(
    function(state, props)
        return {
            Gamepasses = state.Gamepasses,
            TShirts = state.TShirts,
            CardCreation = state.CardCreation
        }
    end,
    function(dispatch)
        return {}
    end
)(CreateCardFrame)

return CreateCardFrame