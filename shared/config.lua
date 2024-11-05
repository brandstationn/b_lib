bs = bs or {}

--We highly recommend you read the documentation before using the lib.
--We highly recommend you read the documentation before using the lib.

-- To change your framework head into fxmanifest.lua and follow the guide.

bs.Debug = true
bs.IgnoreDebug = {
    ['resource_name'] = true,
}

bs.Core = 'ESX' -- ESX OR QB

bs.Dispatch = 'b_dispatch' -- [b_dispatch / cd_dispatch / custom]

bs.missingIMG = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'

bs.SQL = {

    ['vehicle'] = {
        Table = 'player_vehicles',
        Columns = {
            ['license'] = 'license',
            ['vehicle'] = 'vehicle',
            ['hash'] = 'hash',
            ['mods'] = 'mods',

            ['owner'] = 'citizenid',
            ['garage'] = 'garage',
            ['plate'] = 'plate'
        }
    },
    ['characters'] = {
        Table = 'players',
        Columns = {
            ['character'] = 'citizenid',

        }
    }
}
