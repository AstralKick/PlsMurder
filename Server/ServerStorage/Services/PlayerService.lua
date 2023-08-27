local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)

local PlayerService = Knit.CreateService{
    Name = "PlayerService",
    Client = {
        Gamepasses = Knit.CreateProperty({}),
        TShirts = Knit.CreateProperty({}),
    }
}

function PlayerService:KnitStart()
    local function initPlayer(Player: Player)
        Player:AddTag("PLAYER")
    end

    for i,v in ipairs (Players:GetPlayers()) do
        initPlayer(v)
    end
    Players.PlayerAdded:Connect(initPlayer)
end

function PlayerService:Update(Player: Player, Gamepasses: {}, TShirts: {})
    self.Client.Gamepasses:SetFor(Player, Gamepasses)
    self.Client.TShirts:SetFor(Player, TShirts)
end

return PlayerService