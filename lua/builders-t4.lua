-- T4 Cons & Legendary Builders
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
        if not tableContains(builder.buildoptions, optionName) then
            table.insert(builder.buildoptions, optionName)
        end
    end

    for _, faction in pairs(factions) do
        local isArm, isCor, isLeg =
            faction == 'arm', faction == 'cor', faction == 'leg'

        -- Base T3 Aide setup to inherit from
        local t3Aide = faction .. 't3aide'
        local t3AirAide = faction .. 't3airaide'

        -- Buildoptions for T4 Aide
        -- Start with everything T3 Aide has
        local t4AideBuildoptions = {}
        if unitDefs[t3Aide] and unitDefs[t3Aide].buildoptions then
            for _, opt in ipairs(unitDefs[t3Aide].buildoptions) do
                table.insert(t4AideBuildoptions, opt)
            end
        end

        -- Add T4 Eco
        local baseConverterName = isLeg and 'legadveconv' or (faction .. 'mmkr')
        local t4Converter = baseConverterName .. 't4'
        local t4Fusion = faction .. 'afust4'

        if unitDefs[t4Converter] then
            table.insert(t4AideBuildoptions, t4Converter)
        end
        if unitDefs[t4Fusion] then
            table.insert(t4AideBuildoptions, t4Fusion)
        end
        local t3Mex = faction .. 'mohot3'
        if unitDefs[t3Mex] then
            table.insert(t4AideBuildoptions, t3Mex)
        end
        local t4Mex = faction .. 'mohot4'
        if unitDefs[t4Mex] then
            table.insert(t4AideBuildoptions, t4Mex)
        end
        local t4MetalStore = isLeg and 'legamstort4' or faction .. 'uwadvmst4'
        if unitDefs[t4MetalStore] then
            table.insert(t4AideBuildoptions, t4MetalStore)
        end
        local t4EnergyStore = isLeg and 'legadvestoret4'
            or faction .. 'advestoret4'
        if unitDefs[t4EnergyStore] then
            table.insert(t4AideBuildoptions, t4EnergyStore)
        end

        -- T4 Construction Turret
        local t4NanoTurret = faction .. 'nanotct4'
        addNewMergedUnitDef(faction .. 'nanotct3', t4NanoTurret, {
            metalcost = 11000,
            energycost = 186000,
            builddistance = 750,
            buildtime = 320000,
            health = 26400,
            workertime = 5700,
            customparams = {
                i18n_en_humanname = 'T4 Construction Turret',
                i18n_en_tooltip = 'Ultimate BUILDPOWER! For the legendary commander',
            },
            buildoptions = t4AideBuildoptions,
        })

        if unitDefs[t4NanoTurret] then
            table.insert(t4AideBuildoptions, t4NanoTurret)
        end

        -- Legendary Ground Constructor Aide
        local t4Aide = faction .. 't4aide'
        addNewMergedUnitDef(t3Aide, t4Aide, {
            buildtime = 420000,
            energycost = 600000,
            energyupkeep = 6000,
            health = 25000,
            metalcost = 38000,
            speed = 95,
            workertime = 18000,
            name = factionPrefix[faction] .. 'Legendary Aide',
            customparams = {
                techlevel = 4,
                unitgroup = 'buildert4',
                i18n_en_humanname = 'Legendary Ground Construction Aide',
                i18n_en_tooltip = 'The ultimate builder for the ultimate commander',
            },
            buildoptions = t4AideBuildoptions,
        })

        -- Legendary Air Constructor Aide
        local t4AirAide = faction .. 't4airaide'
        addNewMergedUnitDef(t3AirAide, t4AirAide, {
            buildtime = 420000,
            energycost = 600000,
            energyupkeep = 6000,
            health = 2750,
            metalcost = 40000,
            speed = 30,
            workertime = 4800,
            name = factionPrefix[faction] .. 'Legendary Aide',
            customparams = {
                techlevel = 4,
                unitgroup = 'buildert4',
                i18n_en_humanname = 'Legendary Air Construction Aide',
                i18n_en_tooltip = 'The ultimate air builder for the ultimate commander',
            },
            buildoptions = t4AideBuildoptions,
        })
    end
end
