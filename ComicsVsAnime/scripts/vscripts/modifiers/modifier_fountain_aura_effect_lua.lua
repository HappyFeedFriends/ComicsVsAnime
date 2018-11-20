modifier_fountain_aura_effect_lua = class({})

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

function modifier_fountain_aura_effect_lua:IsDebuff()
	return true
end

function modifier_fountain_aura_effect_lua:IsHidden()
	return true
end

function modifier_fountain_aura_effect_lua:OnCreated( kv )
	if IsServer() then
	ComicsVsAnimeKill(self:GetCaster(), self:GetParent(), self:GetCaster())
	end	
end