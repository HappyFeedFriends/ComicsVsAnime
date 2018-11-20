if 	modifier_chakra_bonus == nil then 
	modifier_chakra_bonus = class({}) 
end

function modifier_chakra_bonus:IsHidden()
    return false
end

function modifier_chakra_bonus:IsPurgable()
	return false
end

function modifier_chakra_bonus:RemoveOnDeath()
	return false
end

function modifier_chakra_bonus:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE 
    }
	return funcs
end

function modifier_chakra_bonus:GetModifierSpellAmplify_Percentage( params )
self.value = self:GetCaster():BonusTalentValue("special_bonus_naruto_5",self:GetAbility():GetSpecialValueFor("amp"))
    return self.value * self:GetStackCount()
end