-- T5 Eco (Mythical Fusion)
-- Authors: NineLEL
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, tableMerge = UnitDefs or {}, table.merge

    local factions = { 'arm', 'cor', 'leg' }
    local factionPrefix = {
        arm = 'Armada ',
        cor = 'Cortex ',
        leg = 'Legion ',
    }

    local function cloneUnit(sourceUnit, targetUnit, overrides)
        if unitDefs[sourceUnit] and not unitDefs[targetUnit] then
            unitDefs[targetUnit] = tableMerge(unitDefs[sourceUnit], overrides)
        end
    end

    for _, faction in ipairs(factions) do
        -- T5 Mythical Fusion Reactor
        local t4Fusion = faction .. 'afust4'
        local t5Fusion = faction .. 'afust5'
        
        local fusion4Def = unitDefs[t4Fusion]
        if fusion4Def then
            cloneUnit(t4Fusion, t5Fusion, {
                name = 'Mythical Fusion Reactor',
                buildtime = math.ceil(fusion4Def.buildtime * 2.2),
                metalcost = 120000,
                energycost = 3000000,
                energymake = 180000,
                energystorage = 500000,
                health = 480000,
                footprintx = 16,
                footprintz = 16,
                customparams = {
                    techlevel = 5,
                    unitgroup = 'energy',
                    i18n_en_humanname = 'Mythical Fusion Reactor',
                    i18n_en_tooltip = 'Produces 180,000 Energy (non-explosive)',
                },
            })
        end
    end
end
