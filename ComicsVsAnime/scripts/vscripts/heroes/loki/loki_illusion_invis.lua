loki_illusion_invis = loki_illusion_invis or class({})
LinkLuaModifier ("modifier_loki_movespeed", "heroes/loki/loki_illusion_invis", LUA_MODIFIER_MOTION_NONE)
function loki_illusion_invis:OnSpellStart() 
	local num_illusion = self:GetSpecialValueFor("num_illusion")
	local radius_vector = self:GetSpecialValueFor("radius")
	local illusion_incoming_damage = self:GetSpecialValueFor("incoming_damage")
	local illusion_outgoing_damage = self:GetSpecialValueFor("ougoing_damage")
	local duration_illusion = self:GetSpecialValueFor("duration_illusion")
	local delay = self:GetSpecialValueFor("delay_invis")
	local dur_invis = self:GetSpecialValueFor("duration_invis")
	local control = false
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_loki_7") then
		illusion_outgoing_damage = illusion_outgoing_damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_loki_7")
	end	
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_loki_4") then
		control = true
	end 
	ComicsVsAnimeCreateIllusion(self:GetCaster(), self, num_illusion, illusion_incoming_damage, illusion_outgoing_damage, duration_illusion, false, false,true,radius_vector,control)
	Timers:CreateTimer(delay, function()
		if self:GetCaster():HasScepter() then 
			self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_loki_movespeed",{duration = dur_invis})
			self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_invisible",{duration = dur_invis})
		else
			self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_invisible",{duration = dur_invis})
		end	
	end)
end

modifier_loki_movespeed = modifier_loki_movespeed or class({})

function modifier_loki_movespeed:RemoveOnDeath() return true end
function modifier_loki_movespeed:IsHidden() return false end
function modifier_loki_movespeed:IsPurgeException() return false end

function modifier_loki_movespeed:OnCreated() 
	self.particle = ParticleManager:CreateParticle( "particles/loki/comics_vs_anime_loki_illusion_invis.vpcf", PATTACH_ABSORIGIN, self:GetCaster() );
end 

function modifier_loki_movespeed:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, true)
end

function modifier_loki_movespeed:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} 
end 

function modifier_loki_movespeed:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("aghanim_bonus_ms")
end	