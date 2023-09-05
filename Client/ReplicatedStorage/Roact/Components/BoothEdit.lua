local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)

local CreateElement = Roact.createElement
local CreateRef = Roact.createRef


local BoothBox = Roact.Component:extend('BoothEdit')

function BoothBox:init(props: {})

end

function BoothBox:didMount()

end

function BoothBox:didUpdate(prevProps, prevState)
    
end

function BoothBox:render()

end

return BoothBox