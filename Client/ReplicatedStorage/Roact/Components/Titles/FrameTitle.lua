local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)

local CreateElement = Roact.createElement


local function Title(props)
    return CreateElement("TextLabel", {
      Size = UDim2.fromScale(0.25, 0.2),
      Position = UDim2.fromScale(-0.05, -0.1),
      TextScaled = true,
      TextColor3 = Color3.fromRGB(255, 255, 255),
      Font = Enum.Font.FredokaOne, 
      Text = props.Title,
      Rotation = -5,
      BackgroundTransparency = 1,
      TextWrapped = false
    }, {
        UIStroke = CreateElement("UIStroke", {
            Thickness = 1,
            Color = Color3.fromRGB(0, 0, 0)
        })
    })
end

return Title