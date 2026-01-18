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
                -- Extreme Hazard
                explodeas = 'BANTHA_BLAST',
                selfdestructas = 'BANTHA_BLAST',
                customparams = {
                    techlevel = 5,
                    unitgroup = 'energy',
                    i18n_en_humanname = 'Mythical Fusion Reactor',
                    i18n_en_tooltip = 'Produces 180,000 Energy. WARNING: EXTREME HAZARD UPON DESTRUCTION!',
                },
            })
        end
    end

    local function ensureBuildOption(builderName, optionName)
        local builder = unitDefs[builderName]
        if not builder or not unitDefs[optionName] then
            return
        end
        builder.buildoptions = builder.buildoptions or {}
        local found = false
        for _, opt in ipairs(builder.buildoptions) do
            if opt == optionName then
                found = true
                break
            end
        end
        if not found then
            table.insert(builder.buildoptions, optionName)
        end
    end

    -- Explicitly add T5 Eco (Fusion) to T5 Builders ONLY
    local t5Builders = {
        'armt5aide',
        'armt5airaide',
        'armnanotct5',
        'cort5aide',
        'cort5airaide',
        'cornanotct5',
        'legt5aide',
        'legt5airaide',
        'legnanotct5',
    }

    local t5Fusions = {
        'armafust5',
        'corafust5',
        'leghafust5', -- assuming generic pattern, checking logic below
    }

    for _, builderName in pairs(t5Builders) do
        local faction = builderName:sub(1, 3)
        local fusionName = faction .. 'afust5'
        if faction == 'leg' then
            fusionName = 'leghafust5'
        end -- Legion naming convention fix

        -- Override if specific name exists
        if unitDefs[fusionName] then
            ensureBuildOption(builderName, fusionName)
        end
    end
end
