local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Rodux = require(Packages.Rodux)
local TblUtil = require(Packages.TblUtil)
local Knit = require(Packages.Knit)
Knit.OnStart():await()
local DataService = Knit.GetService("DataService")

local function Reducer(state,action)
    state = state or {
        Open = false,
        Profile = {},
    }

    if action.type == "Open" then
        state.Open = not state.Open
    elseif action.type == "Profile Update" then
        state.Profile = action.Profile
    end

    return state
end


local BountyFrame = Rodux.Store.new(Reducer)

DataService.Profile:Observe(function(data)
    BountyFrame:dispatch{
        type = "Profile Update",
        Profile = data
    }
end)


return BountyFrame