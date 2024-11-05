lib.Streaming = {}

function lib.Streaming:Init()
    function lib.Streaming:RequestModel(model)
        local model = (type(model) == 'number' and model or GetHashKey(model))
        if HasModelLoaded(model) then return true end
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        if HasCollisionForModelLoaded(model) then return true end
        RequestCollisionForModel(model)
        while not HasCollisionForModelLoaded(model) do Wait(0) end
    end

    function lib.Streaming:LoadAnimDict(dict)
        if HasAnimDictLoaded(dict) then return true end
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
    end
end
