lib.Inform = {};

function lib.Inform:Init()
    function lib.Inform:GetPlayer(id)
        print(type(id))

        --print(json.encode(lib.Framework.Functions.GetPlayer(id), {indent = true}))
        return lib.Framework.Functions.GetPlayer(id)
    end

    function lib.Inform:GetIdentifier(id)
        local player = lib.Inform:GetPlayer(id)

        return player.PlayerData.citizenid
    end

    function lib.Inform:GetPlayerFromIdentifier(identifier)
        return lib.Framework.Functions.GetPlayerByCitizenId(identifier)
    end

    function lib.Inform:AddInventoryItem(id, item, count, data)
        if not data then data = {} end
        local player = lib.Inform:GetPlayer(id)

        player.Functions.AddItem(item, count, false, data)
    end

    function lib.Inform:RemoveInventoryItem(id, item, count)
        local player = self.Inform:GetPlayer(id)

        player.Functions.RemoveItem(item, count)
    end

    function lib.Inform:GetInventoryItem(id, item)
        local player = lib.Inform:GetPlayer(id)

        if not player.Functions.GetItemByName(item) then return {count = 0} end
        local item = player.Functions.GetItemByName(item)
        local formated = {
            count = item.amount
        }
        return formated
    end

    function lib.Inform:GetMoney(id, accountType)
        local player = lib.Inform:GetPlayer(id)

        if accountType == "cash" then
            return player.Functions.GetMoney('cash')
        elseif accountType == "bank" then
            return player.Functions.GetMoney('bank')
        elseif accountType == "black_money" then
            return player.Functions.GetMoney('black_money')
        end

        if accountType == 'all' then
            return {
                {
                    name = "cash",
                    money = player.Functions.GetMoney('cash')
                },
                {
                    name = "bank",
                    money = player.Functions.GetMoney('bank')
                },
            }
        end
    end

    function lib.Inform:GiveMoney(id, accountType, amount, reason)
        if not reason then reason = "No reason provided" end
        amount = tonumber(amount)

        local player = lib.Inform:GetPlayer(id)

        if accountType == 'cash' then
            player.Functions.AddMoney('cash', amount, reason)
        elseif accountType == "bank" then
            player.Functions.AddMoney('bank', amount, reason)
        elseif accountType == 'black_money' then
            player.Functions.AddMoney('black_money', amount, reason)
        end
    end

    function lib.Inform:RemoveMoney(id, accountType, amount, reason)
        if not reason then reason = "No reason provided" end
        if(type(amount) ~= 'number') then amount = tonumber(amount) end

        local player = lib.Inform:GetPlayer(id)

        if accountType == 'cash' then
            player.Functions.RemoveMoney('cash', amount, reason)
        elseif accountType == "bank" then
            player.Functions.RemoveMoney('bank', amount, reason)
        elseif accountType == 'black_money' then
            player.Functions.RemoveMoney('black_money', amount, reason)
        end
    end

    function lib.Inform:CreateCallback(name, passed)
        lib.Framework.Functions.CreateCallback(name, passed)
    end

    function lib.Inform:GetPlayers()
        return lib.Framework.Functions.GetPlayers()
    end

    function lib.Inform:ShowNotification(id, text)
        lib.Framework.Functions.Notify(id, text)
    end

    function lib.Inform:GetPlayerData(id)
        local player = lib.Inform:GetPlayer(id)
        local info = nil
        local missingData = 'Unknown'
        local missingImg = bs.missingIMG

        info = {
            identifier = player.PlayerData.citizenid or player.citizenid or missingData,
            src = player.PlayerData.source or missingData,

            firstname = player.PlayerData.charinfo.firstname or missingData,
            lastname = player.PlayerData.charinfo.lastname or missingData,
            dob = player.PlayerData.citizenid or player.citizenid or missingData,
            phonenumber = player.PlayerData.charinfo.phone or missingData,
            img = player.PlayerData.charinfo.image or missingImg,

            jobName = player.PlayerData.job.name or missingData,
            gradeLabel = player.PlayerData.job.grade.name or missingData,
            grade = player.PlayerData.job.grade.level or missingData,
            jobLabel = player.PlayerData.job.label or missingData
        }
        return info
    end

    function lib.Inform:SetJob(id, job, grade)
        local player = lib.Inform:GetPlayer(id)

        player.Functions.SetJob(job, grade)
    end

    function lib.Inform:FetchBankAccounts(identifier)
        local accounts = MySQL.query.await('SELECT * FROM `bank_accounts` WHERE `citizenid` = ?', {
            identifier
        })
        local formatedAccounts = {}
        for _,v in pairs(accounts) do
            table.insert(formatedAccounts, {
                name = tostring(v.account_type),
                accountnumber = tostring(v.account_type),
                balance = tonumber(v.amount),
                owner = v.citizenid
            })
        end
        return formatedAccounts
    end

    function lib.Inform:FetchInvoices(identifier)
        local invoices = MySQL.query.await('SELECT * FROM `phone_invoices` WHERE `citizenid` = ?', {
            identifier
        })

        local tableInvoices = {}
        for k,v in pairs(invoices) do
            table.insert(tableInvoices, {
                dob = v.citizenid,
                amount = tonumber(v.amount),
                desc = v.sender,
            })
        end

        return tableInvoices
    end

    function lib.Inform:HandleCompanyAccounts(company, func)
        if func.name == 'add' then
            --exports['qb-management']:AddMoney(company, tonumber(func.amount))
        elseif func.name == 'remove' then
            --exports['qb-management']:RemoveMoney(company, tonumber(func.amount))
        elseif func.name == 'get' then
            return 25000 --exports['qb-management']:GetAccount(company)
        end
        return true
    end
end
