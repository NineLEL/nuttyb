-- T4 Storage (Metal & Energy)
-- Authors: NineLEL
-- https://github.com/nuttyb-community/nuttyb

do
    if (Spring.GetModOptions().nuttyb_tier4 or '1') == '0' then
        return
    end

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

    -- Explicitly add T4 Storage to T4 and T5 Builders (and remove from T3 if needed logic existed, but we rely on explicit add)
    local builders = {
        'armt4airaide',
        'armt4aide',
        'armnanotct4',
        'armt5aide',
        'armt5airaide',
        'armnanotct5',
        'cort4airaide',
        'cort4aide',
        'cornanotct4',
        'cort5aide',
        'cort5airaide',
        'cornanotct5',
        'legt4airaide',
        'legt4aide',
        'legnanotct4',
        'legt5aide',
        'legt5airaide',
        'legnanotct5',
    }

    local newStorageUnits = {
        'armuwadvmst4',
        'armadvestoret4',
        'coruwadvmst4',
        'coradvestoret4',
        'legamstort4',
        'legadvestoret4',
    }

    for _, builderName in pairs(builders) do
        local faction = builderName:sub(1, 3)
        for _, storageName in pairs(newStorageUnits) do
            if storageName:sub(1, 3) == faction then
                ensureBuildOption(builderName, storageName)
            end
        end
    end
end
