PlayScene = require "PlayScene"
MenuScene = require "MenuScene"
EndScene = require "EndScene"
MainScene = "MenuScene"
EndScore = 0

function love.load()
    love.window.setTitle("Sheep Herding Simulator")
    
    if MainScene == "PlayScene" then
        PlayScene.load()
    elseif MainScene == "MenuScene" then
        MenuScene.load()
    else
        EndScene.load()
    end
end

function love.update(dt)
    if MainScene == "PlayScene" then
        PlayScene.update(dt)
    elseif MainScene == "MenuScene" then
        MenuScene.update(dt)
    else
        EndScene.update(dt)
    end
end

function love.draw()
    if MainScene == "PlayScene" then
        PlayScene.draw()
    elseif MainScene == "MenuScene" then
        MenuScene.draw()
    else
        EndScene.draw()
    end
end

function love.keypressed(key)
    if MainScene == "MenuScene" then
        MenuScene.keypressed(key)
    end
end
