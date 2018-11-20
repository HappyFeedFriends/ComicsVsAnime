modifier_fountain_aura_lua = class({})

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:GetModifierAura()
	return "modifier_fountain_aura_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:GetAuraDuration()
	return 0.1
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_lua:GetAuraRadius()
local radius = RADIUS_AURA
	return radius
end
