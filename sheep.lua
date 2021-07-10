local SHEEP_RADIUS = 20
local SHEEP_WALK_SPEED = 100
local SHEEP_RUN_SPEED = 200

local machine = require "statemachine"
local Sheep = Object:extend()

function Sheep:new()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.speed_x = 0
    self.speed_y = 0

    self.action = nil

    self.color = {
        red     = 1,
        green   = 1,
        blue    = 1
    }

    self.fsm = machine.create({
        initial = 'init',
        events = {
            { name = "go", from = {"run", "walk", "idle"}, to = "walk" },
            { name = "dog", from = {"run", "walk", "idle", "eat"}, to = "run" },
            { name = "rest", from = {"init", "run", "walk", "idle", "eat"}, to = "idle" },
            { name = "hungry", from = {"walk", "idle"}, to = "eat" },
        },
        callbacks = {
            onbeforego = function(self, event, from, to, sheep)
                if (from ~= to) then
                    local angle = love.math.random(0, 2*math.pi)
                    sheep.speed_x = math.cos(angle) * SHEEP_WALK_SPEED
                    sheep.speed_y = math.sin(angle) * SHEEP_WALK_SPEED

                    local timer = 0
                    sheep.action = function(dt)
                        timer = timer + dt

                        if (timer > 3) then
                            if (math.random(0, 1) == 1) then
                                sheep.fsm:rest(sheep)
                            else
                                sheep.fsm:hungry(sheep)
                            end
                        end

                        if (sheep.x < 0 or sheep.x >= love.graphics.getWidth()) then
                            sheep.speed_x = -sheep.speed_x
                        end
                        if (sheep.y < 0 or sheep.y >= love.graphics.getHeight()) then
                            sheep.speed_y = -sheep.speed_y
                        end

                        sheep.x = sheep.x + sheep.speed_x * dt
                        sheep.y = sheep.y + sheep.speed_y * dt
                    end
                end
            end,
            onbeforedog = function(self, event, from, to, sheep, dt)
                sheep:moveRandDirection(from~=to, SHEEP_RUN_SPEED, dt)

                sheep.action = function(dt)

                end
            end,
            onbeforerest = function(self, event, from, to, sheep)
                if (from ~= to) then
                    sheep.speed_x = 0
                    sheep.speed_y = 0

                    local timer = 0
                    sheep.action = function(dt)
                        timer = timer + dt
                        if (timer > 5) then
                            if (math.random(0, 1) == 0) then
                                sheep.fsm:go(sheep)
                            else
                                sheep.fsm:hungry(sheep)
                            end
                        end
                    end
                end
            end,
            onbeforehungry = function(self, event, from, to, sheep)
                sheep.speed_x = 0
                sheep.speed_y = 0
                sheep.color = {
                    red     = 0,
                    green   = 1,
                    blue    = 0
                }

                local timer = 0
                sheep.action = function(dt)
                    timer = timer + dt
                    if (timer > 5) then
                        sheep.color = {
                            red     = 1,
                            green   = 1,
                            blue    = 1
                        }
                        if (math.random(0, 1) == 0) then
                            sheep.fsm:go(sheep)
                        else
                            sheep.fsm:rest(sheep)
                        end
                    end
                end
            end,
        }
    })
end

function Sheep:moveRandDirection(changeDirection, newSpeed, dt)
    if (changeDirection) then
        local angle = love.math.random(0, 2*math.pi)
        self.speed_x = math.cos(angle) * newSpeed
        self.speed_y = math.sin(angle) * newSpeed
    end

    self.x = self.x + self.speed_x * dt
    self.y = self.y + self.speed_y * dt
end

function Sheep:draw()
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.circle("fill", self.x, self.y, SHEEP_RADIUS, 48)
end

return Sheep