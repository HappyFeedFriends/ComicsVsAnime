modifier_fountain_invuriable_custom = class({})


function modifier_fountain_invuriable_custom:IsHidden()
	return false
end

function modifier_fountain_invuriable_custom:GetTexture()
	return "custom_ability/fountain_protection"
end

function modifier_fountain_invuriable_custom:CheckState()
    local state = {
    [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
    return state
end

