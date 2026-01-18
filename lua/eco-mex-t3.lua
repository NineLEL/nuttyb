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
        
        -- Base names for Moho Mines
        -- Armada: armmoho (or armamex), Cortex: cormoho (or coramex), Legion: legmoho
        -- Using 'moho' as the reliable suffix for T2 extraction
        local baseMohoName = faction .. 'moho'
        
        -- Fallback check for 'amex' if 'moho' isn't found in unitDefs
        if not unitDefs[baseMohoName] then
            baseMohoName = (faction == 'leg' and 'legmoho') or (faction .. 'amex')
        end

        local t3MexName = faction .. 'mohot3'
        
        -- Scaling: ~3x T2
        addNewMergedUnitDef(baseMohoName, t3MexName, {
            metalcost = 3300,
            energycost = 28000,
            buildtime = 64000,
            health = 3200,
            -- The 'extractsmetal' property handles the income from the spot.
            -- Increasing it allows it to take more from the same spot.
            -- Scaling from T2 (0.004) to T3 (0.012)
            extractsmetal = 0.0125,
            name = factionPrefix[faction] .. 'Legendary Metal Extractor',
            customparams = {
                techlevel = 3,
                unitgroup = 'eco',
                i18n_en_humanname = 'Legendary Metal Extractor',
                i18n_en_tooltip = 'Extreme efficiency metal extraction. Chopped chicken!',
            },
        })
    end
end
