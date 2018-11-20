
if modifier_shinobu_Agi_bonus == nil then
	modifier_shinobu_Agi_bonus = class({})
end

function modifier_shinobu_Agi_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_shinobu_Agi_bonus:IsHidden()
	return false
end

function modifier_shinobu_Agi_bonus:IsPurgable()
    return false
end

function modifier_shinobu_Agi_bonus:RemoveOnDeath()
    return false
end

function modifier_shinobu_Agi_bonus:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
	return funcs
end

function modifier_shinobu_Agi_bonus:GetModifierBonusStats_Agility()
local agi = self:GetCaster():BonusTalentValue("special_bonus_shinobu_7",self:GetAbility():GetSpecialValueFor("agi_bonus"))
	return agi * self:GetStackCount()
end

function modifier_shinobu_Agi_bonus:GetTexture()
	return "custom_ability/shinobu_blood" 
end