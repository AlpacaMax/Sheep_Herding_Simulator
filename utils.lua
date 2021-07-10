function In_polygon(point_x, point_y, vertices)
    -- Check if a point is in a polygon
    -- Param: point_x: X coordinate of the point
    --        point_y: Y corrdinate of the point
    --        vertices: A table of coordinates of vertices

    local is_in_polygon = false
    for i = 1, #vertices, 2 do
        local start_vertex = {x = vertices[i], y = vertices[i+1]}
        local end_vertex = nil

        if (i < #vertices - 1) then
            end_vertex = {x = vertices[i+2], y = vertices[i+3]}
        else
            end_vertex = {x = vertices[1], y = vertices[2]}
        end
        -- local end_vertex = {x = vertices[i+2], y = vertices[i+3]}

        if (start_vertex.y > point_y and end_vertex.y < point_y)
            or (start_vertex.y < point_y and end_vertex.y > point_y)
        then
            local projected_x = (end_vertex.y - point_y) 
                              / (end_vertex.y - start_vertex.y)
                              * (end_vertex.x - start_vertex.x) 
                              + start_vertex.x
            if (projected_x > point_x) then
                is_in_polygon = not is_in_polygon
            end
        end
    end

    return is_in_polygon
end