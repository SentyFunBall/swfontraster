SenFont = SenFont or {}
SenFont.utils = {
    deepCopy = function(tbl)
        local copy = {}
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                copy[k] = SenFont.utils.deepCopy(v)
            else
                copy[k] = v
            end
        end
        return copy
    end;

    scaleAndTranslate = function(point, scale, offsetX, offsetY)
        return point[1] * scale + offsetX, point[2] * scale + offsetY
    end;

    lerp = function(v0, v1, t)
        return v0 + (v1 - v0) * t
    end;

    bezierInterpolation = function(p0, p1, p2, t) --slightly messy bc lerp doesnt use vectors
        local x1 = SenFont.utils.lerp(p0[1], p1[1], t)
        local y1 = SenFont.utils.lerp(p0[2], p1[2], t)
        local x2 = SenFont.utils.lerp(p1[1], p2[1], t)
        local y2 = SenFont.utils.lerp(p1[2], p2[2], t)
        local x = SenFont.utils.lerp(x1, x2, t)
        local y = SenFont.utils.lerp(y1, y2, t)
        return x, y
    end;
}