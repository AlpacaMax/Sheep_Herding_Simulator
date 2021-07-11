local BG_COLOR = {
    red   = 63/255,
    green = 48/255,
    blue  = 71/255,
}
local SCORE_FONT_COLOR = {
    red   = 245/255,
    green = 133/255,
    blue  = 63/255,
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
        SCORE_FONT_COLOR.red, 
        SCORE_FONT_COLOR.green, 
        SCORE_FONT_COLOR.blue
    )
    love.graphics.print(
        "Sheep Herding Simulator",
        SCORE_FONT, 
        10, 
        love.graphics.getHeight() / 2 - 40
    )
    love.graphics.print(
        "Press 'Space' to Start The Game", 
        INFO_FONT, 
        10, 
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