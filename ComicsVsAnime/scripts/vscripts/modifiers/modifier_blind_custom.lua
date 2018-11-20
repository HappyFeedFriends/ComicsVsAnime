
if modifier_blind_custom == nil then
	modifier_blind_custom = class({})
end

function modifier_blind_custom:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_FIXED_DAY_VISION,
	MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	MODIFIER_PROPERTY_MISS_PERCENTAGE
}
	return funcs
end

function modifier_blind_custom:IsHidden()
	return false
end

function modifier_blind_custom:IsPurgable()
    return true
end

function modifier_blind_custom:RemoveOnDeath()
    return true
end

function modifier_blind_custom:GetFixedNightVision()
    return 0
end

function modifier_blind_custom:GetFixedDayVision()
    return 0
end

function modifier_blind_custom:GetModifierMiss_Percentage()
    return 100
end

function modifier_blind_custom:CheckState()
    local state = {
    [MODIFIER_STATE_BLIND] = true,
    }

    return state
end