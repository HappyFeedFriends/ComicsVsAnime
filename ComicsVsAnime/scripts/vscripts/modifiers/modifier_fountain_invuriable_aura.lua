modifier_fountain_invuriable_aura = class({})

function modifier_fountain_invuriable_aura:IsHidden()
	return true
end

function modifier_fountain_invuriable_aura:IsAura()
	return true
end

function modifier_fountain_invuriable_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fountain_invuriable_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_fountain_invuriable_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_fountain_invuriable_aura:AuraDuration()
    return 0.1
end

function modifier_fountain_invuriable_aura:GetAuraRadius()
local radius = RADIUS_AURA
	return radius
end

function modifier_fountain_invuriable_aura:GetModifierAura()
	return "modifier_fountain_invuriable_custom"
end

