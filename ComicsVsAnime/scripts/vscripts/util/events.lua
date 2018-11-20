function ComicsVsAnime:EventsOn()
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( ComicsVsAnime, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( ComicsVsAnime, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( ComicsVsAnime, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( ComicsVsAnime, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( ComicsVsAnime, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( ComicsVsAnime, "OnNpcGoalReached" ), self )
	ListenToGameEvent('player_chat', Dynamic_Wrap(ComicsVsAnime, 'OnPlayerChat'), self)
	CustomGameEventManager:RegisterListener("PlayerVoteKills", Dynamic_Wrap(ComicsVsAnime, 'GetSelecterKillCount'))
	--ListenToGameEvent('player_connect_full', Dynamic_Wrap(ComicsVsAnime, 'OnConnectFull'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(ComicsVsAnime, 'PlayerConnect'), self)
	--ListenToGameEvent("player_reconnected", Dynamic_Wrap(ComicsVsAnime, 'OnPlayerReconnect'), self)
	--CustomGameEventManager:RegisterListener("modifier_clicked_purge", Dynamic_Wrap(ComicsVsAnime, "ModifierClickedPurge"))
end

function ComicsVsAnime:OnConnectFull(keys)
	local PlayerID = keys.PlayerID
	local index = keys.index
	local userID = keys.userid
end

function ComicsVsAnime:PlayerConnect(keys)
end

--[[function ComicsVsAnime:OnPlayerReconnect(keys)
	PrintTable(keys)
end]]

function ComicsVsAnime:OnPlayerChat(keys)
	local text = keys.text
	local ID = keys.userid
	local PlayerId = keys.playerid
	local teamOnly = keys.teamonly
	local SteamdID = PlayerResource:GetSteamAccountID(PlayerId)
	local player = PlayerResource:GetPlayer(PlayerId)
	local playerName = PlayerResource:GetPlayerName(PlayerId)
	local hero = player:GetAssignedHero()
	local hero_table = PlayerResource:GetSelectedHeroEntity(PlayerId)	
	if IsDev(PlayerId) and text:find(" ") then
		local commands = {}
		for v in string.gmatch(string.sub(text, 2), "%S+") do 
			table.insert(commands, v) 
		end		
		local command = table.remove(commands, 1)
		local prob =  text:find(" ")
		local numbers = string.sub(text, prob+1)
		local cmd =  CHAT_COMMANDS[command]	
		if cmd then
			cmd.funcs(numbers,PlayerId)
		end 
	end		
end 

function ComicsVsAnime:GetSelecterKillCount(data)
	ValueKillsCountCount = data['SelectedValue']
	ComicsVsAnime:SortKillCount(ValueKillsCountCount)
end

function ComicsVsAnime:ModifierClickedPurge(data)
	if data.PlayerID and data.unit and data.modifier then
		local ent = EntIndexToHScript(data.unit)
		if IsValidEntity(ent) and ent:IsAlive() and ent:GetPlayerOwner() == PlayerResource:GetPlayer(data.PlayerID) and table.contains(ONCLICK_PURGABLE_MODIFIERS, data.modifier) and not ent:IsStunned() and not ent:IsChanneling() then
			ent:RemoveModifierByName(data.modifier)
		end
	end
end

function ComicsVsAnime:SortKillCount(value)
	if MaxCount == nil then
		MaxCount = 0
		LowKills = 0
		MediumKills = 0
		HightKills = 0
		FourKills = 0
		FiveKills = 0
	end
	if value == "25" then
		LowKills = LowKills + 1
		print("25 pick: =", LowKills)
	end
	if value == "50" then
		MediumKills = MediumKills + 1
		print("50 pick: =", MediumKills)
	end
	if value == "75" then
		HightKills = HightKills + 1
		print("75 Pick: = ", HightKills)
	end
	if value == "100" then
		FourKills = FourKills + 1
		print("100 Pick: = ", FourKills)
	end
	if value == "999" then
		FiveKills = FiveKills + 1
		print("RANDOM Pick: =", FiveKills)
	end
	local variants = {25,50,75,100}
	local kill_random = variants[RandomInt(1,#variants)]
	local CountsKills = {25,50,75,100,kill_random}	
	local CountVotes = {LowKills,MediumKills,HightKills,FourKills,FiveKills}
	if LowKills == MediumKills and LowKills == HightKills and MediumKills == HightKills and FourKills == HightKills and FiveKills == HightKills then
		SelectedValueCount = 60
	end
	if LowKills == MediumKills then
		SelectedValueCount = 25
	end
	if LowKills == HightKills then
		SelectedValueCount = 50
	end
	if MediumKills == HightKills then
		SelectedValueCount = 75
	end
	if FourKills == HightKills then
		SelectedValueCount = 100
	end	
	if FiveKills == HightKills then
		SelectedValue = 80
	end
	for i = 1, #CountVotes do
		if CountVotes[i]>MaxCount then
			MaxCount = CountVotes[i]
			SelectedValueCount = CountsKills[i]
		end
	end
	print("SELECT KILL LIMIT: =", SelectedValueCount)
end

function ComicsVsAnime:GetAllPlayersID()
    local vPlayers = {}
    for i = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(i) then
            local steam_id = PlayerResource:GetSteamAccountID(i)
            if steam_id ~= 0 then
                table.insert(vPlayers, steam_id)
            end
        end
    end
    return vPlayers
end

function ComicsVsAnime:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	print( "OnGameRulesStateChange: " .. nNewState )
		if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
			if	CUSTOM_PICK == true then	
				HeroSelection:HeroListPreLoad()
			end
			if AUTO_WIN == true then
				TEAM_PLAYERS_VALID = {}
				for i = 0, DOTA_MAX_PLAYERS - 1 do
					local Player = PlayerResource:GetPlayer(i)
					local player_team = PlayerResource:GetTeam(i)

					if PlayerResource:IsValidPlayer(i) and Player and GetTeamPlayerCount(player_team) > 0 then
						TEAM_PLAYERS_VALID[player_team] = 
						{
							PlayersCount = GetTeamPlayerCount(player_team),
						}
					end
				end			
				PrintTable(TEAM_PLAYERS_VALID)
			end
		end
	if nNewState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE and CUSTOM_PICK == false  then
        for i = 0, DOTA_MAX_PLAYERS-1 do
            local hPlayer = PlayerResource:GetPlayer(i)
            if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
                hPlayer:MakeRandomHeroSelection()
            end
        end
    end
		if GetMapName() == 	"desert_quintet" then
			nCOUNTDOWNTIMER = GAME_TIME * 60	
		elseif GetMapName() == "desert_duo" then
			nCOUNTDOWNTIMER = GAME_TIME * 60	
		elseif GetMapName() == "mines_trio" then
			nCOUNTDOWNTIMER = GAME_TIME * 60
		else
			nCOUNTDOWNTIMER = GAME_TIME * 60
		end
		
		if SelectedValueCount == nil then
			SelectedValueCount = 70
		end
		if GetMapName() == "desert_quintet" then
			self.TEAM_KILLS_TO_WIN = SelectedValueCount
		elseif GetMapName() == "desert_duo" then
			self.TEAM_KILLS_TO_WIN = SelectedValueCount
		elseif GetMapName() == "mines_trio" then
			self.TEAM_KILLS_TO_WIN = SelectedValueCount
		else
			self.TEAM_KILLS_TO_WIN = SelectedValueCount
		end
		CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );
		self._fPreGameStartTime = GameRules:GetGameTime()
		if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			if UPGRADE_TOWER == true then
				ComicsVsAnime:OnTowerAbility()
			end
			if DOTA_MOD == true then
				Bosses:InitBosses()
			end
		self.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )
		end
		--[[if new_state == DOTA_GAMERULES_STATE_PRE_GAME then
			for k,v in pairs(entity) do
				local courier = CreateUnitByName("npc_dota_courier", v:GetAbsOrigin(), true, nil, nil, v:GetTeam())
			end
		end]]
end

function ComicsVsAnime:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )	
	if spawnedUnit:IsRealHero() then
		 AddMissingGenericTalent(spawnedUnit)	
		Timers:CreateTimer(0.4, function()
			if spawnedUnit:HasModifier("modifier_silencer_int_steal") then
				spawnedUnit:RemoveModifierByName("modifier_silencer_int_steal")
			end 
		end)
		if not spawnedUnit:HasModifier("health_regen_passive") then
			spawnedUnit:AddNewModifier(spawnedUnit,nil,"health_regen_passive",{duration = -1})
		end 
		if not spawnedUnit:HasModifier("modifier_custom_mechanics") then
			spawnedUnit:AddNewModifier(spawnedUnit,nil,"modifier_custom_mechanics",{duration = -1})
		end		
		if not spawnedUnit:HasModifier("modifier_check_talent") then
			spawnedUnit:AddNewModifier(spawnedUnit,nil,"modifier_check_talent",{duration = -1})
		end
		local deathEffects = spawnedUnit:Attribute_GetIntValue( "effectsID", -1 )
		if deathEffects ~= -1 then
			ParticleManager:DestroyParticle( deathEffects, true )
			spawnedUnit:DeleteAttribute( "effectsID" )
		end
	end
	if spawnedUnit:IsRealHero() and spawnedUnit.bFirstSpawned == nil then
		spawnedUnit.bFirstSpawned = true
		if spawnedUnit:GetUnitName() ~= "npc_dota_hero_target_dummy" then
			LoadingTalents(spawnedUnit)
		end
		--NewDamage:CreateResistances(spawnedUnit)
		ComicsVsAnime:OnHeroInGame(spawnedUnit)	
		spawnedUnit:AddItemByName("item_courier")
		if spawnedUnit:FindAbilityByName("maka_soul") then
			spawnedUnit:FindAbilityByName("maka_soul"):SetLevel(1)
		end
	end
end

function ComicsVsAnime:OnTeamKillCredit( event )

	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = self.TEAM_KILLS_TO_WIN - nTeamKills
	
	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}
	if nKillsRemaining <= 0 then
		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= self.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end

function ComicsVsAnime:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0
	if killedUnit:IsBosses() then
		Bosses:KilledBoss(killedUnit, DOTA_TEAM_NEUTRALS,hero)
	end
	if killedUnit:IsRealHero() then
		self.allSpawned = true
		if hero:IsRealHero() == true then
			if event.entindex_inflictor ~= nil then
				local inflictor_index = event.entindex_inflictor
				if inflictor_index ~= nil then
					local ability = EntIndexToHScript( event.entindex_inflictor )
					if ability ~= nil and ability:GetAbilityName() ~= nil and ability:GetAbilityName() == "necrolyte_reapers_scythe"  then
						extraTime = 20
					end
				end
			end
		end
		if hero:IsRealHero() and heroTeam ~= killedTeam then
			if killedUnit:GetTeam() == self.leadingTeam and self.isGameTied == false then
				local memberID = hero:GetPlayerID()
				ComicsVsAnimeGold(GOLD_LEADER,memberID,hero,true,PlayerResource)
				ComicsVsAnimeXp(XP_LEADER,hero,hero,memberID,false)
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			else
				ComicsVsAnimeXp(25,hero,hero,memberID,false)
			end
		end
		local allHeroes = HeroList:GetAllHeroes()
		for _,attacker in pairs( allHeroes ) do
			for i = 0, killedUnit:GetNumAttackers() - 1 do
				if attacker == killedUnit:GetAttacker( i ) then
					attacker:AddExperience( 25, 0, false, false )
				end
			end
		end
		if killedUnit:GetRespawnTime() > 10 then
			if killedUnit:IsReincarnating() == true then
				return nil
			else
				ComicsVsAnime:SetRespawnTime( killedTeam, killedUnit, extraTime )
			end
		else
			ComicsVsAnime:SetRespawnTime( killedTeam, killedUnit, extraTime )
		end
	end
end

function ComicsVsAnime:SetRespawnTime( killedTeam, killedUnit, extraTime )
	if killedTeam == self.leadingTeam and self.isGameTied == false then
		killedUnit:SetTimeUntilRespawn( 20 + extraTime )
	else
		killedUnit:SetTimeUntilRespawn( 10 + extraTime )
	end
end

function ComicsVsAnime:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	gold = GOLD_MONETKA
		if owner:HasModifier("modifier_razrab") then
			gold = gold + 80000
		end
		if owner:GetTeamNumber() == self.leadingTeam then
			gold = GOLD_MONETKA - LEADER_GOLD	
		end	
		if owner:HasModifier("modifier_gold_bonusx100") then
			gold = gold + GOLD_BONUS_EVENT
		end
	if event.itemname == "item_bag_of_gold" then
		ComicsVsAnimeGold(gold,owner:GetPlayerID(),owner,true,PlayerResource)
		UTIL_Remove( item ) 
	elseif event.itemname == "item_treasure_chest" then
		DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Stop", "0", 0, self, self )
		ComicsVsAnime:SpecialItemAdd( event )
		UTIL_Remove( item )
	end
	
	if event.itemname == "item_event_rezhim" then
		local dur = DUR_EFFECTS
	local modifiers_event = MODIFIERS_EVENT
		self.mod_event = {}
		local mod = PickRandomShuffle( modifiers_event, self.mod_event )
		owner:AddNewModifier( owner, nil, mod, {duration = dur})
		UTIL_Remove( item )
	end
end

function ComicsVsAnime:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )
	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		ComicsVsAnime:TreasureDrop( npc )
	end
end

