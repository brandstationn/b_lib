lib.ClientCallbacks = {}

RegisterNetEvent('b_lib:Server:TriggerClientCallback', function(name, ...)
    if lib.ClientCallbacks[name] then
        lib.ClientCallbacks[name](...)
        lib.ClientCallbacks[name] = nil
    end
end)
