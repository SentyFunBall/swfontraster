SenFont = SenFont or {}

SenFont = {
    font = {};
    
    importFont = function(fontTbl)
        font = fontTbl
    end;

    drawGlyph = function(glyph, x, y, scale)
        for _, contour in ipairs(glyph.data) do
            local prevX, prevY = nil, nil
            for _, point in ipairs(contour) do
                --scale and translate the point
                local scaledX, scaledY = SenFont.utils.scaleAndTranslate(point, scale, x, y)
    
                --draw line from previous point to current point
                if prevX then
                    screen.drawLine(prevX, prevY, scaledX, scaledY)
                end
    
                prevX, prevY = scaledX, scaledY
            end
    
            --close contour
            local firstX, firstY = SenFont.utils.scaleAndTranslate(contour[1], scale, x, y)
            screen.drawLine(prevX, prevY, firstX, firstY)
        end
    end;

    manipulateGlyph = function(glyphData, options)
        --manipulate glyphData to fit the options
        local glyphCopy = SenFont.utils.deepCopy(glyphData)
        
        if options.flipV then --flip vertically
            for _, contour in ipairs(glyphCopy.data) do
                for i, point in ipairs(contour) do
                    point[2] = glyphCopy.height - point[2]
                end
            end
        end
        if options.flipH then --flip horizontally
            for _, contour in ipairs(glyphCopy.data) do
                for i, point in ipairs(contour) do
                    point[1] = glyphCopy.width - point[1]
                end
            end
        end
        if options.rotate then --rotate radians
            for _, contour in ipairs(glyphCopy.data) do
                for i, point in ipairs(contour) do
                    local x = point[1]
                    local y = point[2]
                    point[1] = x * math.cos(options.rotate) - y * math.sin(options.rotate)
                    point[2] = x * math.sin(options.rotate) + y * math.cos(options.rotate)
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
}

require("SenFont.utils")