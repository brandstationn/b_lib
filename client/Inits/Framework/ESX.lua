lib.Inform = {};

function lib.Inform:Init()
    function lib.Inform:TriggerCallback(name, cb, ...)
        local promise = promise.new()

        lib.Framework.TriggerServerCallback(name, function(res)
            if (type(cb) == "table" or type(cb) == "function") then
                cb(res)
            end

            promise:resolve(res)
        end, ...)

        Citizen.Await(promise)
        if (cb == false) then
            return promise.value
        end
    end

    function lib.Inform:ShowNotification(text)
        lib.Framework.ShowNotification(text)
    end

    function lib.Inform:GetPlayerData()
        local info = {}
        local missingData = 'Unknown'
        local missingImg = bs.missingIMG

        local playerData = lib.Framework.GetPlayerData()
        info = {
            identifier = playerData.identifier or missingData,

            firstname = playerData.firstName or missingData,
            lastname = playerData.lastName or missingData,
            dob = playerData.dateofbirth or playerData.character.dob or missingData,
            phonenumber = playerData.phone_number or missingData,
            img = playerData.image or missingImg,

            jobName = playerData.job.name or missingData,
            gradeLabel = playerData.job.grade_label or missingData,
            grade = playerData.job.grade or missingData,
            jobLabel = playerData.job.label or missingData
        }
        return info
    end

    function lib.Inform:IsPlayerLoaded()
        return lib.Framework.IsPlayerLoaded()
    end
end

RegisterNetEvent("esx:setJob", function(job)
    shared:Print("Job update: sending new event...", 'info')
    TriggerEvent("b_lib:plyJobUpdate", lib.Utils:FormatJob(job))
end)

RegisterNetEvent("esx:playerLoaded", function(player)
    Wait(1)
    local job = player.job.name -- change this if needed
    shared:Print("Character Loaded: sending new event...", 'info')
    TriggerEvent('b_lib:plyCharacterLoaded', tostring(job))
end)
