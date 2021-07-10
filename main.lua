function love.load()
    love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())

    love.window.setMode(1000, 618)

    Object = require "classic"
    Sheep = require "sheep"
    Dog = require "dog"

    dog = Dog()
    Sheeps = {}
    for i = 1, 100 do
        local new_sheep = Sheep()
        table.insert(Sheeps, new_sheep)
    end
end

function love.update(dt)
    for _, sheep in ipairs(Sheeps) do
        sheep.action(dt)
    end

    dog:update(dt)
end

function love.draw()
    table.sort(Sheeps, function (a, b)
        return a.y < b.y
    end)

    for _, sheep in ipairs(Sheeps) do
        sheep:draw()        
    end
    dog:draw()
end