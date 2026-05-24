-- ============================================
-- CINEMATIC RP SYSTEM - Utility Functions
-- ============================================

Utils = {}

-- Distance calculation
function Utils.GetDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

-- Get 3D distance
function Utils.GetDistance3D(coords1, coords2)
    return Utils.GetDistance(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

-- Notify player
function Utils.Notify(title, message, type)
    TriggerEvent('chat:addMessage', {
        color = (type == 'error' and {255, 0, 0}) or (type == 'success' and {0, 255, 0}) or {0, 150, 255},
        multiline = true,
        args = {title, message}
    })
end

-- Debug log
function Utils.DebugLog(message)
    if Config.Settings.debugMode then
        print("^5[DEBUG] " .. message .. "^7")
    end
end

-- Get random element from table
function Utils.RandomTable(tbl)
    if #tbl == 0 then return nil end
    return tbl[math.random(1, #tbl)]
end

-- Check if entity exists
function Utils.EntityExists(entity)
    return DoesEntityExist(entity)
end

print("^2[Cinematic RP] Utils loaded successfully!^7")
