Framework = {}

---@type table
local frameworks = {
    { resourceName = 'es_extended', initial = 'ESX', fetch = function(resourceName)
        Framework = exports[resourceName]:getSharedObject()

        -- Old ESX Fetch below
        --[[
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        ]]
    end},
    { resourceName = 'qb-core', initial = 'QBCore', fetch = function(resourceName)
        Framework = exports[resourceName]:GetCoreObject()
    end}
    -- add your custom framework here
}

shared:Print('Searching for compatible frameworks...', 'info')
for _, f in pairs(frameworks) do
    local resourceState = GetResourceState(f.resourceName)

    if (resourceState == "started") then
        f.fetch(f.resourceName)
        shared:Print('Successfully fetched ' .. f.initial .. ' for b_lib', 'success')
        break
    end
end

if (Framework == nil) then
    error("Could not find your framework, this is critical!")
end
