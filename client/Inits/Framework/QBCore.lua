lib.Inform = {};

function lib.Inform:Init()
    function lib.Inform:TriggerCallback(name, cb, ...)
        local promise = promise.new()

        lib.Framework.Functions.TriggerCallback(name, function(res)
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
        lib.Framework.Functions.Notify(text)
    end

    function lib.Inform:GetPlayerData()
        local info = {}
        local missingData = 'Unknown'
        local missingImg = bs.missingIMG

        local playerData = lib.Framework.Functions.GetPlayerData()
        info = {
            identifier = playerData.citizenid or missingData,

            firstname = playerData.charinfo.firstname or missingData,
            lastname = playerData.charinfo.lastname or missingData,
            dob = playerData.charinfo.dob or missingData,
            phonenumber = playerData.charinfo.phone_number or missingData,
            img = playerData.charinfo.image or missingImg,

            jobName = playerData.job.name or missingData,
            gradeLabel = playerData.job.grade.label or missingData,
            grade = playerData.job.grade.name or missingData,
            jobLabel = playerData.job.label or missingData
        }
        return info
    end

    function lib.Inform:IsPlayerLoaded()
        return lib.Framework.Functions.GetPlayerData().charinfo ~= nil
    end
end

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(job)
    shared:Print("Job update: sending new event...", 'info')
    TriggerEvent("b_lib:plyJobUpdate", lib.Utils:FormatJob(job))
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    Wait(1)
    shared:Print("Character Loaded: sending new event...", 'info')
    TriggerEvent('b_lib:plyCharacterLoaded')
end)
