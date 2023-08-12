local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)

-- Constants
local GenericButton = require(script.Parent.ScreenButtonComponents.GenericButton)

-- Roact Methods:
local CreateElement = Roact.createElement
local CreateRef = Roact.createRef

local ScreenButtons = Roact.Component:extend("ScreenButtons")

local LeftButtons = {
    "Bounty",
    "Invite",
    "Codes",
    "Settings",
}
local RightButtons = {
    "Servers",
    "Shop",
    "Customise",
    "Rewards"
}



function ScreenButtons:init(Props: {})

end

function ScreenButtons:didMount()

end

function ScreenButtons:shouldUpdate(nextProps, nextState)

end

function ScreenButtons:render()
    local RightFrameLayout = {}
    RightFrameLayout["List"] = CreateElement("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.05, 0)
    })
    for _,ButtonName in ipairs (RightButtons) do
        RightFrameLayout[ButtonName] = CreateElement(GenericButton, {
            Hover = false,
            MouseDown = false,
            MouseUp = true,
            Name = ButtonName
        })
    end



    local LeftFrameLayout = {}
    LeftFrameLayout["List"] = CreateElement("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.05, 0)
    })
    for _,ButtonName in ipairs (LeftButtons) do
        LeftFrameLayout[ButtonName] = CreateElement(GenericButton, {
            Hover = false,
            MouseDown = false,
            MouseUp = true,
            Name = ButtonName
        })
    end



    return CreateElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    }, {
        LeftFrame = CreateElement("Frame", {
            Size = UDim2.fromScale(0.05, 0.4),
            Position = UDim2.fromScale(0.025, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
        }, LeftFrameLayout),
        RightFrame = CreateElement("Frame", {
            Size = UDim2.fromScale(0.05, 0.4),
            Position = UDim2.fromScale(0.925, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
        }, RightFrameLayout),
    })
end

ScreenButtons = RoactRodux.connect(
    function(state,props)
        return {

        }
    end,
    function(dispatch)
        return {

        }
    end
)(ScreenButtons)

return ScreenButtons