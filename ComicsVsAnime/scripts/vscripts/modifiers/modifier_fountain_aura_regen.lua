modifier_fountain_aura_regen = class({})

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:GetModifierAura()
	return "modifier_fountain_regen_custom"
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fountain_aura_regen:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:GetAuraDuration()
	return 0.1
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_regen:GetAuraRadius()
local radius = RADIUS_AURA
	return radius
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------