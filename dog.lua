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

    self.affect_radius = 100
end

function Dog:update(dt)
    if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
            self.speed_x = DOG_SPEED_DIAGONAL
            self.speed_y = -DOG_SPEED_DIAGONAL
    elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
        self.speed_x = DOG_SPEED_DIAGONAL
        self.speed_y = DOG_SPEED_DIAGONAL
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
        self.speed_x = -DOG_SPEED_DIAGONAL
        self.speed_y = DOG_SPEED_DIAGONAL
    elseif love.keyboard.isDown("a") and love.keyboard.isDown("w") then
        self.speed_x = -DOG_SPEED_DIAGONAL
        self.speed_y = -DOG_SPEED_DIAGONAL
    elseif love.keyboard.isDown("w") then
        self.speed_x = 0
        self.speed_y = -DOG_SPEED
    elseif love.keyboard.isDown("s") then
        self.speed_x = 0
        self.speed_y = DOG_SPEED
    elseif love.keyboard.isDown("a") then
        self.speed_x = -DOG_SPEED
        self.speed_y = 0
    elseif love.keyboard.isDown("d") then
        self.speed_x = DOG_SPEED
        self.speed_y = 0
    else
        self.speed_x = 0
        self.speed_y = 0
    end

    print(self.speed_x, self.speed_y)

    self.x = self.x + self.speed_x * dt
    self.y = self.y + self.speed_y * dt
end

function Dog:draw()
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.circle("fill", self.x, self.y, DOG_RADIUS, 48)
end

return Dog