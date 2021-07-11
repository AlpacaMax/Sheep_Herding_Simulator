local SHEEP_WALK_SPEED  = 25
local SHEEP_RUN_SPEED   = 80

local SHEEP_MIN_WALK_TIME = 1
local SHEEP_MAX_WALK_TIME = 5
local SHEEP_MIN_IDLE_TIME = 2
local SHEEP_MAX_IDLE_TIME = 8
local SHEEP_MIN_EAT_TIME  = 5
local SHEEP_MAX_EAT_TIME  = 10
local SHEEP_RUN_TIME      = 1

local SHEEP_BOUND_OFFSET  = 16

local SHEEP_VOICE         = love.audio.newSource("SoundEffects/sheep_voice_1.wav", "static")

local DOG_BARK_1 = love.audio.newSource("SoundEffects/dog_bark_1.wav", "static")
local DOG_BARK_2 = love.audio.newSource("SoundEffects/dog_bark_2.wav", "static")
local DOG_BARK_3 = love.audio.newSource("SoundEffects/dog_bark_3.wav", "static")

local machine = require "statemachine"
local Sheep = Object:extend()

function Sheep:new()
    self.x = math.random(10, love.graphics.getWidth() - 10)
    self.y = math.random(10, love.graphics.getHeight() - 10)
    self.speed_x = 0
    self.speed_y = 0

    self.action = nil

    self.image = {
        idle = {
            front = love.graphics.newImage("sheep/sheep_front/sheep_front.png"),
            back  = love.graphics.newImage("sheep/sheep_back/sheep_back.png"),
            side  = love.graphics.newImage("sheep/sheep_side/sheep_side.png")
        },
        walk = {
            index = 1,
            front = {},
            back  = {},
            side  = {}
        },
        run  = {
            index = 1,
            front = {},
            back  = {},
            side  = {}
        },
        eat  = {
            index = 1,
            all   = {}
        }
    }

    self.frame = self.image.idle.front
    self.flip = false

    for i = 1, 9 do
        table.insert(
            self.image.walk.side, 
            love.graphics.newImage("sheep/sheep_side/sheep_side_walk/sheep_side_walk"..i..".png")
        )
        table.insert(
            self.image.walk.front,
            love.graphics.newImage("sheep/sheep_front/sheep_front_walk/sheep_front_walk"..i..".png")
        )
        table.insert(
            self.image.walk.back,
            love.graphics.newImage("sheep/sheep_back/sheep_back_walk/sheep_back_walk"..i..".png")
        )
    end

    for i = 1, 11 do
        table.insert(
            self.image.run.side, 
            love.graphics.newImage("sheep/sheep_side/sheep_side_run/sheep_side_run"..i..".png")
        )
        table.insert(
            self.image.run.front,
            love.graphics.newImage("sheep/sheep_front/sheep_front_run/sheep_front_run"..i..".png")
        )
        table.insert(
            self.image.run.back,
            love.graphics.newImage("sheep/sheep_back/sheep_back_run/sheep_back_run"..i..".png")
        )
    end

    for i = 1, 5 do
        table.insert(
            self.image.eat.all,
            love.graphics.newImage("sheep/sheep_front/sheep_eating/sheep_continue"..i..".png")
        )
    end

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

                        if (sheep.x < SHEEP_BOUND_OFFSET or sheep.x >= love.graphics.getWidth() - SHEEP_BOUND_OFFSET) then
                            sheep.speed_x = -sheep.speed_x
                        end
                        if (sheep.y < SHEEP_BOUND_OFFSET or sheep.y >= love.graphics.getHeight() - SHEEP_BOUND_OFFSET) then
                            sheep.speed_y = -sheep.speed_y
                        end

                        sheep.x = sheep.x + sheep.speed_x * dt
                        sheep.y = sheep.y + sheep.speed_y * dt

                        local speed_angle = math.atan(sheep.speed_y, sheep.speed_x)
                        if (speed_angle >= math.pi / 4 and speed_angle < math.pi * 3 / 4) then
                            sheep.frame = sheep.image.walk.front[sheep.image.walk.index]
                            sheep.flip = false
                        elseif (speed_angle >= math.pi * 3 / 4 or speed_angle < -math.pi * 3 / 4) then
                            print(speed_angle)
                            sheep.frame = sheep.image.walk.side[sheep.image.walk.index]
                            sheep.flip = true
                        elseif (speed_angle >= -math.pi * 3 / 4 and speed_angle < -math.pi * 1 / 4) then
                            sheep.frame = sheep.image.walk.back[sheep.image.walk.index]
                            sheep.flip = false
                        elseif (speed_angle >= -math.pi / 4 and speed_angle < math.pi / 4) then
                            sheep.frame = sheep.image.walk.side[sheep.image.walk.index]
                            sheep.flip = false
                        end
                        sheep.image.walk.index = (sheep.image.walk.index) % 9 + 1
                    end
                end
            end,
            onbeforedog = function(self, event, from, to, sheep, dog)
                love.audio.play(SHEEP_VOICE)
                local round_robin = math.random(1, 3)
                if round_robin == 1 then
                    love.audio.play(DOG_BARK_1)
                elseif round_robin == 2 then
                    love.audio.play(DOG_BARK_2)
                else
                    love.audio.play(DOG_BARK_3)
                end
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

                    local speed_angle = math.atan(sheep.speed_y, sheep.speed_x)
                    if (speed_angle >= math.pi / 4 and speed_angle < math.pi * 3 / 4) then
                        sheep.frame = sheep.image.run.front[sheep.image.run.index]
                        sheep.flip = false
                    elseif (speed_angle >= math.pi * 3 / 4 or speed_angle < -math.pi * 3 / 4) then
                        sheep.frame = sheep.image.run.side[sheep.image.run.index]
                        sheep.flip = true
                    elseif (speed_angle >= -math.pi * 3 / 4 and speed_angle < -math.pi * 1 / 4) then
                        sheep.frame = sheep.image.run.back[sheep.image.run.index]
                        sheep.flip = false
                    elseif (speed_angle >= -math.pi / 4 and speed_angle < math.pi / 4) then
                        sheep.frame = sheep.image.run.side[sheep.image.run.index]
                        sheep.flip = false
                    end
                    sheep.image.run.index = (sheep.image.run.index) % 11 + 1
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

                        sheep.frame = sheep.image.idle.front
                        sheep.flip = false
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

                    sheep.frame = sheep.image.eat.all[sheep.image.eat.index]
                    sheep.flip = false
                    sheep.image.eat.index = sheep.image.eat.index % 5 + 1
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
    if (self.flip) then
        love.graphics.draw(self.frame, self.x, self.y, 0, -1, 1, 16, 16)
    else
        love.graphics.draw(self.frame, self.x, self.y, 0,  1, 1, 16, 16)
    end
end

return Sheep