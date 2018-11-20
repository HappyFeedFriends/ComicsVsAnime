modifier_fountain_regen_custom = class({})

--------------------------------------------------------------------------------

function modifier_fountain_regen_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_fountain_regen_custom:GetTexture()
	return "rune_regen"
end

function modifier_fountain_regen_custom:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_fountain_regen_custom:GetModifierHealthRegenPercentage( params )
	return 25
end

--------------------------------------------------------------------------------

function modifier_fountain_regen_custom:GetModifierTotalPercentageManaRegen( params )
	return 7
end

--------------------------------------------------------------------------------

function modifier_fountain_regen_custom:GetModifierConstantManaRegen( params )
	return 16
end

--------------------------------------------------------------------------------

