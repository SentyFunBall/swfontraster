SenFont = SenFont or {}

SenFont = {
    font = {};

    importFont = function(fontTbl)
        SenFont.font = fontTbl
    end;

    drawGlyph = function(glyph, x, y, scale)
        for _, contour in ipairs(glyph.data) do
            for _, segment in ipairs(contour) do
                if #segment == 2 then --line
                    local p1, p2 = segment[1], segment[2]
                    if debugCol then
                        screen.setColor(SenFont.utils.lerp(0, 255, _/#contour), SenFont.utils.lerp(255, 0, _/#contour ), 0)
                    end
                    screen.drawLine(
                        x + p1[1] * scale, y + p1[2] * scale,
                        x + p2[1] * scale, y + p2[2] * scale
                    )
                    lines = lines + 1
                else --curve
                    SenFont.drawCurve(segment, scale, x, y)
                end
            end
        end
    end;

    fillContour = function(contour, scale, x, y)
        for _, segment in ipairs(contour) do
            local triangles = SenFont.utils.triangulateContour(segment)
            for _, triangle in ipairs(triangles) do
                SenFont.utils.drawTriangle(triangle[1], triangle[2], triangle[3], x, y, scale)
            end
        end
    end;

    manipulateGlyph = function(glyphData, options)
        --manipulate glyphData to fit the options
        local glyphCopy = SenFont.utils.deepCopy(glyphData)
        
        if options.flipV then --flip vertically
            for _, contour in ipairs(glyphCopy.data) do
                for i, segment in ipairs(contour) do
                    for i, point in ipairs(segment) do
                        point[2] = glyphCopy.bound.h - point[2]
                    end
                end
            end
        end
        if options.flipH then --flip horizontally
            for _, contour in ipairs(glyphCopy.data) do
                for i, segment in ipairs(contour) do
                    for i, point in ipairs(segment) do
                        point[1] = glyphCopy.bound.w - point[1]
                    end
                end
            end
        end
        if options.rotate then --rotate radians
            for _, contour in ipairs(glyphCopy.data) do
                for i, segment in ipairs(contour) do
                    for i, point in ipairs(segment) do
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

    drawCurve = function(points, scale, offsetX, offsetY)
        local p0, p1, p2 = points[1], points[2], points[3]
        local prevX, prevY =
            offsetX + p0[1] * scale,
            offsetY + p0[2] * scale

        -- Number of segments for approximation (higher = smoother curve)
        local segments = math.ceil(2 * scale)
        for i = 1, segments do
            local t = i / segments
            local x, y = SenFont.utils.bezierInterpoation(p0, p1, p2, t)
            x, y = offsetX + x * scale, offsetY + y * scale
            if debugCol then
                screen.setColor(SenFont.utils.lerp(0, 255, t), SenFont.utils.lerp(255, 0, t), 0)
            end
            screen.drawLine(prevX, prevY, x, y)
            lines = lines + 1
            prevX, prevY = x, y
        end
    end;

    render = function(char, x, y, scale, options)
        options = options or {}
        scale = scale or 1
    
        local glyphIndex = SenFont.font.cmap[char]
        local glyphData = SenFont.font.glyph[glyphIndex]
        
        glyphData = SenFont.manipulateGlyph(glyphData, options)
    
        if options.hollow then
            SenFont.drawGlyph(glyphData, x, y, scale)
        else
            for _, contour in ipairs(glyphData.data) do
                SenFont.fillContour(contour, scale, x, y)
            end
        end
    end;

    drawText = function(string, x, y, scale, options)
        for i = 1, #string do
            local char = string:sub(i, i)
            SenFont.render(char, x, y, scale, options)
            x = x + (SenFont.font.glyph[SenFont.font.cmap[char]].advance_width * scale) + (10 * scale) --add a little space between each character
        end
    end;

    renderGlyph = function(glyph, x, y, scale)
        for _, contour in ipairs(glyph.data) do
            SenFont.fillContour(contour, scale, x, y)
        end
    end;
}

require("SenFont.utils")