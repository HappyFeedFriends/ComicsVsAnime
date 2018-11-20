modifier_spd_1000= class({})

function modifier_spd_1000:RemoveOnDeath()
	return false
end

function modifier_spd_1000:IsHidden()
	return false
end

function modifier_spd_1000:IsPurgable()
    return false
end

function modifier_spd_1000:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_spd_1000:GetModifierMoveSpeed_Limit()
	return 1000
end

function modifier_spd_1000:GetModifierMoveSpeed_Max()
	return 1000
end

function modifier_spd_1000:GetModifierMoveSpeedBonus_Percentage()
	return 1000
end