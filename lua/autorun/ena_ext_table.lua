function table.GetValues( tbl )
    local vals = {}
    for _, v in pairs(tbl or {}) do table.insert(vals, v) end
    return vals
end

table.Keys = table.GetKeys
table.Values = table.GetValues

function table.Map( tbl, mapFunc )
    local map, keyValMode = {}, false
    for k, v in pairs(tbl or {}) do
        local key, val
        if isfunction(mapFunc) then key, val = mapFunc(k, v) end
        if key ~= nil then
            if val == nil then
                if keyValMode then return ErrorNoHaltWithStack("table.Map: keyValMode is enabled!\n") end
                table.insert(map, key)
            else
                keyValMode = true
                map[key] = val
            end
        end
    end
    return map
end

function table.Filter( tbl, filterFunc )
    local newTbl = {}
    for k, v in pairs(tbl or {}) do
        if isfunction(filterFunc) and filterFunc(k, v) ~= nil and filterFunc(k, v) ~= false then
            if table.IsSequential(tbl) then
                table.insert(newTbl, v)
            else
                newTbl[k] = v
            end
        end
    end
    return newTbl
end

function table.Slice( tbl, from, to )
    if not istable(tbl) or not table.IsSequential(tbl) then return {} end
    if not tonumber(from) then return tbl end
    to = tonumber(to) or #tbl
    local sliced = {}
    for k, v in ipairs(tbl) do
        if k >= from and k <= to then table.insert(sliced, v) end
    end
    return sliced
end