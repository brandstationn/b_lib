lib.Inform = {};

function lib.Inform:InitCustom()
    function lib.Inform:GetPlayer(id)

    end

    function lib.Inform:GetIdentifier(id)
        local player = lib.Inform:GetPlayer(id)

    end

    function lib.Inform:GetPlayerFromIdentifier(identifier)

    end

    function lib.Inform:AddInventoryItem(id, item, count, data)
        if not data then data = {} end

        local player = lib.Inform:GetPlayer(id)
    end

    function lib.Inform:RemoveInventoryItem(id, item, count)
        local player = lib.Inform:GetPlayer(id)

    end

    function lib.Inform:GetInventoryItem(id, item)
        local player = lib.Inform:GetPlayer(id)

    end

    function lib.Inform:GetMoney(id, accountType)
        local player = lib.Inform:GetPlayer(id)

    end

    function lib.Inform:GiveMoney(id, accountType, amount, reason)

    end

    function lib.Inform:RemoveMoney(id, accountType, amount, reason)

    end

    function lib.Inform:CreateCallback(name, passed)

    end

    function lib.Inform:GetPlayers()

    end

    function lib.Inform:ShowNotification(id, text)

    end

    function lib.Inform:GetPlayerData(id)

    end

    function lib.Inform:SetJob(id, job, grade)

    end

    function lib.Inform:FetchBankAccounts(identifier)

    end

    function lib.Inform:FetchInvoices(identifier)

    end

    function lib.Inform:HandleCompanyAccounts(company, func)

    end
end
