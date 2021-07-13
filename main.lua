PlayScene = require "PlayScene"
<<<<<<< HEAD
MenuScene = require "MenuScene"
-- EndScene = require "EndScene"
MainScene = "MenuScene"
=======
-- MenuScene = require "MenuScene"
-- EndScene = require "EndScene"
MainScene = "PlayScene"
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
EndScore = 0

function love.load()
    love.window.setTitle("Sheep Herding Simulator")
    
    if MainScene == "PlayScene" then
        PlayScene.load()
<<<<<<< HEAD
    elseif MainScene == "MenuScene" then
        MenuScene.load()
=======
    -- elseif MainScene == "MenuScene" then
    --     MenuScene.load()
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
    -- else
    --     EndScene.load()
    end
end

function love.update(dt)
    if MainScene == "PlayScene" then
        PlayScene.update(dt)
<<<<<<< HEAD
    elseif MainScene == "MenuScene" then
        MenuScene.update(dt)
=======
    -- elseif MainScene == "MenuScene" then
    --     MenuScene.update(dt)
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
    -- else
    --     EndScene.update(dt)
    end
end

function love.draw()
    if MainScene == "PlayScene" then
        PlayScene.draw()
<<<<<<< HEAD
    elseif MainScene == "MenuScene" then
        MenuScene.draw()
=======
    -- elseif MainScene == "MenuScene" then
    --     MenuScene.draw()
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
    -- else
    --     EndScene.draw()
    end
end

function love.keypressed(key)
    if MainScene == "MenuScene" then
        MenuScene.keypressed(key)
    end
<<<<<<< HEAD
end
=======
end)
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
