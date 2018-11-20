----------------------------------------------------------------------------------

item_boots_strength_1 = item_boots_strength_1 or class({})

LinkLuaModifier("modifier_item_boots_strength_1", "items/item_boots", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_item_boots_agility_1", "items/item_boots", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_item_boots_intellegence_1", "items/item_boots", LUA_MODIFIER_MOTION_NONE) 

function item_boots_strength_1:GetIntrinsicModifierName()
	return "modifier_item_boots_strength_1"
end

function item_boots_strength_1:OnSpellStart()
	self:GetCaster():SwapItems(self,"item_boots_agility_1")
end

modifier_item_boots_strength_1 = modifier_item_boots_strength_1 or class({})

function modifier_item_boots_strength_1:IsHidden() return true end
function modifier_item_boots_strength_1:IsPurgable() return false end
function modifier_item_boots_strength_1:IsDebuff() return false end
function modifier_item_boots_strength_1:RemoveOnDeath() return false end

function modifier_item_boots_strength_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end	

function modifier_item_boots_strength_1:GetModifierBonusStats_Strength()
	return	self:GetAbility():GetSpecialValueFor("bonus_str")
end	

function modifier_item_boots_strength_1:GetModifierMoveSpeedBonus_Constant()
	return 	self:GetAbility():GetSpecialValueFor("bonus_ms")
end	

function modifier_item_boots_strength_1:GetModifierPreAttack_BonusDamage()
	return	self:GetAbility():GetSpecialValueFor("bonus_damage") 
end	

----------------------------------------------------------------------------------

item_boots_agility_1 = item_boots_agility_1 or class({})

function item_boots_agility_1:GetIntrinsicModifierName()
	return "modifier_item_boots_agility_1"
end

function item_boots_agility_1:OnSpellStart()
	self:GetCaster():SwapItems(self,"item_boots_intellegence_1")
end

modifier_item_boots_agility_1 = modifier_item_boots_agility_1 or class({})

function modifier_item_boots_agility_1:IsHidden() return true end
function modifier_item_boots_agility_1:IsPurgable() return false end
function modifier_item_boots_agility_1:IsDebuff() return false end
function modifier_item_boots_agility_1:RemoveOnDeath() return false end

function modifier_item_boots_agility_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end	

function modifier_item_boots_agility_1:GetModifierBonusStats_Agility()
	return	self:GetAbility():GetSpecialValueFor("bonus_agi")
end	

function modifier_item_boots_agility_1:GetModifierMoveSpeedBonus_Constant()
	return 	self:GetAbility():GetSpecialValueFor("bonus_ms")
end	

function modifier_item_boots_agility_1:GetModifierPreAttack_BonusDamage()
	return	self:GetAbility():GetSpecialValueFor("bonus_damage") 
end

----------------------------------------------------------------------------------

item_boots_intellegence_1 = item_boots_intellegence_1 or class({})

function item_boots_intellegence_1:GetIntrinsicModifierName()
	return "modifier_item_boots_intellegence_1"
end

function item_boots_intellegence_1:OnSpellStart()
	self:GetCaster():SwapItems(self,"item_boots_strength_1")
end

modifier_item_boots_intellegence_1 = modifier_item_boots_intellegence_1 or class({})

function modifier_item_boots_intellegence_1:IsHidden() return true end
function modifier_item_boots_intellegence_1:IsPurgable() return false end
function modifier_item_boots_intellegence_1:IsDebuff() return false end
function modifier_item_boots_intellegence_1:RemoveOnDeath() return false end

function modifier_item_boots_intellegence_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end	

function modifier_item_boots_intellegence_1:GetModifierBonusStats_Intellect()
	return	self:GetAbility():GetSpecialValueFor("bonus_int")
end	

function modifier_item_boots_intellegence_1:GetModifierMoveSpeedBonus_Constant()
	return 	self:GetAbility():GetSpecialValueFor("bonus_ms")
end	

function modifier_item_boots_intellegence_1:GetModifierPreAttack_BonusDamage()
	return	self:GetAbility():GetSpecialValueFor("bonus_damage") 
end