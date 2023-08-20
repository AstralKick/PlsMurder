local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)

-- Constants
local RoduxStores = ReplicatedStorage.Source.Roact.Rodux
local ComponentFolder = ReplicatedStorage.Source.Roact.Components


-- Roact methods:
local CreateElement = Roact.createElement

-- RODUX STORES:
local Stores = {}
for _,Store in ipairs (RoduxStores:GetChildren()) do
    Stores[Store.Name] = require(Store)
end

-- COMPONENTS:
local Components = {}
for _,Component in ipairs (ComponentFolder:GetChildren()) do
    if not Component:IsA("ModuleScript") then continue end
    Components[Component.Name] = require(Component)
end

local MainUI = CreateElement("ScreenGui", {ResetOnSpawn = false}, {
    -- INDIVIDUAL TREE WORKFLOW: ADD ROACT/RODUX TREES HERE WHERE NEEDED.


    ScreenButtons = CreateElement(RoactRodux.StoreProvider, {
        store = Stores.ButtonStore
    }, {
        Screen = CreateElement(Components.ScreenButtons),
    }), 
    BountyFrame = CreateElement(RoactRodux.StoreProvider, {
        store = Stores.BountyFrame,
    }, {
        BountyFrame = CreateElement(Components.BountyFrame),
    })
    -------------------------------------------------------
})

return MainUI