local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Rodux = require(Packages.Rodux)
local TblUtil = require(Packages.TblUtil)
local Knit = require(Packages.Knit)
Knit.OnStart():await()
local PlayerService = Knit.GetService("PlayerService")

local function Reducer(state,action)
    state = state or {
        Gamepasses = {},
        TShirts = {},
        CardCreation = {
            Message = "default noob",
            ProductId = 1,
            KillCount = 10,
        }
    }

    if action.type == "Update TShirts" then
        state.TShirts = action.TShirts
    elseif action.type == "Update Gamepasses" then
        state.Gamepasses = action.Gamepasses
    elseif action.type == "Set ProductId" then
        state.CardCreation.ProductId = action.ProductId
    elseif action.type == "Set KillCount" then
        state.CardCreation.KillCount = action.KillCount
    elseif action.type == "Set Message" then
        state.CardCreation.Message = action.Message
    end

    return state
end


local CreateCard = Rodux.Store.new(Reducer)

PlayerService.Gamepasses:Observe(function(GPS: {})
    CreateCard:dispatch{
        type = "Update Gamepasses",
        Gamepasses = GPS
    }
end)

PlayerService.TShirts:Observe(function(TS: {})
    CreateCard:dispatch{
        type = "Update TShirts",
        TShirts = TS
    }
end)

return CreateCard