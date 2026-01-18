-- T3 Metal Extractors
-- Authors: NineLEL
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, tableMerge = UnitDefs or {}, table.merge

    local factions = { 'arm', 'cor', 'leg' }
    local factionPrefix = { arm = 'Armada ', cor = 'Cortex ', leg = 'Legion ' }

    local function addNewMergedUnitDef(baseUnit, newUnit, mergeProps)
        if unitDefs[baseUnit] and not unitDefs[newUnit] then
            unitDefs[newUnit] = tableMerge(unitDefs[baseUnit], mergeProps)
        end
    end

    for _, faction in ipairs(factions) do
        local isLegion = (faction == 'leg')

        local baseUnits = {
            arm = 'armshockwave',
            cor = 'cormexp',
            leg = 'legmohocon',
        }
        local baseMohoName = baseUnits[faction]

        local t3MexName = faction .. 'mohot3'

        addNewMergedUnitDef(baseMohoName, t3MexName, {
            metalcost = 4000,
            energycost = 32000,
            buildtime = 80000,
            health = 3600,
            extractsmetal = 0.008,
            name = factionPrefix[faction] .. 'Epic Metal Extractor',
            customparams = {
                techlevel = 3,
                unitgroup = 'eco',
                i18n_en_humanname = 'Epic Metal Extractor',
                i18n_en_tooltip = 'Extreme efficiency metal extraction. Chopped chicken!',
            },
        })
    end
end
