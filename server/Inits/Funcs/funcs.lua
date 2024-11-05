lib.Funcs = {};

function lib.Funcs:Init()

    ---@param coords any
    ---@param range number
    function lib.Funcs:GetClosestPlayer(coords, range)
        local players = lib.Inform:GetPlayers()
        local closest = nil
        local closestDistance = range

        for k,v in pairs(players) do
            local playerCoords = GetEntityCoords(GetPlayerPed(k))
            local distance = #(coords - playerCoords)

            if distance < closestDistance then
                closest = k
                closestDistance = distance
                break
            end
        end

        return closest, closestDistance
    end

    function lib.Funcs:FetchSQLConfigInfo()
        return bs.SQL
    end

    ---@param src number
    function lib.Funcs:ExtractIdentifiers(src)
        local identifiers = {}
        local playerIdents = GetPlayerIdentifiers(src)

        for i = 1, #playerIdents do
        local ident = playerIdentifiers[i]
        local colonPosition = string.find(ident, ":") - 1
        local identifierType = string.sub(ident, 1, colonPosition)
        identifiers[identifierType] = ident
        end

        return identifiers
    end

    function lib.Funcs:DiscordLog(webHook, header, message, target, color)
        if webHook == nil then webHook = sv_bs.Webhooks.backup end
        local resourceName = GetInvokingResource()
        if not resourceName then resourceName = GetCurrentResourceName() end
        local embeds = {
            {
                type = "rich",
                color = color or 16711680,
                title = header,
                author = {
                    ["name"] = 'brandstation Developments - ' .. resourceName,
                    ['icon_url'] = 'https://dunb17ur4ymx4.cloudfront.net/webstore/logos/e20e32338e57cdb500cb5327abd6e00ffa7b1d68.png'
                },
                description = message .. "\n " .. lib.Funcs:GetPlayerDetails(target or source),
                footer = {
                    icon_url = 'https://dunb17ur4ymx4.cloudfront.net/webstore/logos/e20e32338e57cdb500cb5327abd6e00ffa7b1d68.png',
                    text = os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y") .. " - " .. os.date("%H") .. ":" .. os.date("%M")
                }
            }
        }

        PerformHttpRequest(webHook, function(err, text, headers) end, "POST", json.encode({username = "Force Lib - "..resourceName, embeds = embeds}), { ["Content-Type"] = "application/json" })
    end

    function lib.Funcs:TriggerClientCallback(name, source, cb, ...)
        lib.ClientCallbacks[name] = cb
        TriggerClientEvent('b_lib:Client:TriggerClientCallback', source, name, ...)
    end
end
