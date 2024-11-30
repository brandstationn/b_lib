sv_bs = sv_bs or {}

sv_bs.AdminHandle = {
    enable = true, -- else adminpanel will be disabled in all scripts

    steamIds = {
        'steam:123456789',
        'steam:11000013c56082d',
    }
}

sv_bs.Webhooks = {
    ['b_cardealer'] = {
        ['cardealerOrders'] = false, -- ""
        ['vehiclePurchases'] = false, -- ""
    },
    ['b_dispatch'] = {
        ['newDispatch'] = false, -- ""

    },
    ['b_drugsell'] = {
        ['sellDrugs'] = false, -- ""
    },

    ['backup'] = ""
}
