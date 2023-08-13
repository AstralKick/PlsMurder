local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)

Knit.AddControllers(ReplicatedStorage.Source.Controllers)

Knit.Start():andThen(function()
    for i,v in ipairs (ReplicatedStorage.Source.Components:GetChildren()) do
        require(v)
    end
end):catch(warn)