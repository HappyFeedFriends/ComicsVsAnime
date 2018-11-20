LinkLuaModifier("modifier_tower_tier1_1", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier1_1_buff", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
---------------------------------------------------------------
-- TOWER ABILITY 1
---------------------------------------------------------------
tower_tier_1_1 = class({})

function tower_tier_1_1:GetIntrinsicModifierName()
	return "modifier_tower_tier1_1"
end


modifier_tower_tier1_1 = class({})

function modifier_tower_tier1_1:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier1_1:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_1:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier1_1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier1_1:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier1_1:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier1_1:GetModifierAura()
	return "modifier_tower_tier1_1_buff"
end

function modifier_tower_tier1_1:IsAura()
	return true
end

function modifier_tower_tier1_1:IsDebuff()
	return false
end

function modifier_tower_tier1_1:IsHidden()
	return true
end
modifier_tower_tier1_1_buff = class({})

function modifier_tower_tier1_1_buff:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier1_1_buff:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_1_buff:IsHidden()
	return true
end

function modifier_tower_tier1_1_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}

	return decFuncs
end

function modifier_tower_tier1_1_buff:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_range")
end
---------------------------------------------------------------
-- TOWER ABILITY 2
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier1_2", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier1_2_buff", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
tower_tier_1_2 = class({})

function tower_tier_1_2:GetIntrinsicModifierName()
	return "modifier_tower_tier1_2"
end

modifier_tower_tier1_2 = class({})

function modifier_tower_tier1_2:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier1_2:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_2:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier1_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier1_2:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier1_2:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier1_2:GetModifierAura()
	return "modifier_tower_tier1_2_buff"
end

function modifier_tower_tier1_2:IsAura()
	return true
end

function modifier_tower_tier1_2:IsDebuff()
	return false
end

function modifier_tower_tier1_2:IsHidden()
	return true
end
modifier_tower_tier1_2_buff = class({})

function modifier_tower_tier1_2_buff:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier1_2_buff:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_2_buff:IsHidden()
	return true
end

function modifier_tower_tier1_2_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return decFuncs
end

function modifier_tower_tier1_2_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

---------------------------------------------------------------
-- TOWER ABILITY 3
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier1_3", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier1_3_buff", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
tower_tier_1_3 = class({})

function tower_tier_1_3:GetIntrinsicModifierName()
	return "modifier_tower_tier1_3"
end

modifier_tower_tier1_3 = class({})

function modifier_tower_tier1_3:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier1_3:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_3:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier1_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier1_3:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier1_3:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier1_3:GetModifierAura()
	return "modifier_tower_tier1_3_buff"
end

function modifier_tower_tier1_3:IsAura()
	return true
end

function modifier_tower_tier1_3:IsDebuff()
	return false
end

function modifier_tower_tier1_3:IsHidden()
	return true
end
modifier_tower_tier1_3_buff = class({})

function modifier_tower_tier1_3_buff:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier1_3_buff:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_3_buff:IsHidden()
	return false
end

function modifier_tower_tier1_3_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_tower_tier1_3_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end
---------------------------------------------------------------
-- TOWER ABILITY 4
---------------------------------------------------------------
LinkLuaModifier("modifier_tower_tier1_4", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier1_4_buff", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
tower_tier_1_4 = class({})

function tower_tier_1_4:GetIntrinsicModifierName()
	return "modifier_tower_tier1_4"
end

modifier_tower_tier1_4 = class({})

function modifier_tower_tier1_4:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier1_4:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_4:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier1_4:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier1_4:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier1_4:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier1_4:GetModifierAura()
	return "modifier_tower_tier1_4_buff"
end

function modifier_tower_tier1_4:IsAura()
	return true
end

function modifier_tower_tier1_4:IsDebuff()
	return false
end

function modifier_tower_tier1_4:IsHidden()
	return true
end
modifier_tower_tier1_4_buff = class({})

function modifier_tower_tier1_4_buff:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier1_4_buff:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier1_4_buff:IsHidden()
	return true
end

function modifier_tower_tier1_4_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}

	return decFuncs
end

function modifier_tower_tier1_4_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen_bonus")
end

function tower_tier_1_5(keys)
	if keys.ability:IsCooldownReady() then
		local caster = keys.caster
		local ability = keys.ability
		local modifier = "modifier_stunned"
		local radius = ability:GetSpecialValueFor("stunned_radius")
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
-- TOWER ABILITY 6
---------------------------------------------------------------
tower_tier_1_6 = class({})

LinkLuaModifier("modifier_tower_tier_1_6", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier_1_6_buff", "heroes/tower_ability/tower_ability_lvl1", LUA_MODIFIER_MOTION_NONE)

function tower_tier_1_6:GetIntrinsicModifierName()
	return "modifier_tower_tier_1_6"
end


modifier_tower_tier_1_6 = class({})

function modifier_tower_tier_1_6:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier_1_6:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_1_6:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier_1_6:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier_1_6:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier_1_6:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier_1_6:GetModifierAura()
	return "modifier_tower_tier_1_6_buff"
end

function modifier_tower_tier_1_6:IsAura()
	return true
end

function modifier_tower_tier_1_6:IsDebuff()
	return false
end

function modifier_tower_tier_1_6:IsHidden()
	return true
end
modifier_tower_tier_1_6_buff = class({})

function modifier_tower_tier_1_6_buff:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier_1_6_buff:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_1_6_buff:IsHidden()
	return true
end

function modifier_tower_tier_1_6_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_tower_tier_1_6_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end