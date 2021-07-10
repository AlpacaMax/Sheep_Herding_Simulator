function love.load()
    love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())

    Object = require "classic"
    Sheep = require "sheep"

    Shp = Sheep()
    Shp.fsm:rest(Shp)
end

function love.update(dt)
    Shp.action(dt)
end

function love.draw()
    Shp:draw()
end