item_magic_medallion_1 = class({})
item_magic_medallion_2 = class({})
item_magic_medallion_3 = class({})
LinkLuaModifier("modifier_magic_medallion", "items/item_magic_medallion", LUA_MODIFIER_MOTION_NONE)

function item_magic_medallion_1:GetIntrinsicModifierName()
	return "modifier_magic_medallion"
end

function item_magic_medallion_2:GetIntrinsicModifierName()
	return "modifier_magic_medallion"
end

function item_magic_medallion_3:GetIntrinsicModifierName()
	return "modifier_magic_medallion"
end

modifier_magic_medallion = class({})

function modifier_magic_medallion:IsHidden() 
	return true 
end
function modifier_magic_medallion:IsPurgable() 
	return false 
 end
 
function modifier_magic_medallion:IsDebuff() 
	return false 
end

function modifier_magic_medallion:RemoveOnDeath() 
	return false 
end

function modifier_magic_medallion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,}

	return funcs
end

function modifier_magic_medallion:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_amplify")
end

function modifier_magic_medallion:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end