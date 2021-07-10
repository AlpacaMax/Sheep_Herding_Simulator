local SHEEP_RADIUS      = 15
local SHEEP_WALK_SPEED  = 25
local SHEEP_RUN_SPEED   = 80

local SHEEP_MIN_WALK_TIME = 1
local SHEEP_MAX_WALK_TIME = 5
local SHEEP_MIN_IDLE_TIME = 2
local SHEEP_MAX_IDLE_TIME = 8
local SHEEP_MIN_EAT_TIME  = 5
local SHEEP_MAX_EAT_TIME  = 10
local SHEEP_RUN_TIME      = 1

local machine = require "statemachine"
local Sheep = Object:extend()

function Sheep:new()
    self.x = math.random(10, love.graphics.getWidth() - 10)
    self.y = math.random(10, love.graphics.getHeight() - 10)
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
            { name = "go", from = {"init", "run", "walk", "idle"}, to = "walk" },
            { name = "dog", from = {"run", "walk", "idle", "eat"}, to = "run" },
            { name = "rest", from = {"init", "run", "walk", "idle", "eat"}, to = "idle" },
            { name = "hungry", from = {"init", "walk", "idle"}, to = "eat" },
        },
        callbacks = {
            onbeforego = function(self, event, from, to, sheep)
                if (from ~= to) then
                    local angle = love.math.random(0, 2*math.pi)
                    sheep.speed_x = math.cos(angle) * SHEEP_WALK_SPEED
                    sheep.speed_y = math.sin(angle) * SHEEP_WALK_SPEED

                    local timer = 0
                    local bound = love.math.random(
                        SHEEP_MIN_WALK_TIME, 
                        SHEEP_MAX_WALK_TIME
                    )
                    sheep.action = function(dt)
                        timer = timer + dt

                        if (timer > bound) then
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
            onbeforedog = function(self, event, from, to, sheep, dog)
                sheep.color = {
                    red = 1,
                    green = 0,
                    blue = 0
                }

                local timer = 0
                sheep.action = function(dt)
                    timer = timer + dt
                    if (timer > SHEEP_RUN_TIME) then
                        sheep.color = {
                            red     = 1,
                            green   = 1,
                            blue    = 1
                        }
                        sheep.fsm:rest(sheep)
                    end

                    local a_side = sheep.x - dog.x
                    local b_side = sheep.y - dog.y
                    local c_side = Distance(dog.x, dog.y, sheep.x, sheep.y)

                    sheep.speed_x = SHEEP_RUN_SPEED * (a_side / c_side)
                    sheep.speed_y = SHEEP_RUN_SPEED * (b_side / c_side)

                    sheep.x = sheep.x + sheep.speed_x * dt
                    sheep.y = sheep.y + sheep.speed_y * dt

                    if (sheep.x < 0) then
                        sheep.x = 0
                    elseif (sheep.x > love.graphics.getWidth()) then
                        sheep.x = love.graphics.getWidth()
                    end

                    if (sheep.y < 0) then
                        sheep.y = 0
                    elseif(sheep.y > love.graphics.getHeight()) then
                        sheep.y = love.graphics.getHeight()
                    end
                end
            end,
            onbeforerest = function(self, event, from, to, sheep)
                if (from ~= to) then
                    sheep.speed_x = 0
                    sheep.speed_y = 0

                    local timer = 0
                    local bound = love.math.random(
                        SHEEP_MIN_IDLE_TIME, 
                        SHEEP_MAX_IDLE_TIME
                    )
                    sheep.action = function(dt)
                        timer = timer + dt
                        if (timer > bound) then
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
                local bound = love.math.random(
                    SHEEP_MIN_EAT_TIME, 
                    SHEEP_MAX_EAT_TIME
                )
                sheep.action = function(dt)
                    timer = timer + dt
                    if (timer > bound) then
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

    local robin_select = math.random(1, 3)
    if (robin_select == 1) then
        self.fsm:rest(self)
    elseif (robin_select == 2) then
        self.fsm:go(self)
    else
        self.fsm:hungry(self)
    end
end

function Sheep:draw()
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.circle("fill", self.x, self.y, SHEEP_RADIUS, 48)
end

return Sheep