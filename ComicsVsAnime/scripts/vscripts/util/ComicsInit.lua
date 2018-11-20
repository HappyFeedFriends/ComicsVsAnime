function ComicsVsAnime:InitGameMode()
	XP_TABLE = {}
	XP_TABLE[1] = 0
	for i = 2, MAX_LEVEL do
		XP_TABLE[i] = XP_TABLE[i-1] + i * XP_LEVEL 
	end
	if CUSTOM_RUNE == true then
		PlayerTables:CreateTable("gold", {}, AllPlayersInterval)
	end
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( MAX_LEVEL )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_TABLE)
	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	
	
	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self.m_GatheredShuffledTeams = {}
	self.numSpawnCamps = 5
	self.specialItem = ""
	self.spawnTime = SPAWN_ITEM
	self.nNextSpawnItemNumber = 1
	self.hasWarnedSpawn = false
	self.allSpawned = false
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	self.itemSpawnIndex = 1
	self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	self.tier1ItemBucket = {}
	self.tier2ItemBucket = {}
	self.tier3ItemBucket = {}
	self.tier4ItemBucket = {}
	self.TEAM_KILLS_TO_WIN = 25
	self.CLOSE_TO_VICTORY_THRESHOLD = 5
	---------------------------------------------------------------------------

	self:GatherAndRegisterValidTeams()

	GameRules:GetGameModeEntity().ComicsVsAnime = self
	if GetMapName() == "desert_quintet" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 8
	elseif GetMapName() == "temple_quartet" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 4 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 4 )
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 10
	elseif GetMapName() == "dota" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
		self.m_GoldRadiusMin = 0
		self.m_GoldRadiusMax = 0
		self.m_GoldDropPercent = 0
	else
		self.m_GoldRadiusMin = 250
		self.m_GoldRadiusMax = 550
		self.m_GoldDropPercent = 4
	end
	if CUSTOM_PICK == true then
		GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_target_dummy")
		GameRules:SetSameHeroSelectionEnabled( true )
	end
	GameRules:SetHeroSelectionTime( HERO_PICK_TIME )
	GameRules:SetPreGameTime( HERO_SELECTION_TIME + 5 )
	GameRules:SetPostGameTime( POST_GAME )
	GameRules:SetShowcaseTime( SHOW_TIME )
	GameRules:SetStrategyTime( STRATEGY_TIME )
	GameRules:SetGoldPerTick( GOLD_PER_TICK )
	GameRules:SetGoldTickTime( GOLD_INTERVAL_TICK )
	GameRules:SetRuneSpawnTime( SPAWN_RUNE )
	GameRules:SetStartingGold( GOLD_START )
	GameRules:SetCustomGameEndDelay( OFF )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , RUNE_DD )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, RUNE_HASTE )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, RUNE_ILLUSION ) 
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, RUNE_INVIS )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, RUNE_REGENERATION ) 
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, RUNE_ARCANA )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, RUNE_BOUNTY ) 
	
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( OFF )
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( OFF )
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( OFF )
	
	CustomGameEventManager:RegisterListener("PlayerVoteKills", Dynamic_Wrap(ComicsVsAnime, 'GetSelecterKillCount'))
	ComicsVsAnime:EventsOn();
	InitPlayerTalents();
	Convars:RegisterCommand( "Spawn_boss", function(...) return self:SpawnStaticBoss(name) end, "Spawn boss", FCVAR_CHEAT )
	if GOLD_EVENT == true then 
		self:StartGoldEvent()
		Convars:RegisterCommand( "GoldEvent", function(...) self:StartGoldEvent() end, "Gold event on.", FCVAR_CHEAT )
	end
	if PRICE_EVENT == true then 
		self:StartTimerToGoldRain() 
		Convars:RegisterCommand( "priceEvent", function(...) self:StartTimerToGoldRain() end, "Price Event on.", FCVAR_CHEAT )
	end
	if CUSTOM_RUNE == true then 
		Convars:RegisterCommand( "RuneSpawn", function(...) CustomRunes:SpawnRunes() end, "Rune Spawn", FCVAR_CHEAT )
	end
	
	Convars:RegisterCommand( "force_item_drop", function(...) self:ForceSpawnItem() end, "Force an item drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "force_gold_drop", function(...) self:ForceSpawnGold() end, "Force gold drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "set_timer", function(...) return SetTimer( ... ) end, "Set the timer.", FCVAR_CHEAT )
	Convars:RegisterCommand( "force_end_game", function(...) return self:EndGame( DOTA_TEAM_GOODGUYS ) end, "Force the game to end.", FCVAR_CHEAT )
	
	Convars:SetInt( "dota_server_side_animation_heroesonly", 0 )
	ComicsVsAnime:SetUpFountains()
	ComicsVsAnime:FiltersOn()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
	self.SortAll()
	CustomGameEventManager:Send_ServerToAllClients("damage_tooltip", {abilities} )
	spawncamps = {}
	for i = 1, self.numSpawnCamps do
		local campname = "camp"..i.."_path_customspawn"
		spawncamps[campname] =
		{
			NumberToSpawn = RandomInt(3,5),
			WaypointName = "camp"..i.."_path_wp1"
		}
	end
end
 
 function ComicsVsAnime:SortAll()
	local abilities = {}
	local talents = {}
	for k,v in pairs(CUSTOM_ABILITY) do
		if not string.find(k, "special_bonus_") and k ~= "Version" and v ~= "1" and k~= "=" and v ~= "/" and v ~= "=" then
			local ability_type = CUSTOM_ABILITY[k].AbilityDamageTypeTooltip
			if ability_type then
				abilities[k] = ability_type
			end
		end	
	end 
	abilities = json.encode(abilities)
	CustomNetTables:SetTableValue( "custom_damage_type", "table", { abilities } )
 end 
 
function ComicsVsAnime:SetUpFountains()

	local dur = (HERO_SELECTION_TIME + TIME_DEATH * 60) + 5
	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_regen", {} )
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_invuriable_aura", {} )
		Timers:CreateTimer(dur, function()
			fountainEnt:RemoveModifierByName("modifier_fountain_aura_lua")
			fountainEnt:RemoveModifierByName("modifier_fountain_invuriable_aura")
			CustomGameEventManager:Send_ServerToAllClients("start_fountain_event", {text = "FOUNTAIN PROTECTION REMOVE"} )
			print("Fountaib disabled...")
				Timers:CreateTimer(8, function()	
				CustomGameEventManager:Send_ServerToAllClients("end_fountain_event", {nil} )
			end)
		end)
	end
end

function ComicsVsAnime:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

function ComicsVsAnime:EndGame( victoryTeam )
	local overBoss = Entities:FindByName( nil, "@overboss" )
	if overBoss then
		local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
		if celebrate then
			overBoss:CastAbilityNoTarget( celebrate, -1 )
		end
	end

	GameRules:SetGameWinner( victoryTeam )
end

function ComicsVsAnime:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

function ComicsVsAnime:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	local leader = sortedTeams[1].teamID
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 and DOTA_MOD == false then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

function ComicsVsAnime:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if self.countdownEnabled == true then
		CountdownTimer()
		if nCOUNTDOWNTIMER == 30 and DOTA_MOD == false then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end
		if nCOUNTDOWNTIMER <= 0 and DOTA_MOD == false then
			--Check to see if there's a tie
			if self.isGameTied == false then
				GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
				ComicsVsAnime:EndGame( self.leadingTeam )
				self.countdownEnabled = false
			else
				self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
				local broadcast_killcount = 
				{
					killcount = self.TEAM_KILLS_TO_WIN
				}
				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
			end
       	end
	end
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if DROP_ITEM == true then
			ComicsVsAnime:ThinkGoldDrop()
			ComicsVsAnime:ThinkSpecialItemDrop()
		end
		ComicsVsAnime:OnGameInProgress()
	end

	return 1
end

function ComicsVsAnime:GatherAndRegisterValidTeams()
	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

function ComicsVsAnime:spawncamp(campname)
	spawnunits(campname)
end

function spawnunits(campname)
	local spawndata = spawncamps[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
	if SpawnLocation == nil then
		return
	end

    local randomCreature = 
    	{
			"basic_zombie",
			"berserk_zombie"
	    }
	local r = randomCreature[RandomInt(1,#randomCreature)]
	--print(r)
    for i = 1, NumberToSpawn do
        local creature = CreateUnitByName( "npc_dota_creature_" ..r , SpawnLocation:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
        --print ("Spawning Camps")
        creature:SetInitialGoalEntity( waypointlocation )
    end
end

function ComicsVsAnime:StartTimerToGoldRain()
	local CenterMap = Entities:FindByName( nil, "goldSpawn" ):GetAbsOrigin()
	local timer = RandomInt(300, 550)
	local dur = RandomInt(1, 4)

	Timers:CreateTimer(timer, function()
		Timers:CreateTimer(dur, function()
			Timers:RemoveTimer("goldtimer")
			ComicsVsAnime:StartTimerToGoldRain()
		end)
		Timers:CreateTimer("goldtimer", {
		useGameTime = true,
		endTime = 0,
		callback = function()
			EmitGlobalSound("Item.PickUpGemWorld")
			rRange = RandomVector( RandomFloat( 175, 900 ) )
			GoldBags = CreateItem( "item_event_rezhim", nil, nil )
			goldbag = CreateItemOnPositionForLaunch( CenterMap, GoldBags )
			GoldBags:LaunchLootInitialHeight( false, 0, 120, 0.45, rRange )
		  return 0.45
		end
	  })
	end)
end

function ComicsVsAnime:StartGoldEvent()
	local dur = RandomInt(20,35)
	local delay = RandomInt(240,400)
	Timers:CreateTimer(delay, function()
		local AllHeroes = HeroList:GetAllHeroes()	
	for count, hero in ipairs(AllHeroes) do
		hero:AddNewModifier( hero, hero, "modifier_gold_bonusx100", {Duration = dur} )
	end
		Timers:CreateTimer(dur, function()	
			ComicsVsAnime:StartGoldEvent()
			
			for count, hero in ipairs(AllHeroes) do
				GridNav:DestroyTreesAroundPoint(hero:GetAbsOrigin(), 275, true)
				hero:RemoveModifierByName("modifier_gold_bonusx100")
				
			end
		end)
	end)
end

function ComicsVsAnime:OnHeroInGame(hero)
	local time_elapsed = 0
	Timers:CreateTimer(0.1, function()
		if hero:GetUnitName() ~= "npc_dota_hero_target_dummy" or hero.is_real_wisp then
			hero.picked = true
		end
	end)
	local steamID = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
	if hero:GetUnitName() == "npc_dota_hero_dark_willow" then
		SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/units/maka/maka_scythe.vmdl"}):FollowEntity(hero, true)
	end	
	if hero:GetUnitName() == "npc_dota_hero_ursa" then
		SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/econs/source/thor_mjollnir.vmdl"}):FollowEntity(hero, true)
	end	
	if hero:GetUnitName() == "npc_dota_hero_chaos_knight" then
		if steamID == 311310226 then
			local sword_left = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_loki/loki_poseidon_edge/loki_poseidon_left.vmdl"})
            sword_left:FollowEntity(hero, true)
			local sword_right = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_loki/loki_poseidon_edge/loki_poseidon_right.vmdl"})
            sword_right:FollowEntity(hero, true)
		else
			local sword_left = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_loki/loki_left_weapon.vmdl"})
			sword_left:FollowEntity(hero, true)
			local sword_right = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_loki/loki_right_weapon.vmdl"})
			sword_right:FollowEntity(hero, true)
		end
	end

	if hero:GetUnitName() == "npc_dota_hero_silencer" then
		SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_hulk/econs/head.vmdl"}):FollowEntity(hero, true)
		SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_hulk/econs/hammer.vmdl"}):FollowEntity(hero, true)
	end
	Timers:CreateTimer(0.1, function()
		if hero.is_real_wisp or hero:GetUnitName() ~= "npc_dota_hero_target_dummy" and not hero:IsIllusion() then
			hero.picked = true
			return
		elseif not hero.is_real_wisp then
			if hero:GetUnitName() == "npc_dota_hero_target_dummy" and not hero:IsIllusion() then
				Timers:CreateTimer(function()
					if time_elapsed < 0.9 then
						time_elapsed = time_elapsed + 0.1
					else
						return nil
					end
					return 0.1
				end)
			end
			return
		end
	end)
end

function ComicsVsAnime:CustomSpawnCamps()
	for name,_ in pairs(spawncamps) do
	spawnunits(name)
	end
end

GAMEMODE_INITIALIZATION_STATUS = {}

function ComicsVsAnime:OnGameInProgress()
	if CUSTOM_RUNE == true then
		if GAMEMODE_INITIALIZATION_STATUS[3] then
			return
		end
		GAMEMODE_INITIALIZATION_STATUS[3] = true
		Timers:CreateTimer(function()
			CustomRunes:SpawnRunes()
			return SPAWN_RUNE
		end)
	end	
end

function ComicsVsAnime:OnTowerAbility()	
	local towers = Entities:FindAllByClassname("npc_dota_tower")
	local ability_table = IndexAllTowerAbilities()
	for _,radiant_tower in pairs(towers) do
		if radiant_tower:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			local dire_tower_name = string.gsub(radiant_tower:GetUnitName(), "goodguys", "badguys")
			local dire_tower
			for _,tower in pairs(towers) do
				if tower:GetUnitName() == dire_tower_name and not tower.initially_upgraded  then
					dire_tower = tower
					break
				end
			end
			
			if string.find(radiant_tower:GetUnitName(), "tower1") then
				local ability_name = GetRandomTowerAbility(1, ability_table)
				local ability = radiant_tower:AddAbility(ability_name)
				ability:SetLevel(1)
				local ability = dire_tower:AddAbility(ability_name)
				ability:SetLevel(1)
				for j = 1, #ability_table[1] do
					if ability_table[1][j] == ability_name then
						table.remove(ability_table[1], j)
						break
					end
				end
			end
			
			if string.find(radiant_tower:GetUnitName(), "tower2") then
				for i = 1, 2 do
					local ability_name = GetRandomTowerAbility(i, ability_table)
					local ability = radiant_tower:AddAbility(ability_name)
					ability:SetLevel(1)
					local ability = dire_tower:AddAbility(ability_name)
					ability:SetLevel(1)
					for j = 1, #ability_table[i] do
						if ability_table[i][j] == ability_name then
							table.remove(ability_table[i], j)
							break
						end
					end
				end
			end
			if string.find(radiant_tower:GetUnitName(), "tower3") then
				for i = 2, 3 do
					local ability_name = GetRandomTowerAbility(i, ability_table)
					local ability = radiant_tower:AddAbility(ability_name)
					ability:SetLevel(1)
					local ability = dire_tower:AddAbility(ability_name)
					ability:SetLevel(1)
					for j = 1, #ability_table[i] do
						if ability_table[i][j] == ability_name then
							table.remove(ability_table[i], j)
							break
						end
					end
				end
			end
			if string.find(radiant_tower:GetUnitName(), "tower4") then
				for i = 1,2 do
					local ability_name = GetRandomTowerAbility(4, ability_table)
					local ability = radiant_tower:AddAbility(ability_name)
					ability:SetLevel(1)
					local ability = dire_tower:AddAbility(ability_name)
					ability:SetLevel(1)
					for j = 1, #ability_table[4] do
						if ability_table[4][j] == ability_name then
							table.remove(ability_table[4], j)
							break
						end
					end
					dire_tower.initially_upgraded = true
				end
			end
		end
	end	
end