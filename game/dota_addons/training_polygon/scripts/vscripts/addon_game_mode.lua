-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  -- PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  -- PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  -- PrecacheResource("model_folder", "particles/heroes/antimage", context)
  -- PrecacheModel("models/heroes/viper/viper.vmdl", context)
  -- PrecacheModel("models/heroes/lina/lina.vmdl", context)
  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  --PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/am_replies.vsndevts", context)
  --PrecacheResource("soundfile", "soundevents/eul_snd.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("lina_light_strike_array", context)
  --PrecacheItemByNameSync("glimpse_datadriven", context)
  PrecacheItemByNameSync("item_manta", context)
  PrecacheItemByNameSync("item_cyclone", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_kunkka", context)
  PrecacheUnitByNameSync("npc_dota_hero_lina", context)
  PrecacheUnitByNameSync("npc_dota_hero_bloodseeker", context)
  PrecacheUnitByNameSync("npc_dota_hero_pugna", context)
  PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
  PrecacheUnitByNameSync("npc_dota_hero_necrolyte", context)
  PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
  PrecacheUnitByNameSync("npc_dota_hero_nevermore", context)
  PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
  PrecacheUnitByNameSync("npc_dota_hero_tidehunter", context)
  PrecacheUnitByNameSync("npc_dota_hero_ursa", context)
  PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
  PrecacheUnitByNameSync("npc_dota_hero_alchemist", context)
  PrecacheUnitByNameSync("npc_dota_hero_skywrath_mage", context)
  PrecacheUnitByNameSync("npc_dota_hero_medusa", context)
  PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
  PrecacheUnitByNameSync("npc_dota_hero_visage", context)
  PrecacheUnitByNameSync("npc_dota_hero_disruptor", context)
  PrecacheUnitByNameSync("npc_dota_hero_shadow_demon", context)
  PrecacheUnitByNameSync("npc_dota_hero_lich", context)
  PrecacheUnitByNameSync("npc_dota_hero_earthshaker", context)
  PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
  PrecacheUnitByNameSync("npc_dota_hero_obsidian_destroyer", context)
  PrecacheUnitByNameSync("npc_dota_hero_undying", context)
  PrecacheUnitByNameSync("npc_dota_hero_elder_titan", context)
  PrecacheUnitByNameSync("npc_dota_hero_rattletrap", context)
  PrecacheUnitByNameSync("npc_dota_hero_windrunner", context)
  PrecacheUnitByNameSync("npc_dota_hero_huskar", context)
  PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
  PrecacheUnitByNameSync("npc_dota_hero_tiny", context)
  PrecacheUnitByNameSync("npc_dota_hero_phoenix", context)
  PrecacheUnitByNameSync("npc_dota_hero_legion_commander", context)
  PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
  PrecacheUnitByNameSync("npc_dota_hero_slardar", context)
  PrecacheUnitByNameSync("npc_dota_hero_axe", context)
  PrecacheUnitByNameSync("npc_dota_hero_brewmaster", context)
  PrecacheUnitByNameSync("npc_dota_hero_centaur", context)
  PrecacheUnitByNameSync("npc_dota_hero_lion", context)
  PrecacheUnitByNameSync("npc_dota_hero_queenofpain", context)
  PrecacheUnitByNameSync("npc_dota_hero_winter_wyvern", context)
  PrecacheUnitByNameSync("npc_dota_visage_familiar1", context)
  PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
  PrecacheUnitByNameSync("npc_dota_neutral_polar_furbolg_ursa_warrior", context)
  PrecacheUnitByNameSync("npc_dota_neutral_centaur_khan", context)
  PrecacheUnitByNameSync("npc_dota_hero_leshrac", context)
  PrecacheUnitByNameSync("npc_dota_mk_fix", context)
  PrecacheUnitByNameSync("npc_dota_neutral_prowler_shaman", context)
  PrecacheUnitByNameSync("npc_dota_hero_techies", context)
  PrecacheUnitByNameSync("npc_dota_hero_monkey_king", context)
  PrecacheUnitByNameSync("npc_dota_hero_death_prophet", context)
  PrecacheUnitByNameSync("npc_dota_roshan", context)
  PrecacheUnitByNameSync("npc_dota_hero_nyx_assassin", context)
  PrecacheUnitByNameSync("first_donator_monument", context)
  PrecacheUnitByNameSync("npc_dota_hero_phantom_lancer", context)
  PrecacheUnitByNameSync("npc_dota_hero_naga_siren", context)
  PrecacheUnitByNameSync("npc_dota_hero_ember_spirit", context)
  PrecacheUnitByNameSync("npc_dota_hero_chaos_knight", context)
  PrecacheUnitByNameSync("npc_dota_hero_sand_king", context)
  PrecacheUnitByNameSync("npc_dota_hero_spirit_breaker", context)
  PrecacheUnitByNameSync("npc_dota_creep_badguys_melee", context)
  PrecacheUnitByNameSync("npc_dota_creep_goodguys_melee", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end

