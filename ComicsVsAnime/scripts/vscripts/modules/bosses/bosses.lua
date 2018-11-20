if Bosses == nil then
print("[Boss Respawn] Loading Library")
	Bosses = class({})
end	

function Bosses:SpawnStaticBoss(name)
	local entity = Entities:FindAllByName(name)
	for _,spawner in pairs(entity) do
		Bosses:SpawnBossUnit(name, spawner)
	end
end

function Bosses:SpawnBossUnit(name, spawner)
	local boss = CreateUnitByName(name, spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	boss.Spawner = spawner
	return boss
end

function Bosses:InitBosses()
	for k,v in pairs(BOSSES) do
		Bosses:SpawnStaticBoss(v)	
	end
end

function Bosses:KilledBoss(unit, team,attacker)
	local unitname = unit:GetUnitName()
	local position = unit:GetAbsOrigin()
	local items_table = require('modules/bosses/item_drop_madara')
	if unitname == "npc_ComicsVsAnime_boss_2" then
		items_table = require('modules/bosses/item_drop_fate')
	end	
	local item = ComicsVsAnimeRandomDrop(items_table)
	if item ~= nil then
		unit:CreateDropBoss(item,position)
	end
	for _,v in pairs(HeroList:GetAllHeroes()) do
		if v:GetTeam() == attacker:GetTeam() then
			ComicsVsAnimeGold(GOLD_BOSS,v,v,false,nil,true)
		end
	end
	Timers:CreateTimer(BOSS_RESPAWN, function()
		Bosses:SpawnStaticBoss(unitname)
	end)
end

