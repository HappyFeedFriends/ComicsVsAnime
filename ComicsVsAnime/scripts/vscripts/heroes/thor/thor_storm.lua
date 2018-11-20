thor_storm = thor_storm or class({})
LinkLuaModifier ("modifier_thor_storm_aura", "heroes/thor/thor_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_thor_storm", "heroes/thor/thor_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_thor_storm_talent", "heroes/thor/thor_storm", LUA_MODIFIER_MOTION_NONE)
function thor_storm:OnSpellStart()
	local target_position = self:GetCaster():GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(self:GetCaster(),self,"modifier_thor_storm_aura", {duration = duration,radius = radius},  target_position, self:GetCaster():GetTeamNumber(), false)
end 

modifier_thor_storm_aura = modifier_thor_storm_aura or class({})

function modifier_thor_storm_aura:RemoveOnDeath()		return true 										end
function modifier_thor_storm_aura:IsHidden() 			return true 										end
function modifier_thor_storm_aura:IsPurgable() 			return false 										end
function modifier_thor_storm_aura:IsAura() 				return true 										end
function modifier_thor_storm_aura:GetAuraSearchFlags() 	return self:GetAbility():GetAbilityTargetFlags() 	end
function modifier_thor_storm_aura:GetAuraSearchType()	return self:GetAbility():GetAbilityTargetType() 	end
function modifier_thor_storm_aura:GetAuraSearchTeam() 	return self:GetAbility():GetAbilityTargetTeam() 	end
function modifier_thor_storm_aura:GetModifierAura()		return "modifier_thor_storm" 						end
function modifier_thor_storm_aura:GetAuraRadius() 		return self.radius 									end

function modifier_thor_storm_aura:OnCreated(kv)
	self.radius  = kv.radius
	self.particle =  ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self.radius, self.radius, self.radius))
end

function modifier_thor_storm_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end

modifier_thor_storm = modifier_thor_storm or class({})

function modifier_thor_storm:RemoveOnDeath()return true end
function modifier_thor_storm:IsHidden()return true end
function modifier_thor_storm:IsPurgable()return false end

function modifier_thor_storm:OnCreated()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end 

function modifier_thor_storm:OnIntervalThink()
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		self.particles = ParticleManager:CreateParticle( "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_OVERHEAD_FOLLOW	, self:GetParent())
		ParticleManager:SetParticleControl(self.particles, 1, self:GetParent():GetAbsOrigin());
		--self:GetAbility():ApplyCustomDamage(self:GetParent(), self:GetCaster(), damage)
		local damageTable = 
		{
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
		}
		ApplyDamage(damageTable)
	end
end 

function modifier_thor_storm:OnDestroy()
	if IsServer() then
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_6") then
			self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_thor_storm_talent",{duration = self:GetCaster():ComicsVsAnimeTalent("special_bonus_thor_6")})
		end 
		ParticleManager:DestroyParticle(self.particles, true)
	end
end

function modifier_thor_storm:GetEffectName()
    return "particles/units/heroes/hero_razor/razor_rain_storm_cloud.vpcf"
end

function modifier_thor_storm:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_thor_storm_talent = modifier_thor_storm_talent or class({})

function modifier_thor_storm_talent:RemoveOnDeath()return true end
function modifier_thor_storm_talent:IsHidden()return true end
function modifier_thor_storm_talent:IsPurgable()return false end

function modifier_thor_storm_talent:OnCreated()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end 

function modifier_thor_storm_talent:OnIntervalThink()
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	self.particles = ParticleManager:CreateParticle( "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_OVERHEAD_FOLLOW	, self:GetParent())
	ParticleManager:SetParticleControl(self.particles, 1, self:GetParent():GetAbsOrigin());
	local damageTable = 
	{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
	}
	ApplyDamage(damageTable)
end 

function modifier_thor_storm_talent:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particles, true)
	end
end

function modifier_thor_storm_talent:GetEffectName()
    return "particles/units/heroes/hero_razor/razor_rain_storm_cloud.vpcf"
end

function modifier_thor_storm_talent:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end