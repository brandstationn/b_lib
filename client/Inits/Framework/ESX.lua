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
            identifier = playerData.character.socialnumber or playerData.identifier or playerData.id or missingData,

            firstname = playerData.character.firstname or missingData,
            lastname = playerData.character.lastname or missingData,
            dob = playerData.character.socialnumber or playerData.character.dob or missingData,
            phonenumber = playerData.character.phone_number or missingData,
            img = playerData.character.image or missingImg,

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

RegisterNetEvent("esx:playerLoaded", function()
    Wait(1)
    shared:Print("Character Loaded: sending new event...", 'info')
    TriggerEvent('b_lib:plyCharacterLoaded')
end)
