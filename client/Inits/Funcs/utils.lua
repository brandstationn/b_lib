lib.Utils = {}

function lib.Utils:Init()
    function lib.Utils:Trim(value)
        if value then
            return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
        else
            return nil
        end
    end

    function lib.Utils:FormatJob(details)
        local job = {
            name = details?.name or "NAME NOT FOUND",
            label = details?.label or "LABEL NOT FOUND",
        }

        return job
    end
end
