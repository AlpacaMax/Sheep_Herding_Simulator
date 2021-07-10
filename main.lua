function love.load()
    love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())

    love.window.setMode(1000, 618)

    require "utils"
    require "area"
    Object = require "classic"
    Sheep = require "sheep"
    Dog = require "dog"

    dog = Dog()
    Sheeps = {}
    for i = 1, 100 do
        local new_sheep = Sheep()
        table.insert(Sheeps, new_sheep)
    end
    area = Rectangle_Area(300, 200)
end

function love.update(dt)
    local all_in_area = true
    for _, sheep in ipairs(Sheeps) do
        sheep.action(dt)

        if (Distance(dog.x, dog.y, sheep.x, sheep.y) <= dog.affect_radius) then
            sheep.fsm:dog(sheep, dog)
        end

        all_in_area = all_in_area and In_polygon(sheep.x, sheep.y, area)
    end

    if (all_in_area) then
        print("You won!")
        love.load()
    end

    dog:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon('line', area)

    table.sort(Sheeps, function (a, b)
        return a.y < b.y
    end)
    for _, sheep in ipairs(Sheeps) do
        sheep:draw()        
    end

    dog:draw()
end