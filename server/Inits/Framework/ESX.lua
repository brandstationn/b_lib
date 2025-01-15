lib.Inform = {};

function lib.Inform:Init()
    function lib.Inform:GetPlayer(id)
        return lib.Framework.GetPlayerFromId(id)
    end

    function lib.Inform:GetIdentifier(id)
        local player = lib.Inform:GetPlayer(id)

        return player.socialnumber or player.id or player.identifier
    end

    function lib.Inform:GetPlayerFromIdentifier(identifier)
        return lib.Framework.GetPlayerFromSocialnumber(identifier) or lib.Framework.GetPlayerFromIdentifier(identifier)
    end

    function lib.Inform:AddInventoryItem(id, item, count, data)
        if not data then data = {} end

        local player = lib.Inform:GetPlayer(id)

        local status, error = pcall(function() player.addInventoryItem(item, count, data) end)
        if not status then
            player.addInventoryItem({
                item = item,
                count = count,
                data = data
            })
        end
    end

    function lib.Inform:RemoveInventoryItem(id, item, count)
        local player = self.Inform:GetPlayer(id)

        player.removeInventoryItem(item, count)
    end

    function lib.Inform:GetInventoryItem(id, item)
        local player = lib.Inform:GetPlayer(id)

        return player.getInventoryItem(item) or {count = 0}
    end

    function lib.Inform:GetMoney(id, accountType)
        local player = lib.Inform:GetPlayer(id)

        if accountType == "cash" then
            return player.getMoney()
        elseif accountType == "bank" then
            local status, error = pcall(function() return player.getAccount('bank').money end)
            if not status then
                return exports.bank:getMainAccountMoney(player.socialnumber)
            end
        elseif accountType == "black_money" then
            return player.getAccount('black_money').money
        end

        if accountType == 'all' then
            return {
                {
                    name = "cash",
                    money = player.getMoney()
                },
                {
                    name = "bank",
                    money = (player.getAccount('bank')) and player.getAccount('bank').money or exports.bank:getMainAccountMoney(player.socialnumber)
                },
            }
        end
    end

    function lib.Inform:GiveMoney(id, accountType, amount, reason)
        if not reason then reason = "No reason provided" end
        amount = tonumber(amount)

        local player = lib.Inform:GetPlayer(id)

        if accountType == 'cash' then
            player.addMoney(amount)
        elseif accountType == "bank" then
            player.addAccountMoney('bank', amount)
        elseif accountType == 'black_money' then
            player.addAccountMoney('black_money', amount)
        end
    end

    function lib.Inform:RemoveMoney(id, accountType, amount, reason)
        if not reason then reason = "No reason provided" end
        if(type(amount) ~= 'number') then amount = tonumber(amount) end

        local player = lib.Inform:GetPlayer(id)

        if accountType == 'cash' then
            player.removeMoney(amount)
        elseif accountType == "bank" then
            player.removeAccountMoney('bank', amount)
        elseif accountType == 'black_money' then
            player.removeAccountMoney('black_money', amount)
        end
    end

    function lib.Inform:CreateCallback(name, passed)
        lib.Framework.RegisterServerCallback(name, passed)
    end

    function lib.Inform:GetPlayers()
        return lib.Framework.GetPlayers()
    end

    function lib.Inform:ShowNotification(id, text)
        TriggerClientEvent('esx:showNotification', id, text)
    end

    function lib.Inform:GetPlayerData(id)
        local player = lib.Inform:GetPlayer(id)
        local info = nil
        local missingData = 'Unknown'
        local missingImg = bs.missingIMG


        -- change if needed
        info = {
            identifier = player.identifier or player.id or missingData,
            src = player.source or missingData,

            firstname = player.variables.firstName or player.firstname or missingData,
            lastname = player.variables.lastName or player.lastname or missingData,
            dob = player.variables.dateofbirth or player.dateofbirth or missingData,
            phonenumber = player.phone_number or missingData,

            jobName = player.job.name or missingData,
            gradeLabel = player.job.grade_label or missingData,
            grade = player.job.grade or missingData,
            jobLabel = player.job.label or missingData
        }
        return info
    end

    function lib.Inform:SetJob(id, job, grade)
        local player = lib.Inform:GetPlayer(id)

        player.setJob(job, grade)
    end

    function lib.Inform:FetchBankAccounts(identifier)
        return MySQL.query.await('SELECT * FROM `bank_accounts` WHERE `owner` = ?', {
            identifier
        })
    end

    function lib.Inform:HandleCompanyAccounts(company, func)
        local cAccount = {};
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. company, function(account)
            cAccount = account
        end)
        if not cAccount then
            cAccount = nil
            shared:Print('Unable to access account.', 'warning')
        end;
        print(cAccount)

        if func.name == 'add' then
            if cAccount then
                cAccount.addMoney(tonumber(func.amount))
            end
        elseif func.name == 'remove' then
            if cAccount then
                cAccount.removeMoney(tonumber(func.amount))
            end
        elseif func.name == 'get' then
            if cAccount then
                return tonumber(cAccount.money)
            else
                return 0 -- or any default value you want to return when cAccount is nil
            end
        end
        return cAccount
    end
end
