lib.Inform = {};

function lib.Inform:Init()
    function lib.Inform:TriggerCallback(name, cb, ...)
        local promise = promise.new()

        -- YOURCORE.TriggerCallback(name, function(res)
        --     if (type(cb) == "table" or type(cb) == "function") then
        --         cb(res)
        --     end

        --     promise:resolve(res)
        -- end, ...)

        Citizen.Await(promise)
        if (cb == false) then
            return promise.value
        end
    end

    function lib.Inform:ShowNotification(text)

    end

    function lib.Inform:GetPlayerData()
        local info = {}
        local missingData = 'Unknown'
        local missingImg = bs.missingIMG

        local playerData =
        info = {
            identifier = playerData or missingData,

            firstname = playerData or missingData,
            lastname = playerData or missingData,
            dob = playerData or missingData,
            phonenumber = playerData or missingData,
            img = playerData or missingImg,

            jobName = playerData or missingData,
            gradeLabel = playerData or missingData,
            grade = playerData or missingData,
            jobLabel = playerData or missingData
        }
        return info
    end

    function lib.Inform:IsPlayerLoaded()
        return lib.Framework.Functions.GetPlayerData().charinfo ~= nil
    end
end
