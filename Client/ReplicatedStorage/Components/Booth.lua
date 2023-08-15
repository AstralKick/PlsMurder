local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Knit = require(Packages.Knit)
local Trove = require(Packages.Trove)
local Roact = require(Packages.Roact) -- For mounting the SurfaceGuis.
local TblUtil = require(Packages.TblUtil)
local WantedComponent = require(ReplicatedStorage.Source.Roact.Components.Bounties.WantedComponent)


local Booth = Component.new{ Tag = "Booth" }

function Booth:Construct()
    BoothService = Knit.GetService("BoothService")

end

function Booth:Start()
    local Folder = Instance.new("Folder")
    Folder.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    self._uiFolder = Folder
    self:CreateUI()

    self:GetOwner()
end


-- Custom Functions 
function Booth:GetOwner()
    local Owner = select(2, BoothService:GetOwner(self.Instance):await())
    self.owner = Owner
end


function Booth:UpdateItems(BountyCards: {})
    local boothDisplay = TblUtil.Filter(BountyCards, function(value, key)
        return value.DisplayType == "Booth"
    end)
    local cabinetDisplay = TblUtil.Filter(BountyCards, function(value, key)
        return value.DisplayType == "Cabinet"
    end)
    local mostWantedDisplay = TblUtil.Filter(BountyCards, function(value, key)
        return value.DisplayType == "MostWanted"
    end)

    for GUID,v in pairs (boothDisplay) do
        local i = v.DisplayNumber
        if not self.tree.BoothDisplay[i] then continue end
        local newElement = Roact.createElement(WantedComponent, {
            -- Props here.
            UserId = v.UserId,
            Verified = v.Verified,
            StarCreator = v.StarCreator,
            KillCount = v.KillCount,
            Message = v.Message,
            PaperType = v.PaperType,
            ItemId = v.ItemId,
            GUID = GUID,
            Adornee = self.Instance:FindFirstChild("Booth Display", true):FindFirstChild(i)
        })
        Roact.update(self.tree.BoothDisplay[i], newElement)
    end
    for GUID,v in pairs (cabinetDisplay) do
        local i = v.DisplayNumber
        if not self.tree.CabinetDisplay[i] then continue end
        local newElement = Roact.createElement(WantedComponent, {
            -- Props here.
            UserId = v.UserId,
            Verified = v.Verified,
            StarCreator = v.StarCreator,
            KillCount = v.KillCount,
            Message = v.Message,
            PaperType = v.PaperType,
            ItemId = v.ItemId,
            GUID = GUID,
            Adornee = self.Instance:FindFirstChild("Display Cabinet", true):FindFirstChild(i)
        })
        Roact.update(self.tree.CabinetDisplay[i], newElement)
    end
    for GUID,v in pairs (mostWantedDisplay) do
        local i = v.DisplayNumber
        if not self.tree.MostWantedDisplay[i] then continue end
        local newElement = Roact.createElement(WantedComponent, {
            -- Props here.
            UserId = v.UserId,
            Verified = v.Verified,
            StarCreator = v.StarCreator,
            KillCount = v.KillCount,
            Message = v.Message,
            PaperType = v.PaperType,
            ItemId = v.ItemId,
            GUID = GUID,
            Adornee = self.Instance:FindFirstChild("Most Wanted", true):FindFirstChild(i)
        })
        Roact.update(self.tree.MostWantedDisplay[i], newElement)
    end
end

function Booth:Claimed(boothDisplay, cabinetDisplay, mostWantedDisplay)
    local ClaimPart = self.Instance.ClaimPart
    for _,Particle in ipairs (ClaimPart:GetDescendants()) do
        if not Particle:IsA("ParticleEmitter") then continue end
        Particle:Emit(Particle:GetAttribute("EmitCount"))
    end

    self:GetOwner()
    self:UpdateItems(boothDisplay, cabinetDisplay, mostWantedDisplay)
    

    self._trove = Trove.new()


    self._trove:Add(function()
        self.owner = nil
        self:ClearUI()
    end)
end

function Booth:UpdateUI()

end

function Booth:CreateUI()
    self.tree = {
        BoothDisplay = {},
        CabinetDisplay = {},
        MostWantedDisplay = {}
    }

    for i = 1, 5 do
        local bounty = Roact.createElement(WantedComponent)
        self.tree.BoothDisplay[i] = Roact.mount(bounty, self._uiFolder)
    end
    for i = 1, 3 do
        local bounty = Roact.createElement(WantedComponent)
        self.tree.CabinetDisplay[i] = Roact.mount(bounty, self._uiFolder)
    end
    self.tree.MostWantedDisplay[1] = Roact.mount(Roact.createElement(WantedComponent), self._uiFolder)
end

function Booth:ClearUI()
    for i,v in ipairs (self.tree.BoothDisplay) do
        local bounty = Roact.createElement(WantedComponent)
        Roact.update(self.tree.BoothDisplay[i], bounty)
    end
    for i,v in ipairs (self.tree.CabinetDisplay) do
        local bounty = Roact.createElement(WantedComponent)
        Roact.update(self.tree.CabinetDisplay[i], bounty)
    end
    for i,v in ipairs (self.tree.MostWantedDisplay) do
        local bounty = Roact.createElement(WantedComponent)
        Roact.update(self.tree.MostWantedDisplay[i], bounty)
    end
end

function Booth:Clear()
    self._trove:Destroy()
end

function Booth:Stop()

end

return Booth