local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

local newTrove = Trove.new()

local Blur = Instance.new("BlurEffect")
Blur.Parent = Lighting
Blur.Size = 0

local BlurModule = {}

function BlurModule:On(Size: number)
    newTrove:Clean()
    local newTween = TweenService:Create(Blur, TweenInfo.new(0.5), {Size = Size or 15})
    newTrove:Add(function()
        newTween:Cancel()
    end)
    newTween:Play()
end

function BlurModule:Off()
    newTrove:Clean()
    local newTween = TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0})
    newTrove:Add(function()
        newTween:Cancel()
    end)
    newTween:Play()
end

return BlurModule