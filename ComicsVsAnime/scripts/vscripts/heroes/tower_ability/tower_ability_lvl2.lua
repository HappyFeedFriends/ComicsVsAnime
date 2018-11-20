---------------------------------------------------------------
-- TOWER ABILITY 1
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier_2_1", "heroes/tower_ability/tower_ability_lvl2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier_2_1_attack_speed", "heroes/tower_ability/tower_ability_lvl2", LUA_MODIFIER_MOTION_NONE)
tower_tier_2_1 = class({})

function tower_tier_2_1:GetIntrinsicModifierName()
	return "modifier_tower_tier_2_1"
end

function tower_tier_2_1:OnProjectileHit( hTarget, vLocation )
	local damage = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetAttackDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}
	ApplyDamage(damage)
end

modifier_tower_tier_2_1 = class({})

function modifier_tower_tier_2_1:IsHidden()
	return true
end

function modifier_tower_tier_2_1:IsPurgable()
	return true
end

function modifier_tower_tier_2_1:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return decFuncs
end

function modifier_tower_tier_2_1:OnAttack(params)
	if params.attacker == self:GetParent() and IsServer() then
		local dur = self:GetAbility():GetSpecialValueFor("bonus_attack_dur")
		ComicsVsAnimeAddStack(self:GetParent(), self:GetAbility(),1, 1, "modifier_tower_tier_2_1_attack_speed", dur, false, true,true,true)
		self:GetParent():ComicsVsAnimeSplitShot(self:GetAbility(),900,self:GetAbility():GetSpecialValueFor("split_targets"))
	end
end

modifier_tower_tier_2_1_attack_speed = class({})

function modifier_tower_tier_2_1_attack_speed:IsHidden()
	return false
end

function modifier_tower_tier_2_1_attack_speed:IsPurgable()
	return true
end

function modifier_tower_tier_2_1_attack_speed:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return decFuncs
end

function modifier_tower_tier_2_1_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * self:GetStackCount()
end	
---------------------------------------------------------------
-- TOWER ABILITY 2
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier_2_2", "heroes/tower_ability/tower_ability_lvl2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier_2_2_mana_burn", "heroes/tower_ability/tower_ability_lvl2", LUA_MODIFIER_MOTION_NONE)
if tower_tier_2_2 == nil then
	tower_tier_2_2 = class({})
end

function tower_tier_2_2:GetIntrinsicModifierName()
	return "modifier_tower_tier_2_2"
end

modifier_tower_tier_2_2 = class({})

function modifier_tower_tier_2_2:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier_2_2:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_2_2:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier_2_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier_2_2:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier_2_2:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier_2_2:GetModifierAura()
	return "modifier_tower_tier_2_2_mana_burn"
end

function modifier_tower_tier_2_2:IsAura()
	return true
end

function modifier_tower_tier_2_2:IsDebuff()
	return false
end

function modifier_tower_tier_2_2:IsHidden()
	return true
end

if modifier_tower_tier_2_2_mana_burn == nil then
	modifier_tower_tier_2_2_mana_burn = class({})
end

function modifier_tower_tier_2_2_mana_burn:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier_2_2_mana_burn:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_2_2_mana_burn:IsHidden()
	return true
end

function modifier_tower_tier_2_2_mana_burn:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}

	return decFuncs
end

function modifier_tower_tier_2_2_mana_burn:GetModifierConstantManaRegen()
	return (self:GetParent():GetMaxMana()/100 * self:GetAbility():GetSpecialValueFor("mana_steal")) * (-1)
end
	
---------------------------------------------------------------
-- TOWER ABILITY 3
---------------------------------------------------------------

function tower_tier_2_3(keys)
	if keys.ability:IsCooldownReady() then
		local caster = keys.caster
		local ability = keys.ability
		local modifier_root = "modifier_tower_tier_2_3_root"
		local radius = ability:GetSpecialValueFor("root_radius")
		local min_creep = ability:GetSpecialValueFor("min_creeps")
		local dur 
		local unites = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),nil,radius,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		if #unites > 0 then
			for _,enemy in pairs(unites) do
				if enemy:IsCreep() and 	#enemy >= min_creep then
					dur = ability:GetSpecialValueFor("duration_creep")
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {duration = dur})
					ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
				end
				if enemy:IsHero() then
					dur = ability:GetSpecialValueFor("duration_hero")
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {duration = dur})
					ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
				end
			end
		end
	end
end

---------------------------------------------------------------
-- TOWER ABILITY 4
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier_2_4_hexed", "heroes/tower_ability/tower_ability_lvl2", LUA_MODIFIER_MOTION_NONE)
modifier_tower_tier_2_4_hexed = class({})

function modifier_tower_tier_2_4_hexed:IsHidden()
	return false 
end

function modifier_tower_tier_2_4_hexed:IsPurgable() 
	return false
end

function modifier_tower_tier_2_4_hexed:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE,MODIFIER_PROPERTY_MOVESPEED_LIMIT,MODIFIER_PROPERTY_MOVESPEED_MAX}
end

function modifier_tower_tier_2_4_hexed:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_tower_tier_2_4_hexed:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end	

function modifier_tower_tier_2_4_hexed:GetModifierModelChange()
	return "models/courier/navi_courier/navi_courier.vmdl"
end

function tower_tier_2_4(keys)
	if keys.ability:IsCooldownReady() then
		local caster = keys.caster
		local ability = keys.ability
		local modifier = "modifier_tower_tier_2_4_hexed"
		local radius = ability:GetSpecialValueFor("hexed_radius")
		local dur 
		local unites = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),nil,radius,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(unites) do
			if enemy:IsCreep() then
				dur = ability:GetSpecialValueFor("duration_creep")
				enemy:AddNewModifier(caster,ability,modifier,{duration = dur })
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			end
			if enemy:IsHero() then
				dur = ability:GetSpecialValueFor("duration_hero")
				enemy:AddNewModifier(caster,ability,modifier,{duration = dur })
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			end
		end
	end
end

---------------------------------------------------------------
-- TOWER ABILITY 5
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier_2_5_silenced", "heroes/tower_ability/tower_ability_lvl2", LUA_MODIFIER_MOTION_NONE)
modifier_tower_tier_2_5_silenced = class({})

function modifier_tower_tier_2_5_silenced:IsHidden()
	return false 
end

function modifier_tower_tier_2_5_silenced:IsPurgable() 
	return false
end

function modifier_tower_tier_2_5_silenced:OnCreated()
	self.particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_silence_2_purple_mask.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
end

function modifier_tower_tier_2_5_silenced:OnDestroy()
  ParticleManager:DestroyParticle(self.particle, true)
  ParticleManager:ReleaseParticleIndex( self.particle )
end 

function modifier_tower_tier_2_5_silenced:CheckState()
    local state = {
    [MODIFIER_STATE_SILENCED] = true,
    }

    return state
end	

function tower_tier_2_5(keys)
	if keys.ability:IsCooldownReady() then
		local caster = keys.caster
		local ability = keys.ability
		local modifier = "modifier_tower_tier_2_5_silenced"
		local radius = ability:GetSpecialValueFor("silence_radius")
		local dur 
		local unites = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),nil,radius,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(unites) do
			dur = ability:GetSpecialValueFor("duration_hero")
			enemy:AddNewModifier(caster,ability,modifier,{duration = dur })
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end

function tower_tier_2_6(keys)
	if keys.ability:IsCooldownReady() then
		local caster = keys.caster
		local ability = keys.ability
		local radius = ability:GetSpecialValueFor("radius")
		local unites = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),nil,radius,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		local killed = false
		for _,enemy in pairs(unites) do
			if enemy:IsIllusion() then
				 ComicsVsAnimeKill(caster, enemy, ability)
				 killed = true
			end
		end	
		if killed then
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end