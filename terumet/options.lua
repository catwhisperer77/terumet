terumet.options = {}

terumet.options.protection = {
    -- List of potential external mods that will handle machine protection in lieu of the default owner system
    -- If any of these mods are found on load, the default protection system will NOT be active
    -- and all machine protection will be based on mintest.is_protected implemented by external mods
    -- (1 has no specific meaning, only to provide a value)
    EXTERNAL_MODS = {
        ['areas']=1
    }
}

terumet.options.cosmetic = {
    -- Set to false/nil for Terumetal Glass to be streaky similar to default Minetest glass
    CLEAR_GLASS = true,
    -- Style of reinforced blocks:
    -- 1 = rebar on top/bottom only
    -- 2 = rebar on all faces
    -- false/nil = not visible (reinforced blocks look exact same as original block)
    REINFORCING_VISIBLE = 1,
    -- Set to false/nil for heatline blocks to not have visible ports
    BLOCK_HEATLINE_VISIBLE = true,
}

terumet.options.misc = {
    -- Groups to remove from converted blocks (heatline/reinforced blocks)
    -- ex: 'wood' prevents wood planks with heatlines/reinforcing from being used as wood in general recipes
    -- if any other groups cause problems when transferred over to a block, add it here
    -- (1 has no specific meaning, only to provide a value)
    BLOCK_REMOVE_GROUPS = {
        ['wood']=1,
        ['stone']=1,
        ['flammable']=1,
    },

    -- text color for additional info on items
    TIP_COLOR = '#ffa2ba',
    -- text color for machine description on upgrades
    TIP_UPGRADE_MACHINE_COLOR = '#ff5fdd',
}

terumet.options.tools = {
    --
    -- TOOL SETTINGS
    --
    sword_damage = {
        -- damage inflicted by each type of sword
        TERUMETAL = 6,
        COPPER_ALLOY = 8,
        IRON_ALLOY = 9,
        GOLD_ALLOY = 7,
        BRONZE_ALLOY = 10,
        COREGLASS = 12
    },

    -- Comment out/remove this section to disable all upgraded tools
    UPGRADES = {
        -- comment out/remove a single line to disable that upgrade
        rng = {color='#ffda00', nametag='Kinetic', xinfo='Longer reach', item='terumet:item_cryst_mese 3', time=20.0, flux=8, repmult=1.5, effect=8}, -- effect=new range
        spd = {color='#4aeffd', nametag='Expert', xinfo='Faster speed', item='terumet:item_cryst_dia 3', time=20.0, flux=8, repmult=2, effect=0.8}, -- effect=multiplier to tool speeds
        dur = {color='#68905a', nametag='Durable', xinfo='Degrades slower', item='terumet:item_rubber 3', time=20.0, flux=8, repmult=1.5, effect=1.6}, -- effect=multiplier to tool uses
    }
}

terumet.options.machine = {
    --
    -- GENERAL MACHINE SETTINGS
    --
    -- Heat sources that can be used in fuel slots of machines
    BASIC_HEAT_SOURCES = {
        ['bucket:bucket_lava']={ hus=20000, return_item='bucket:bucket_empty' },
    },
    -- Whether machines emit smoke particles or not while working
    PARTICLES = true,
    -- Text descriptions of heat transfer modes of machines
    HEAT_TRANSFER_MODE_NAMES = {
        [0]='Disabled',
        [1]='Accept',
        [2]='Provide',
    },
    -- Sounds played by machines, (nil to disable)
    OVERHEAT_SOUND = 'terumet_venting', -- when overheating and discharging
    HEATIN_SOUND = 'terumet_heatin', -- when accepting heat from an item/battery
    HEATOUT_SOUND = 'terumet_heatout', -- when depositing heat in a battery

    DEFAULT_INPUT_SIDE = 3,
    DEFAULT_OUTPUT_SIDE = 4,

    -- tooltip colors for machine items
    TIP_HU_COLOR = '#ff9d15',
    TIP_PERCENT_COLOR = '#ffdcac',
}

terumet.options.heater = {
    furnace={
        --
        -- FURNACE HEATER SETTINGS
        --
        -- Maximum HUs Furnace Heater can store
        MAX_HEAT = 10000,
        -- Maximum HUs Furnace Heater can transfer per tick
        HEAT_TRANSFER_RATE = 500,
        -- HU generation per second of burn time
        GEN_HUPS = 100
    },
    solar={
        --
        -- SOLAR HEATER SETTINGS
        --
        -- Maximum HUs Solar Heater can store
        MAX_HEAT = 40000,
        -- HUs Solar Heater generates per second based on sunlight level
        SOLAR_HUPS = { 0, 0, 0, 0, 0, 10, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60 },
        -- Maximum HUs Solar Heater can transfer per tick
        HEAT_TRANSFER_RATE = 1000,
    },
    entropy={
        --
        -- ENTROPIC HEATER SETTINGS
        --
        MAX_HEAT = 200000,
        HEAT_TRANSFER_RATE = 5000,
        -- the maximum extent the heater "scans" from the main machine
        MAX_RANGE = {x=5, y=5, z=5},
        -- if a node time is not defined, use this time
        DEFAULT_DRAIN_TIME = 1.0,
        EFFECTS = {
            ['default:water_source']={change='default:ice', time=5.0, hups=1000},
            ['default:water_flowing']={change='default:ice', time=2.5, hups=1200},
            ['default:lava_source']={change='default:obsidian', time=2.0, hups=10000},
            ['default:lava_flowing']={change='default:obsidian', time=1.0, hups=5000},
            ['default:dirt_with_grass']={change='default:dirt', hups=1000},
            ['default:sandstone']={change='default:sand', hups=3000},
            ['default:silver_sandstone']={change='default:silver_sand', hups=3000},
            ['default:stone']={change='default:cobble', time=3.0, hups=1000},
            ['default:cobble']={change='default:gravel', time=3.0, hups=800},
            ['default:gravel']={change='default:silver_sand', time=3.0, hups=500},
            ['default:coalblock']={change='default:stone_with_coal', time=60.0, hups=1500},
            ['default:stone_with_coal']={change='default:stone', time=10.0, hups=1500},
            ['default:mossycobble']={change='default:cobble', time=15.0, hups=500},
            ['default:clay']={change='default:dirt', time=5.0, hups=500},
            ['default:cactus']={change='air', time=10.0, hups=2000},
            ['default:papyrus']={change='air', time=20.0, hups=2000},
            ['group:flora']={change='default:dry_shrub', time=6.0, hups=150},
            ['default:dry_shrub']={change='air', time=3.0, hups=1500},
            ['fire:basic_flame']={change='air', time=0.5, hups=10000},
            ['fire:permanent_flame']={change='air', time=0.5, hups=10000},
            ['air']={time=1.0, hups=500},
            ['group:tree']={change='air', time=12.0, hups=3000},
            ['group:sapling']={change='air', time=4.0, hups=4000},
            ['group:wood']={change='air', time=9.0, hups=1000},
            ['group:leaves']={change='air', time=4.0, hups=2000},
        }
    }
}

terumet.options.crusher = {
    --
    -- CRUSHER SETTINGS
    --

    MAX_HEAT = 5000,

    HEAT_HUPS = 150,
    TIME_HEATING = 4.0, -- in sec.
    TIME_COOLING = 6.0, -- in sec.

    recipes = {
        ['default:stone']='default:cobble',
        ['default:cobble']='default:gravel',
        ['default:gravel']='default:silver_sand',
        ['default:obsidian']='default:obsidian_shard 9',
        ['default:obsidian_shard']='terumet:item_dust_ob',
        ['default:sandstone']='default:sand',
        ['default:silver_sandstone']='default:silver_sand',
        ['default:coalblock']='default:coal_lump 9',
        ['default:apple']='terumet:item_dust_bio 2',
        ['default:papyrus']='terumet:item_dust_bio 3',
        ['group:flora']='terumet:item_dust_bio',
        ['group:leaves']='basic_materials:oil_extract',
        ['group:sapling']='terumet:item_dust_bio',
        ['group:tree']='terumet:item_dust_wood 4',
        ['group:wood']='terumet:item_dust_wood 1',
    }
}

terumet.options.thermobox = {
    --
    -- THERMOBOX SETTINGS
    --
    MAX_HEAT = 200000,
    HEAT_TRANSFER_RATE = 2500
}

terumet.options.thermdist = {
    --
    -- THERMAL DISTRIBUTOR SETTINGS
    MAX_HEAT = 20000,
    HEAT_TRANSFER_RATE = 2500
}

terumet.options.heatline = {
    --
    -- HEATLINE SETTINGS
    --
    -- Maximum HUs heatline input can contain
    MAX_HEAT = 50000,
    -- Maximum distance over a heatline input can send (in blocks of heatline)
    -- when a heatline extends beyond this, it will occasionally display smoke particles to warn
    MAX_DIST = 36,
    -- Every RECHECK_LINKS_TIMER seconds, recheck the heatline network on an input
    RECHECK_LINKS_TIMER = 4.0,
    -- Max heat transferred every tick (divided among all connected machines in order of distance)
    HEAT_TRANSFER_MAX = 2500,
    -- whether /heatlines chat command is available to list all heatline network info
    DEBUG_CHAT_COMMAND = false,
}

terumet.options.heat_ray = {
    --
    -- HEAT RAY EMITTER SETTINGS
    --
    -- Maximum HUs emitter can contain
    MAX_HEAT = 20000,
    -- HUs sent in one ray
    SEND_AMOUNT = 10000,
    -- maximum number of nodes emitter will seek before giving up
    MAX_DISTANCE = 1000,
    -- set to zero to disable particle display of ray
    RAY_PARTICLES_PER_NODE = 6
}

terumet.options.smelter = {
    --
    -- TERUMETAL ALLOY SMELTER SETTINGS
    --
    -- Maximum HUs smelter can contain
    MAX_HEAT = 20000,
    -- Amount of flux value (FV) one item is worth
    FLUX_VALUE = 2,
    -- Maximum stored FV of an alloy smelter's flux tank
    -- NOTE: if FLUX_MAXIMUM / FLUX_VALUE > 99, flux could be lost on breaking a smelter
    -- (only a maximum of 1 stack of Crystallized Terumetal will be dropped)
    -- also if stored flux < FLUX_VALUE, that amount will be lost (minimum 1 Crystallized Terumetal dropped)
    FLUX_MAXIMUM = 100,
    -- Heat expended per second melting flux
    MELT_HUPS = 20,
    -- Heat expended per second alloying
    ALLOY_HUPS = 10,
    -- Default items usable as flux
    FLUX_ITEMS = {
        ['terumet:lump_raw']={time=3.0},
        ['terumet:ingot_raw']={time=2.0},
        ['terumet:item_cryst_raw']={time=1.0},
    },
    -- Default alloy-making recipes
    recipes = {
    -- Standard Bronze
    -- Note these are first in the recipe list to override single terucopper/terutin if all elements for bronze are available
        {result='default:bronze_ingot 9', flux=0, time=8.0, input={'default:copper_lump 8', 'default:tin_lump'}},
        {result='default:bronze_ingot 9', flux=0, time=4.0, input={'default:copper_ingot 8', 'default:tin_ingot'}},
        {result='default:bronzeblock 9', flux=0, time=40.0, input={'default:copperblock 8', 'default:tinblock'}},
        {result='default:bronze_ingot 9', flux=0, time=2.0, input={'terumet:item_cryst_copper 8', 'terumet:item_cryst_tin'}},
    -- Terumetal Glass
        {result='terumet:block_tglass 4', flux=1, time=8.0, input={'default:glass 4', 'default:silver_sand'}},
    -- Terumetal Glow Glass
        {result='terumet:block_tglassglow 4', flux=1, time=8.0, input={'terumet:block_tglass 4', 'default:mese_crystal'}},
    -- Teruchalchum
        {result='terumet:ingot_tcha 3', flux=9, time=6.0, input={'default:bronze_ingot', 'default:tin_lump 2'}},
        {result='terumet:ingot_tcha 3', flux=9, time=4.0, input={'default:bronze_ingot', 'default:tin_ingot 2'}},
        {result='terumet:block_tcha 3', flux=75, time=54.0, input={'default:bronzeblock', 'default:tinblock 2'}},
        {result='terumet:ingot_tcha 3', flux=9, time=3.0, input={'default:bronze_ingot', 'terumet:item_cryst_tin 2'}},
    -- Terucopper
        {result='terumet:ingot_tcop', flux=1, time=3.0, input={'default:copper_lump'}},
        {result='terumet:ingot_tcop', flux=1, time=2.5, input={'default:copper_ingot'}},
        {result='terumet:block_tcop', flux=8, time=22.5, input={'default:copperblock'}},
        {result='terumet:ingot_tcop', flux=1, time=1.0, input={'terumet:item_cryst_copper'}},
    -- Terutin
        {result='terumet:ingot_ttin', flux=1, time=2.0, input={'default:tin_lump'}},
        {result='terumet:ingot_ttin', flux=1, time=1.5, input={'default:tin_ingot'}},
        {result='terumet:block_ttin', flux=8, time=15.0, input={'default:tinblock'}},
        {result='terumet:ingot_ttin', flux=1, time=0.5, input={'terumet:item_cryst_tin'}},
    -- Terusteel
        {result='terumet:ingot_tste', flux=2, time=4.5, input={'default:iron_lump'}},
        {result='terumet:ingot_tste', flux=2, time=3.5, input={'default:steel_ingot'}},
        {result='terumet:block_tste', flux=16, time=31.5, input={'default:steelblock'}},
        {result='terumet:ingot_tste', flux=2, time=2.0, input={'terumet:item_cryst_iron'}},
    -- Terugold
        {result='terumet:ingot_tgol', flux=3, time=5.0, input={'default:gold_lump'}},
        {result='terumet:ingot_tgol', flux=3, time=4.0, input={'default:gold_ingot'}},
        {result='terumet:block_tgol', flux=25, time=36.0, input={'default:goldblock'}},
        {result='terumet:ingot_tgol', flux=3, time=2.5, input={'terumet:item_cryst_gold'}},
    -- Coreglass
        {result='terumet:ingot_cgls', flux=5, time=10.0, input={'default:diamond', 'default:obsidian_shard'}},
        {result='terumet:block_cgls', flux=30, time=90.0, input={'default:diamondblock', 'default:obsidian'}},
        {result='terumet:ingot_cgls', flux=5, time=5.0, input={'terumet:item_cryst_dia', 'terumet:item_cryst_ob'}},
    -- Teruceramic
        {result='terumet:item_ceramic', flux=2, time=3.0, input={'default:clay_lump'}},
    -- Thermese
        {result='terumet:item_thermese', flux=4, time=8.0, input={'default:mese_crystal'}},
    },
}

terumet.options.furnace = {
    --
    -- HIGH-TEMP FURNACE SETTINGS
    --
    -- Maximum HUs ht-furnace can contain
    MAX_HEAT = 30000,
    -- Heat cost per second
    COOK_HUPS = 100,
    -- Multiplier applied to normal cooking time
    -- NOTE: This multiplier is ignored for battery heating
    TIME_MULT = 0.5,
}

terumet.options.vac_oven = {
    --
    -- VACUUM OVEN SETTINGS
    --
    -- Maximum HUs machine can contain
    MAX_HEAT = 100000,
    -- HU cost per tick of cooking
    COOK_HUPS = 500,

    recipes = {
        {results={'terumet:item_tarball 4', 'terumet:item_coke', 'basic_materials:oil_extract 4'}, time=10.0, input='default:coal_lump'},
        {results={'terumet:item_tarball 40', 'terumet:block_coke', 'basic_materials:oil_extract 40'}, time=80.0, input='default:coalblock'},
    },

    VAC_FOOD = {
        ACTIVE = true,  -- make false to disable vacuum-packed food entirely
        -- number of items from a stack used to make one(1) vacuum-packed version
        PACKED_ITEMS = 1,
        -- multiplier applied to healing/stamina effect of a vacuum-packed food over its non-packed type
        EFFECT_MULTIPLIER = 1.5,
        -- if AUTO_GENERATE is true, the mod scans all items defined as of this mod's initialization
        -- if an item has an on_use and has the group food_*, it is assumed to be a food and adds a vacuum-packed version
        -- to ensure a mod's items are scanned, it should be added to terumet's list of dependent mods in mod.conf/depends.txt
        AUTO_GENERATE = true,
        -- items that are flagged as food by AUTO_GENERATE you do not want to be made into a vacfood can be added through this list
        -- if AUTO_GENERATE is false, this list has no effect
        -- (1 is meaningless and just to provide a value)
        BLACKLIST = {
            ['mobs:glass_milk']=1,
            ['mobs:bucket_milk']=1,
            ['main:honey_bottle']=1,
            ['mobs:egg']=1,
            ['group:food_butter']=1, -- you can use groups too
        },
        -- items that aren't automatically recognized as food can be added through this list
        -- even if AUTO_GENERATE is false, these items will be made into a vacfood
        -- (1 is meaningless and just to provide a value)
        WHITELIST = {
            ['moretrees:acorn_muffin']=1,
        }
        -- see interop/farming.lua for foods from "farming" mod
        -- see interop/extra.lua for foods from "extra" mod
    },

    MAX_RESULTS = 4, -- Maximum number of result items from recipes (adjust this if any larger recipes are added)
}

terumet.options.vulcan = {
    --
    -- CRYSTAL VULCANIZER SETTINGS
    --
    -- populated through registration, see interop/terumet_api.lua
    recipes = {}, -- DO NOT CHANGE
    -- Maximum HUs vulcanizer can contain
    MAX_HEAT = 60000,
    -- Heat cost per second of vulcanizing
    VULCANIZE_HUPS = 200,
    -- Time to process one item (in seconds)
    PROCESS_TIME = 6.0,
    -- when true, crystalizing obsidian always produces exactly one crystal.
    -- this prevents easy infinite obsidian loops.
    LIMIT_OBSIDIAN = true,
}

terumet.options.lavam = {
    --
    -- LAVA MELTER SETTINGS
    --
    -- Maximum HUs melter can contain
    MAX_HEAT = 30000,
    -- Nodes that can be melted to lava
    -- related number is total required heat to melt
    VALID_STONES = {
        ['default:stone']=15000,
        ['default:cobble']=20000,
        ['default:desert_stone']=14000,
        ['default:desert_cobble']=18000
    },
    -- total time for 1 item required in seconds (best if required heat/MELT_TIME is a whole number)
    MELT_TIME = 200
}

terumet.options.meseg = {
    --
    -- MESE GARDEN SETTINGS
    --
    -- Maximum HUs garden can contain
    MAX_HEAT = 50000,
    -- HUs required to begin growing
    START_HEAT = 10000,
    -- HUs required per second when growing
    HEAT_HUPS = 350,
    -- Multiplier applied to efficiency every second not heated or seeded
    EFFIC_LOSS_RATE = 0.75,
    -- Maximum efficiency "points" (at this level, progress is 100% of possible rate)
    -- Efficiency points increase by number of seed crystals each second until max
    MAX_EFFIC = 2000,
    -- Progress "points" needed to grow a new shard
    -- points gained each second = number of seed crystals x efficiency
    PROGRESS_NEED = 300,
    -- item id of seed crystal
    SEED_ITEM = 'default:mese_crystal',
    -- item id of produced item
    PRODUCE_ITEM = 'default:mese_crystal_fragment',
    -- Chance to lose a seed crystal each growth is 1/(SEED_LOSS_CHANCE-seed crystal count)
    -- so SEED_LOSS_CHANCE = 101 means:
    --  1 seed crystal = 1/100 chance (very low)
    --  99 seed crystals = 1/2 chance (coin flip)
    -- You can set to false or nil to disable losing seeds, even if it's overpowered.
    SEED_LOSS_CHANCE = 101,
    -- sound to play at Garden node when a seed is lost (nil for none)
    SEED_LOSS_SOUND = 'terumet_break',
    -- true if particle effects occur when a seed is lost (default machine PARTICLES option false will also disable)
    SEED_LOSS_PARTICLES = true
}

terumet.options.repm = {
    --
    -- EQUIPMENT REFORMER SETTINGS
    --
    MAX_HEAT = 50000,

    -- HUs/sec to melt repair material and repair material units processed per tick
    MELT_HUPS = 100,
    MELTING_RATE = 10,
    -- HUs/sec to repair one item and repair material units applied to repairing per tick
    REPAIR_HUPS = 30,
    REPAIR_RATE = 10,
    -- maximum units of repair material that can be stored
    RMAT_MAXIMUM = 1000,

    -- items that can be turned into "repair-material" and how much
    -- populated through registration, see interop/terumet_api.lua
    repair_mats = {}, -- DO NOT CHANGE

    -- all items that can be repaired and how much "repair-material" is required to remove a full wear bar
    -- (TODO) mods can add addtional ones through the API terumet.register_repairable_item -- see interop/terumet_api.lua
    repairable = {}, -- DO NOT CHANGE
}

terumet.options.ore_saw = {
    --
    -- ORE SAW SETTINGS
    --
    -- Nodes that can be gathered directly via saw (1 is meaningless and just to provide a value)
    VALID_ORES = {
        ['default:stone_with_diamond']=1,
        ['default:stone_with_mese']=1,
        ['default:stone_with_copper']=1,
        ['default:stone_with_tin']=1,
        ['default:stone_with_iron']=1,
        ['default:stone_with_gold']=1,
        ['default:stone_with_coal']=1,
        ['terumet:ore_raw']=1,
        ['terumet:ore_raw_desert']=1,
        ['terumet:ore_dense_raw']=1,
        ['terumet:ore_raw_desert_dense']=1,
        ['asteroid:copperore']=1,
        ['asteroid:diamondore']=1,
        ['asteroid:goldore']=1,
        ['asteroid:ironore']=1,
        ['asteroid:meseore']=1,
        ['moreores:mineral_mithril']=1,
        ['moreores:mineral_silver']=1,
        ['titanium:titanium_in_ground']=1,
        ['quartz:quartz_ore']=1,
        ['nether:titanium_ore']=1,
    },
    -- Number of times basic ore saw can be used before breaking
    BASIC_USES = 40,
    -- Number of times advanced ore saw can be used before breaking
    ADVANCED_USES = 200,
}

-- NOTE: Armor and bracers will only be available if the mod "3d_armor" by stujones11 (https://github.com/stujones11/minetest-3d_armor) is active
terumet.options.armor = {
    -- delete or comment out entire BRACERS = {...} block to disable all bracers
    BRACERS = { -- delete single line or comment out (add -- to start) to disable that type of bracer
        -- water-breathing bracer
        aqua={name='Aqua',        color='#0010ff', mat='default:papyrus',         xinfo='Underwater breathing',
              def=5,   uses=65535/150, rep=100, breathing=1},
        -- high jump bracer
        jump={name='Jump',        color='#ffac00', mat='terumet:item_cryst_mese', xinfo='Increase jump height',
              def=5,   uses=65535/200, rep=150, jump=0.5},
        -- movement speed bracer
        spd={ name='Speed',       color='#4eff00', mat='terumet:item_cryst_dia',  xinfo='Increase move speed',
              def=5,   uses=65535/150, rep=400, speed=0.8},
        -- anti-gravity bracer
        agv={ name='Antigravity', color='#7600ff', mat='terumet:item_entropy',    xinfo='Reduce gravity',
              def=5,   uses=65535/100, rep=400, speed=-0.1, gravity=-0.5, jump=-0.1},
        -- high heal bracer
        heal={name='Heal',        color='#ff0086', mat='terumet:block_dust_bio',  xinfo='Heal +10',
              heal=10, uses=65535/200, rep=600},
        -- high defense bracer
        def={ name='Defense',     color='#727272', mat='terumet:item_rsuitmat',   xinfo='Defense +30',
              def=30,  uses=65535/150, rep=300},
        -- fire protection bracer
        -- 3darmor must have the option "Enable fire protection" on in order for this bracer to function or be loaded
        fire={name='Fireproof',   color='#ff5d00', mat='terumet:item_cryst_ob',   xinfo='Immunity to fire/lava',
                       uses=65535/100, rep=300, fire=99},
    },
    -- Item used to create bracer crystals
    BRACER_CRYSTAL_ITEM = 'default:steelblock',
}
