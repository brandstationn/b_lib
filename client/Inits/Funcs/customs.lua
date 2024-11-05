lib.Customs = {}

function lib.Customs:Init()
    function lib.Customs:OpenBossMenu(job)
        TriggerEvent("force_bossmenu:openPanel", job)
    end

end
