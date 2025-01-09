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

    bezierInterpoation = function(p0, p1, p2, t)
        local x = (1 - t) * (1 - t) * p0[1] + 2 * (1 - t) * t * p1[1] + t * t * p2[1]
        local y = (1 - t) * (1 - t) * p0[2] + 2 * (1 - t) * t * p1[2] + t * t * p2[2]
        return x, y
    end;

    lerp = function(a, b, t)
        return a + (b - a) * t
    end;

}