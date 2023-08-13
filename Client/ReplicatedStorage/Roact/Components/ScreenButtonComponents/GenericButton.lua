local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)
local Images = require(ReplicatedStorage.Source.Roact.Data.Images)
local SFX = SoundService.SFX

-- Constants
local RoduxStores = ReplicatedStorage.Source.Roact.Rodux

-- RODUX STORES:
local Stores = {}
for _,Store in ipairs (RoduxStores:GetChildren()) do
    Stores[Store.Name] = require(Store)
end

-- Roact Methods:
local CreateElement = Roact.createElement
local CreateRef = Roact.createRef

local GenericButton = Roact.Component:extend("GenericButton")

function GenericButton:init()
    self.ref = CreateRef()
end

function GenericButton:didMount()
    self.mouseDownTween = TweenService:Create(self.ref:getValue(), TweenInfo.new(0.1), {Size = UDim2.fromScale(0.75, 0.75)})
    self.mouseUpTween = TweenService:Create(self.ref:getValue(), TweenInfo.new(0.1), {Size = UDim2.fromScale(1, 1)})
    self.hoverOn = TweenService:Create(self.ref:getValue(), TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(200, 200, 200)})
    self.hoverOff = TweenService:Create(self.ref:getValue(), TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(255, 255, 255)})
end

function GenericButton:willUpdate(nextProps, nextState)
    local Button = self.ref:getValue()

    if nextProps.MouseDown and not self.props.MouseDown then
        self.mouseDownTween:Play()
    elseif not nextProps.MouseDown and self.props.MouseDown then
        self.mouseUpTween:Play()
        SFX.ButtonClick:Play()
    end
    if nextProps.Hover and not self.props.Hover then
        self.hoverOn:Play()
    elseif not nextProps.Hover and self.props.Hover then
        self.hoverOff:Play()
    end

end

function GenericButton:render()
    local image = Images.ScreenButtons[self.props.Name]
    

    return CreateElement("ImageButton", {
        Size = UDim2.fromScale(1, 1),
        SizeConstraint = Enum.SizeConstraint.RelativeXX,
        BackgroundTransparency = 1,
        Image = image,
        [Roact.Ref] = self.ref,
        [Roact.Event.MouseButton1Down] = function()
            Stores.ButtonStore:dispatch{
                type = "buttonDown",
                buttonName = self.props.Name,
                isDown = true,
            }
        end,
        [Roact.Event.MouseButton1Up] = function()
            Stores.ButtonStore:dispatch{
                type = "buttonDown",
                buttonName = self.props.Name,
                isDown = false,
            }
        end,
        [Roact.Event.MouseEnter] = function()
            Stores.ButtonStore:dispatch{
                type = "hover",
                buttonName = self.props.Name,
                isHovering = true,
            }
        end,
        [Roact.Event.MouseLeave] = function()
            Stores.ButtonStore:dispatch{
                type = "hover",
                buttonName = self.props.Name,
                isHovering = false,
            }
        end,
    }, {
        Title = CreateElement("TextLabel", {
            Size = UDim2.fromScale(1, 0.2),
            Position = UDim2.fromScale(0, 0.9),
            BackgroundTransparency = 1,
            Font = Enum.Font.FredokaOne,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = self.props.Name,
            TextScaled = true,
            Rotation = -5,
        }, {
            UIStroke = CreateElement("UIStroke", {
                Thickness = 1,
                Color = Color3.fromRGB(0,0,0)
            })
        })
    })
end

GenericButton = RoactRodux.connect(
    function(state, props)
        return {
            Hover = state[props.Name].Hover,
            MouseDown = state[props.Name].MouseDown,
        }
    end,
    function(dispatch)
        return {

        }
    end
)(GenericButton)

return GenericButton