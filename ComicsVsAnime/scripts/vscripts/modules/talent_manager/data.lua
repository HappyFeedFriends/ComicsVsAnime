
local delayed_add_talents_list = {}

local function PopulateGenericImbaTalentTableValues()
	CustomNetTables:SetTableValue("cva_talent_manager", "cva_talent_info", PASSIVED_TALENT_LIST)
end

local function GetHeroEndAbilityIndex(hero)
	local endAbilityIndex = (hero:GetAbilityCount()-1)
	while hero:GetAbilityByIndex(endAbilityIndex) == nil and endAbilityIndex >= 0 do
		endAbilityIndex = endAbilityIndex - 1
	end
	return endAbilityIndex
end

local function PopulateHeroTalentList(hero)
	local heroName = hero:GetUnitName()
	local endAbilityIndex = GetHeroEndAbilityIndex(hero)
	local talent_list = CUSTOM_TALENTS_LIST[heroName]
	if talent_list == nil then
		talent_list = CUSTOM_TALENTS_LIST["default"]
	end 
	local hero_talent_list = {}
	for i=0,NUM_UP_TABLE do
		local current_level = LEVEL_TABLE_TALENTS-(i*LVL_UP_TABLE)
		local inner_value = {}
		if i%2 == 0 then
			local areImbaTalents = false
			local currentAbilityIndex = (endAbilityIndex - i)
			local ability1 = hero:GetAbilityByIndex(currentAbilityIndex-1)
			if ability1 then
				local abilityName = ability1:GetAbilityName()
				if abilityName:find("special_bonus_") == 1 then
					areImbaTalents = true
				end
				if abilityName:find("special_bonus_") == 1 or abilityName:find("special_bonus_unique_") == 1 then
					inner_value[7] = abilityName
				end
			end
			local ability2 = hero:GetAbilityByIndex(currentAbilityIndex)
			if ability2 then
				local abilityName = ability2:GetAbilityName()
				if abilityName:find("special_bonus_") == 1 then
					areImbaTalents = true
				end

				if abilityName:find("special_bonus_") == 1 or abilityName:find("special_bonus_unique_") == 1 then
					inner_value[8] = abilityName
				end
			end
			if not areImbaTalents then
				for k,v in pairs(talent_list) do 
					inner_value[k] = v
				end
			end
		else
			inner_value = talent_list
		end
		hero_talent_list[current_level] = inner_value
	end

	CustomNetTables:SetTableValue( "cva_talent_manager", "hero_talent_list_"..hero:entindex(), hero_talent_list )
end

local function PopulateHeroTalentChoice(hero)
	local talent_choices = {}
	for i=0,NUM_UP_TABLE do
		local current_level = LEVEL_TABLE_TALENTS-(i*LVL_UP_TABLE)
		talent_choices[current_level] = -1
	end

	CustomNetTables:SetTableValue( "cva_talent_manager", "hero_talent_choice_"..hero:entindex(), talent_choices )
end

local function LinkAbilityWithTalent(compiled_list, ability_name, talent_name)
	local ability_list = compiled_list[talent_name]
	if ability_list == nil then
		ability_list = {}
	end

	local bol_found = false
	for _,v in pairs(ability_list) do
		if v == ability_name then
			bol_found = true
		end
	end

	if bol_found == false then
		table.insert(ability_list, ability_name)
		compiled_list[talent_name] = ability_list
	end
end

function PopulateHeroTalentLinkedAbilities(hero)
	local existing_table = CustomNetTables:GetTableValue( "cva_talent_manager", "talent_linked_abilities" )
	if existing_table == nil then
		existing_table = {}
	end

	local currentAbilityIndex = GetHeroEndAbilityIndex(hero)
	while currentAbilityIndex > 0 do
		local ability = hero:GetAbilityByIndex(currentAbilityIndex)
		if ability then
			local ability_values = ability:GetAbilityKeyValues()
			local ability_name = ability:GetAbilityName()
			if ability_name:find("special_bonus_") then
				if LINKEDABILITY[ability_name] then
					LinkAbilityWithTalent(existing_table, LINKEDABILITY[ability_name], ability_name)
				else
					for k,v in pairs(ability_values) do
						if k == "LinkedTalentManager" then
							for _,m in pairs(v) do
								LinkAbilityWithTalent(existing_table, m, ability_name)
							end
							break
						end
					end
				end
			else
				for k,v in pairs(ability_values) do
					if k == "AbilitySpecial" then
						for _,m in pairs(v) do
							local talentBonus = m["LinkedSpecialBonus"]
							if talentBonus ~= nil then
								LinkAbilityWithTalent(existing_table, ability_name, talentBonus)
							end
						end
						break
					end
				end
			end
		end
		currentAbilityIndex = currentAbilityIndex - 1
	end

	CustomNetTables:SetTableValue( "cva_talent_manager", "talent_linked_abilities", existing_table )
end

local function HasNotPopulatedValues(hero_id)
	return (CustomNetTables:GetTableValue( "cva_talent_manager", "hero_talent_list_"..hero_id) == nil)
end

function LoadingTalents(hero)
	if HasNotPopulatedValues(hero:entindex()) then
		PopulateHeroTalentChoice(hero)
		PopulateHeroTalentList(hero)
		PopulateHeroTalentLinkedAbilities(hero)
	end
end

function HandlePlayerUpgradeImbaTalent(unused, kv)
	local thisPlayerID = kv.PlayerID
	local heroID = kv.heroID
	local level = kv.level
	local index = kv.index
	local hero = EntIndexToHScript(heroID)
	if hero and IsValidEntity(hero) then
		local ownerPlayerID = hero:GetPlayerID()
		if ownerPlayerID == thisPlayerID or (PlayerResource:GetUnitShareMaskForPlayer(ownerPlayerID, thisPlayerID) % 2 == 1) then
			local hero_talent_list = CustomNetTables:GetTableValue( "cva_talent_manager", "hero_talent_list_"..heroID )
			local hero_talent_choices = CustomNetTables:GetTableValue( "cva_talent_manager", "hero_talent_choice_"..heroID )
			local currentUnspentAbilityPoints = hero:GetAbilityPoints()
			local level_key = tostring(level)
			if hero:GetLevel() >= level and(currentUnspentAbilityPoints > 0) and hero_talent_choices ~= nil and hero_talent_list ~= nil and (hero_talent_choices[level_key] ~= nil) and (hero_talent_list[level_key] ~= nil) and hero_talent_choices[level_key] <= 0 then
				local talent_name = hero_talent_list[level_key][tostring(index)]
				if talent_name ~= nil then
							-- 10 = 1, 20 = 2, 30 = 3, 40 = 4
					if string.find(talent_name, "cva_passived_talent") == 1 then
						local modifier_talent_name = "modifier_"..talent_name
						local modifier = hero:FindModifierByName(modifier_talent_name)
						if modifier ~= nil then
							return
						else
							modifier = hero:AddNewModifier(hero, nil, modifier_talent_name, {})
							if modifier == nil then
								local existing_list = delayed_add_talents_list[heroID]
								if existing_list == nil then
									existing_list = {}
								end

								existing_list[modifier_talent_name] = level

								delayed_add_talents_list[heroID] = existing_list
							else
								modifier:SetStackCount(1+(level-5)/5)
								modifier:ForceRefresh()
							end
						end
					else
						local ability = hero:FindAbilityByName(talent_name)
						if ability and ability:GetLevel() > 0 then
							return
						elseif ability then
							ability:SetLevel(1)
						end
					end
					hero_talent_choices[level_key] = index
					hero:SetAbilityPoints(currentUnspentAbilityPoints - 1)
					CustomNetTables:SetTableValue( "cva_talent_manager", "hero_talent_choice_"..heroID, hero_talent_choices )
				end
			end
		end
	end
end
 
function InitPlayerTalents()
	PopulateGenericImbaTalentTableValues()
	CustomGameEventManager:RegisterListener("upgrade_talents", HandlePlayerUpgradeImbaTalent)
end

function AddMissingGenericTalent(hero)

	local heroID = hero:GetEntityIndex()
	local existing_list = delayed_add_talents_list[heroID]
	if existing_list then
		for modifier_talent_name,level in pairs(existing_list) do
			local modifier = hero:AddNewModifier(hero, nil, modifier_talent_name, {})
			modifier:SetStackCount(1+(level-5)/5)
			modifier:ForceRefresh()
		end
		delayed_add_talents_list[heroID] = nil
	end
end