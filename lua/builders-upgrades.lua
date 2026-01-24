-- Builder & Storage Upgrades (T3 & T4)
-- Authors: NineLEL, Nervensaege, TetrisCo
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, tableMerge, tableContains =
        UnitDefs or {}, table.merge, table.contains
    local factions = { 'arm', 'cor', 'leg' }
    local factionPrefix = { arm = 'Armada ', cor = 'Cortex ', leg = 'Legion ' }

    local function addNewMergedUnitDef(baseUnit, newUnit, mergeProps)
        if unitDefs[baseUnit] and not unitDefs[newUnit] then
            unitDefs[newUnit] = tableMerge(unitDefs[baseUnit], mergeProps)
        end
    end

    for _, faction in ipairs(factions) do
        local isArm, isCor, isLeg =
            faction == 'arm', faction == 'cor', faction == 'leg'

        -----------------------------------------------------------------------
        -- Construction Turrets (T3 & T4)
        -----------------------------------------------------------------------

        -- T3 Construction Turret
        addNewMergedUnitDef(faction .. 'nanotct2', faction .. 'nanotct3', {
            metalcost = 3700,
            energycost = 62000,
            builddistance = 550,
            buildtime = 108000,
            collisionvolumescales = '61 128 61',
            footprintx = 6,
            footprintz = 6,
            health = 8800,
            mass = 37200,
            sightdistance = 575,
            workertime = 1900,
            icontype = 'armnanotct2',
            canrepeat = true,
            objectname = isLeg and 'Units/legnanotcbase.s3o'
                or isCor and 'Units/CORRESPAWN.s3o'
                or 'Units/ARMRESPAWN.s3o',
            customparams = {
                i18n_en_humanname = 'T3 Construction Turret',
                i18n_en_tooltip = 'More BUILDPOWER! For the connoisseur',
            },
        })

        -- T4 Construction Turret
        addNewMergedUnitDef(faction .. 'nanotct3', faction .. 'nanotct4', {
            metalcost = 11000,
            energycost = 186000,
            builddistance = 500,
            buildtime = 320000,
            health = 26400,
            workertime = 3800,
            customparams = {
                i18n_en_humanname = 'T4 Construction Turret',
                i18n_en_tooltip = 'Ultimate BUILDPOWER! For the legendary commander',
            },
        })

        -----------------------------------------------------------------------
        -- Storage Units (T3 & T4)
        -----------------------------------------------------------------------

        -- Metal Storage
        local mStorBase = isLeg and 'legamstor' or faction .. 'uwadvms'

        -- T3 Metal Storage
        addNewMergedUnitDef(
            mStorBase,
            isLeg and 'legamstort3' or faction .. 'uwadvmst3',
            {
                metalstorage = 30000,
                metalcost = 4200,
                energycost = 231150,
                buildtime = 142800,
                health = 53560,
                maxthisunit = 20,
                icontype = 'armuwadves',
                name = factionPrefix[faction] .. 'T3 Metal Storage',
                customparams = {
                    i18n_en_humanname = 'T3 Hardened Metal Storage',
                    i18n_en_tooltip = 'The big metal storage tank for your most precious resources. Chopped chicken!',
                },
            }
        )

        -- T4 Metal Storage
        addNewMergedUnitDef(
            isLeg and 'legamstort3' or faction .. 'uwadvmst3',
            isLeg and 'legamstort4' or faction .. 'uwadvmst4',
            {
                metalstorage = 100000,
                metalcost = 15000,
                energycost = 800000,
                buildtime = 500000,
                health = 150000,
                name = factionPrefix[faction] .. 'Legendary Metal Storage',
                customparams = {
                    i18n_en_humanname = 'Legendary Hardened Metal Storage',
                    i18n_en_tooltip = 'Pinnacle of resource containment. The gold standard!',
                },
            }
        )

        -- Energy Storage
        local eStorBase = isLeg and 'legadvestore' or faction .. 'uwadves'

        -- T3 Energy Storage
        addNewMergedUnitDef(
            eStorBase,
            isLeg and 'legadvestoret3' or faction .. 'advestoret3',
            {
                energystorage = 272000,
                metalcost = 2100,
                energycost = 59000,
                buildtime = 93380,
                health = 49140,
                icontype = 'armuwadves',
                maxthisunit = 20,
                name = factionPrefix[faction] .. 'T3 Energy Storage',
                customparams = {
                    i18n_en_humanname = 'T3 Hardened Energy Storage',
                    i18n_en_tooltip = 'Power! Power! We need power!1!',
                },
            }
        )

        -- T4 Energy Storage
        addNewMergedUnitDef(
            isLeg and 'legadvestoret3' or faction .. 'advestoret3',
            isLeg and 'legadvestoret4' or faction .. 'advestoret4',
            {
                energystorage = 1000000,
                metalcost = 8000,
                energycost = 250000,
                buildtime = 350000,
                health = 120000,
                name = factionPrefix[faction] .. 'Legendary Energy Storage',
                customparams = {
                    i18n_en_humanname = 'Legendary Hardened Energy Storage',
                    i18n_en_tooltip = 'Vast amounts of energy contained for your legendary projects.',
                },
            }
        )

        -----------------------------------------------------------------------
        -- Construction Aides (Builders)
        -----------------------------------------------------------------------

        -- Helper to collect build options
        local function getBuildOptions(builderName)
            local options = {}
            if unitDefs[builderName] and unitDefs[builderName].buildoptions then
                for _, opt in ipairs(unitDefs[builderName].buildoptions) do
                    table.insert(options, opt)
                end
            end
            return options
        end

        local t3AideOptions = {
            faction .. 'afust3',
            faction .. 'nanotct2',
            faction .. 'nanotct3',
            faction .. 'nanotct4',
            faction .. 'alab',
            faction .. 'avp',
            faction .. 'aap',
            faction .. 'gatet3',
            faction .. 'flak',
            isLeg and 'legadveconvt3' or faction .. 'mmkrt3',
            isLeg and 'legamstort3' or faction .. 'uwadvmst3',
            isLeg and 'legamstort4' or faction .. 'uwadvmst4',
            isLeg and 'legadvestoret3' or faction .. 'advestoret3',
            isLeg and 'legadvestoret4' or faction .. 'advestoret4',
            isLeg and 'legdeflector' or faction .. 'gate',
            isLeg and 'legforti' or faction .. 'fort',
            isArm and 'armshltx' or faction .. 'gant',
            faction .. 'mohot3',
            faction .. 'mohot4',
        }

        -- Faction exclusive options
        local exclusives = {
            arm = {
                'armamd',
                'armmercury',
                'armbrtha',
                'armminivulc',
                'armvulc',
                'armanni',
                'armannit3',
                'armlwall',
                'armannit4',
            },
            cor = {
                'corfmd',
                'corscreamer',
                'cordoomt3',
                'corbuzz',
                'corminibuzz',
                'corint',
                'cordoom',
                'corhllllt',
                'cormwall',
                'cordoomt4',
            },
            leg = {
                'legabm',
                'legstarfall',
                'legministarfall',
                'leglraa',
                'legbastion',
                'legrwall',
                'leglrpc',
                'legbastiont4',
                'legapopupdef',
                'legdtf',
            },
        }
        for _, opt in ipairs(exclusives[faction] or {}) do
            table.insert(t3AideOptions, opt)
        end

        -- Taxed Gantries
        local taxedMap = {
            arm = { 'corgant', 'leggant' },
            cor = { 'armshltx', 'leggant' },
            leg = { 'armshltx', 'corgant' },
        }
        for _, g in ipairs(taxedMap[faction] or {}) do
            table.insert(t3AideOptions, g .. '_taxed')
        end

        -- Ground Aide T3
        addNewMergedUnitDef(faction .. 'decom', faction .. 't3aide', {
            builddistance = 350,
            buildtime = 140000,
            energycost = 200000,
            energyupkeep = 2000,
            health = 10000,
            metalcost = 12600,
            speed = 85,
            workertime = 6000,
            name = factionPrefix[faction] .. 'Epic Aide',
            customparams = {
                techlevel = 3,
                unitgroup = 'buildert3',
                i18n_en_humanname = 'Epic Ground Construction Aide',
            },
            buildoptions = t3AideOptions,
        })

        -- Ground Aide T4
        local t4AideOptions = tableMerge({}, t3AideOptions)
        table.insert(t4AideOptions, faction .. 'afust4')
        local baseConv = isLeg and 'legadveconv' or (faction .. 'mmkr')
        table.insert(t4AideOptions, baseConv .. 't4')

        addNewMergedUnitDef(faction .. 't3aide', faction .. 't4aide', {
            buildtime = 420000,
            energycost = 600000,
            energyupkeep = 6000,
            health = 25000,
            metalcost = 38000,
            speed = 95,
            workertime = 8000,
            name = factionPrefix[faction] .. 'Legendary Aide',
            customparams = {
                techlevel = 4,
                unitgroup = 'buildert4',
                i18n_en_humanname = 'Legendary Ground Construction Aide',
            },
            buildoptions = t4AideOptions,
        })

        -- Air Aide T3
        addNewMergedUnitDef('armfify', faction .. 't3airaide', {
            cruisealtitude = 3000,
            builddistance = 1750,
            buildtime = 140000,
            energycost = 200000,
            health = 1100,
            metalcost = 13400,
            speed = 25,
            workertime = 1600,
            name = factionPrefix[faction] .. 'Epic Aide',
            customparams = {
                techlevel = 3,
                unitgroup = 'buildert3',
                i18n_en_humanname = 'Epic Air Construction Aide',
            },
            buildoptions = t3AideOptions,
        })

        -- Air Aide T4
        addNewMergedUnitDef(faction .. 't3airaide', faction .. 't4airaide', {
            buildtime = 420000,
            energycost = 600000,
            energyupkeep = 6000,
            health = 2750,
            metalcost = 40000,
            speed = 30,
            workertime = 3200,
            name = factionPrefix[faction] .. 'Legendary Aide',
            customparams = {
                techlevel = 4,
                unitgroup = 'buildert4',
                i18n_en_humanname = 'Legendary Air Construction Aide',
            },
            buildoptions = t4AideOptions,
        })

        -----------------------------------------------------------------------
        -- Faction Gantry & Taxed Gantry Logic
        -----------------------------------------------------------------------
        local gantryBase = isArm and 'armshltx'
            or isCor and 'corgant'
            or 'leggant'
        unitDefs[gantryBase].maxthisunit = 1
        unitDefs[faction .. 'apt3'].maxthisunit = 1

        -- Add Taxed versions
        local baseDef = unitDefs[gantryBase]
        addNewMergedUnitDef(gantryBase, gantryBase .. '_taxed', {
            energycost = baseDef.energycost * 1.5,
            metalcost = baseDef.metalcost * 1.5,
            name = factionPrefix[faction] .. 'Experimental Gantry Taxed',
            customparams = {
                i18n_en_humanname = factionPrefix[faction]
                    .. 'Experimental Gantry Taxed',
            },
        })

        -- Ensure aides are in gantry build options
        for _, f in pairs({ gantryBase, faction .. 'apt3' }) do
            if unitDefs[f] then
                unitDefs[f].buildoptions = unitDefs[f].buildoptions or {}
                local suffix = (f == gantryBase) and 'aide' or 'airaide'
                for _, tier in ipairs({ 't3', 't4' }) do
                    local aideName = faction .. tier .. suffix
                    if
                        not tableContains(unitDefs[f].buildoptions, aideName)
                    then
                        table.insert(unitDefs[f].buildoptions, aideName)
                    end
                end
            end
        end
    end
end
