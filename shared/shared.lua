shared = shared or {}

---@param text string
---@param type 'error' | 'warning' | 'config' | 'info' | 'success' | 'debug'
---@return any
function shared:Print(text, type)
    local types = {
        ["error"] = "^7[^1 ERROR ^7] ",
        ["warning"] = "^7[^3 WARNING ^7] ",
        ["config"] = "^7[^3 CONFIG WARNING ^7] ",
        ["info"] = "^7[^5 INFO ^7] ",
        ["success"] = "^7[^2 SUCCESS ^7] ",
        ["debug"] = "^7[^6 DEBUG ^7] ",
    }
    return print("^7[^5 b_lib ^7] " .. (types[string.lower(type or "info")]) .. text)
end

function shared:Debug(resource, export, ...)
    if bs.DebugIgnore[resource] then return end
    local args = { ... }
    local argsFormatted = json.encode(args) or "None"

    if bs.Debug then
        self:Print(("^7[^5%s^7] Resource %s invoked export %s. Arguments: %s"):format(
            IsDuplicityVersion() and "SERVER" or "CLIENT", resource, export, argString), 'debug')
    end
end

function shared:printTable(table)
    return json.encode(table, {indent = true})
end
