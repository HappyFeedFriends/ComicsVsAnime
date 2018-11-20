item_butterfly_1 = class({})
item_butterfly_2 = class({})
item_butterfly_3 = class({})
LinkLuaModifier("modifier_item_butterfly_1", "items/item_butterfly", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_item_butterfly_3", "items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_butterfly_1_crit", "items/item_butterfly", LUA_MODIFIER_MOTION_NONE)

function item_butterfly_1:GetIntrinsicModifierName()
	return "modifier_item_butterfly_1"
end

function item_butterfly_2:GetIntrinsicModifierName()
	return "modifier_item_butterfly_1"
end

function item_butterfly_3:GetIntrinsicModifierName()
	return "modifier_item_butterfly_1"
end

function item_butterfly_3:OnSpellStart()
	if IsServer() then
		local dur = self:GetSpecialValueFor("duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_butterfly_3", {duration = dur})
	end
end

modifier_item_butterfly_3 = class({})

function modifier_item_butterfly_3:IsHidden() 
	return false 
end
function modifier_item_butterfly_3:IsPurgable() 
	return false 
 end
 
function modifier_item_butterfly_3:IsDebuff() 
	return false 
end

function modifier_item_butterfly_3:RemoveOnDeath() 
	return false 
end

function modifier_item_butterfly_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,}

	return funcs
end
function modifier_item_butterfly_3:GetModifierMoveSpeed_Limit() 
	return self:GetAbility():GetSpecialValueFor("ms_linit")
end
function modifier_item_butterfly_3:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("ms_linit")
end

function modifier_item_butterfly_3:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ms_linit")
end


modifier_item_butterfly_1 = class({})

function modifier_item_butterfly_1:IsHidden() 
	return true 
end
function modifier_item_butterfly_1:IsPurgable() 
	return false 
 end
 
function modifier_item_butterfly_1:IsDebuff() 
	return false 
end

function modifier_item_butterfly_1:RemoveOnDeath() 
	return false 
end

function modifier_item_butterfly_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}

	return funcs
end

function modifier_item_butterfly_1:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_butterfly_1:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_butterfly_1:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_item_butterfly_1:GetModifierAttackSpeedBonus_Constant()
	return 	self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end	