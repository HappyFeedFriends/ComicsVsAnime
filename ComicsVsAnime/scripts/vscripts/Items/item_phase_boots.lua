item_phase_boots_1 = class({})
item_phase_boots_2 = class({})
item_phase_boots_3 = class({})
item_phase_boots_4 = class({})
LinkLuaModifier("modifier_phase_boots_custom", "items/item_phase_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phase_boots_custom_buff", "items/item_phase_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phase_boots_4_buff", "items/item_phase_boots", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------------------
-- 1 LVL
-------------------------------------------------------
function item_phase_boots_1:GetIntrinsicModifierName()
	return "modifier_phase_boots_custom"
end

function item_phase_boots_1:OnSpellStart()
	local caster = self:GetCaster()
	local phase_duration = self:GetSpecialValueFor("phase_duration")
	EmitSoundOn("DOTA_Item.PhaseBoots.Activate", caster)
	if not caster:HasModifier("modifier_phase_boots_custom_buff") then
		caster:AddNewModifier(caster, self, "modifier_phase_boots_custom_buff", {duration = phase_duration})
	end
end
-------------------------------------------------------
-- 2 LVL
-------------------------------------------------------
function item_phase_boots_2:GetIntrinsicModifierName()
	return "modifier_phase_boots_custom"
end

function item_phase_boots_2:OnSpellStart()
	local caster = self:GetCaster()
	local phase_duration = self:GetSpecialValueFor("phase_duration")
	EmitSoundOn("DOTA_Item.PhaseBoots.Activate", caster)
	if not caster:HasModifier("modifier_phase_boots_custom_buff") then
		caster:AddNewModifier(caster, self, "modifier_phase_boots_custom_buff", {duration = phase_duration})
	end
end
-------------------------------------------------------
-- 3 LVL
-------------------------------------------------------
function item_phase_boots_3:GetIntrinsicModifierName()
	return "modifier_phase_boots_custom"
end

function item_phase_boots_3:OnSpellStart()
	local caster = self:GetCaster()
	local phase_duration = self:GetSpecialValueFor("phase_duration")
	EmitSoundOn("DOTA_Item.PhaseBoots.Activate", caster)
	if not caster:HasModifier("modifier_phase_boots_custom_buff") then
		caster:AddNewModifier(caster, self, "modifier_phase_boots_custom_buff", {duration = phase_duration})
	end
end
-------------------------------------------------------
-- 4 LVL
-------------------------------------------------------
function item_phase_boots_4:GetIntrinsicModifierName()
	return "modifier_phase_boots_custom"
end

function item_phase_boots_4:OnSpellStart()
	local caster = self:GetCaster()
	local phase_duration = self:GetSpecialValueFor("phase_duration")
	EmitSoundOn("DOTA_Item.PhaseBoots.Activate", caster)
	if not caster:HasModifier("modifier_phase_boots_4_buff") then
		caster:AddNewModifier(caster, self, "modifier_phase_boots_4_buff", {duration = phase_duration})
	else
		caster:RemoveModifierByName("modifier_phase_boots_4_buff")
		caster:AddNewModifier(caster, self, "modifier_phase_boots_4_buff", {duration = phase_duration})
	end
end


modifier_phase_boots_custom = class({})

function modifier_phase_boots_custom:IsHidden() 
	return true 
end
function modifier_phase_boots_custom:IsPurgable() 
	return false 
 end
 
function modifier_phase_boots_custom:IsDebuff() 
	return false 
end

function modifier_phase_boots_custom:IsPermanent() 
	return true 
end

function modifier_phase_boots_custom:RemoveOnDeath() 
	return false 
end

function modifier_phase_boots_custom:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE}

	return funcs
end

function modifier_phase_boots_custom:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_phase_boots_custom:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_phase_boots_custom:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

modifier_phase_boots_custom_buff = class({})

function modifier_phase_boots_custom_buff:IsHidden() 
	return false 
end
function modifier_phase_boots_custom_buff:IsPurgable() 
	return false 
end
function modifier_phase_boots_custom_buff:IsDebuff() 
	return false 
end

function modifier_phase_boots_custom_buff:OnCreated()
	self.caster = self:GetCaster()
	self.particle_boost = "particles/econ/events/ti8/phase_boots_ti8_body_magic.vpcf"
	if self:GetAbility():GetLevel() == 1 then
		self.particle_boost = "particles/econ/events/ti7/phase_boots_ti7.vpcf"
	elseif self:GetAbility():GetLevel() == 2 then
		self.particle_boost = "particles/econ/events/ti8/phase_boots_ti8_body_magic.vpcf"
	elseif self:GetAbility():GetLevel() == 3 then
		self.particle_boost = "particles/econ/events/ti8/phase_boots_ti8.vpcf"
	end

	if IsServer() then
		local particle_boost_fx = ParticleManager:CreateParticle(self.particle_boost, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle_boost_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_boost_fx, 1, self.caster:GetAbsOrigin())
		self:AddParticle(particle_boost_fx, false, false, -1, false, false)
	end
end

function modifier_phase_boots_custom_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX}

	return decFuncs
end

function modifier_phase_boots_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("proc_spd")
end

function modifier_phase_boots_custom_buff:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("ms_limit")
end

modifier_phase_boots_4_buff = class({})

function modifier_phase_boots_4_buff:IsHidden() 
	return false 
end
function modifier_phase_boots_4_buff:IsPurgable() 
	return false 
end
function modifier_phase_boots_4_buff:IsDebuff() 
	return false 
end

function modifier_phase_boots_4_buff:OnCreated()
	self.caster = self:GetCaster()
	self.particle_boost = "particles/econ/events/ti6/phase_boots_ti6.vpcf"
	if IsServer() then
		local particle_boost_fx = ParticleManager:CreateParticle(self.particle_boost, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle_boost_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_boost_fx, 1, self.caster:GetAbsOrigin())
		self:AddParticle(particle_boost_fx, false, false, -1, false, false)
	end
end

function modifier_phase_boots_4_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX}

	return decFuncs
end

function modifier_phase_boots_4_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("proc_spd")
end

function modifier_phase_boots_4_buff:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("ms_limit")
end

function modifier_phase_boots_4_buff:CheckState()
	local States = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
	return States
end
