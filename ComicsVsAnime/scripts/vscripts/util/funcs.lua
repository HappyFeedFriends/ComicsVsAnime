														-----------------------------------
														--|	 Comics Vs Anime Functions	|--
														-----------------------------------
--[[
	AUTHOR: HAPPYFEEDFRIENDS
	CUSTOM GAMES: COMICS VS ANIME
	DATE CREATED: 10.06.2018
	DATE OF LAST UPDATE: 08.07.2018
]]	

function ChangeAttacksComicsVsAnime(unit)
	local particle_modifier_first_bullet_aleph = "particles/kurumi/comics_vs_anime_kurumi_first_bullet_aleph.vpcf"
	local particle_modifier_second_bullet = "particles/kurumi/comics_vs_anime_kurumi_second_bullet.vpcf"
	local particle_modifier_seventh_bullet_zayin = "particles/kurumi/comics_vs_anime_kurumi_seventh_bullet_zayin.vpcf"
	if unit:HasModifier("modifier_first_bullet_aleph") then
		unit:SetRangedProjectileName(particle_modifier_first_bullet_aleph)
	elseif unit:HasModifier("modifier_second_bullet") then
		unit:SetRangedProjectileName(particle_modifier_second_bullet)
	elseif unit:HasModifier("modifier_seventh_bullet_zayin") then	
		unit:SetRangedProjectileName(particle_modifier_seventh_bullet_zayin)
	else
		unit:SetRangedProjectileName(unit:GetKeyValue("ProjectileModel"))	
	end
end

function ComicsVsAnimeMultDamageWater(unites)
	if unites ~= nil then
		local origin_light = 10
		if GetMapName() == "mines_trio" then
			origin_light = -2000
		end
		if unites:GetAbsOrigin().z <= origin_light then
			return true
		else
			return false
		end
	end	
end

function ComicsVsAnimeModelScale(start, ends, timing)
    return (1-timing)*start + timing*ends
end

function CDOTA_BaseNPC:ComicsVsAnimeHasTalent(talentName)
	if self:FindAbilityByName(talentName) and self:FindAbilityByName(talentName):GetLevel() > 0 then
		return true
	else
		return false
	end	
end

function TooltipCustomDamage(damage,victim,types)
	if damage > 0 then
		local a,b
		if types == "MAGIC" then
			a = Vector( 108, 211, 246 )
		elseif types == "SPIRITUAL" then
			a = Vector( 245, 236, 72 )
		elseif types == "DAMAGE_TYPE_ELECTRICAL" then
			a = Vector( 44, 213, 214 )
		end
			local dmg = string.len( math.floor( damage ) ) + 1
			local particle = ParticleManager:CreateParticle( "particles/other/comics_vs_anime_magic_critical_numbers.vpcf", PATTACH_POINT_FOLLOW, victim)
			ParticleManager:SetParticleControl( particle, 0, Vector( 40, 0, 75 ) )
			ParticleManager:SetParticleControl( particle, 1, Vector( 0, damage, 4 ) )
			ParticleManager:SetParticleControl( particle, 2, Vector( 1, dmg, 1 ) )
			ParticleManager:SetParticleControl( particle, 3, a )
	end		
end

function ComicsVsAnimeKill(caster, target, ability)
	target:Kill(ability, caster)
	for k,v in pairs (SPISOK_REMOVE_MODIFIER) do
		if target:HasModifier(v) then
			target:RemoveModifierByName(v)
		end	
	end
	if target:IsAlive() then
		target:Kill(ability, caster)
	end	
end

function CDOTA_BaseNPC:ComicsVsAnimeBackHero()
	local victim_angle = self:GetAnglesAsVector()
	local victim_angle_rad = victim_angle.y * math.pi/180
	local victim_position = self:GetAbsOrigin()
	local new_position = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
	return new_position
end

function CDOTA_BaseNPC:ComicsVsAnimeMana(mana,t,d)
	if mana == nil then
		mana = 0
	end
	
	if d == nil then
		d = true
	end
	
	if t == 1 then
		self:SetMana(self:GetMana() + mana)
	elseif t == 2 then
		self:SetMana(self:GetMana() - mana)
	elseif t == 3 then	
		self:SetMana(self:GetMana() * mana)
	elseif t == 4 then
		self:SetMana(self:GetMana() / mana)
	end	
	if d == true then
		SendOverheadEventMessage( self, OVERHEAD_ALERT_MANA_ADD , self, mana, nil )
	elseif d == false then
		SendOverheadEventMessage( self, OVERHEAD_ALERT_MANA_LOSS , self, mana, nil )
	end
	return self
end

function CDOTA_BaseNPC:ComicsVsAnimeTalent(talentName,value,values)
	if self:FindAbilityByName(talentName) and self:FindAbilityByName(talentName):GetLevel() > 0 then
		if value ~= nil then
			return value
		elseif values ~= nil then
			return self:FindAbilityByName(talentName):GetSpecialValueFor(values)		
		elseif value == nil and self:FindAbilityByName(talentName):GetSpecialValueFor("value") ~= nil then
			return self:FindAbilityByName(talentName):GetSpecialValueFor("value") 
		end
	end
	return false
end

function CDOTA_BaseNPC:HasTalent(talentName)
	if self:HasAbility(talentName) and self:FindAbilityByName(talentName):GetLevel() > 0 then return true end
	return false
end

function CDOTA_BaseNPC:FindTalentValue(talentName, value)
	if self:HasAbility(talentName) then
		local value_name = value or "value"
		return self:FindAbilityByName(talentName):GetSpecialValueFor(value_name)
	end
	return 0
end
function CDOTA_BaseNPC:BonusTalentValue(talentName,start_value,value)
	if self:HasTalent(talentName) then
		return start_value + self:FindTalentValue(talentName, value)
	end 
	return start_value
end

function ComicsVsAnimeHeal(heal,target)
	target:Heal(heal,nil)
	SendOverheadEventMessage( target, OVERHEAD_ALERT_HEAL, target, heal, nil )
end

function ComicsVsAnimeGold(Gold,target,overhead,lua,modify,activity)
	if Gold == nil then
		Gold = 0
	end
	if activity == nil then
		activity = true
	end	
	if lua == true and modify ~= nil then
		modify:ModifyGold( target, Gold, true, 0 )
	else
		target:ModifyGold( Gold,true,0 )
		overhead = target
	end	
	if activity == true then
		SendOverheadEventMessage( overhead, OVERHEAD_ALERT_GOLD , overhead, Gold, nil )
	end
end

function ComicsVsAnimeXp(Xp,target,overhead,modify,activity)
	if Xp == nil then
		Xp = 0
	end
	if activity == nil then
		activity = true
	end	
	if modify == nil then
		modify = target
	end
		target:AddExperience( Xp,0,false,false )
		overhead = target
	if activity == true then
		SendOverheadEventMessage( overhead, OVERHEAD_ALERT_XP , overhead, Xp, nil )
	end
end

function HasDamageFlag(damage_flags, flag)
	return bit.band(damage_flags, flag) == flag
end

function ComicsVsAnimeReflect(victim, attacker, damage, flags, ability, damage_type)
	if victim:IsAlive() and not HasDamageFlag(flags, DOTA_DAMAGE_FLAG_REFLECTION) and attacker:GetTeamNumber() ~= victim:GetTeamNumber() then
		ApplyDamage({
			victim = attacker,
			attacker = victim,
			damage = damage,
			damage_type = damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
			ability = ability
		})
		return true
	end
	return false
end

function ComicsVsAnimeCreateIllusion(unit, ability, num_illusion, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration, item, abilities,random_vector,radius_vector,controll)
	if controll == nil then
		controll = true
	end	
	local caster = unit
	local player = caster:GetPlayerID()
	local unit_name = caster:GetUnitName()
	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()
	caster:Stop()
	if not caster.illusion then
		caster.illusion = {}
	end
	for k,v in pairs(caster.illusion) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end
	caster.illusion = {}
	for i=1, num_illusion do
		if random_vector == true then
			casterOrigin = casterOrigin + RandomVector( RandomFloat( 0, radius_vector ) )
		end
		local illusion = CreateUnitByName(unit_name, casterOrigin, true, caster, nil, caster:GetTeamNumber())
		illusion:SetPlayerID(caster:GetPlayerID())
		if controll then
			illusion:SetControllableByPlayer(player, true)
		end

		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		
		local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp(false)
		end
			if abilities == true then
				illusion:SetAbilityPoints(0)
				for abilitySlot=0,15 do
					local ability = caster:GetAbilityByIndex(abilitySlot)
					if ability ~= nil then 
						local abilityLevel = ability:GetLevel()
						local abilityName = ability:GetAbilityName()
						local illusionAbility = illusion:FindAbilityByName(abilityName)
						illusionAbility:SetLevel(abilityLevel)
					end
				end
			end
			if items == true then	
				for itemSlot=0,6 do
					local item = caster:GetItemInSlot(itemSlot)
					if item ~= nil then
						local itemName = item:GetName()
						if not (itemName == "item_courier" or itemName == "item_tpscroll") then
							local newItem = CreateItem(itemName, illusion, illusion)
							illusion:AddItem(newItem)
						end
					end
				end
			end	

		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage })
		illusion:MakeIllusion()
		illusion:SetHealth(caster:GetHealth())
		table.insert(caster.illusion, illusion)
	end
end

function ComicsVsAnimeAddStack(unit, ability,start_stack, num_stack, modifier, dur, DataDriven, Lua,HasModify,update_stack)
	if start_stack == nil then
		start_stack = 1
	end
	if num_stack == nil then
		num_stack = 1
	end	
	if update_stack == nil then
		update_stack = true
	end	
	if Lua == true and Datadriven == false or Datadriven == nil and  HasModify == true then
		if unit:HasModifier(modifier) then
		local current_stack = unit:GetModifierStackCount( modifier, ability )
			if update_stack == true then
				unit:AddNewModifier(unit, ability,modifier,{duration = dur})
			end
			unit:SetModifierStackCount( modifier, ability, current_stack + num_stack )
		else
			unit:AddNewModifier(unit, ability,modifier,{duration = dur})
			unit:SetModifierStackCount( modifier, ability, start_stack )
		end	
	elseif Datadriven == true and Lua == false or Lua == nil and  HasModify == true then
		if unit:HasModifier(modifier) then
			local current_stack = unit:GetModifierStackCount( modifier, ability )
			if update_stack == true then
				ability:ApplyDataDrivenModifier(unit, unit,modifier,{duration = dur})
			end
			unit:SetModifierStackCount( modifier, ability, current_stack + num_stack )
		else
			ability:ApplyDataDrivenModifier(unit, unit,modifier,{duration = dur})
			unit:SetModifierStackCount( modifier, ability, start_stack )
		end
	end	
	
	if Lua == true and Datadriven == false or Datadriven == nil and  HasModify == false then
			unit:AddNewModifier(unit, ability,modifier,{duration = dur})
			unit:SetModifierStackCount( modifier, ability, num_stack )
	elseif Datadriven == true and Lua == false or Lua == nil and  HasModify == false then
			ability:ApplyDataDrivenModifier(unit, unit,modifier,{duration = dur})
			unit:SetModifierStackCount( modifier, ability, num_stack )
	end
	
end

function CDOTA_BaseNPC:AddStackModifier(ability,modifier,dur,start_stack,num_stack,lua,update_time)
	start_stack = start_stack or 1
	num_stack = num_stack or 1
	if update_time == nil then update_time = true end	
	if lua == nil then lua = true end
	
	if lua == true then
		self:AddStackLua(ability,modifier,dur,start_stack,num_stack,update_time)
	else
		self:AddStackDataDriven(ability,modifier,dur,start_stack,num_stack,update_time)
	end	
end

function CDOTA_BaseNPC:AddStackDataDriven(ability,modifier,dur,start_stack,num_stack,update_time)
	if self:HasModifier(modifier) then
		if update_time then
			ability:ApplyDataDrivenModifier(self, self,modifier,{duration = dur})
		end	
		local current_stack = self:GetModifierStackCount( modifier, ability )
		self:SetModifierStackCount( modifier, ability, current_stack + num_stack )
	else
		ability:ApplyDataDrivenModifier(self, self,modifier,{duration = dur})
		self:SetModifierStackCount( modifier, ability, start_stack )
	end	
end

function CDOTA_BaseNPC:AddStackLua(ability,modifier,dur,start_stack,num_stack,update_time)
	if self:HasModifier(modifier) then
		if update_time then
			self:AddNewModifier(self, ability,modifier,{duration = dur })
		end	
		local current_stack = self:GetModifierStackCount( modifier, ability )
		self:SetModifierStackCount( modifier, ability, current_stack + num_stack )
	else
		self:AddNewModifier(self, ability,modifier,{duration = dur })
		self:SetModifierStackCount( modifier, ability, start_stack )
	end	
end

function ComicsVsAnimeCharges(unit, ability, max_charges, start_charges, cooldown, modifier) 
max_charges = max_charges or 1
start_charges = start_charges or max_charges or  1
cooldown = cooldown or 1
modifier = modifier or "modifier_charges"
	unit:AddNewModifier(unit, unit:FindAbilityByName(ability), modifier, {max_count = max_charges, start_count = start_charges, cooldown = cooldown})
end

if not KeyValues then
	KeyValues = {}
end

LOAD_BASE_FILES = false

function LoadGameKeyValues()
	local scriptPath ="scripts/npc/"
	local files = {
		AbilityKV = {base="npc_abilities",custom="npc_abilities_custom"},
		ItemKV = {base="items",custom="npc_items_custom"},
		UnitKV = {base="npc_units",custom="npc_units"},
		HeroKV = {base="npc_heroes",custom="npc_heroes_custom"},
		HeroKV2 = {base="",custom="npc_heroes"}
	}

	for k,v in pairs(files) do
		local file = {}
		if LOAD_BASE_FILES then
			file = LoadKeyValues(scriptPath..v.base..".txt")
		end

		local custom_file = LoadKeyValues(scriptPath..v.custom..".txt")
		if custom_file then
			for k,v in pairs(custom_file) do
				file[k] = v
			end
		else
			print("[KeyValues] Critical Error on "..v.custom..".txt")
			return
		end
		
		GameRules[k] = file
		KeyValues[k] = file
	end   

	KeyValues.All = {}
	for name,path in pairs(files) do
		for key,value in pairs(KeyValues[name]) do
			if not KeyValues.All[key] then
				KeyValues.All[key] = value
			end
		end
	end
	for key,value in pairs(KeyValues.HeroKV) do
		if not KeyValues.UnitKV[key] then
			KeyValues.UnitKV[key] = value
		else
			if type(KeyValues.All[key]) == "table" then
				print("[KeyValues] Warning: Duplicated unit/hero entry for "..key)
			end
		end
	end

	for key,value in pairs(KeyValues.HeroKV2) do
		if not KeyValues.UnitKV[key] then
			KeyValues.UnitKV[key] = value
		else
			if type(KeyValues.All[key]) == "table" then
			end
		end
	end
end

function GetKeyValue(name, key, level, tbl)
	local t = tbl or KeyValues.All[name]
	if key and t then
		if t[key] and level then
			local s = split(t[key])
			if s[level] then return tonumber(s[level]) or s[level]
			else return tonumber(s[#s]) or s[#s] end
		else return t[key] end
	else return t end
end

function CDOTA_BaseNPC:GetKeyValue(key, level)
	if level then return GetUnitKV(self:GetUnitName(), key, level)
	else return GetUnitKV(self:GetUnitName(), key) end
end

function GetKeyValueByHeroName(hero_name, key)
	if level then return GetUnitKV(hero_name, key, level)
	else return GetUnitKV(hero_name, key) end
end

function CDOTABaseAbility:GetKeyValue(key, level)
	if level then return GetAbilityKV(self:GetAbilityName(), key, level)
	else return GetAbilityKV(self:GetAbilityName(), key) end
end

function CDOTA_Item:GetKeyValue(key, level)
	if level then return GetItemKV(self:GetAbilityName(), key, level)
	else return GetItemKV(self:GetAbilityName(), key) end
end

function CDOTABaseAbility:GetAbilitySpecial(key)
	return GetAbilitySpecial(self:GetAbilityName(), key, self:GetLevel())
end

function GetUnitKV(unitName, key, level)
	return GetKeyValue(unitName, key, level, KeyValues.UnitKV[unitName])
end

function GetAbilityKV(abilityName, key, level)
	return GetKeyValue(abilityName, key, level, KeyValues.AbilityKV[abilityName])
end

function GetItemKV(itemName, key, level)
	return GetKeyValue(itemName, key, level, KeyValues.ItemKV[itemName])
end


function CDOTA_BaseNPC:ComicsVsAnimeSplitShot(ability,radius,max_targets)
	local split_shot_targets = FindUnitsInRadius(
		self:GetTeam(), 
		self:GetAbsOrigin(), 
		nil,
		radius,
		ability:GetAbilityTargetTeam(), 
		ability:GetAbilityTargetType(),
		ability:GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false)
	for _,v in pairs(split_shot_targets) do
		if v ~= self:GetAttackTarget() and max_targets ~= 0 then
			local projectile_info = 
			{
				EffectName = self:GetKeyValue("ProjectileModel"),
				Ability = ability,
				vSpawnOrigin = self:GetAbsOrigin(),
				Target = v,
				Source = self,
				bHasFrontalCone = false,
				iMoveSpeed = self:GetProjectileSpeed(),
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
	end
end

--[[function ComicsVsAnimePreformAbilityPrecastActions(unit, ability)
	if ability:IsCooldownReady() and ability:IsOwnersManaEnough() then
		ability:PayManaCost()
		ability:AutoStartCooldown()
		--ability:UseResources(true, true, true) -- not works with items?
		return true
	end
	return false
end]]

function CDOTA_BaseNPC:ComicsVsAnimeSplitShotDamage(target,ability,damage_type)
	if damage_type == nil then
		damage_type = DAMAGE_TYPE_PHYSICAL
	end	
		local damage = {
			victim = target,
			attacker = self,
			damage = self:GetAttackDamage(),
			damage_type = damage_type,
			ability = ability
		}
		ApplyDamage(damage)
end

function CDOTABaseAbility:ComicsVsAnimeItemDrop(caster)
	local itemName = tostring(self:GetAbilityName())
	if caster:IsHero() or caster:HasInventory() then
		local newItem = CreateItem(itemName, nil, nil)
		CreateItemOnPositionSync(caster:GetOrigin(), newItem)
		caster:RemoveItem(self)
	end
end

function CDOTABaseAbility:ComicsVsAnimeBlink(caster,range,effect,effect_end,delay)
	local origin_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()

	local distance = (target_point - origin_point):Length2D()
	ProjectileManager:ProjectileDodge(caster)
	if effect ~= nil then
		local blink_pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(blink_pfx)
	end
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	if distance > range then
		target_point = origin_point + (target_point - origin_point):Normalized() * range
		Timers:CreateTimer(delay, function()
			caster:SetAbsOrigin(target_point)
			FindClearSpaceForUnit(caster, target_point, true)
			if effect_end ~= nil then
				local blink_end_pfx = ParticleManager:CreateParticle(effect_end, PATTACH_ABSORIGIN, caster)
				ParticleManager:ReleaseParticleIndex(blink_end_pfx)
			end
		end)
	else
		Timers:CreateTimer(delay, function()
			caster:SetAbsOrigin(target_point)
			FindClearSpaceForUnit(caster, target_point, true)
			if effect_end ~= nil then
				local blink_end_pfx = ParticleManager:CreateParticle(effect_end, PATTACH_ABSORIGIN, caster)
				ParticleManager:ReleaseParticleIndex(blink_end_pfx)
			end
		end)
	end
end

function ComicsVsAnimeReductionArmor(armor)
	local m = 0.06 * armor
	return 100 * (1 - m/(1+math.abs(m)))
end

function RandomFromTable(table)
	local array = {}
	local n = 0
	for _,v in pairs(table) do
		array[#array+1] = v
		n = n + 1
	end

	if n == 0 then return nil end

	return array[RandomInt(1,n)]
end

function GetRandomTowerAbility(tier, ability_table)

	local ability = RandomFromTable(ability_table[tier])	

	return ability
end

function IndexAllTowerAbilities()
	local ability_table = {}
	local tier_one_abilities = {}
	local tier_two_abilities = {}
	local tier_three_abilities = {}
	local tier_four_abilities = {}
	for _,tier in pairs(TOWER_ABILITIES) do		
		for _,ability in pairs(tier) do
			if tier == TOWER_ABILITIES.tier_one then
				table.insert(tier_one_abilities, ability.ability_name)
			elseif tier == TOWER_ABILITIES.tier_two then
				table.insert(tier_two_abilities, ability.ability_name)
			elseif tier == TOWER_ABILITIES.tier_three then
				table.insert(tier_three_abilities, ability.ability_name)
			else
				table.insert(tier_four_abilities, ability.ability_name)
			end			
		end
	end

	table.insert(ability_table, tier_one_abilities)
	table.insert(ability_table, tier_two_abilities)
	table.insert(ability_table, tier_three_abilities)
	table.insert(ability_table, tier_four_abilities)

	return ability_table
end

function RemoveWearables( hero )
	hero.hiddenWearables = {} 
	local model = hero:FirstMoveChild()
	while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" or model:GetClassname() == "prop_dynamic" then
			model:AddEffects(EF_NODRAW) 
			table.insert(hero.hiddenWearables, model)
		end
		model = model:NextMovePeer()
	end
end

function RemoveAbilityWithModifiers(unit, ability)
	for _,v in ipairs(unit:FindAllModifiers()) do
		if v:GetAbility() == ability then
			v:Destroy()
		end
	end
end

function GetPlayersInTeam(team)
	local players = {}
	for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1  do
		if PlayerResource:IsValidPlayerID(playerID) and (not team or PlayerResource:GetTeam(playerID) == team) then
			table.insert(players, playerID)
		end
	end
	return players
end

function CDOTA_BaseNPC:IsBosses()
	if self.GetUnitName ~= nil and string.find(self:GetUnitName(), "npc_ComicsVsAnime_boss") ~= nil then
		return true
	else
		return false
	end	
end

function GetTableNum(table)
	if not table then 
		return nil 
	end
	local t = 0
	for _,_ in pairs(table) do
		t = t+1
	end

	return t
end	

function CDOTA_BaseNPC:CreateDropBoss(itemName, pos)
   	local newItem = CreateItem(itemName, nil, nil)
	CreateItemOnPositionSync(self:GetOrigin(), newItem)
   	--[[Timers:CreateTimer({
          endTime = 60,
          callback = function()
		if newItem and IsValidEntity(newItem) then
			if not newItem:GetOwnerEntity() then 
				UTIL_Remove(newItem)
			end
		end
			return nil
     end})]]
end

function ComicsVsAnimeRandomDrop(table)
	if not table then 
		return nil
	end
	local r, r2

	r = RandomInt(1, GetTableNum(table))
	r2 = 1
	for i, items in pairs(table) do
		if items  then
			if RollPercentage(items[1]) and r2 == r then
				return i
			end
		end
		r2 = r2 + 1
	end
end

function SearchItems(unit)
	for i = 0, DOTA_ITEM_SLOT_9 or DOTA_STASH_SLOT_6 do
		local current_item = unit:GetItemInSlot(i)
		if not current_item then
			unit:AddItemByName("item_dummy")
		end
	end
end

function ClearDummy(unit)
	for i = 0, DOTA_ITEM_SLOT_9 or DOTA_STASH_SLOT_6 do
		local current_item = unit:GetItemInSlot(i)
		if current_item and current_item:GetAbilityName() == "item_dummy" then
			unit:RemoveItem(current_item)
			UTIL_Remove(current_item)
		end
	end
end

function CDOTA_BaseNPC:SwapItems(item, newItem)
	SearchItems(self)
	if self:HasItemInInventory(item:GetName()) then
		self:RemoveItem(item)
		self:AddItem(CreateItem(newItem, self, self))
	end

	ClearDummy(self)
end

function CDOTA_BaseNPC:SwapAbility(ability1,ability2)
	self:AddAbility(ability2)
	self:SwapAbilities( ability1, ability2, false, true )
	self:RemoveAbility(ability1)
end

function CDOTA_BaseNPC:BonusCustomResistance(resistance,value)
	local resist = self:GetResistance(resistance)
	self:AddResistance(resistance, value)
	print('[DamageSystem] Update Resistance: ', resistance, ' | ', resist.."%", ' ==> ', self:GetResistance(resistance).."%")
end

function CDOTA_BaseNPC:BonusBlockResistance(resistance,value)
	local block = self:GetBlockedDamage(resistance)
	self:BlockedDamage(resistance, value)
	print('[DamageSystem] Update Blocked: ', resistance, ' | ', block, ' ==> ', self:GetBlockedDamage(resistance))
end

function CheckDistance(caster_pos,target_pos)
	return (caster_pos - target_pos):Length2D()
end 

function math.round(x)
	if x%2 ~= 0.5 then
		return math.floor(x+0.5)
	end
	return x-0.5
end

function IsDev(playerId)
	if PlayerResource:GetSteamAccountID(playerId) == 311310226 then
		return true
	end
	return false
end 

function CommandsGold(hero,gold)
	PlayerResource:ModifyGold( hero, gold, true, 0 )
end 

function CommandsGiveItems(items,hero)	
	for k,v in pairs(DOTA_ITEMS) do
		if string.find(items,"recipe") and string.find(k,items) then
			hero:AddItem(CreateItem(k, hero, hero))
			return true
		elseif not string.find(k,"recipe") and string.find(k,items) then
			hero:AddItem(CreateItem(k, hero, hero))
			return true
		end	
	end	
	for k,v in pairs(CUSTOM_ITEMS) do
		if string.find(items,"recipe") and string.find(k,items) then
			hero:AddItem(CreateItem(k, hero, hero))
			return true
		elseif not string.find(k,"recipe") and string.find(k,items) then
			hero:AddItem(CreateItem(k, hero, hero))
			return true
		end	
	end 
end

function CommandsModifyStats(stats,hero)
	hero:ModifyAgility(stats)
	hero:ModifyStrength(stats)
	hero:ModifyIntellect(stats)
end 

function CommandsCreateCreep(unit,hero)
local position = hero:GetAbsOrigin() + RandomVector( RandomFloat(0,200))	
	for units,v in pairs(UNITES_CUSTOM) do
		if string.find(units,unit) then
			local spawnedUnit = CreateUnitByName(units, position, true, hero, hero, hero:GetTeam())
			spawnedUnit:SetTeam(hero:GetTeam())
			spawnedUnit:SetControllableByPlayer(hero:GetPlayerID(), true)
			return true
		end		
	end		
	for units,v in pairs(UNITES_DOTA) do
		if string.find(units,unit) then
			local spawnedUnit = CreateUnitByName(units, position, true, hero, hero, hero:GetTeam())
			spawnedUnit:SetTeam(hero:GetTeam())
			spawnedUnit:SetControllableByPlayer(hero:GetPlayerID(), true)
			return true
		end		
	end 
end
function CommandsCreateHero(unit,player)
	for units,v in pairs(HEROES_CUSTOM) do
		if string.find(units,unit) then
			local hero = CreateHeroForPlayer(units, player)
			hero:SetTeam(player:GetTeam())
			hero:SetAbsOrigin(player:GetAbsOrigin())
			hero:SetControllableByPlayer(player:GetPlayerID(), true)
		end		
	end	 
end

function CommandsSwapHero(player_id, hero_entity)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local level = hero:GetLevel()
	PlayerResource:ReplaceHeroWith(player_id, hero_entity, hero:GetGold(), 0 )
	UTIL_Remove(hero)
	CommandsLevel(PlayerResource:GetSelectedHeroEntity(player_id),tonumber(level))
end

function CommandsLevel(hero,lvl)
	lvl = lvl or MAX_LEVEL
	for i = hero:GetLevel(), lvl do
		if XP_TABLE[hero:GetLevel()] and XP_TABLE[hero:GetLevel() + 1] then
			hero:AddExperience(XP_TABLE[hero:GetLevel() + 1] - XP_TABLE[hero:GetLevel()], 0, false, false)
		else
			break
		end
	end
end 

function CDOTA_BaseNPC:GetSpellLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.ComicsVsAnimeSpellLifeSteal then
			lifesteal = lifesteal + parent_modifier:ComicsVsAnimeSpellLifeSteal()
		end
	end
	return lifesteal
end

function CDOTA_BaseNPC:GetLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.ComicsVsAnimeAttackLifeSteal then
			lifesteal = lifesteal + parent_modifier:ComicsVsAnimeAttackLifeSteal()
		end
	end
	return lifesteal
end

function PrintTable(t, indent, done)
  if type(t) ~= "table" then 
	return 
  end

  done = done or {}
  done[t] = true
  indent = indent or 0
  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end
  table.sort(l)
	for k, v in ipairs(l) do
		if v ~= 'FDesc' then
		  local value = t[v]
			  if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..":")
				PrintTable (value, indent + 2, done)
			  elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			  else
				if t.FDesc and t.FDesc[v] then
				  print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
				else
				  print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				end
			end
		end
	end
end

function NetTablesUtil(key,table)
	if IsServer() then
		CustomNetTables:SetTableValue("util", key, {value=table})
	end
end 

function NetTablesUtilUse(key)
	return CustomNetTables:GetTableValue( "util", key ).value
end

function GetAllPlayersDataInfo()
    local Player = {}

    for i = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(i) then
            local data = 
			{
				steam_id = tostring(PlayerResource:GetSteamAccountID(i))
			}
			
				data.steam_id =
				{
					kills = PlayerResource:GetKills(i), 
					deaths = PlayerResource:GetDeaths(i), 
				}
            table.insert(Player, data)
        end
    end
    return Player
end
	
--[[function RequestNetwork()
    local data = {}
	data.player = GetAllPlayersDataInfo()
	local connection = CreateHTTPRequestScriptVM('POST', "http://u41943.onhh.ru/base_heroes")
	local player_data = CreateHTTPRequestScriptVM('POST', "http://u41943.onhh.ru/phpbb/player_Info.txt")
	local players_data = CreateHTTPRequestScriptVM('POST', "http://u41943.onhh.ru/phpbb/addRequest.php")
	local encoded_data = json.encode(data)
	players_data:SetHTTPRequestGetOrPostParameter('payload', encoded_data)
	players_data:Send(function(key)
		--key = json.decode(key["Body"])
		PrintTable(key["Body"])
		print(key["Body"])
	end)	
	player_data:Send(function(key)
		print(key["Body"])
	end)	
end]]

function FullAbility()
local info = {}
	for k,v in pairs(DOTA_ABILITY) do
		if k ~= "Version" then
		info[k] = v
		end
	end
	for k,v in pairs(CUSTOM_ABILITY) do
		if k ~= "Version" then
		info[k] = v
		end
	end
	return info
end

function AllAbilityGame()
	local ability_table = {}
	for k,v in pairs(DOTA_ABILITY) do
		if k ~= "Version" then
			table.insert(ability_table,k)
		end
	end
	for k,v in pairs(CUSTOM_ABILITY) do
		if k ~= "Version" then
			table.insert(ability_table,k)
		end 
	end
	return ability_table
end 

function FullItems()
local info = {}
	for k,v in pairs(CUSTOM_ITEMS) do
		if k ~= "Version" then
		info[k] = v
		end
	end
	for k,v in pairs(DOTA_ITEMS) do
		if k ~= "Version" then
		info[k] = v
		end
	end
	return info
end 

function AllItemsGame()
	local item_table = {}
	for k,v in pairs(CUSTOM_ITEMS) do
		if k ~= "Version" then
			table.insert(item_table,k)
		end
	end
	for k,v in pairs(DOTA_ITEMS) do
		if k ~= "Version" then
			table.insert(item_table,k)
		end
	end 
	return item_table
end

PLAYER_DATA = {[0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {}, [9] = {}, [10] = {}, [11] = {}, [12] = {}, [13] = {}, [14] = {}, [15] = {}, [16] = {}, [17] = {}, [18] = {}, [19] = {}, [20] = {}, [21] = {}, [22] = {}, [23] = {}}
LoadGameKeyValues()
print("[Functions] Loading Functions 100%")