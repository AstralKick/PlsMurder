local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local Knit = require(Packages.Knit)

-- Methods
local CreateElement = Roact.createElement
local CreateRef = Roact.createRef

local BountyCard = Roact.PureComponent:extend("BountyCard")
local PurchaseService

Knit.OnStart():andThen(function()
    PurchaseService = Knit.GetService("PurchaseService")
end):catch(warn)

function BountyCard:init()

end

function BountyCard:didMount()

end

function BountyCard:render()
    local Adornee = self.props.Adornee
    local UserId = self.props.UserId
    local Verified = self.props.Verified
    local StarCreator = self.props.StarCreator
    local KillCount = self.props.KillCount
    local Message = self.props.Message
    local PaperType = self.props.PaperType
    local ItemId = self.props.ItemId
    local BountyId = self.props.GUID
    local owner = self.props.owner
    

    return CreateElement("SurfaceGui", {
        ResetOnSpawn = false,
        Adornee = Adornee,
        AlwaysOnTop = true,
    }, {
        CreateElement("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://14414161215"
    }, {
        WantedMessage = CreateElement("TextLabel", {
            Size = UDim2.fromScale(0.8, 0.15),
            Position = UDim2.fromScale(0.5, 0.05),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Oswald,
            Text = "WANTED",
            TextScaled = true,
        }),
        PlayerIcon = CreateElement("ImageLabel", {
            Size = UDim2.fromScale(0.7, 0.3),
            Position = UDim2.fromScale(0.5, 0.2),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Image = "rbxthumb://type=AvatarHeadShot&id=6143375&w=420&h=420" -- PLACEHOLDER.
        }),
        PlayerName = CreateElement("TextLabel", {
            Size = UDim2.fromScale(0.8, 0.1),
            Position = UDim2.fromScale(0.5, 0.4),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Oswald,
            Text = "AstraI_YT",
            TextScaled = true,
        }),
        PriceFrame = CreateElement("Frame", {
            Size = UDim2.fromScale(0.8, 0.2),
            Position = UDim2.fromScale(0.5, 0.75),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
        }, {
            ListLayout = CreateElement("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.05, 0),
            }),
            CoinImg = CreateElement("ImageLabel", {
                Size = UDim2.fromScale(0.4, 1),
                BackgroundTransparency = 1,
                Image = "rbxassetid://14414211263",
            }),
            Price = CreateElement("TextLabel", {
                Size = UDim2.fromScale(0.55, 1),
                TextScaled = true,
                BackgroundTransparency = 1,
                Font = Enum.Font.Oswald,
                Text = "5000" -- Price to be updated. PLACEHOLDER.
            }),
        }),
        OverlayButton = CreateElement("TextButton", {
            Size = UDim2.fromScale(1, 1),
            Text = "",
            BackgroundTransparency = 1,
            [Roact.Event.Activated] = function()
                PurchaseService:InitPurchase(owner, BountyId):andThen(function(Result, Message)
                    -- Do result stuff here.
                    if Result then
                        print(Message)
                    else
                        print(Message)
                    end
                end)
            end,
        })
      })
    })
end

return BountyCard