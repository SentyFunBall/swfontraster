SenFont = SenFont or {}

SenFont = {
    font = {};

    importFont = function(fontTbl)
        font = fontTbl
    end;

    drawGlyph = function(glyph, x, y, scale)
        local offsetX, offsetY = x, y
        for _, contour in ipairs(glyph.data) do
            for _, segment in ipairs(contour) do
                if segment.type == 1 then
                    -- Iterate through each pair of points in the line segment
                    local points = segment.points
                    for i = 1, #points - 1 do
                        local p1, p2 = points[i], points[i + 1]
                        screen.drawLine(
                            offsetX + p1[1] * scale, offsetY + p1[2] * scale,
                            offsetX + p2[1] * scale, offsetY + p2[2] * scale
                        )
                    end
                else
                    -- Draw each curve segment
                    SenFont.drawCurve(segment.points, scale, offsetX, offsetY)
                end
            end
        end
    end;

    manipulateGlyph = function(glyphData, options)
        --manipulate glyphData to fit the options
        local glyphCopy = SenFont.utils.deepCopy(glyphData)
        
        if options.flipV then --flip vertically
            for _, contour in ipairs(glyphCopy.data) do
                for i, segment in ipairs(contour) do
                    for i, point in ipairs(segment.points) do
                        point[2] = glyphCopy.height - point[2]
                    end
                end
            end
        end
        if options.flipH then --flip horizontally
            for _, contour in ipairs(glyphCopy.data) do
                for i, segment in ipairs(contour) do
                    for i, point in ipairs(segment.points) do
                        point[1] = glyphCopy.width - point[1]
                    end
                end
            end
        end
        if options.rotate then --rotate radians
            for _, contour in ipairs(glyphCopy.data) do
                for i, segment in ipairs(contour) do
                    for i, point in ipairs(segment.points) do
                        local x = point[1]
                        local y = point[2]
                        point[1] = x * math.cos(options.rotate) - y * math.sin(options.rotate)
                        point[2] = x * math.sin(options.rotate) + y * math.cos(options.rotate)
                    end
                end
            end
        end
    
        return glyphCopy
    end;

    render = function(char, x, y, scale, options)
        options = options or {}
        scale = scale or 1
    
        local glyphIndex = font.cmap[char]
        local glyphData = font.glyph[glyphIndex]
        --local offsetX = x + (glyphData.width * scale) / 2 --center the glyph
        
        glyphData = SenFont.manipulateGlyph(glyphData, options)
    
        SenFont.drawGlyph(glyphData, x, y, scale)
    end;

    drawCurve = function(points, scale, offsetX, offsetY)
        local p0, p1, p2 = points[1], points[2], points[3]
        local prevX, prevY =
            offsetX + p0[1] * scale,
            offsetY + p0[2] * scale

        -- Number of segments for approximation (higher = smoother curve)
        local segments = 5 * scale
        for i = 1, segments do
            local t = i / segments
            local x, y = SenFont.utils.evaluateQuadraticBezier(p0, p1, p2, t)
            x, y = offsetX + x * scale, offsetY + y * scale
            screen.drawLine(prevX, prevY, x, y)
            prevX, prevY = x, y
        end
    end;
}

require("SenFont.utils")