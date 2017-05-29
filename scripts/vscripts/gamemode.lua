-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
--require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
--require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
--require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
--require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
--require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
--require('libraries/playertables')
-- This library can be used to create container inventories or container shops
--require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
--require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
--require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
--require('libraries/selection')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('casting')
-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end
---------------------------------------------------------- cheat check/fakelage setting








--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")

  
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]


function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item



  --hero:SetBaseMagicalResistanceValue(0)
  -- Timers:CreateTimer(function()
  -- print("kek")
  --   if (Convars:GetBool("sv_cheats")) then
  --     CustomGameEventManager:Send_ServerToAllClients("cheats_activated",{})
  --     return nil
  --   end

  --   return 2
  -- end
  -- )
  if hero:IsOwnedByAnyPlayer() then
    hero:SetBaseHealthRegen(25)
    hero:SetBaseStrength(200)
    
    hero:SetAbilityPoints(0)
    hero:SetBaseManaRegen(0)
  end
  --hero:SetMoveCapability(0)
  
  hero:SetAttackCapability(0)
  

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  --local monument=CreateUnitByName("first_donator_monument", Vector(5084.013672, 4443.666504, 128.000000), true, nil, nil, DOTA_TEAM_NEUTRALS)

end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  timingCalc=Time()

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "tp_test", Dynamic_Wrap(GameMode, 'TestCommand1'), "A console command example", FCVAR_CHEAT )
  Convars:RegisterCommand("tp_test2", Dynamic_Wrap(GameMode,'TestCommand2'),"petuch",FCVAR_CHEAT) 
  Convars:RegisterCommand("tp_hide_menu", Dynamic_Wrap(GameMode,'HideMenu'),"petuch",FCVAR_CHEAT) 
  Convars:RegisterCommand("tp_show_menu", Dynamic_Wrap(GameMode,'ShowMenu'),"petuch",FCVAR_CHEAT) 
  Convars:RegisterCommand("tp_print_place", Dynamic_Wrap(GameMode,'cmdPrintPlace'),"petuch",FCVAR_CHEAT) 
  Convars:RegisterCommand("tp_start_glimpse", Dynamic_Wrap(GameMode,'cmdStartGlimpse'),"petuch",FCVAR_CHEAT) 
  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
  GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(GameMode, "TrackingProjectileFilter"), self)
  GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(GameMode, "AbilityTuning"), self)
  GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierGained"), self)

end





function GameMode:cmdPrintPlace()
  local cmdPlayer = Convars:GetCommandClient()
  local active_hero = cmdPlayer:GetAssignedHero()
  local respawn_place = active_hero:GetAbsOrigin()
  print(respawn_place)
  local gavno=active_hero:FindModifierByName("modifier_disruptor_glimpse")
  print("gavno:",gavno)
  DebugPrintTable(gavno)
  print(gavno.vPositions)
end




function GameMode:TestCommand1()
  print("ti pidor")
  stones_list = {}
  local cmdPlayer = Convars:GetCommandClient()
  local active_hero = cmdPlayer:GetAssignedHero()
  PlayerResource:ReplaceHeroWith(cmdPlayer:GetPlayerID(),"npc_dota_hero_earth_spirit",0,1)
  local hero = cmdPlayer:GetAssignedHero()
  local pinok=hero:FindAbilityByName("earth_spirit_boulder_smash")
  pinok:SetLevel(4)
  hero:SetMoveCapability(1)
  
  local alpha = 20
  local ztest = true
  local drawColor = Vector(255, 0, 0)
  local fps=30
  local attackRange = 200
  local radius = attackRange --+ hero:GetHullRadius()
  local stoneKickRange=2000
  local boxWidth=160
  local boxHeight=0
  --drawing
  Timers:CreateTimer(function()
      local playerPos = hero:GetAbsOrigin()
      for index,stone in pairs(stones_list) do 
        --print(index,stone) 
        lenght=(hero:GetAbsOrigin()-stone:GetAbsOrigin()):Length()
        lenght_with_hulls=lenght+hero:GetHullRadius()+stone:GetHullRadius()
        if lenght_with_hulls<=radius then


          local npcPos = stone:GetAbsOrigin()
          local boxDirection = npcPos - playerPos
          boxDirection.z = 0 -- We are doing 2d vector math here
          boxDirection = boxDirection:Normalized() -- some precision lost here. How do i compensate?
          local boxCenter = npcPos + ((stoneKickRange/2) * boxDirection)
          local boxMax = Vector(stoneKickRange/2, boxWidth, boxHeight)
          local boxMin = Vector(-stoneKickRange/2, -boxWidth, 0)
          local color = Vector(127, 176, 255)
          --DebugDrawBoxDirection(boxCenter, boxMax, boxMin, boxDirection, color, 20, 1/fps)
          DebugDrawCircle(npcPos, color, 20, 8, ztest, 1/fps)
        end


      end

      
      DebugDrawCircle(playerPos, drawColor, alpha, radius, ztest, 1/fps)
      return 1/fps
    end
  )
  

end



function GameMode:HideMenu()
  CustomGameEventManager:Send_ServerToAllClients("cmd_hide_menu",{})

end

function GameMode:ShowMenu()
  CustomGameEventManager:Send_ServerToAllClients("cmd_show_menu",{})
end

function custom_manta_training( eventSourceIndex, args )
--   manta_skills={"lina_light_strike_array",
--             "kunkka_ghostship",
--             "lina_laguna_blade",
--             "bloodseeker_blood_bath",
--             "pugna_nether_blast",
--             "meepo_poof",
--             "necrolyte_death_pulse",
--             "mirana_starfall",
--             "nevermore_shadowraze1",
--             "nevermore_shadowraze2",
--             "nevermore_shadowraze3",
--             "zuus_lightning_bolt",
--             "zuus_thundergods_wrath",
--             "tidehunter_anchor_smash",
--             "ursa_earthshock",
--             "omniknight_purification",
--             "alchemist_unstable_concoction_throw",
--             "skywrath_mage_arcane_bolt",
--             "medusa_mystic_snake",
--             "medusa_stone_gaze",
--             "techies_suicide",
--             "monkey_king_boundless_strike",
--             "shadow_demon_demonic_purge",
--             "earthshaker_fissure",
--             "earthshaker_enchant_totem",
--             "earthshaker_enchant_totem",
--             "invoker_emp",
--             "obsidian_destroyer_sanity_eclipse",
--             "undying_decay",
--             "elder_titan_echo_stomp",
--             "rattletrap_rocket_flare",
--             "rattletrap_hookshot",
--             "rattletrap_hookshot",
--             "rattletrap_hookshot",
--             "windrunner_powershot",
--             "huskar_life_break",
--             "gyrocopter_homing_missile",
--             "tiny_toss",
--             "phoenix_supernova",
--             "legion_commander_overwhelming_odds",
--             "magnataur_reverse_polarity",
--             "slardar_slithereen_crush",
--             "axe_berserkers_call",
--             "brewmaster_thunder_clap",
--             "centaur_hoof_stomp",
--             "lion_finger_of_death",
--             "queenofpain_scream_of_pain",
--             "monkey_king_primal_spring",
--             "visage_summon_familiars_stone_form",
--             "polar_furbolg_ursa_warrior_thunder_clap",
--             "centaur_khan_war_stomp",
--             "spawnlord_master_stomp",
--             "obsidian_destroyer_astral_imprisonment",
--             "roshan_slam"
--           }
-- manta_evasion_type={1,
--               5,
--               3,
--               1,
--               1,
--               1,
--               5,
--               1,
--               1,
--               1,
--               1,
--               1,
--               1,
--               1,
--               1,
--               1,
--               4,
--               4,
--               4,
--               2,
--               5,
--               1,
--               3,
--               1,
--               1,
--               5,
--               1,
--               1,
--               1,
--               1,
--               5,
--               5,
--               5,
--               5,
--               5,
--               4,
--               4,
--               4,
--               2,
--               1,
--               1,
--               1,
--               2,
--               1,
--               1,
--               3,
--               5,
--               5,
--               1,
--               1,
--               1,
--               1,
--               1,
--               1
--              }

-- manta_static_time={0.5,
--               nil,
--               0.2666664124,
--               2.633331299,
--               0.9333343506,
--               0,
--               nil,
--               0.5666656494,
--               0,
--               0,
--               0,
--               0,
--               0,
--               0,
--               0,
--               0,
--               nil,
--               nil,
--               nil,
--               2,
--               nil,
--               0,
--               5.033332825,
--               0,
--               0,
--               1.033332824707,
--               2.899993896,
--               0,
--               0,
--               1.300003052,
--               nil,
--               nil,
--               nil,
--               nil,
--               nil,
--               nil,
--               nil,
--               1.266677856,
--               6,
--               0,
--               0,
--               0,
--               0,
--               0,
--               0,
--               0.2666778564,
--               nil,
--               nil,
--               0.5666656494,
--               0,
--               0,
--               0,
--               0,
--               0
--              }
  local hero_name="npc_dota_hero_antimage"
  CustomGameState=1
  MANTA_SKILL_ID=0
  MANTA_CURRENT_SKILL=""
  MANTA_SKILL_CASTED=0
  MANTA_SKILL_CASTED_TIME=0
  MANTA_HERO_HURT=0
  MANTA_HERO_HURT_TIME=0
  MANTA_CASTED=0
  MANTA_CASTED_TIME=0
  MANTA_MODIFIER_GAINED=0
  TimebarState=args['timebar']
  CustomGameEventManager:Send_ServerToAllClients("custom_training_start",{timebar=TimebarState})
  local castTime=0
  local player=PlayerResource:GetPlayer(args.PlayerID)
  active_hero=player:GetAssignedHero()
  if active_hero:GetName()~=hero_name then
    active_hero:RemoveSelf()
    PlayerResource:ReplaceHeroWith(args.PlayerID,hero_name,0,1)
    active_hero=player:GetAssignedHero()
  end
  active_hero:SetMoveCapability(0)
  active_hero:SetBaseHealthRegen(0)
  active_hero:SetBaseStrength(100)
  --active_hero:SetBaseMaxHealth(2000)
  for i=0,14 do
    local itemFind=active_hero:GetItemInSlot(i)
    --print(itemFind)
    if itemFind~=nil then
      active_hero:RemoveItem(itemFind)
    end
  end

  local item = CreateItem("item_manta",active_hero,active_hero)
  active_hero:AddItem(item)
  local id=0
  local castDelay=3
  local deathDelay=2
  local ids = {}
  allowed_skills=args['skills']
  local i=0
  while allowed_skills[tostring(i)] do
    table.insert(ids, allowed_skills[tostring(i)])
    i=i+1
  end
  local ids_count=#ids
  local id_counter=1
  Timers:CreateTimer("manta_training_timer", {
    useOldStyle = true,
    endTime = GameRules:GetGameTime() + 1,
    callback = function()
      MANTA_SKILL_ID=ids[id_counter]
      --print("######ID CHANGED:",MANTA_SKILL_ID)
      castTime=castSpellById(ids[id_counter],active_hero,castDelay,deathDelay)
      local nextCast=castDelay+castTime+1
      id_counter=id_counter+1
      
      if id_counter>ids_count then
        id_counter=1
      end
      if CustomGameState==1 then
        return GameRules:GetGameTime() + nextCast
      else
        CustomGameEventManager:Send_ServerToAllClients("custom_training_ends",{})
        return nil
      end



      --print ("Hello. I'm running after 5 seconds and then every second thereafter.")
      return GameRules:GetGameTime() + 1
    end
  })



end

function custom_manta_training_end( eventSourceIndex, args )
  CustomGameState=0
  Timers:RemoveTimer("manta_training_timer")
  CustomGameEventManager:Send_ServerToAllClients("custom_training_ends",{})

end

function euls_training_end( eventSourceIndex, args )
  eulsGameState=0
  if not pizduk:IsNull() then
    pizduk:RemoveSelf()
  end
  if pizduki then
    for i=1,#pizduki, 1 do
      pizduki[1]:RemoveSelf()
      table.remove(pizduki,1)
      print("pizduk removed:",i)
    end
  end
  
  CustomGameEventManager:Send_ServerToAllClients("custom_training_ends",{})
end

function euls_training_start( eventSourceIndex, args )
  eulsGameState=1
  local skill_id=args['skillId']
  local eulTimebar=args['timebar']
  local eulLense=args['lense']
  local eulBlink=args['blink']
  --skill->hero
  eul_skills={"kunkka_torrent",--id=1
              "nevermore_requiem",--id=2
              "invoker_sun_strike",--id=3
              "elder_titan_echo_stomp",--id=4
              "techies_suicide",--id=5
              "death_prophet_silence",--id=6
              "lina_light_strike_array",--id=7
              "earthshaker_fissure",--id=8
              "earthshaker_enchant_totem",--id=9
              "leshrac_split_earth",--id=10
              "slardar_slithereen_crush",--id=11
              "centaur_hoof_stomp",--id=12
              "bloodseeker_blood_bath",--id=13
              "earthshaker_enchant_totem",--id=14 with AGHS
              "lion_impale",--id=15
              "nyx_assassin_impale",--id=16
              "phoenix_fire_spirits",--id=17
              "pudge_meat_hook",--id=18
              "earth_spirit_boulder_smash",--id=19
              "mirana_arrow",--id=20
              "sandking_burrowstrike",--id=21
              "spirit_breaker_greater_bash",--id=22
              "spirit_breaker_greater_bash",--id=23 with talent
              "sandking_burrowstrike",--id 24 AGHS
              "nyx_assassin_spiked_carapace"--id 25 AGHS
            }

  eul_heroes={"npc_dota_hero_kunkka",--id=1
              "npc_dota_hero_nevermore",--id=2
              "npc_dota_hero_invoker",--id=3
              "npc_dota_hero_elder_titan",--id=4
              "npc_dota_hero_techies",--id=5
              "npc_dota_hero_death_prophet",--id=6
              "npc_dota_hero_lina",--id=7
              "npc_dota_hero_earthshaker",--id=8
              "npc_dota_hero_earthshaker",--id=9
              "npc_dota_hero_leshrac",--id=10
              "npc_dota_hero_slardar",--id=11
              "npc_dota_hero_centaur",--id=12
              "npc_dota_hero_bloodseeker",--id=13
              "npc_dota_hero_earthshaker",--id=14 AGHS
              "npc_dota_hero_lion",--id=15
              "npc_dota_hero_nyx_assassin",--id=16
              "npc_dota_hero_phoenix",--id=17
              "npc_dota_hero_pudge",--id=18
              "npc_dota_hero_earth_spirit",--id=19
              "npc_dota_hero_mirana",--id=20
              "npc_dota_hero_sand_king",--id=21
              "npc_dota_hero_spirit_breaker",--id=22
              "npc_dota_hero_spirit_breaker",--id=23 with talent
              "npc_dota_hero_sand_king",--id=24 with AGHS
              "npc_dota_hero_nyx_assassin"--id=25 AGHS
            }

  eul_castpoints={2,--id=1
                  1.67,--id=2
                  1.75,--id=3
                  1.7,--id=4
                  1.75,--id=5
                  0.5,--id=6
                  0.95,--id=7
                  0.69,--id=8
                  0.69,--id=9
                  1.05,--id=10
                  0.35,--id=11
                  0.5,--id=12
                  2.6,--id=13
                  1,--id=14 AGHS
                  0,--id=15
                  0,--id=16
                  0,--id=17
                  0,--id=18
                  0,--id=19
                  0,--id=20
                  0,--id=21
                  0,--id=22
                  0,--id=23 with talent
                  0,--id=24 AGHS
                  0--id=25 AGHS
                }
  local barTime
  if eul_castpoints[skill_id]==0 then
    eulTimebar=0
  end
  if skill_id==13 then
    barTime=2.6
    CustomGameEventManager:Send_ServerToAllClients("eul_training_started",{castpoint=2.5, timebar=eulTimebar, id=skill_id, bartime=eul_castpoints[skill_id]})
  else
    barTime=2.5
    CustomGameEventManager:Send_ServerToAllClients("eul_training_started",{castpoint=eul_castpoints[skill_id], timebar=eulTimebar, id=skill_id, bartime=barTime})
  end

  EUL_SKILL=eul_skills[skill_id]
  local player=PlayerResource:GetPlayer(args.PlayerID)
  local hero=player:GetAssignedHero()
  hero:RemoveSelf()
  PlayerResource:ReplaceHeroWith(args.PlayerID,eul_heroes[skill_id],0,1)
  local hero=player:GetAssignedHero()
  hero:SetMoveCapability(1)
  removeItems(hero)
  local respawn_place = randomRingPosition(300,500,hero)--respawn place for cm
  if EUL_SKILL=="spirit_breaker_greater_bash" then
    local passivka = hero:FindAbilityByName("spirit_breaker_charge_of_darkness")
    passivka:SetLevel(4)
    pizduki={}
    local direction = (hero:GetAbsOrigin()-respawn_place):Normalized()
    local target="npc_dota_creep_badguys_melee"
    for i=1,6, 1 do
      local target_point_vector = respawn_place + 600 * direction*i
      local pizduk3=CreateUnitByName(target, target_point_vector, true, nil, nil, DOTA_TEAM_BADGUYS)
      pizduk3:SetBaseHealthRegen(1000)
      pizduk3:SetIdleAcquire(false)
      pizduk3:SetMoveCapability(0)
      pizduk3:SetAttackCapability(0)
      pizduki[i]=pizduk3
      print("inserted:",i)
    end
    if skill_id==23 then
      local passivka2 = hero:FindAbilityByName("special_bonus_unique_spirit_breaker_2")
      passivka2:SetLevel(1)
    end
  end
  if skill_id==14 or skill_id==24 or skill_id==25 then
    local scepter = CreateItem("item_ultimate_scepter",hero,hero)
    hero:AddItem(scepter)
  end
  if EUL_SKILL=="nevermore_requiem" then
    local passivka = hero:FindAbilityByName("nevermore_necromastery")
    passivka:SetLevel(4)
    hero:SetModifierStackCount("modifier_nevermore_necromastery", hero, 36)
  end
  if EUL_SKILL=="earthshaker_enchant_totem" then
    local passivka = hero:FindAbilityByName("earthshaker_aftershock")
    passivka:SetLevel(4)
    local spell=hero:FindAbilityByName("earthshaker_enchant_totem")
    spell:SetLevel(1)
    EUL_SKILL="earthshaker_aftershock"
  end
  if EUL_SKILL=="earthshaker_enchant_totem" then
    local passivka = hero:FindAbilityByName("earthshaker_aftershock")
    passivka:SetLevel(4)
    local spell=hero:FindAbilityByName("earthshaker_enchant_totem")
    spell:SetLevel(1)
    EUL_SKILL="earthshaker_aftershock"
  end
  if eulLense==1 then
    local lense = CreateItem("item_aether_lens",hero,hero)
    hero:AddItem(lense)
  end
  if eulBlink==1 then
    local DAGGER = CreateItem("item_blink",hero,hero)
    hero:AddItem(DAGGER)
  end
  if EUL_SKILL=="invoker_sun_strike" then
    local spell=hero:FindAbilityByName("invoker_exort")
    spell:SetLevel(5)
  else
    local spell=hero:FindAbilityByName(EUL_SKILL)
    spell:SetLevel(1)
  end

  --print(EUL_SKILL)
  local item = CreateItem("item_cyclone",hero,hero)
  hero:AddItem(item)
  
  --creating target

  local target="npc_dota_hero_crystal_maiden"
  pizduk=CreateUnitByName(target, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS)
  pizduk:SetMoveCapability(1)
  pizduk:SetBaseHealthRegen(150)

end

function alchemist_banka_training( eventSourceIndex, args )
  AlchemistTrainingState=1
  local TimebarState=args['timebar']
  local player=PlayerResource:GetPlayer(args.PlayerID)
  local hero=player:GetAssignedHero()
  hero:RemoveSelf()
  PlayerResource:ReplaceHeroWith(args.PlayerID,"npc_dota_hero_alchemist",0,1)
  active_hero=player:GetAssignedHero()
  active_hero:SetMoveCapability(1)
  active_hero:SetAbsOrigin(Vector(0,0,128))
  removeItems(active_hero)
  local item = CreateItem("item_manta",active_hero,active_hero)
  active_hero:AddItem(item)
  local ability_name = "alchemist_unstable_concoction"
  local ability = active_hero:FindAbilityByName(ability_name)
  ability:SetLevel(1)
  CustomGameEventManager:Send_ServerToAllClients("eul_training_started",{castpoint=0.1, timebar=TimebarState, id=420, bartime=5.5})
end

function alchemist_banka_training_end( eventSourceIndex, args )
  AlchemistTrainingState=0
  CustomGameEventManager:Send_ServerToAllClients("custom_training_ends",{})
end

function glimpse_training_start( eventSourceIndex, args )
  glimpse_training_state=1
  


  glimpse_type={"item_manta",
                "phantom_lancer_doppelwalk",
                "naga_siren_mirror_image",
                "ember_spirit_sleight_of_fist",
                "chaos_knight_phantasm",
                "ember_spirit_activate_fire_remnant"
                }
  glimpse_hero={"npc_dota_hero_antimage",
                "npc_dota_hero_phantom_lancer",
                "npc_dota_hero_naga_siren",
                "npc_dota_hero_ember_spirit",
                "npc_dota_hero_chaos_knight",
                "npc_dota_hero_ember_spirit"
                }
  glimpse_castpoint={0,
                    0.1,
                    0.65,
                    0,
                    0.4,
                    0}
  glimpse_duration={0.1,
                    1,
                    0.3,
                    0.2,
                    0.5,
                    nil}


  local skill_id=args['skillId']
  local TimebarState=args['timebar']                
  local player=PlayerResource:GetPlayer(args.PlayerID)
  active_hero = player:GetAssignedHero()
  removeItems(active_hero)
  active_hero:RemoveSelf()
  PlayerResource:ReplaceHeroWith(args.PlayerID,glimpse_hero[skill_id],0,1)
  active_hero = player:GetAssignedHero()
  if skill_id==1 then
    local item = CreateItem("item_manta",active_hero,active_hero)
    active_hero:AddItem(item)    
  else
    local spell=active_hero:FindAbilityByName(glimpse_type[skill_id])
    spell:SetLevel(1)
  end
  local boots = CreateItem("item_travel_boots",active_hero,active_hero)
  active_hero:AddItem(boots) 
  active_hero:SetAttackCapability(1)
  active_hero:SetBaseAgility(1000)
  active_hero:SetMoveCapability(1)

  hero_pos_table = {}
  for i, v in ipairs(hero_pos_table) do 
    print(i,v)

  end
  GLIMPSE_TP_MODE=args['tpMode']
  GLIMPLSE_SKILL=glimpse_type[skill_id]
  DISRUPTOR_KILLED=0
  PIZDUK_ALIVE=0
  PIZDUK2_ALIVE=0
  GLIMPSE_SAFETIME=glimpse_castpoint[skill_id]+glimpse_duration[skill_id]/2
  GLIMPSE_MINTIME=glimpse_castpoint[skill_id]+0.4
  CustomGameEventManager:Send_ServerToAllClients("glimpse_training_started",{timebar=TimebarState,castpoint=glimpse_castpoint[skill_id],duration=glimpse_duration[skill_id]})
  
  local backtrack_time=4.5
  local interval=0.05
  local max_index=backtrack_time/interval
  SAD_DISRUPTOR=nil
  if GLIMPSE_TP_MODE=="tpMode2" then
    CustomGameEventManager:Send_ServerToAllClients("travel_reminder",{})
    disruptor_position=randomDisruptorPosition(4000,active_hero)
    createSadDisruptor(disruptor_position,active_hero,1500)
    local distance = (disruptor_position - active_hero:GetAbsOrigin()):Length2D() 
    local direction = (disruptor_position - active_hero:GetAbsOrigin()):Normalized()
    local target_point = 0.92 * distance
    local target_point_vector = active_hero:GetAbsOrigin() + direction * target_point
    local target="npc_dota_creep_goodguys_melee"
    pizduk2=CreateUnitByName(target, target_point_vector, true, nil, nil, active_hero:GetTeam())
    pizduk2:SetMoveCapability(1)
    pizduk2:SetIdleAcquire(false)
    pizduk2:SetBaseHealthRegen(150)
    pizduk2:SetMaximumGoldBounty(0)
    pizduk2:SetMinimumGoldBounty(0)
    pizduk2:SetDeathXP(0)
    PIZDUK2_ALIVE=1
  else
    disruptor_position=randomDisruptorPosition(2000,active_hero)
    createSadDisruptor(disruptor_position,active_hero,1500)
  end

  
  --GLIMPSE POSITION THINKER

  Timers:CreateTimer("glimpse_position_thinker", {
    useGameTime=true,
    endTime=0,
    callback=function()
      table.insert(hero_pos_table,1,active_hero:GetAbsOrigin())
      if #hero_pos_table>=max_index then
        table.remove(hero_pos_table,#hero_pos_table)
      end
      -- local color=Vector(255,0,0)
      -- local ztest=true
      -- for i, v in ipairs(hero_pos_table) do 
      -- DebugDrawCircle(v, color, 20, 20, ztest, interval)

      -- end
      return interval
    end
  })

end

function glimpse_training_end( eventSourceIndex, args )
  glimpse_training_state=0
  if not SAD_DISRUPTOR:IsNull() then
    SAD_DISRUPTOR:RemoveSelf()
  end
  if GLIMPLSE_SKILL=="ember_spirit_sleight_of_fist" and PIZDUK_ALIVE==1 then
    if not pizduk:IsNull() then
      pizduk:RemoveSelf()
    end
  end
  if PIZDUK2_ALIVE==1 then
    pizduk2:RemoveSelf()
  end
  Timers:RemoveTimer("glimpse_position_thinker")
  CustomGameEventManager:Send_ServerToAllClients("custom_training_ends",{})
end


function GameMode:cmdStartGlimpse()
  
  CustomGameEventManager:Send_ServerToAllClients("glimpse_training_started",{castpoint=0.1})
  local cmdPlayer = Convars:GetCommandClient()
  active_hero = cmdPlayer:GetAssignedHero()
  disruptor_position=randomDisruptorPosition(2000,active_hero)
  print(disruptor_position)
  sadDisruptor=createSadDisruptor(disruptor_position,active_hero,1500)
  
  local item = CreateItem("item_manta",active_hero,active_hero)
  active_hero:AddItem(item)
  active_hero:SetAttackCapability(1)
  active_hero:SetBaseAgility(1000)
  hero_pos_table = {}
  --glimpsePositionThinker(active_hero)

end

function createSadDisruptor(position,hero,castRange)
  SadDisruptor = CreateUnitByNameAsync("npc_dota_hero_disruptor", position, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
    --unit:AddAbility(abilityName)
    CustomGameEventManager:Send_ServerToAllClients("ping_on_minimap",{respawn_place=position})
    unit:SetBaseHealthRegen(0)
    unit:SetBaseStrength(0)
    unit:SetMaxHealth(1)
    unit:SetBaseMaxHealth(1)
    unit:SetMoveCapability(0)
    unit:SetMaximumGoldBounty(0)
    unit:SetMinimumGoldBounty(0)
    unit:SetDeathXP(0)
    unit:SetForwardVector((hero:GetOrigin() - position):Normalized())
    unit:SetIdleAcquire(false)
    local ability = unit:FindAbilityByName("disruptor_glimpse")
    ability:SetLevel(4)
    --------------making ga
    unit:AddAbility("omniknight_guardian_angel")
    local guardian=unit:FindAbilityByName("omniknight_guardian_angel")
    guardian:SetLevel(1)
    guardian:SetOverrideCastPoint(0)
    unit:SetContextThink(DoUniqueString("cast_ability"),
        function()
          --print("ga casted:",Time())
          unit:CastAbilityNoTarget(guardian, -1)
        end,
      0)

    local backtrack_time=4.5
    local interval=0.05
    local max_index=backtrack_time/interval
    Timers:CreateTimer(function()
      if hero:IsNull() or unit:IsNull() then
        return nil
      else
        if hero_pos_table[#hero_pos_table] then
          local lenght=(hero:GetAbsOrigin()-position):Length()
          local lenght2=(active_hero:GetAbsOrigin()-hero_pos_table[#hero_pos_table]):Length()
          local calc_time=lenght2/600
          if lenght2/600>1.8 then
            calc_time=1.8
          end
          if lenght<=castRange and calc_time>GLIMPSE_MINTIME then
            --print("proc calc_time:",calc_time)
            unit:SetContextThink(DoUniqueString("cast_ability"),
            function()

              unit:CastAbilityOnTarget(hero,ability,-1)
              
              unit:SetIdleAcquire(false)
            end,
            0)
            return nil 
          else
            return interval
          end
        else
          return interval
        end
      end
      
    end)
    return unit
  end)

end





CustomGameEventManager:RegisterListener( "custom_manta_training_end", custom_manta_training_end )

CustomGameEventManager:RegisterListener( "custom_manta_training_start", custom_manta_training )

CustomGameEventManager:RegisterListener( "euls_training", euls_training_start )

CustomGameEventManager:RegisterListener( "euls_end", euls_training_end )

CustomGameEventManager:RegisterListener( "alche_end", alchemist_banka_training_end )

CustomGameEventManager:RegisterListener( "alche_start", alchemist_banka_training )

CustomGameEventManager:RegisterListener( "start_glimpse", glimpse_training_start )

CustomGameEventManager:RegisterListener( "end_glimpse", glimpse_training_end )

-- CustomGameEventManager:RegisterListener( "ping_setting", setPing )


function GameMode:OnNPCSpawned(keys)
  DebugPrint("[BAREBONES] NPC Spawned")
  DebugPrintTable(keys)

  local npc = EntIndexToHScript(keys.entindex)
  --print(npc:GetUnitName(),Time())
  -- if npc:GetUnitName()=="npc_dota_earth_spirit_stone" then
  --   stones_list[keys.entindex]=npc
  -- end
  ------------------------------------GLIMPSE LOGIC---------------------------------------
  if npc:GetUnitName()=="npc_dota_thinker" and glimpse_training_state==1 then
    local lenght=(active_hero:GetAbsOrigin()-npc:GetAbsOrigin()):Length()
    local lenght2=(active_hero:GetAbsOrigin()-hero_pos_table[#hero_pos_table]):Length()
    local glimpse_time=lenght/600
    if lenght/600>1.8 then
      glimpse_time=1.8
    end
    CustomGameEventManager:Send_ServerToAllClients("glimpse_casted",{bartime=glimpse_time,castpoint=GLIMPSE_SAFETIME})
    local calc_time=lenght2/600
    if lenght2/600>1.8 then
      calc_time=1.8
    end
    if GLIMPLSE_SKILL=="ember_spirit_sleight_of_fist" then
      local distance = (SAD_DISRUPTOR:GetAbsOrigin() - active_hero:GetAbsOrigin()):Length2D() 
      local direction = (SAD_DISRUPTOR:GetAbsOrigin() - active_hero:GetAbsOrigin()):Normalized()
      local target_point = 0.5 * distance
      local target_point_vector = active_hero:GetAbsOrigin() + direction * target_point
      local target="npc_dota_creep_badguys_melee"
      pizduk=CreateUnitByName(target, target_point_vector, true, nil, nil, DOTA_TEAM_BADGUYS)
      pizduk:SetMoveCapability(1)
      pizduk:SetIdleAcquire(false)
      pizduk:SetBaseHealthRegen(150)
      pizduk:SetMaximumGoldBounty(0)
      pizduk:SetMinimumGoldBounty(0)
      pizduk:SetDeathXP(0)
      PIZDUK_ALIVE=1
    end
    Timers:CreateTimer({
      useGameTime = false,
      endTime = glimpse_time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
      callback = function()
        if not SAD_DISRUPTOR:IsNull() then
          SAD_DISRUPTOR:Purge(true,true,false,true,false)
          -- print("purging:",Time())
        end
      end
    })

    -- print("thinker_spawn:",npc:GetAbsOrigin())
    -- print("calc_spawn",hero_pos_table[#hero_pos_table])
    -- print("glimpse time:",glimpse_time)
    -- print("calc time:",calc_time)

  end
  if npc:GetUnitName()=="npc_dota_hero_disruptor" then

    SAD_DISRUPTOR=npc
  end


  local respawn_place = npc:GetAbsOrigin()
  --print(respawn_place.x,respawn_place.y)
  
end

function GameMode:_OnEntityKilled( keys )
  if GameMode._reentrantCheck then
    return
  end

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  if killedUnit:IsRealHero() then 
    DebugPrint("KILLED, KILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
    if END_GAME_ON_KILLS and GetTeamHeroKills(killerEntity:GetTeam()) >= KILLS_TO_END_GAME_FOR_TEAM then
      GameRules:SetSafeToLeave( true )
      GameRules:SetGameWinner( killerEntity:GetTeam() )
    end

    --PlayerResource:GetTeamKills
    if SHOW_KILLS_ON_TOPBAR then
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, GetTeamHeroKills(DOTA_TEAM_BADGUYS) )
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, GetTeamHeroKills(DOTA_TEAM_GOODGUYS) )
    end
  end

  GameMode._reentrantCheck = true
  GameMode:OnEntityKilled( keys )
  GameMode._reentrantCheck = false
  -------------------------------GLIMPSE LOGIC---------------------------
  if glimpse_training_state==1 and killedUnit:GetName()=="npc_dota_hero_disruptor" then
    DISRUPTOR_KILLED=DISRUPTOR_KILLED+1
    if PIZDUK2_ALIVE==1 then
      if not pizduk2:IsNull() then
        pizduk2:RemoveSelf()
        PIZDUK2_ALIVE=0
      end
    end
    
    
    if GLIMPLSE_SKILL=="ember_spirit_sleight_of_fist" then
      if not pizduk:IsNull() then
        pizduk:RemoveSelf()
      end
    end
    
    if GLIMPSE_TP_MODE=="tpMode1" then
      --print(DISRUPTOR_KILLED)
      if (DISRUPTOR_KILLED+1)%5==0 then
        CustomGameEventManager:Send_ServerToAllClients("travel_reminder",{})
        disruptor_position=randomDisruptorPosition(4000,killerEntity)
        createSadDisruptor(disruptor_position,active_hero,1500)
        local distance = (disruptor_position - active_hero:GetAbsOrigin()):Length2D() 
        local direction = (disruptor_position - active_hero:GetAbsOrigin()):Normalized()
        local target_point = 0.90 * distance
        local target_point_vector = active_hero:GetAbsOrigin() + direction * target_point
        local target="npc_dota_creep_goodguys_melee"
        pizduk2=CreateUnitByName(target, target_point_vector, true, nil, nil, active_hero:GetTeam())
        pizduk2:SetMoveCapability(1)
        pizduk2:SetIdleAcquire(false)
        pizduk2:SetBaseHealthRegen(150)
        pizduk2:SetMaximumGoldBounty(0)
        pizduk2:SetMinimumGoldBounty(0)
        pizduk2:SetDeathXP(0)
        PIZDUK2_ALIVE=1
      else
        disruptor_position=randomDisruptorPosition(2000,killerEntity)
        createSadDisruptor(disruptor_position,active_hero,1500)
      end
    elseif GLIMPSE_TP_MODE=="tpMode2" then
      CustomGameEventManager:Send_ServerToAllClients("travel_reminder",{})
      disruptor_position=randomDisruptorPosition(4000,killerEntity)
      createSadDisruptor(disruptor_position,active_hero,1500)
      local distance = (disruptor_position - active_hero:GetAbsOrigin()):Length2D() 
      local direction = (disruptor_position - active_hero:GetAbsOrigin()):Normalized()
      local target_point = 0.90 * distance
      local target_point_vector = active_hero:GetAbsOrigin() + direction * target_point
      local target="npc_dota_creep_goodguys_melee"
      pizduk2=CreateUnitByName(target, target_point_vector, true, nil, nil, active_hero:GetTeam())
      pizduk2:SetMoveCapability(1)
      pizduk2:SetIdleAcquire(false)
      pizduk2:SetBaseHealthRegen(150)
      pizduk2:SetMaximumGoldBounty(0)
      pizduk2:SetMinimumGoldBounty(0)
      pizduk2:SetDeathXP(0)
      PIZDUK2_ALIVE=1
    else
      disruptor_position=randomDisruptorPosition(2000,killerEntity)
      createSadDisruptor(disruptor_position,active_hero,1500)
    end
    killedUnit:RemoveSelf() --Removing died dusruptor from game
  end

end

-- An entity died
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed
  -- if killedUnit:GetUnitName()=="npc_dota_earth_spirit_stone" then
  --   stones_list[keys.entindex_killed]=nil
  -- end


end

function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
  hero = self.vUserIds[userID]:GetAssignedHero()
  --medusaSnake(active_hero,3,2,)
  -- local castDelay=3
  -- local deathDelay=2
  -- local respawn_place = randomCirclePosition(tonumber(text),hero)
  -- local lenght=hero:GetAbsOrigin()-respawn_place
  -- local range=lenght:Length()
  -- local castpoint=0.1
  -- local castTime=(range-50)/500+castpoint
  -- local calcTime=(range-48)/500
  -- print("=======TEST=========")
  -- print("calculated range:", range)
  -- print("calculated castTime:",calcTime)
  -- local ability_name = "skywrath_mage_arcane_bolt"
  -- local caster_name = "npc_dota_hero_skywrath_mage"
  -- casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
end
--===============EVASION CHECK===============
function GameMode:TestCommand2()
  local cmdPlayer = Convars:GetCommandClient()
  PlayerResource:ReplaceHeroWith(cmdPlayer:GetPlayerID(),"npc_dota_hero_alchemist",0,1)
  local hero = cmdPlayer:GetAssignedHero()
  hero:SetMoveCapability(1)
  local item = CreateItem("item_manta",hero,hero)
  hero:AddAbility("event_test")

  hero:AddItem(item)
  --alcheBanka(hero,3,3)
  KEK_TIME=Time()
end
function ResetEvasionVars()
  MANTA_CURRENT_SKILL=""
  MANTA_HERO_HURT=0
  MANTA_HERO_HURT_TIME=0
  MANTA_CASTED=0
  MANTA_CASTED_TIME=0
  MANTA_SKILL_CASTED=0
  MANTA_HERO_HURT=0
end


function GameMode:OrderFilter(event)
    --Check if the order is the glyph type
    --print("POSTUPIL PRIKAZ:",Time())
    --DeepPrintTable( event )

    --Return true by default to keep all other orders the same
      ----------------------------Manta training evasion check logic-------------------------------------
    if CustomGameState==1 then
      if event['entindex_ability']~=0 then
        local ability=EntIndexToHScript(event['entindex_ability'])
        if ability:GetAbilityName()=="item_manta" then---------------PLAYER PRESSED MANTA
          --print("AAAAAAAA SUKA")
          MANTA_CASTED_TIME=Time()
          --print("MANTA_CASTED_TIME",MANTA_CASTED_TIME)
          if MANTA_HERO_HURT==1 then

          else
            --MANTA_CASTED=1
            
          end
          
        end
      end
    end
    if AlchemistTrainingState==1 then
      if event['entindex_ability']~=0 then
        local ability=EntIndexToHScript(event['entindex_ability'])
        if ability:GetAbilityName()=="item_manta" then---------------PLAYER PRESSED MANTA
          --print("AAAAAAAA SUKA")
          MANTA_CASTED_TIME=Time()
          --print("MANTA_CASTED_TIME",MANTA_CASTED_TIME)
          if ALCHE_HERO_HURT==1 then
            CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=true, time=420})
          else
            --MANTA_CASTED=1
            
          end
          
        end
      end
    end
    return true
end
function GameMode:AbilityTuning(event)
    --Check if the order is the glyph type
    -- print("------------AbilityTuning:",Time())
    -- DeepPrintTable( event )

    --Return true by default to keep all other orders the same
      ----------------------------Manta training evasion check logic-------------------------------------

    return true
end
function GameMode:ModifierGained(event)
    --Check if the order is the glyph type 
    -- print("------------ModCreated:",Time())
    --DeepPrintTable( event )
    if CustomGameState==1 then
      if event['name_const']=="modifier_medusa_stone_gaze_stone" then
        MANTA_MODIFIER_GAINED=Time()
      end
      if event['name_const']=="modifier_stunned" then
        MANTA_MODIFIER_GAINED=Time()
      end
      if event['name_const']=="modifier_axe_berserkers_call" then
        MANTA_MODIFIER_GAINED=Time()
      end
    end
    if eulsGameState==1 then
      if EUL_SKILL=="lion_impale" and event['name_const']=="modifier_lion_impale" then
        EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
        EUL_SKILL_DMG_DONE=1
        EUL_CASTED=0
        --print("EUL_COMPLETE_TIME",EUL_COMPLETE_TIME)
        CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
      end
      if EUL_SKILL=="nyx_assassin_spiked_carapace" and event['name_const']=="modifier_stunned" then
        EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
        EUL_SKILL_DMG_DONE=1
        EUL_CASTED=0
        --print("EUL_COMPLETE_TIME",EUL_COMPLETE_TIME)
        CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
      end
      if EUL_SKILL=="sandking_burrowstrike" and event['name_const']=="modifier_sandking_impale" then
        EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
        EUL_SKILL_DMG_DONE=1
        EUL_CASTED=0
        --print("EUL_COMPLETE_TIME",EUL_COMPLETE_TIME)
        CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
      end
      if EUL_SKILL=="kunkka_torrent" and event['name_const']=="modifier_kunkka_torrent" then
        EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
        EUL_SKILL_DMG_DONE=1
        EUL_CASTED=0
        --print("EUL_COMPLETE_TIME",EUL_COMPLETE_TIME)
        CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
      end
      if EUL_SKILL=="nyx_assassin_impale" and event['name_const']=="modifier_nyx_assassin_impale" then
        EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
        EUL_SKILL_DMG_DONE=1
        EUL_CASTED=0
        --print("EUL_COMPLETE_TIME",EUL_COMPLETE_TIME)
        CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
      end
    end
      ----------------------------Manta training evasion check logic-------------------------------------

    return true
end
function GameMode:TrackingProjectileFilter(event)

    --DeepPrintTable( event )

    return true
end

function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  --print("TIME BETWEEN CAST AND ILLUSIONS:",Time()-KEK_TIME)
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
  ---------------------manta training evasion logic----------------------
  if CustomGameState==2 then

  end
end
 


function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  --print("OnNonPlayerUsedAbility time:",Time())
  DebugPrintTable(keys)
  local abilityname=  keys.abilityname
  ----------------------------Manta training evasion check logic-------------------------------------
  if CustomGameState==2 then
    MANTA_SKILL_CASTED=1
    MANTA_SKILL_CASTED_TIME=Time()
    --print("######NON PLAYA USED ABULUTU ID=",MANTA_CURRENT_ID)
  end
end

function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  -- DebugPrintTable(keys)
  -- print("ability used:",Time(),keys.abilityname)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
  if abilityname=="item_manta" then
    KEK_TIME=Time()
  end
  if AlchemistTrainingState==1 then
    if abilityname=="alchemist_unstable_concoction" then
      CustomGameEventManager:Send_ServerToAllClients("eul_casted",{time=5.5})
      ALCHE_ABILITY_TIME=Time()
      ALCHE_BANKA_USED=1
      ALCHE_HERO_HURT=0
      Timers:CreateTimer({
        useGameTime = false,
        endTime = 6, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()
          if ALCHE_HERO_HURT==0 then
            CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=420})
          end
        end
      })
    end
  end

  if eulsGameState==1 then
    --------------------------------------------------------------------------------bloodbath logic
    if EUL_SKILL=="bloodseeker_blood_bath" then
      if abilityname=="bloodseeker_blood_bath" then
        CustomGameEventManager:Send_ServerToAllClients("eul_casted",{time=2.6})
      end
      if abilityname=="item_cyclone" then
        EUL_CASTED=1
        EUL_SKILL_DMG_DONE=0
        EUL_CASTED_TIME=Time()
        EUL_DMG_DONE=0
        Timers:CreateTimer({
            useGameTime = false,
            endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
              if EUL_SKILL_DMG_DONE==0 and EUL_CASTED==1 then
                CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=true, time=420})
                EUL_CASTED=0
              end
            end
          })
      end
      --------------------------------------------------------------------------------bloodbath logic end
    else
      if abilityname=="item_cyclone" then
        EUL_CASTED=1
        EUL_SKILL_DMG_DONE=0
        EUL_CASTED_TIME=Time()
        EUL_DMG_DONE=0
        CustomGameEventManager:Send_ServerToAllClients("eul_casted",{time=2.5})
        Timers:CreateTimer({
          useGameTime = false,
          endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
          callback = function()
            if EUL_SKILL_DMG_DONE==0 and EUL_CASTED==1 then
              CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=true, time=420})
              EUL_CASTED=0
            end
          end
        })
      end
      if abilityname=="death_prophet_silence" and EUL_CASTED==1 then
        if EUL_DMG_DONE==1 then
          EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
          EUL_SKILL_DMG_DONE=1
          EUL_CASTED=0
          CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
        else
          CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=true, time=420})
        end
      end
    end
  end
  -----------------------------------------Manta evasion checker logic
  if CustomGameState==2 then


  end
end

function GameMode:OnEntityHurt(keys)
  DebugPrint("[BAREBONES] Entity Hurt")
  DebugPrintTable(keys)
  
  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
      --print(damagingAbility:GetAbilityName(),Time(),EUL_CASTED)
      --print("hero hurt:",Time(),damagingAbility:GetAbilityName())
      if eulsGameState==1 and entVictim==pizduk then
        if EUL_SKILL=="bloodseeker_blood_bath" then
          --------------------------------------------------------------------------------bloodbath logic
          if EUL_CASTED==1 then
            if (damagingAbility:GetAbilityName()=="item_cyclone") then
              EUL_DAMAGE_TIME=Time()  
              EUL_DMG_DONE=1
            end
            if (damagingAbility:GetAbilityName()==EUL_SKILL) then
                EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
                EUL_SKILL_DMG_DONE=1
                EUL_CASTED=0
                CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
            end
          end
          --------------------------------------------------------------------------------bloodbath logic
        else
          if EUL_CASTED==1 then
            if (damagingAbility:GetAbilityName()=="item_cyclone") then
              EUL_DAMAGE_TIME=Time()  
              EUL_DMG_DONE=1
            end
            if (damagingAbility:GetAbilityName()==EUL_SKILL) then
                EUL_COMPLETE_TIME=Time()-EUL_DAMAGE_TIME
                EUL_SKILL_DMG_DONE=1
                EUL_CASTED=0
                print("EUL_COMPLETE_TIME",EUL_COMPLETE_TIME)
                CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=false, time=EUL_COMPLETE_TIME})
            end
          end
        end      
      end
      -----------------------------------------Manta evasion checker logic
      if CustomGameState==1 then
        if entVictim==active_hero then
          MANTA_HERO_HURT_TIME=Time()
        end
      end
      if AlchemistTrainingState==1 then
        if entVictim==active_hero then
          ALCHE_HERO_HURT=1
          ALCHE_HERO_HURT_TIME=Time()
          CustomGameEventManager:Send_ServerToAllClients("eul_result",{bad=true, time=420})
        end
      end

    end
  end
end