health_regen_passive = class({})

function health_regen_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
}
	return funcs
end

function health_regen_passive:IsHidden()
	return true
end

function health_regen_passive:IsPurgable()
    return false
end

function health_regen_passive:RemoveOnDeath()
    return false
end

function health_regen_passive:GetModifierHealthRegenPercentage()
	return 0.6
end

function health_regen_passive:GetModifierTotalPercentageManaRegen()
	return 2
end

function health_regen_passive:GetAttributes()
      return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
