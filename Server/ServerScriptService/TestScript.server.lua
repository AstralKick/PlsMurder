local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local ApiRequestsModule = require(ServerStorage.Source.Util.ApiRequests)

Players.PlayerAdded:Connect(function(Player: Player)
    local PlayerClass = ApiRequestsModule.new(Player)

    PlayerClass:GetItems()
    ApiRequestsModule:GetLikes()
end)