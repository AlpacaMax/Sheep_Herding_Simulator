Object = require "classic"
local machine = require "statemachine"
Sheep = Object:extend()

local sheep_fsm = machine.create({
    initial = 'idle',
    events = {
        { name = "go", from = {"walk", "idle"}, to = "walk" },
        { name = ""}
    }
})