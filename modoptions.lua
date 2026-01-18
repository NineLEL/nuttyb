local options = {
    {
        key = 'nuttyb_options',
        name = 'NuttyB Options',
        desc = 'Options for the NuttyB mod',
        type = 'section',
    },
    {
        key    = 'nuttyb_evo_commander',
        name   = 'Enable Evo Commander',
        desc   = 'Enables Commander Evolution mechanics (XP/Leveling)',
        type   = 'bool',
        def    = true,
        section= 'nuttyb_options',
    },
    {
        key    = 'nuttyb_tier4',
        name   = 'Enable Tier 4 (Legendary)',
        desc   = 'Enables Tier 4 Units and Structures',
        type   = 'bool',
        def    = true,
        section= 'nuttyb_options',
    },
    {
        key    = 'nuttyb_tier5',
        name   = 'Enable Tier 5 (Mythical)',
        desc   = 'Enables Tier 5 Units and Structures',
        type   = 'bool',
        def    = true,
        section= 'nuttyb_options',
    },
}
return options
