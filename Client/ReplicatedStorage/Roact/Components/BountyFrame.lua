local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)
local BlurModule = require(ReplicatedStorage.Source.Modules.BlurHandler)
local TblUtil = require(Packages.TblUtil)

-- Constants
local CreateElement = Roact.createElement
local CreateRef = Roact.createRef
local Images = require(ReplicatedStorage.Source.Roact.Data.Images)

-- Component References
local CloseButton = require(ReplicatedStorage.Source.Roact.Components.ScreenButtonComponents.CloseButton)
local FrameTitle = require(ReplicatedStorage.Source.Roact.Components.Titles.FrameTitle)
local WantedComponent = require(ReplicatedStorage.Source.Roact.Components.Bounties.WantedComponent2)

local function InnerFrame(props)
    local BountyCards = props.BountyCards or {}
    local Children = {}

    Children["ListLayout"] = CreateElement("UIListLayout", {
        FillDirection = props.FillDirection,
        Padding = UDim.new(0.025, 0),
        HorizontalAlignment = props.HorizontalAlignment,
        VerticalAlignment = props.VerticalAlignment,
    }) 

    for GUID, CardDetails in pairs (BountyCards) do
        Children[GUID] = CreateElement(WantedComponent, {
            GUID = GUID,
            UserId = CardDetails.UserId,
            KillCount = CardDetails.KillCount,
            Message = CardDetails.Message,
            PaperType = CardDetails.PaperType,
            Verified = CardDetails.Verified,
            StarCreator = CardDetails.StarCreator,
            Favouriteable = props.Favouriteable,
            CardSize = props.CardSize,
            Favourited = props.Favourited
        })
    end

    return CreateElement("ImageLabel", {
        Size = props.Size,
        Position = props.Position,
        Image = Images.BountiesFrame.Rectangle,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(Vector2.new(50, 50), Vector2.new(50, 50))
    }, {
        ScrollingFrame = CreateElement("ScrollingFrame", {
            Size = UDim2.fromScale(0.95, 0.95),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
        }, Children)
    })
end

local function Title(props)
    return CreateElement("TextLabel", {
        Size = UDim2.fromScale(0.5, 0.1),
        Position = UDim2.fromScale(0.5, -0.2),
        AnchorPoint = Vector2.new(0.5, 0),
        TextScaled = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.FredokaOne,
        Text = props.Text,
        BackgroundTransparency = 1,
        LayoutOrder = props.LayoutOrder,
    })
end

-- Constants
local RoduxStores = ReplicatedStorage.Source.Roact.Rodux

-- RODUX STORES:
local Stores = {}
for _,Store in ipairs (RoduxStores:GetChildren()) do
    Stores[Store.Name] = require(Store)
end


local BountyFrame = Roact.Component:extend("BountyFrame")

function BountyFrame:init(props)
    self.Ref = CreateRef()
end

function BountyFrame:didMount()

end

function BountyFrame:willUpdate(nextprops,nextstate)
    if not nextprops.Open then
        self.Ref:getValue():TweenSize(UDim2.fromScale(0.56*0.9, 0.68*0.9), "In", "Back", 0, true)
        BlurModule:Off()
    else
        self.Ref:getValue():TweenSize(UDim2.fromScale(0.56, 0.68), "Out", "Back", 0.3, true)
        BlurModule:On(15)
    end
end

function BountyFrame:render()
    local BountyCardProps = self.props.Profile.BountyCards or {}

    -- Bounty Card Separator
    local BountyCards = {}
    local FavouritedBountyCards = {}

    for GUID, Card in pairs (BountyCardProps) do
        if Card.Favourited then
            FavouritedBountyCards[GUID] = TblUtil.Copy(Card, true)
        else
            BountyCards[GUID] = TblUtil.Copy(Card, true)
        end
    end


    return CreateElement("ImageLabel", {
        Size = UDim2.fromScale(0.56*0.9, 0.68*0.9),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = Images.BountiesFrame.Background,
        BackgroundTransparency = 1,
        [Roact.Ref] = self.Ref,
        Visible = self.props.Open
    }, {
        FrameTitle = CreateElement(FrameTitle, {
            Title = "bounties",
        }),
        -- Children
        CloseButton =  CreateElement(CloseButton, {
            callback = function()
                Stores.BountyFrame:dispatch{
                    type = "Open"
                }
            end,
        }),
        -- Favourited Frame
        FavouritedFrame = CreateElement("Frame", {
            Size = UDim2.fromScale(0.28, 0.9),
            Position = UDim2.fromScale(0.05, 0.05),
            BackgroundTransparency = 1,
        }, {
            UIList = CreateElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            Title = CreateElement(Title, {
                Text = "favorited",
                LayoutOrder = -1,
            }),
            FavouritedFrame = CreateElement(InnerFrame, {
                Size = UDim2.fromScale(1, 0.9),
                Position = UDim2.fromScale(0.05, 0.2),
                Favouriteable = false,
                FillDirection = Enum.FillDirection.Vertical,
                BountyCards = FavouritedBountyCards,
                CardSize = UDim2.fromScale(0.9, 0.5),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Favourited = true,
            }),
        }),

        -- Active Bounties
        Bounties = CreateElement("Frame", {
            Size = UDim2.fromScale(0.62, 0.9),
            Position = UDim2.fromScale(0.35, 0.05),
            BackgroundTransparency = 1,
        }, {
            UIList = CreateElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0.0725, 0)
            }),

            -- Active Frame
            ActiveBounties = CreateElement("Frame", {
                Size = UDim2.fromScale(1, 0.435),
                Position = UDim2.fromScale(0.05, 0.05),
                BackgroundTransparency = 1,
                LayoutOrder = 1,
            }, {
                UIList = CreateElement("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                }),
                Title = CreateElement(Title, {
                    Text = "active bounties",
                    LayoutOrder = -1,
                }),
                CompletedFrame = CreateElement(InnerFrame, {
                    Size = UDim2.fromScale(1, 0.9),
                    Position = UDim2.fromScale(0.05, 0.2),
                    BountyCards = BountyCards,
                    Favouriteable = true,
                    FillDirection = Enum.FillDirection.Horizontal,
                    CardSize = UDim2.fromScale(0.2, 0.95),
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
            }),
            -- Completed Frame
            CompletedBounties = CreateElement("Frame", {
                Size = UDim2.fromScale(1, 0.435),
                Position = UDim2.fromScale(0.05, 0.05),
                BackgroundTransparency = 1,
                LayoutOrder = 2,
            }, {
                UIList = CreateElement("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                }),
                Title = CreateElement(Title, {
                    Text = "completed bounties",
                    LayoutOrder = -1,
                }),
                CompletedFrame = CreateElement(InnerFrame, {
                    Size = UDim2.fromScale(1, 0.9),
                    Position = UDim2.fromScale(0.05, 0.2),
                    BountyCards = self.props.Profile.CompletedBounties,
                    Favouriteable = false,
                    FillDirection = Enum.FillDirection.Horizontal,
                    CardSize = UDim2.fromScale(0.2, 0.95),
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
            }),
        })
    })
end

BountyFrame = RoactRodux.connect(
    function(state, props)
        return {
            Open = state.Open,
            Profile = state.Profile,
        }
    end
)(BountyFrame)

return BountyFrame