lib.Funcs = {}

function lib.Funcs:Init()
    function lib.Funcs:DrawMissionText(text, length, height, scale, center)
        if not center then center = true end
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextEntry("STRING")
        SetTextCentre(center)
        SetTextOutline()
        AddTextComponentString(text)
        DrawText(height, length)
    end

    function lib.Funcs:Draw3DText(coords, text)
        local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

        SetTextScale(0.38, 0.38)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 200)
        SetTextEntry("STRING")
        SetTextCentre(1)

        AddTextComponentString(text)
        DrawText(_x, _y)

        local factor = string.len(text) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end

    function lib.Funcs:GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
        local players, myPlayer = {}, PlayerId()
        local active = GetActivePlayers()

        for i = 1, #active do
            local currentPlayer = active[i]
            local ped = GetPlayerPed(currentPlayer)

            if DoesEntityExist(ped) and ((onlyOtherPlayers and currentPlayer ~= myPlayer) or not onlyOtherPlayers) then
                if returnKeyValue then
                    players[currentPlayer] = ped
                else
                    players[#players + 1] = returnPeds and ped or currentPlayer
                end
            end
        end

        return players
    end

    function lib.Funcs:GetVehicles()
        local vehicles = {}

        for vehicle in lib.entitier:EnumerateVehicles() do
            table.insert(vehicles, vehicle)
        end

        return vehicles
    end

    function lib.Funcs:GetClosestVehicle(coords)
        local vehicles        = lib.Funcs:GetVehicles()
        local closestDistance = -1
        local closestVehicle  = -1
        local coords          = coords

        if coords == nil then
            local playerPed = PlayerPedId()
            coords          = GetEntityCoords(playerPed)
        end

        for i=1, #vehicles, 1 do
            local vehicleCoords = GetEntityCoords(vehicles[i])
            local distance      = #(vec3(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z) - vec3(coords.x, coords.y, coords.z))

            if closestDistance == -1 or closestDistance > distance then
                closestVehicle  = vehicles[i]
                closestDistance = distance
            end
        end

        return closestVehicle, closestDistance
    end

    function lib.Funcs:SpawnVehicle(vehicleModel, coords, heading, cb, networked)
        local model = type(vehicleModel) == "number" and vehicleModel or GetHashKey(vehicleModel)
        local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
        networked = networked == nil and true or networked

        local playerCoords = GetEntityCoords(PlayerPedId())
        if not vector or not playerCoords then
            return
        end

        local dist = #(playerCoords - vector)
        if dist > 424 then
            local executingResource = GetInvokingResource() or "Unknown"
            return shared:Print('Tried to spawn vehicle on the client but the position is too far away (Out of onesync range).', 'error')
        end

        CreateThread(function()
            lib.Streaming:RequestModel(model)

            local vehicle = CreateVehicle(model, vector.xyz, heading, networked, true)

            if networked then
                local id = NetworkGetNetworkIdFromEntity(vehicle)
                SetNetworkIdCanMigrate(id, true)
                SetEntityAsMissionEntity(vehicle, true, true)
            end
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            SetVehicleNeedsToBeHotwired(vehicle, false)
            SetModelAsNoLongerNeeded(model)
            SetVehRadioStation(vehicle, "OFF")

            RequestCollisionAtCoord(vector.xyz)
            while not HasCollisionLoadedAroundEntity(vehicle) do
                Wait(0)
            end

            if cb then
                cb(vehicle)
            end
        end)
    end

    function lib.Funcs:GenerateUUID()
        local template ='xxxxxxxxxx4xxxyxx'

        return string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', v)
        end)
    end

    function lib.Funcs:GetVehicleProperties(vehicle)
        local color1, color2 = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local extras = {}

        for id=0, 12 do
            if DoesExtraExist(vehicle, id) then
                local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
                extras[tostring(id)] = state
            end
        end

        return {

            model             = GetEntityModel(vehicle),

            plate             = lib.Utils:Trim(GetVehicleNumberPlateText(vehicle)),
            plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

            health            = GetEntityHealth(vehicle),
            dirtLevel         = GetVehicleDirtLevel(vehicle),

            color1            = color1,
            color2            = color2,

            pearlescentColor  = pearlescentColor,
            wheelColor        = wheelColor,

            wheels            = GetVehicleWheelType(vehicle),
            windowTint        = GetVehicleWindowTint(vehicle),

            neonEnabled       = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },

            extras            = extras,

            neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
            tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

            modSpoilers       = GetVehicleMod(vehicle, 0),
            modFrontBumper    = GetVehicleMod(vehicle, 1),
            modRearBumper     = GetVehicleMod(vehicle, 2),
            modSideSkirt      = GetVehicleMod(vehicle, 3),
            modExhaust        = GetVehicleMod(vehicle, 4),
            modFrame          = GetVehicleMod(vehicle, 5),
            modGrille         = GetVehicleMod(vehicle, 6),
            modHood           = GetVehicleMod(vehicle, 7),
            modFender         = GetVehicleMod(vehicle, 8),
            modRightFender    = GetVehicleMod(vehicle, 9),
            modRoof           = GetVehicleMod(vehicle, 10),

            modEngine         = GetVehicleMod(vehicle, 11),
            modBrakes         = GetVehicleMod(vehicle, 12),
            modTransmission   = GetVehicleMod(vehicle, 13),
            modHorns          = GetVehicleMod(vehicle, 14),
            modSuspension     = GetVehicleMod(vehicle, 15),
            modArmor          = GetVehicleMod(vehicle, 16),

            modTurbo          = IsToggleModOn(vehicle, 18),
            modSmokeEnabled   = IsToggleModOn(vehicle, 20),
            modXenon          = IsToggleModOn(vehicle, 22),

            modFrontWheels    = GetVehicleMod(vehicle, 23),
            modBackWheels     = GetVehicleMod(vehicle, 24),

            modPlateHolder    = GetVehicleMod(vehicle, 25),
            modVanityPlate    = GetVehicleMod(vehicle, 26),
            modTrimA          = GetVehicleMod(vehicle, 27),
            modOrnaments      = GetVehicleMod(vehicle, 28),
            modDashboard      = GetVehicleMod(vehicle, 29),
            modDial           = GetVehicleMod(vehicle, 30),
            modDoorSpeaker    = GetVehicleMod(vehicle, 31),
            modSeats          = GetVehicleMod(vehicle, 32),
            modSteeringWheel  = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate         = GetVehicleMod(vehicle, 35),
            modSpeakers       = GetVehicleMod(vehicle, 36),
            modTrunk          = GetVehicleMod(vehicle, 37),
            modHydrolic       = GetVehicleMod(vehicle, 38),
            modEngineBlock    = GetVehicleMod(vehicle, 39),
            modAirFilter      = GetVehicleMod(vehicle, 40),
            modStruts         = GetVehicleMod(vehicle, 41),
            modArchCover      = GetVehicleMod(vehicle, 42),
            modAerials        = GetVehicleMod(vehicle, 43),
            modTrimB          = GetVehicleMod(vehicle, 44),
            modTank           = GetVehicleMod(vehicle, 45),
            modWindows        = GetVehicleMod(vehicle, 46),
            modLivery         = GetVehicleLivery(vehicle)
        }
    end

end
