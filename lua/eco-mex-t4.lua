-- T4 Metal Extractors
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
        local t3MexName = faction .. 'mohot3'
        local t4MexName = faction .. 'mohot4'
        
        -- Scaling: ~3x cost/HP, 2x extraction of T3
        addNewMergedUnitDef(t3MexName, t4MexName, {
            metalcost = 10000,
            energycost = 84000,
            buildtime = 128000,
            health = 10000,
            extractsmetal = 0.025,
            name = factionPrefix[faction] .. 'Legendary Metal Extractor',
            customparams = {
                techlevel = 4,
                unitgroup = 'eco',
                i18n_en_humanname = 'Legendary Metal Extractor',
                i18n_en_tooltip = 'The legendary pinnacle of metal extraction. Unlimited power!',
            },
        })
    end
end
