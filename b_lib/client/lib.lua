lib = {
    Inform = {},
    Funcs = {},
    Streaming = {},
    Customs = {},
    Utils = {},
    Framework = {}
};

CreateThread(function()
    while (Framework == nil) do Wait(100) end
    lib.Framework = Framework;

    lib.Inform:Init();
    lib.Funcs:Init();
    lib.Utils:Init();
    lib.Customs:Init();
    lib.Streaming:Init();

    print("^0 Just loaded ^2[ b_lib ]!^0");
end)

exports('Fetch', function()
    return lib.Inform, lib.Funcs, lib.Utils, lib.Customs, lib.Streaming, bs;
end)
