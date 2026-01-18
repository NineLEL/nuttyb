-- T5 Cons & Mythical Builders
-- Authors: NineLEL
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, factions, tableMerge, factionPrefix, tableContains =
        UnitDefs or {},
        { 'arm', 'cor', 'leg' },
        table.merge,
        { arm = 'Armada ', cor = 'Cortex ', leg = 'Legion ' },
        table.contains

    local function addNewMergedUnitDef(baseUnit, newUnit, mergeProps)
        if unitDefs[baseUnit] and not unitDefs[newUnit] then
            unitDefs[newUnit] = tableMerge(unitDefs[baseUnit], mergeProps)
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

    for _, faction in pairs(factions) do
        local isArm, isCor, isLeg =
            faction == 'arm', faction == 'cor', faction == 'leg'

        local t4Aide = faction .. 't4aide'
        local t4AirAide = faction .. 't4airaide'
        local t4Turret = faction .. 'nanotct4'

        -- Buildoptions for T5 Aide
        -- Start with everything T4 Aide has
        local t5AideBuildoptions = {}
        if unitDefs[t4Aide] and unitDefs[t4Aide].buildoptions then
            for _, opt in ipairs(unitDefs[t4Aide].buildoptions) do
                table.insert(t5AideBuildoptions, opt)
            end
        end

        -- Add T5 Eco
        local t5Fusion = faction .. 'afust5'
        if unitDefs[t5Fusion] then
            table.insert(t5AideBuildoptions, t5Fusion)
        end

        -- T5 Mythical Construction Turret
        local t5NanoTurret = faction .. 'nanotct5'
        addNewMergedUnitDef(t4Turret, t5NanoTurret, {
            metalcost = 32000,
            energycost = 520000,
            builddistance = 1000,
            buildtime = 640000,
            health = 85000,
            workertime = 17100,
            customparams = {
                techlevel = 5,
                unitgroup = 'buildert5',
                i18n_en_humanname = 'Mythical Construction Turret',
                i18n_en_tooltip = 'MYTHICAL BUILDPOWER! For the chosen ones.',
            },
            buildoptions = t5AideBuildoptions,
        })

        if unitDefs[t5NanoTurret] then
            table.insert(t5AideBuildoptions, t5NanoTurret)
        end

        -- Mythical Ground Constructor Aide
        local t5Aide = faction .. 't5aide'
        addNewMergedUnitDef(t4Aide, t5Aide, {
            buildtime = 1200000,
            energycost = 2000000,
            energyupkeep = 12000,
            health = 75000,
            metalcost = 120000,
            speed = 105,
            workertime = 54000,
            name = factionPrefix[faction] .. 'Mythical Aide',
            customparams = {
                techlevel = 5,
                unitgroup = 'buildert5',
                i18n_en_humanname = 'Mythical Ground Construction Aide',
                i18n_en_tooltip = 'The mythical builder of the ancient kings.',
            },
            buildoptions = t5AideBuildoptions,
        })

        -- Mythical Air Constructor Aide
        local t5AirAide = faction .. 't5airaide'
        addNewMergedUnitDef(t4AirAide, t5AirAide, {
            buildtime = 1200000,
            energycost = 2000000,
            energyupkeep = 12000,
            health = 8000,
            metalcost = 130000,
            speed = 35,
            workertime = 14400,
            name = factionPrefix[faction] .. 'Mythical Aide',
            customparams = {
                techlevel = 5,
                unitgroup = 'buildert5',
                i18n_en_humanname = 'Mythical Air Construction Aide',
                i18n_en_tooltip = 'The mythical air builder of the celestial empire.',
            },
            buildoptions = t5AideBuildoptions,
        })

        -- Back-register T5 units to T4 builders
        ensureBuildOption(t4Aide, t5Aide)
        ensureBuildOption(t4Aide, t5AirAide)
        ensureBuildOption(t4Aide, t5NanoTurret)

        ensureBuildOption(t4AirAide, t5Aide)
        ensureBuildOption(t4AirAide, t5AirAide)
        ensureBuildOption(t4AirAide, t5NanoTurret)

        ensureBuildOption(t4Turret, t5Aide)
        ensureBuildOption(t4Turret, t5AirAide)
        ensureBuildOption(t4Turret, t5NanoTurret)
    end
end
