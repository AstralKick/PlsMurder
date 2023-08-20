local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local Knit = require(Packages.Knit)
local SFX = SoundService:WaitForChild("SFX")

-- Methods
local CreateElement = Roact.createElement
local CreateRef = Roact.createRef

local Images = require(ReplicatedStorage.Source.Roact.Data.Images)

local BountyCard = Roact.PureComponent:extend("BountyCard")
local PurchaseService
local CardService

Knit.OnStart():andThen(function()
    PurchaseService = Knit.GetService("PurchaseService")
    CardService = Knit.GetService("CardService")
end):catch(warn)

function BountyCard:init()
    self.Ref = CreateRef()
end

function BountyCard:didMount()

end

function BountyCard:willUnmount()

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
    
    
    return CreateElement("Frame", {
        Size = self.props.CardSize,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        [Roact.Ref] = self.Ref
    }, {
        CreateElement("ImageLabel", {
        Size = UDim2.fromScale(1, 0.8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://14414161215"
    }, {
        WantedMessage = CreateElement("TextLabel", {
            Size = UDim2.fromScale(0.8, 0.15),
            Position = UDim2.fromScale(0.5, 0.05),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.FredokaOne,
            Text = "WANTED",
            TextScaled = true,
        }),
        PlayerIcon = CreateElement("ImageLabel", {
            Size = UDim2.fromScale(0.7, 0.3),
            Position = UDim2.fromScale(0.5, 0.2),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Image = `rbxthumb://type=AvatarHeadShot&id={UserId}&w=420&h=420` -- PLACEHOLDER.
        }),
        PlayerName = CreateElement("TextLabel", {
            Size = UDim2.fromScale(0.8, 0.1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.FredokaOne,
            TextColor3 = Color3.fromRGB(0, 0, 0),
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
                FillDirection = Enum.FillDirection.Horizontal,
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
                Font = Enum.Font.FredokaOne,
                TextColor3 = Color3.fromRGB(0, 0, 0),
                Text = "5000" -- Price to be updated. PLACEHOLDER.
            }),
        }),
      }),
      -- Favourite/Delete Buttons
      ButtonFrames = CreateElement("Frame", {
        Size = UDim2.fromScale(1, 0.2),
        Position = UDim2.fromScale(0, 0.8),
        BackgroundTransparency = 1,
      }, {
        ListLayout = CreateElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0.1, 0),
        }),
        FavouriteButton = CreateElement("ImageButton", {
            Size = UDim2.fromScale(0.8, 0.8),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Image = Images.BountiesFrame.Favourite,
            BackgroundTransparency = 1,
            Visible = self.props.Favouriteable,
            [Roact.Event.Activated] = function()
                SFX.Sparkle:Play()
                CardService.FavouriteCard:Fire(BountyId)
            end,
        }),
        DeleteButton = CreateElement("ImageButton", {
            Size = UDim2.fromScale(0.8, 0.8),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Image = Images.BountiesFrame.Delete,
            BackgroundTransparency = 1,
            [Roact.Event.Activated] = function()
                SFX.Delete:Play()
                if self.props.Favourited then
                    CardService.UnfavouriteCard:Fire(BountyId)
                else
                    CardService.DeleteCard:Fire(BountyId)
                end
            end,
        })
      })
    })
end

return BountyCard