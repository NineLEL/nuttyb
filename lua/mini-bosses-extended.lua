-- Mini Bosses Extended Version
-- Authors: RCore, Altwaal
-- docs.google.com/spreadsheets/d/1QSVsuAAMhBrhiZdTihVfSCwPzbbZWDLCtXWP23CU0ko
-- https://github.com/nuttyb-community/nuttyb

do
    local unitDefs, tableMerge, tableCopy, spring =
        UnitDefs or {}, table.merge, table.copy, Spring
    local MATRIARCH, CFX, SCBX, BRK, VO =
        'raptor_matriarch_basic',
        'customfusionexplo',
        'ScavComBossExplo',
        'berserk',
        'VTOL OBJECT'

    local nbQhpMult, nbHpMult = 1.3, 1.3
    nbHpMult = unitDefs[MATRIARCH].health / 60000
    nbQhpMult = unitDefs['raptor_queen_epic'].health / 1250000

    local playerCountScale = 1
    if spring.Utilities.Gametype.IsRaptors() then
        playerCountScale = (#spring.GetTeamList() - 2) / 12
    end

    local spawnCountMult = spring.GetModOptions().raptor_spawncountmult or 3
    local totalSpawnScale = playerCountScale * (spawnCountMult / 3)

    local function scaledMax(base)
        return math.max(1, math.ceil(base * totalSpawnScale))
    end

    local mqAnger = { 50, 60, 70, 80, 90, 100 }
    local mqTimeMult =
        math.max(1, spring.GetModOptions().raptor_queentimemult or 1.3)
    local mqStart, mqLast = mqAnger[1], mqAnger[#mqAnger]
    local mqFactor = (mqTimeMult * mqLast / 1.3 - mqStart) / (mqLast - mqStart)

    for idx = 2, #mqAnger do
        mqAnger[idx] = math.floor(mqStart + (mqAnger[idx] - mqStart) * mqFactor)
    end

    local mqNumQueens = spring.GetModOptions().raptor_queen_count or 1
    local mqDoomAngerScale = math.min(10, nbQhpMult / 1.3 * 0.9)
    local queenThreshold = 20
    local baseQueenAnger = 10
            * (1.06 ^ math.max(0, math.min(mqNumQueens, queenThreshold) - 8))
        + math.max(0, mqNumQueens - queenThreshold)
    local mqDoomAnger = math.ceil(mqDoomAngerScale * baseQueenAnger)
    local mqAngerBoss = mqTimeMult * 75 + mqDoomAnger
    local maxDoombringers =
        math.max(3, scaledMax(math.floor((21 * mqNumQueens + 36) / 19)))

    local function newUnit(src, tgt, ovr)
        if unitDefs[src] and not unitDefs[tgt] then
            unitDefs[tgt] = tableMerge(unitDefs[src], ovr or {})
        end
    end

    local baseHealth = unitDefs[MATRIARCH].health

    newUnit('raptor_queen_veryeasy', 'raptor_miniq_a', {
        name = 'Queenling Prima',
        icontype = 'raptor_queen_veryeasy',
        health = baseHealth * 5,
        customparams = {
            i18n_en_humanname = 'Queenling Prima',
            i18n_en_tooltip = 'Majestic and bold, ruler of the hunt.',
        },
    })

    newUnit('raptor_queen_easy', 'raptor_miniq_b', {
        name = 'Queenling Secunda',
        icontype = 'raptor_queen_easy',
        health = baseHealth * 6,
        customparams = {
            i18n_en_humanname = 'Queenling Secunda',
            i18n_en_tooltip = 'Swift and sharp, a noble among raptors.',
        },
    })

    newUnit('raptor_queen_normal', 'raptor_miniq_c', {
        name = 'Queenling Tertia',
        icontype = 'raptor_queen_normal',
        health = baseHealth * 7,
        customparams = {
            i18n_en_humanname = 'Queenling Tertia',
            i18n_en_tooltip = 'Refined tastes. Likes her prey rare.',
        },
    })

    newUnit('armcomboss', 'raptor_armcomboss', {
        name = 'Arm Com Boss',
        icontype = 'armcomboss',
        health = baseHealth * 5,
        customparams = {
            i18n_en_humanname = 'Arm Com Boss',
            i18n_en_tooltip = 'Swift and sharp, a noble among raptors.',
        },
    })

    newUnit('corcomboss', 'raptor_corcomboss', {
        name = 'Cor Com Boss',
        icontype = 'corcomboss',
        health = baseHealth * 6,
        customparams = {
            i18n_en_humanname = 'Cor Com Boss',
            i18n_en_tooltip = 'Relentless and brutal, a boss among raptors.',
        },
    })

    newUnit('legcomlvl10', 'raptor_legcomboss', {
        name = 'Legion Com Boss',
        icontype = 'legcomlvl10',
        speed = unitDefs.legcomlvl10.speed * 1.5,
        health = unitDefs.legcomlvl10.health * 3,
        customparams = {
            i18n_en_humanname = 'Legion Com Boss',
            i18n_en_tooltip = 'Fast and resilient, a terror of the swarm.',
        },
    })

    if unitDefs.raptor_legcomboss and unitDefs.raptor_legcomboss.weapondefs then
        unitDefs.raptor_legcomboss.weapondefs.disintegrator = nil
        if unitDefs.raptor_legcomboss.weapons then
            local i = #unitDefs.raptor_legcomboss.weapons
            while i > 0 do
                local w = unitDefs.raptor_legcomboss.weapons[i]
                if w and w.def == 'disintegrator' then
                    table.remove(unitDefs.raptor_legcomboss.weapons, i)
                end
                i = i - 1
            end
        end
    end

    unitDefs.raptor_miniq_b.weapondefs.acidgoo =
        tableCopy(unitDefs['raptor_matriarch_acid'].weapondefs.acidgoo)
    unitDefs.raptor_miniq_c.weapondefs.empgoo =
        tableCopy(unitDefs['raptor_matriarch_electric'].weapondefs.goo)

    for _, d in ipairs {
        {
            'raptor_matriarch_basic',
            'raptor_mama_ba',
            'Matrona',
            'Claws charged with vengeance.',
        },
        {
            'raptor_matriarch_fire',
            'raptor_mama_fi',
            'Pyro Matrona',
            'A firestorm of maternal wrath.',
        },
        {
            'raptor_matriarch_electric',
            'raptor_mama_el',
            'Paralyzing Matrona',
            'Crackling with rage, ready to strike.',
        },
        {
            'raptor_matriarch_acid',
            'raptor_mama_ac',
            'Acid Matrona',
            'Acid-fueled, melting everything in sight.',
        },
    } do
        newUnit(d[1], d[2], {
            name = d[3],
            icontype = d[1],
            health = baseHealth * 1.5,
            customparams = { i18n_en_humanname = d[3], i18n_en_tooltip = d[4] },
        })
    end

    newUnit('critter_penguinking', 'raptor_consort', {
        name = 'Raptor Consort',
        icontype = 'corkorg',
        health = baseHealth * 3,
        mass = 100000,
        nochasecategory = 'MOBILE VTOL OBJECT',
        sonarstealth = false,
        stealth = false,
        speed = 67.5,
        customparams = {
            i18n_en_humanname = 'Raptor Consort',
            i18n_en_tooltip = 'Sneaky powerful little terror.',
        },
    })

    unitDefs.raptor_consort.weapondefs.goo =
        tableCopy(unitDefs['raptor_queen_epic'].weapondefs.goo)

    newUnit('raptor_consort', 'raptor_doombringer', {
        name = 'Doombringer',
        icontype = 'armafust3',
        health = baseHealth * 10,
        speed = 50,
        customparams = {
            i18n_en_humanname = 'Doombringer',
            i18n_en_tooltip = 'Your time is up. The Queens called for backup.',
        },
    })

    local function pveSquad(minA, maxA, bhv, rar, amt, wgt)
        return {
            raptorcustomsquad = true,
            raptorsquadunitsamount = amt or 1,
            raptorsquadminanger = minA,
            raptorsquadmaxanger = maxA,
            raptorsquadweight = wgt or 5,
            raptorsquadrarity = rar or 'basic',
            raptorsquadbehavior = bhv,
            raptorsquadbehaviordistance = 500,
            raptorsquadbehaviorchance = 0.75,
        }
    end

    local miniQueenCommon = {
        selfdestructas = CFX,
        explodeas = CFX,
        weapondefs = {
            yellow_missile = { damage = { default = 1, vtol = 1000 } },
        },
    }

    local comBossWeapons = {
        weapondefs = {
            armcomlaserboss = {
                name = 'Laser Boss',
                reloadtime = 4,
                rgbcolor = '0.3 1 0',
                range = 1250,
                speed = 25,
                damage = { default = 4800, commanders = 2400, shield = 5000 },
            },
            armcomsealaserboss = {
                name = 'Sea Laser Boss',
                damage = { default = 5000 },
            },
        },
        weapons = {
            [1] = { def = 'armcomlaserboss', badtargetcategory = VO },
            [2] = {
                def = 'armcomsealaserboss',
                maindir = '0 0 1',
                maxangledif = 180,
                badtargetcategory = VO,
            },
        },
    }

    local comBossBase = tableMerge({
        explodeas = SCBX,
        maxthisunit = 4,
        customparams = pveSquad(75, 100, BRK),
    }, comBossWeapons)

    for unitName, unitConfig in pairs {
        raptor_miniq_a = tableMerge(miniQueenCommon, {
            maxthisunit = scaledMax(2),
            customparams = pveSquad(60, 100, BRK),
            weapondefs = {
                goo = { damage = { default = 750 } },
                melee = { damage = { default = 4000 } },
            },
        }),
        raptor_miniq_b = tableMerge(miniQueenCommon, {
            maxthisunit = scaledMax(3),
            customparams = pveSquad(mqAnger[3], 100, BRK),
            weapondefs = {
                acidgoo = {
                    burst = 8,
                    reloadtime = 10,
                    sprayangle = 4096,
                    damage = { default = 1500, shields = 1500 },
                },
                melee = { damage = { default = 5000 } },
            },
            weapons = {
                [1] = { def = 'MELEE', maindir = '0 0 1', maxangledif = 155 },
                [2] = { onlytargetcategory = 'VTOL', def = 'yellow_missile' },
                [3] = { onlytargetcategory = 'VTOL', def = 'yellow_missile' },
                [4] = { onlytargetcategory = 'VTOL', def = 'yellow_missile' },
                [5] = { def = 'acidgoo', maindir = '0 0 1', maxangledif = 180 },
            },
        }),
        raptor_miniq_c = tableMerge(miniQueenCommon, {
            maxthisunit = scaledMax(4),
            customparams = pveSquad(mqAnger[5], 100, BRK),
            weapondefs = {
                empgoo = {
                    burst = 10,
                    reloadtime = 10,
                    sprayangle = 4096,
                    damage = { default = 2000, shields = 2000 },
                },
                melee = { damage = { default = 6000 } },
            },
            weapons = {
                [1] = { def = 'MELEE', maindir = '0 0 1', maxangledif = 155 },
                [2] = { onlytargetcategory = 'VTOL', def = 'yellow_missile' },
                [3] = { onlytargetcategory = 'VTOL', def = 'yellow_missile' },
                [4] = { onlytargetcategory = 'VTOL', def = 'yellow_missile' },
                [5] = { def = 'empgoo', maindir = '0 0 1', maxangledif = 180 },
            },
        }),
        raptor_consort = {
            explodeas = 'raptor_empdeath_big',
            maxthisunit = scaledMax(6),
            customparams = pveSquad(mqAnger[3], 100, BRK),
            weapondefs = {
                eyelaser = {
                    name = 'Angry Eyes',
                    reloadtime = 3,
                    rgbcolor = '1 0 0.3',
                    range = 500,
                    damage = { default = 6000, commanders = 6000 },
                },
                goo = {
                    name = 'Snowball Barrage',
                    soundstart = 'penbray2',
                    soundStartVolume = 2,
                    cegtag = 'blob_trail_blue',
                    burst = 8,
                    sprayangle = 2048,
                    weaponvelocity = 600,
                    reloadtime = 4,
                    range = 1000,
                    hightrajectory = 1,
                    rgbcolor = '0.7 0.85 1.0',
                    damage = { default = 1000 },
                },
            },
            weapons = {
                [1] = { def = 'eyelaser', badtargetcategory = VO },
                [2] = {
                    def = 'goo',
                    maindir = '0 0 1',
                    maxangledif = 180,
                    badtargetcategory = VO,
                },
            },
        },
        raptor_doombringer = {
            explodeas = SCBX,
            maxthisunit = maxDoombringers,
            customparams = pveSquad(95, 100, BRK, nil, 1, 99),
            weapondefs = {
                eyelaser = {
                    name = 'Eyes of Doom',
                    reloadtime = 3,
                    rgbcolor = '0.3 1 0',
                    range = 500,
                    damage = { default = 48000, commanders = 24000 },
                },
                goo = {
                    name = 'Amber Hailstorm',
                    soundstart = 'penbray1',
                    soundStartVolume = 2,
                    cegtag = 'blob_trail_red',
                    burst = 15,
                    sprayangle = 3072,
                    weaponvelocity = 600,
                    reloadtime = 5,
                    rgbcolor = '0.7 0.85 1.0',
                    hightrajectory = 1,
                    damage = { default = 5000 },
                },
            },
            weapons = {
                [1] = { def = 'eyelaser', badtargetcategory = VO },
                [2] = {
                    def = 'goo',
                    maindir = '0 0 1',
                    maxangledif = 180,
                    badtargetcategory = VO,
                },
            },
        },
        raptor_armcomboss = comBossBase,
        raptor_corcomboss = comBossBase,
        raptor_legcomboss = {
            explodeas = SCBX,
            maxthisunit = 1,
            customparams = pveSquad(mqAnger[1], 100, BRK),
            weapondefs = {
                armmg_weapon = {
                    accuracy = 100,
                    areaofeffect = 110,
                    avoidfeature = false,
                    burnblow = true,
                    burst = 2,
                    burstrate = 0.15,
                    craterareaofeffect = 0,
                    craterboost = 0,
                    cratermult = 0,
                    edgeeffectiveness = 0.15,
                    explosiongenerator = 'custom:genericshellexplosion-small-t2',
                    gravityaffected = 'true',
                    impulsefactor = 1.8,
                    name = 'Rapid-Fire Plasma Cannon',
                    noselfdamage = true,
                    range = 500,
                    reloadtime = 0.3,
                    soundhit = 'xplomed2',
                    soundhitwet = 'splssml',
                    soundstart = 'cannon3',
                    sprayangle = 500,
                    turret = true,
                    weapontype = 'Cannon',
                    weaponvelocity = 600,
                    damage = { default = 500, vtol = 250 },
                },
                torpedo = {
                    areaofeffect = 75,
                    avoidfeature = false,
                    avoidfriendly = true,
                    burnblow = true,
                    burst = 4,
                    burstrate = 0.15,
                    cegtag = 'torpedotrail-tiny',
                    collidefriendly = true,
                    craterareaofeffect = 0,
                    craterboost = 0,
                    cratermult = 0,
                    edgeeffectiveness = 0.55,
                    explosiongenerator = 'custom:genericshellexplosion-small-uw',
                    flighttime = 1.8,
                    impulsefactor = 0.123,
                    model = 'legtorpedo.s3o',
                    name = 'MK-X Torpedo Launcher',
                    noselfdamage = true,
                    predictboost = 1,
                    range = 600,
                    reloadtime = 0.8,
                    soundhit = 'xplodep2',
                    soundstart = 'torpedo1',
                    startvelocity = 230,
                    tracks = false,
                    turnrate = 2500,
                    turret = true,
                    waterweapon = true,
                    weaponacceleration = 50,
                    weapontimer = 3,
                    weapontype = 'TorpedoLauncher',
                    weaponvelocity = 425,
                    damage = { default = 400, subs = 200 },
                },
                railgunt2 = {
                    areaofeffect = 16,
                    avoidfeature = false,
                    burnblow = false,
                    burst = 4,
                    burstrate = 0.12,
                    cegtag = 'railgun',
                    collidefriendly = false,
                    craterareaofeffect = 0,
                    craterboost = 0,
                    cratermult = 0,
                    duration = 0.12,
                    edgeeffectiveness = 0.85,
                    explosiongenerator = 'custom:plasmahit-sparkonly',
                    fallOffRate = 0.2,
                    firestarter = 0,
                    impulsefactor = 1,
                    intensity = 0.8,
                    minintensity = 1,
                    name = 'Railgun',
                    noselfdamage = true,
                    ownerExpAccWeight = 4.0,
                    proximitypriority = 1,
                    range = 950,
                    reloadtime = 2,
                    rgbcolor = '0.74 0.64 0.94',
                    soundhit = 'mavgun3',
                    soundhitwet = 'splshbig',
                    soundstart = 'lancefire',
                    soundstartvolume = 26,
                    thickness = 3,
                    tolerance = 6000,
                    turret = true,
                    weapontype = 'LaserCannon',
                    weaponvelocity = 3000,
                    damage = { default = 500 },
                },
                botcannon = {
                    accuracy = 0.2,
                    areaofeffect = 10,
                    avoidfeature = false,
                    avoidfriendly = false,
                    burst = 9,
                    burstrate = 0.025,
                    collidefriendly = false,
                    craterareaofeffect = 116,
                    craterboost = 0.1,
                    cratermult = 0.1,
                    edgeeffectiveness = 0.15,
                    energypershot = 5400,
                    explosiongenerator = 'custom:botrailspawn',
                    gravityaffected = 'true',
                    heightboostfactor = 8,
                    hightrajectory = 1,
                    impulsefactor = 0.5,
                    leadbonus = 0,
                    model = 'LegionUnitCapsule.s3o',
                    movingaccuracy = 600,
                    mygravity = 4.8,
                    name = 'Long range bot cannon',
                    noselfdamage = true,
                    projectiles = 2,
                    range = 700,
                    reloadtime = 0.9,
                    sprayangle = 2800,
                    stockpile = true,
                    stockpiletime = 10,
                    soundhit = 'xplonuk1xs',
                    soundhitwet = 'splshbig',
                    soundstart = 'lrpcshot3',
                    soundstartvolume = 50,
                    turret = true,
                    trajectoryheight = 1,
                    waterbounce = true,
                    bounceSlip = 0.74,
                    bouncerebound = 0.5,
                    numbounce = 10,
                    weapontype = 'Cannon',
                    weaponvelocity = 2000,
                    damage = { default = 0, shields = 250 },
                    customparams = {
                        spawns_name = 'raptor_allterrain_assault_basic_t4_v2 raptor_allterrain_assault_acid_t2_v1',
                        spawns_expire = 15,
                        spawns_surface = 'LAND',
                        spawns_mode = 'random',
                        stockpilelimit = 2,
                    },
                },
            },
            weapons = {
                [1] = {
                    def = 'armmg_weapon',
                    onlytargetcategory = 'NOTSUB',
                    fastautoretargeting = true,
                },
                [2] = {
                    badtargetcategory = 'VTOL',
                    def = 'torpedo',
                    onlytargetcategory = 'NOTAIR',
                },
                [3] = {
                    badtargetcategory = 'NOTAIR GROUNDSCOUT',
                    def = 'railgunt2',
                    onlytargetcategory = 'NOTSUB',
                },
                [4] = {
                    badtargetcategory = 'VTOL GROUNDSCOUT SHIP',
                    def = 'botcannon',
                    onlytargetcategory = 'NOTSHIP',
                },
            },
        },
        raptor_mama_ba = {
            maxthisunit = scaledMax(4),
            customparams = pveSquad(55, 100, BRK),
            weapondefs = {
                goo = { damage = { default = 750 } },
                melee = { damage = { default = 750 } },
            },
        },
        raptor_mama_fi = {
            explodeas = 'raptor_empdeath_big',
            maxthisunit = scaledMax(4),
            customparams = pveSquad(55, 100, BRK),
            weapondefs = {
                flamethrowerspike = { damage = { default = 80 } },
                flamethrowermain = { damage = { default = 160 } },
            },
        },
        raptor_mama_el = {
            maxthisunit = scaledMax(4),
            customparams = pveSquad(65, 100, BRK),
        },
        raptor_mama_ac = {
            maxthisunit = scaledMax(4),
            customparams = pveSquad(60, 100, BRK),
            weapondefs = { melee = { damage = { default = 750 } } },
        },
        raptor_land_assault_basic_t4_v2 = {
            maxthisunit = scaledMax(8),
            customparams = pveSquad(33, 100, 'raider'),
        },
        raptor_land_assault_basic_t4_v1 = {
            maxthisunit = scaledMax(12),
            customparams = pveSquad(51, 100, 'raider', 'basic', 2),
        },
    } do
        unitDefs[unitName] = unitDefs[unitName] or {}
        table.mergeInPlace(unitDefs[unitName], unitConfig, true)
    end

    local newCosts = {
        raptor_mama_ba = 36000,
        raptor_mama_fi = 36000,
        raptor_mama_el = 36000,
        raptor_mama_ac = 36000,
        raptor_consort = 45000,
        raptor_doombringer = 90000,
        raptor_armcomboss = 45000,
        raptor_corcomboss = 45000,
        raptor_legcomboss = 45000,
    }

    local oldUnitDef_Post = UnitDef_Post
    function UnitDef_Post(unitID, unitDef)
        if oldUnitDef_Post then
            oldUnitDef_Post(unitID, unitDef)
        end
        local nbHpScale = nbHpMult > 1.3 and nbHpMult / 1.3 or 1
        for unitName, baseCost in pairs(newCosts) do
            if UnitDefs[unitName] then
                UnitDefs[unitName].metalcost = math.floor(baseCost * nbHpScale)
            end
        end
    end
end
