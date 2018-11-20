-----------------------------------
-- Global Settings
-----------------------------------
HERO_SELECTION_TIME = 30		-- Времени на пик [SECOND]
GOLD_START = 800				-- Начальная голда
SPAWN_RUNE = 70					-- Время спавна рун [SECOND]
OFF = 0							-- отключение
GOLD_PER_TICK = 2				-- Голд в GOLD_INTERVAL_TICK [SECOND]
GOLD_INTERVAL_TICK = 0.5		-- Интервал получения золота [SECONDS]
GAME_TIME = 35					-- Время игры [MINUTES]
GOLD_RUNE = 200					-- Золото с Bounty Rune [RANDOM]
XP_RUNE = RandomInt(250,350)	-- Опыт с Bounty Rune [RANDOM]
MAX_LEVEL = 55					-- Максимальный уровень
XP_LEVEL = 100					-- Опыт на каждый последующий уровень
SPAWN_ITEM = 135 				-- Время спавна предметов
GOLD_MONETKA = 400				-- Денег с монетки
LEADER_GOLD = 250				-- Уменьшаемое количество золота команде лидеров от монетки
GOLD_BONUS_EVENT = 150			-- Бонусное золото во время эвента
EXP_RING = 40					-- Опыт в круге.
GOLD_RING = 7					-- Золото в круге.
EXP_GLOBAL = 45					-- Опыт глобально
GOLD_GLOBAL = 5					-- Золота Глобально
TIME_DEATH = 25				    -- Время через которое отключается бессмертие и убийство на фонтане. [MINUTES]
RADIUS_AURA = 1200				-- Радиус регенерации/убийства/бессмертия на фонтане
STRATEGY_TIME = 10				-- Время на стратегию
SHOW_TIME = 0					--
POST_GAME = 20					--	
HERO_PICK_TIME = 40				-- Время на выбор героя
DUR_EFFECTS = RandomInt(1,6)	-- Длительность эффекта от подарков
GOLD_LEADER = 450				-- Золота за убийство лидера
XP_LEADER = 100					-- Опыта за убийство лидера
BOSS_RESPAWN = 0
LEVEL_TABLE_TALENTS = 45
LVL_UP_TABLE = 5
NUM_UP_TABLE = 8
CustomNetTables:SetTableValue( "cva_talent_manager", "settings", { LEVEL_TABLE_TALENTS,LVL_UP_TABLE,NUM_UP_TABLE } )
-----------------------------------
-- Вкл/Выкл
-----------------------------------	
CUSTOM_RUNE	= false				-- Включает/Выключает кастомные руны.	
CUSTOM_PICK = true				-- Включить/Выключить кастомный пик
PRICE_EVENT = true 				-- Включить/Выключить Эвент с подарками.
GOLD_EVENT = false				-- Включить/Выключить Эвент с увеличенным золотом.
UPGRADE_TOWER = false			-- Улучшать башни? true/false
DROP_ITEM = true				-- Предметы падают? true/false
X2MOD = nil 					-- BETA
DOTA_MOD = false				-- DOTA_MOD
TALENT_MANAGER = true
AUTO_WIN = false

-----------------------------------
--Настройки для определённых карт
-----------------------------------
if GetMapName() == "dota" then
	GAME_TIME = 0
	TIME_DEATH = 25
	GOLD_START = 1000
	GOLD_PER_TICK = 1
	GOLD_INTERVAL_TICK = 1
	EXP_RING = 0
	GOLD_RING = 0	
	EXP_GLOBAL = 10	
	GOLD_GLOBAL = 1
	PRICE_EVENT = false 			
	GOLD_EVENT = false
	UPGRADE_TOWER = true
	DROP_ITEM = false
	DOTA_MOD = true
	BOSS_RESPAWN = 100
	GOLD_BOSS = RandomInt(3500,4500)
	RADIUS_AURA = 1400
	HERO_SELECTION_TIME = 5
	GOLD_RUNE = RandomInt(50,110)	-- Золото с Bounty Rune [RANDOM]
	XP_RUNE = RandomInt(45,60)
	require("modules/bosses/bosses")
end
if UPGRADE_TOWER == true then
	TOWER_ABILITIES = LoadKeyValues("scripts/kv/tower_abilities.kv")
end	
TALENT =
{
	"special_bonus_primary_stats_10",
	"special_bonus_ulquiorra_8",
	"special_bonus_sasuke_5",
	"special_bonus_shinobu_7",
	"special_bonus_akame_7",
	"special_bonus_kurumi_2",
	"special_bonus_kurumi_6",
	"special_bonus_rem_5",
	"special_bonus_rem_6",
	"special_bonus_star_6",
	"special_bonus_ichigo_8",
	"special_bonus_black_panther_7",
	"special_bonus_star_7",
	"special_bonus_naruto_5",
	"special_bonus_black_panther_5",
	"special_bonus_black_panther_6",
	"special_bonus_primary_stats_20",
	"special_bonus_primary_stats_60",
	"special_bonus_primary_stats_40",
	"special_bonus_primary_stats_50",
	"special_bonus_incoming_10",
	"special_bonus_incoming_15",
	"special_bonus_damage_pct_bonus_15",
	"special_bonus_damage_pct_bonus_10",
	"special_bonus_armor_pct_10",
	"special_bonus_armor_pct_8",
	"special_bonus_armor_pct_5",
	"special_bonus_green_damage_pct_25",
	"special_bonus_green_damage_pct_15",
	"special_bonus_green_damage_pct_10",
	"special_bonus_movespeed_600",
	"special_bonus_thanos_4",
	"special_bonus_loki_5",
	"special_bonus_black_panther_8",
	"special_bonus_movespeed_800",
	"special_bonus_movespeed_700",
	
}
MODIFIER_IGNORE_CRIT_ANIMATION = 
{
	"rem_waves_slow",
	"rem_water_waves_aura",
	"thanos_ult_thinker",
	"thanos_interval_dmg",
	"black_panther_blood",
}
TALENT_MAGICAL_CRIT =
{
	"special_bonus_magical_crit_15",
	"special_bonus_magical_crit_20",
	"special_bonus_magical_crit_25",
	"special_bonus_magical_crit_30",
	"special_bonus_magical_crit_35",
}
-----------------------------------
-- Rune/Руны:
-- 	True = on/ Вкл
-- 	False = off/Выкл
-----------------------------------

RUNE_BOUNTY = true				
RUNE_ARCANA = true 			
RUNE_INVIS = true
RUNE_DD = true
RUNE_ILLUSION = false
RUNE_REGENERATION = true
RUNE_HASTE = false

--[[if CUSTOM_PICK == true then
	STRATEGY_TIME = 0
	SHOW_TIME = 0
	POST_GAME = 0
	HERO_PICK_TIME = 0
end]]

if CUSTOM_RUNE == true then
	RUNE_BOUNTY = false				
	RUNE_ARCANA = false 			
	RUNE_INVIS = false
	RUNE_DD = false
	RUNE_ILLUSION = false
	RUNE_REGENERATION = false
	RUNE_HASTE = false
end

-----------------------------------
-- Fountain settings
-----------------------------------

SPISOK_REMOVE_MODIFIER = 
{
	"modifier_maka_reflect_activate",
	"modifier_venom_damage_bonus",
}

-----------------------------------
-- Items Settings
-----------------------------------
TIER_1 = 
{
	"item_ring_of_aquila",
	"item_phase_boots",
	"item_power_treads",
	"item_gem",
	"item_power_treads_2",
	"item_blink",
	"item_ghost",
	"item_phase_boots_1",
	"item_phase_boots_2",
	"item_vanguard",
	"item_boots_agility_1",
}

TIER_2 =
{

	"item_mask_of_madness",
	"item_blade_mail",
	"item_vladmir",
	"item_yasha",
	"item_mekansm",
	"item_hood_of_defiance",
	"item_magic_medallion_1",
	"item_lens2",
	"item_left_katana_deadpool",
	"item_right_katana_deadpool",
}
TIER_3 =
{
	"item_shivas_guard",
	"item_sphere",
	"item_diffusal_blade",
	"item_maelstrom",
	"item_basher",
	"item_invis_sword",
	"item_pipe",
	"item_black_king_bar",
	"item_bloodstone",
	"item_lotus_orb",
	"item_moon_shard",
	"item_Desolator_osnova_3",
	"item_thor_mjollnier",
	"item_thor_mjollnier_2",
	"item_phase_boots_3",
	"item_phase_boots_4",
}
	
TIER_4 =
{
	"item_skadi",
	"item_sheepstick",
	"item_orchid",
	"item_heart",
	"item_mjollnir",
	"item_ethereal_blade",
	"item_radiance",
	"item_abyssal_blade",
	"item_mkb",
	"item_satanic",
	"item_octarine_core",
	"item_rapier",
	"item_butterfly_2",
	"item_katanes_deadpool",
	"item_thor_mjollnier_4",
}

MODIFIERS_EVENT = 
{
	"modifier_spd_50",
	"modifier_spd_1000",
	"modifier_armor_pct_30",
	"modifier_damage_pct_bonus_30",
}

BOSSES =
{
	"npc_ComicsVsAnime_boss_1",
	"npc_ComicsVsAnime_boss_2",
}
BLOCKED_ITEMS = 
{
	"item_power_treads",
	"item_boots_agility_1",
	"item_boots_intellegence_1",
	"item_boots_strength_1",
	"item_radiance",
	"item_bottle",
	"item_ring_of_basilius",
	"item_ring_of_aquila",
	"item_bfury",
	"item_armlet",
}

CHAT_COMMANDS =
{
	["GOLD"] = 
	{
		funcs = function(args,hero)
			CommandsGold(hero,tonumber(args)) 
		end
	},
	
	["LVLHERO"] = 
	{
		funcs = function(args, hero)
			CommandsLevel(PlayerResource:GetSelectedHeroEntity(hero),tonumber(args)) 
		end
	},
	["GIVEITEMS"] = 
	{
		funcs = function(args, hero)
			CommandsGiveItems(args,PlayerResource:GetSelectedHeroEntity(hero)) 
		end
	},	
	["CREATECREEP"] = 
	{
		funcs = function(args, hero)
			CommandsCreateCreep(args,PlayerResource:GetSelectedHeroEntity(hero)) 
		end
	},	
	["STATS"] = 
	{
		funcs = function(args, hero)
			CommandsModifyStats(tonumber(args),PlayerResource:GetSelectedHeroEntity(hero))
		end
	},	
	["END"] = 
	{
		funcs = function(args, hero)
			if PlayerResource:GetSelectedHeroEntity(hero):GetTeam() then
				ComicsVsAnime:EndGame( PlayerResource:GetSelectedHeroEntity(hero):GetTeam() )
			end
		end
	},	
	["CREATEHEROES"] = 
	{
		funcs = function(args, hero)
			PopulateHeroTalentLinkedAbilities(PlayerResource:GetSelectedHeroEntity(hero))
		end
	},	
	["SWAPHERO"] = 
	{
		funcs = function(args, hero)
			for k,v in pairs(HEROES_CUSTOM) do
				if string.find(k,args) then
					CommandsSwapHero(hero, k)
					break
				end	
			end
		end
	},
}
UNITES_DOTA = LoadKeyValues("scripts/npc/npc_units.txt")
UNITES_CUSTOM = LoadKeyValues("scripts/npc/npc_units_custom.txt")
HEROES_CUSTOM = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
CUSTOM_ABILITY = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
CUSTOM_ITEMS = LoadKeyValues("scripts/npc/npc_items_custom.txt")
DOTA_ITEMS = LoadKeyValues("scripts/npc/items.txt")
PASSIVED_TALENT_LIST = LoadKeyValues("scripts/kv/passived_talent_list.kv")
CUSTOM_TALENTS_LIST = LoadKeyValues("scripts/kv/hero_talents_list.kv")
LINKEDABILITY = LoadKeyValues("scripts/kv/hero_linked_talents.kv")
