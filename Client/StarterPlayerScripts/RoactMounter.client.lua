local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)

local RoactFolder = ReplicatedStorage.Source.Roact

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

Roact.setGlobalConfig{
    elementTracing = true
}

local Tree = require(RoactFolder.Tree)

Roact.mount(Tree, PlayerGui)