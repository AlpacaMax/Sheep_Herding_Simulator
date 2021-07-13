local BG_COLOR = {
<<<<<<< HEAD
    red   = 185/255,
    green = 205/255,
    blue  = 76/255,
}
local SCORE_FONT_COLOR = {
    red   = 255/255,
    green = 255/255,
    blue  = 255/255,
=======
    red   = 63/255,
    green = 48/255,
    blue  = 71/255,
}
local SCORE_FONT_COLOR = {
    red   = 245/255,
    green = 133/255,
    blue  = 63/255,
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
}
local SCORE_FONT = love.graphics.newFont(30)
local INFO_FONT = love.graphics.newFont(18)

local Scene = {}

function Scene.load()
    love.graphics.setBackgroundColor(
        BG_COLOR.red,
        BG_COLOR.green,
        BG_COLOR.blue
    )
    love.mouse.setVisible(false)
end

function Scene.update(dt)

end

function Scene.draw()
    love.graphics.setColor(
<<<<<<< HEAD
        SCORE_FONT_COLOR.red,
        SCORE_FONT_COLOR.green,
=======
        SCORE_FONT_COLOR.red, 
        SCORE_FONT_COLOR.green, 
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
        SCORE_FONT_COLOR.blue
    )
    love.graphics.print(
        "Sheep Herding Simulator",
<<<<<<< HEAD
        SCORE_FONT,
        10,
        love.graphics.getHeight() / 2 - 40
    )
    love.graphics.print(
        "Press 'Space' to Start The Game",
        INFO_FONT,
        10,
=======
        SCORE_FONT, 
        10, 
        love.graphics.getHeight() / 2 - 40
    )
    love.graphics.print(
        "Press 'Space' to Start The Game", 
        INFO_FONT, 
        10, 
>>>>>>> 2e66dd486ab52fe7a96dd9f87dc61236c6ced411
        love.graphics.getHeight() / 2
    )
end

function Scene.keypressed(key)
    if key == "space" then
        MainScene = "PlayScene"
    end
    love.load()
end

return Scene