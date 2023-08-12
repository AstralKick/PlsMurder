local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Rodux = require(Packages.Rodux)
local TblUtil = require(Packages.TblUtil)

local defaultTable = {
    Hover = false,
    MouseDown = false,
    MouseUp = true,
}

local function Reducer(state, action)
    state = state or {
        Bounty = TblUtil.Copy(defaultTable, true),
        Invite = TblUtil.Copy(defaultTable, true),
        Codes = TblUtil.Copy(defaultTable, true),
        Settings = TblUtil.Copy(defaultTable, true),
        Servers = TblUtil.Copy(defaultTable, true),
        Shop = TblUtil.Copy(defaultTable, true),
        Customise = TblUtil.Copy(defaultTable, true),
        Rewards = TblUtil.Copy(defaultTable, true),
    }

    if action.type ==  "buttonDown" then
        local buttonName = action.buttonName
        state[buttonName].MouseDown = action.isDown
    elseif action.type == "hover" then
        local buttonName = action.buttonName
        state[buttonName].Hover = action.isHovering
        state[buttonName].MouseDown = if not action.isHovering then action.isHovering else state[buttonName].MouseDown
    end

    return state
end


local ButtonStore = Rodux.Store.new(Reducer)

return ButtonStore