-- Metal Extractor Upgrades (T3 & T4)
-- Authors: NineLEL
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, tableMerge = UnitDefs or {}, table.merge

    local FACTION_DATA = {
        arm = { prefix = 'Armada ', base = 'armshockwave' },
        cor = { prefix = 'Cortex ', base = 'cormexp' },
        leg = { prefix = 'Legion ', base = 'legmohocon' },
    }

    local WEAPON_DEFS = {
        arm = {
            armmohot3_emp = {
                areaofeffect = 200,
                craterboost = 0,
                cratermult = 0,
                edgeeffectiveness = 0.15,
                energypershot = 80,
                explosiongenerator = 'custom:EMP_FLASH',
                firestarter = 0,
                impulseboost = 0,
                impulsefactor = 0,
                intensity = 0.5,
                name = 'Epic EMP Cannon',
                noselfdamage = true,
                paralyzer = true,
                paralyzetime = 6,
                range = 600,
                reloadtime = 1,
                rgbcolor = '0.9 0.9 0',
                soundhit = 'empxplp2',
                soundstart = 'hackshot',
                turret = true,
                weapontype = 'Cannon',
                weaponvelocity = 540,
                damage = {
                    default = 1200,
                },
            },
            armmohot4_emp = {
                areaofeffect = 320,
                craterboost = 0,
                cratermult = 0,
                edgeeffectiveness = 0.25,
                energypershot = 250,
                explosiongenerator = 'custom:EMP_FLASH',
                firestarter = 0,
                impulseboost = 0,
                impulsefactor = 0,
                intensity = 0.8,
                name = 'Legendary EMP Blast',
                noselfdamage = true,
                paralyzer = true,
                paralyzetime = 10,
                range = 850,
                reloadtime = 0.8,
                rgbcolor = '1 1 0',
                soundhit = 'empxplp2',
                soundstart = 'hackshot',
                turret = true,
                weapontype = 'Cannon',
                weaponvelocity = 650,
                damage = {
                    default = 2500,
                },
            },
        },
        cor = {
            cormoho_rocket = {
                areaofeffect = 128,
                avoidfeature = false,
                burst = 5,
                burstrate = 0.3,
                cegtag = 'missiletrailsmall-red',
                craterboost = 0,
                cratermult = 0,
                edgeeffectiveness = 0.15,
                explosiongenerator = 'custom:FLASH96',
                firestarter = 70,
                flighttime = 1.3,
                impulseboost = 0.123,
                impulsefactor = 0.123,
                impactonly = true,
                model = 'missile.s3o',
                name = 'Epic Barrage Rocket',
                noselfdamage = true,
                range = 750,
                reloadtime = 5,
                rgbcolor = '1 0.5 0.2',
                smoketrail = true,
                soundhit = 'xplomed2',
                soundstart = 'rocklit3',
                startvelocity = 450,
                texture1 = 'null',
                texture2 = 'smoketrailbar',
                tolerance = 6000,
                tracks = true,
                turnrate = 12000,
                turret = true,
                weaponacceleration = 150,
                weapontype = 'MissileLauncher',
                weaponvelocity = 750,
                damage = {
                    default = 400,
                },
            },
            corsumo_weapon = {
                areaofeffect = 12,
                avoidfeature = false,
                beamtime = 0.15,
                corethickness = 0.2,
                craterboost = 0,
                cratermult = 0,
                edgeeffectiveness = 0.15,
                energypershot = 100,
                explosiongenerator = 'custom:laserhit-medium-red',
                firestarter = 90,
                impactonly = true,
                impulseboost = 0,
                impulsefactor = 0,
                name = 'Epic High Energy Laser',
                noselfdamage = true,
                range = 750,
                reloadtime = 0.4,
                rgbcolor = '1 0 0',
                soundhit = 'xplomed2',
                soundstart = 'lasrhvy3',
                targetmoveerror = 0.2,
                thickness = 3,
                turret = true,
                weapontype = 'BeamLaser',
                weaponvelocity = 1000,
                damage = {
                    default = 350,
                },
            },
            cormoho_rocket_t4 = {
                areaofeffect = 160,
                avoidfeature = false,
                burst = 8,
                burstrate = 0.2,
                cegtag = 'missiletrailsmall-red',
                craterboost = 0,
                cratermult = 0,
                edgeeffectiveness = 0.2,
                explosiongenerator = 'custom:FLASH96',
                firestarter = 80,
                flighttime = 1.5,
                impulseboost = 0.15,
                impulsefactor = 0.15,
                impactonly = true,
                model = 'missile.s3o',
                name = 'Legendary Barrage Rocket',
                noselfdamage = true,
                range = 1000,
                reloadtime = 4,
                rgbcolor = '1 0.4 0.1',
                smoketrail = true,
                soundhit = 'xplomed2',
                soundstart = 'rocklit3',
                startvelocity = 500,
                texture1 = 'null',
                texture2 = 'smoketrailbar',
                tolerance = 6000,
                tracks = true,
                turnrate = 15000,
                turret = true,
                weaponacceleration = 200,
                weapontype = 'MissileLauncher',
                weaponvelocity = 900,
                damage = {
                    default = 750,
                },
            },
            corsumo_weapon_t4 = {
                areaofeffect = 16,
                avoidfeature = false,
                beamtime = 0.2,
                corethickness = 0.3,
                craterboost = 0,
                cratermult = 0,
                edgeeffectiveness = 0.2,
                energypershot = 250,
                explosiongenerator = 'custom:laserhit-medium-red',
                firestarter = 100,
                impactonly = true,
                impulseboost = 0,
                impulsefactor = 0,
                name = 'Legendary Overclocked Laser',
                noselfdamage = true,
                range = 950,
                reloadtime = 0.3,
                rgbcolor = '1 0.1 0',
                soundhit = 'xplomed2',
                soundstart = 'lasrhvy3',
                targetmoveerror = 0.1,
                thickness = 4.5,
                turret = true,
                weapontype = 'BeamLaser',
                weaponvelocity = 1200,
                damage = {
                    default = 650,
                },
            },
        },
    }

    local WEAPONS = {
        arm = {
            t3 = {
                [1] = {
                    def = 'armmohot3_emp',
                    onlytargetcategory = 'NOTSUB',
                },
            },
            t4 = {
                [1] = {
                    def = 'armmohot4_emp',
                    onlytargetcategory = 'NOTSUB',
                },
            },
        },
        cor = {
            t3 = {
                [1] = {
                    def = 'cormoho_rocket',
                    onlytargetcategory = 'NOTSUB',
                },
                [2] = {
                    def = 'corsumo_weapon',
                    onlytargetcategory = 'NOTSUB',
                },
            },
            t4 = {
                [1] = {
                    def = 'cormoho_rocket_t4',
                    onlytargetcategory = 'NOTSUB',
                },
                [2] = {
                    def = 'corsumo_weapon_t4',
                    onlytargetcategory = 'NOTSUB',
                },
            },
        },
    }

    local function addNewMergedUnitDef(baseUnit, newUnit, mergeProps)
        if unitDefs[baseUnit] and not unitDefs[newUnit] then
            unitDefs[newUnit] = tableMerge(unitDefs[baseUnit], mergeProps)
        end
    end

    local factions = { 'arm', 'cor', 'leg' }
    for _, faction in ipairs(factions) do
        local data = FACTION_DATA[faction]

        -- Tier 3 (Epic)
        local t3MexName = faction .. 'mohot3'
        local t3MergeProps = {
            metalcost = 4000,
            energycost = 32000,
            buildtime = 80000,
            health = 3600,
            extractsmetal = 0.008,
            canattack = true,
            canstop = true,
            name = data.prefix .. 'Epic Metal Extractor',
            customparams = {
                techlevel = 3,
                unitgroup = 'eco',
                i18n_en_humanname = 'Epic Metal Extractor',
                i18n_en_tooltip = 'Extreme efficiency metal extraction. Chopped chicken!',
            },
            weapondefs = WEAPON_DEFS[faction],
            weapons = WEAPONS[faction] and WEAPONS[faction].t3 or nil,
        }

        if faction == 'arm' then
            t3MergeProps.cancloak = true
            t3MergeProps.cloakcost = 20
            t3MergeProps.mincloakdistance = 150
            t3MergeProps.initCloaked = true
        end
        addNewMergedUnitDef(data.base, t3MexName, t3MergeProps)

        -- Tier 4 (Legendary)
        local t4MexName = faction .. 'mohot4'
        local t4MergeProps = {
            metalcost = 25000,
            energycost = 250000,
            buildtime = 500000,
            health = 9500,
            extractsmetal = 0.024,
            canattack = true,
            canstop = true,
            name = data.prefix .. 'Legendary Metal Extractor',
            customparams = {
                techlevel = 4,
                unitgroup = 'eco',
                i18n_en_humanname = 'Legendary Metal Extractor',
                i18n_en_tooltip = 'Pinnacle of metal extraction technology. The gold standard!',
            },
            weapondefs = WEAPON_DEFS[faction],
            weapons = WEAPONS[faction] and WEAPONS[faction].t4 or nil,
        }

        if faction == 'arm' then
            t4MergeProps.cancloak = true
            t4MergeProps.cloakcost = 50
            t4MergeProps.mincloakdistance = 120
            t4MergeProps.initCloaked = true
        end
        addNewMergedUnitDef(t3MexName, t4MexName, t4MergeProps)
    end
end
