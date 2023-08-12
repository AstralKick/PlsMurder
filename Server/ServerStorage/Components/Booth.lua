local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Knit = require(Packages.Knit)
local Trove = require(Packages.Trove)
local Promise = require(Packages.Promise)

local Booth = Component.new{ Tag = "Booth" }

function Booth:Construct()
    self.ClaimPart = self.Instance.ClaimPart

    self.Prompt = Instance.new("ProximityPrompt")
    self.Prompt.ActionText = "Claim Booth"
    self.Prompt.HoldDuration = 2
    self.Prompt.RequiresLineOfSight = false
    self.Prompt.Parent = self.ClaimPart

    DataService = Knit.GetService("DataService")
end

function Booth:Start()
    self.Prompt.Triggered:Connect(function(Player: Player)
        self:Claim(Player)
    end)
end

function Booth:Claim(Player: Player)
    if self.owner ~= nil then return end
    self._trove = Trove.new()
    self.owner = Player
    self.Prompt.Enabled = false

    local currentBooth = select(2, DataService:GetKey(Player, "CurrentBooth"):await())
    
    self:LoadBooth(currentBooth):andThen(function(newBooth: Model)
        newBooth.Parent = self.Instance
        newBooth:PivotTo(self.ClaimPart:GetPivot())

        -- Setup functions here ( to load the bounties ).
    end):catch(warn)
    
    self._trove:Add(function()
        -- Cleanup
        self.owner = nil
        self:AdjustTheme("Basic")
        self.Prompt.Enabled = true
    end)
    self._trove:Add(Player.Destroying:Connect(function()
        self:Clear()
    end))
end

function Booth:LoadBooth(Booth: string)
    local BoothToCopy = ReplicatedStorage.Booths:FindFirstChild(Booth)
    return Promise.new(function(resolve, reject)
        if not BoothToCopy then
            reject()
        end
        self.Instance.Booth:Destroy()
        local newBooth = BoothToCopy:Clone()
        resolve(newBooth)
    end)
end

function Booth:AdjustTheme(newTheme: string)
    self:LoadBooth(newTheme):andThen(function(newBooth: Model)
        newBooth.Parent = self.Instance
        newBooth:PivotTo(self.ClaimPart:GetPivot())
    end):catch(warn)
end

function Booth:Clear()
    self._trove:Destroy()
end

function Booth:Stop()

end

return Booth