-- T4 Storage (Metal & Energy)
-- Authors: NineLEL
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, factions, tableMerge, factionPrefix =
        UnitDefs or {},
        { 'arm', 'cor', 'leg' },
        table.merge,
        { arm = 'Armada ', cor = 'Cortex ', leg = 'Legion ' }

    local function addNewMergedUnitDef(baseUnit, newUnit, mergeProps)
        if unitDefs[baseUnit] and not unitDefs[newUnit] then
            unitDefs[newUnit] = tableMerge(unitDefs[baseUnit], mergeProps)
        end
    end

    for _, faction in pairs(factions) do
        local isLeg = faction == 'leg'

        -- T4 Metal Storage
        local t3MetalStore = isLeg and 'legamstort3' or faction .. 'uwadvmst3'
        local t4MetalStore = isLeg and 'legamstort4' or faction .. 'uwadvmst4'

        addNewMergedUnitDef(t3MetalStore, t4MetalStore, {
            metalstorage = 100000,
            metalcost = 12600,
            energycost = 693450,
            buildtime = 428400,
            health = 160000,
            maxthisunit = 20,
            name = factionPrefix[faction] .. 'Legendary Metal Storage',
            customparams = {
                i18n_en_humanname = 'Legendary Metal Storage',
                i18n_en_tooltip = 'Massive metal storage for the legendary commander.',
            },
        })

        -- T4 Energy Storage
        local t3EnergyStore = isLeg and 'legadvestoret3'
            or (faction == 'arm' and 'armadvestoret3' or 'coradvestoret3')

        local t3EnergyID = isLeg and 'legadvestoret3'
            or faction .. 'advestoret3'
        local t4EnergyStore = isLeg and 'legadvestoret4'
            or faction .. 'advestoret4'

        addNewMergedUnitDef(t3EnergyID, t4EnergyStore, {
            energystorage = 1000000,
            metalcost = 6300,
            energycost = 177000,
            buildtime = 280140,
            health = 150000,
            maxthisunit = 20,
            name = factionPrefix[faction] .. 'Legendary Energy Storage',
            customparams = {
                i18n_en_humanname = 'Legendary Energy Storage',
                i18n_en_tooltip = 'UNLIMITED POWER STORAGE (almost).',
            },
        })
    end
end
