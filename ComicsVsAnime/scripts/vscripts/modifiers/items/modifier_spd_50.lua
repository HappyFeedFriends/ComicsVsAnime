modifier_spd_50= class({})

function modifier_spd_50:RemoveOnDeath()
	return false
end

function modifier_spd_50:IsHidden()
	return false
end

function modifier_spd_50:IsPurgable()
    return false
end

function modifier_spd_50:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_spd_50:GetModifierMoveSpeed_Limit()
	return 50
end

function modifier_spd_50:GetModifierMoveSpeed_Max()
	return 50
end