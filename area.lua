function Rectangle_Area(width, height)
    local left = love.graphics.getWidth() / 2 - width / 2
    local right = left + width
    local top = love.graphics.getHeight() / 2 - height / 2
    local bottom = top + height

    return {
        left, top,
        right, top,
        right, bottom,
        left, bottom
    }
end