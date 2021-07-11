local DOG_RADIUS = 12
local DOG_SPEED = 150
local DOG_SPEED_DIAGONAL = DOG_SPEED * math.cos(math.pi / 4)

local Dog = Object:extend()

function Dog:new()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.speed_x = 0
    self.speed_y = 0
    self.color = {
        red     = 244/255,
        green   = 91/255,
        blue    = 105/255
    }

    self.image = {
        idle  = love.graphics.newImage("dog/dog3/front/dog3_front.png"),
        front = {},
        side  = {},
        back  = {}
    }
    self.index = 1
    self.frame = nil
    self.flip = false

    for i = 1, 10 do
        table.insert(
            self.image.front,
            love.graphics.newImage("dog/dog3/front/dog3_front_run"..i..".png")
        )
        table.insert(
            self.image.side,
            love.graphics.newImage("dog/dog3/side/dog3_side_run"..i..".png")
        )
        table.insert(
            self.image.back,
            love.graphics.newImage("dog/dog3/back/dog3_back_run"..i..".png")
        )
    end

    self.affect_radius = 100
end

function Dog:update(dt)
    if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
        self.speed_x = DOG_SPEED_DIAGONAL
        self.speed_y = -DOG_SPEED_DIAGONAL
        self.frame = self.image.back[self.index]
        self.flip = true
    elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
        self.speed_x = DOG_SPEED_DIAGONAL
        self.speed_y = DOG_SPEED_DIAGONAL
        self.frame = self.image.front[self.index]
        self.flip = true
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
        self.speed_x = -DOG_SPEED_DIAGONAL
        self.speed_y = DOG_SPEED_DIAGONAL
        self.frame = self.image.front[self.index]
        self.flip = false
    elseif love.keyboard.isDown("a") and love.keyboard.isDown("w") then
        self.speed_x = -DOG_SPEED_DIAGONAL
        self.speed_y = -DOG_SPEED_DIAGONAL
        self.frame = self.image.back[self.index]
        self.flip = false
    elseif love.keyboard.isDown("w") then
        self.speed_x = 0
        self.speed_y = -DOG_SPEED
        self.frame = self.image.back[self.index]
        self.flip = false
    elseif love.keyboard.isDown("s") then
        self.speed_x = 0
        self.speed_y = DOG_SPEED
        self.frame = self.image.front[self.index]
        self.flip = false
    elseif love.keyboard.isDown("a") then
        self.speed_x = -DOG_SPEED
        self.speed_y = 0
        self.frame = self.image.side[self.index]
        self.flip = false
    elseif love.keyboard.isDown("d") then
        self.speed_x = DOG_SPEED
        self.speed_y = 0
        self.frame = self.image.side[self.index]
        self.flip = true
    else
        self.speed_x = 0
        self.speed_y = 0
        self.frame = self.image.idle
        self.flip = false
    end

    self.x = self.x + self.speed_x * dt
    self.y = self.y + self.speed_y * dt
    self.index = self.index % 10 + 1
end

function Dog:draw()
    if self.flip then
        love.graphics.draw(self.frame, self.x, self.y, 0, -1, 1, 16, 16)
    else
        love.graphics.draw(self.frame, self.x, self.y, 0, 1,  1, 16, 16)
    end
end

return Dog