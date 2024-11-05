lib.ClientCallbacks = {}

RegisterNetEvent('b_lib:Client:TriggerClientCallback', function(name, ...)
    lib.Funcs:TriggerClientCallback(name, function(...)
        TriggerServerEvent('b_lib:Server:TriggerClientCallback', name, ...)
    end, ...)
end)
