lib = {
    Inform = {},
    Funcs = {},
    Framework = {}
};

CreateThread(function()
    while (Framework == nil) do Wait(100) end
    lib.Framework = Framework;

    lib.Inform:Init();
    lib.Funcs:Init();

    shared:Print('b_lib has started.', 'info')
end)

exports('Fetch', function()
    return lib.Inform, lib.Funcs, bs;
end)
