
if modifier_thanos_interval_dmg == nil then
	modifier_thanos_interval_dmg = class({})
end

function modifier_thanos_interval_dmg:OnCreated( kv )
	if IsServer() then
		local particle = "particles/fountain_lazor1.vpcf"
		self.particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		local interval1 = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(interval1)
		self.damage = self:GetCaster():GetModifierStackCount( "modifier_thanos_Stack_damage", self:GetAbility() )
	end
end


function modifier_thanos_interval_dmg:IsDeBuff()
    return true
end

function modifier_thanos_interval_dmg:IsHidden()
	return false
end

function modifier_thanos_interval_dmg:IsPurgable()
    return true
end

function modifier_thanos_interval_dmg:RemoveOnDeath()
    return true
end

function modifier_thanos_interval_dmg:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() and self:GetAbility() ~= nil then
        if self:GetCaster():IsAlive() == false then
            self:Destroy()
        end
		local target_location = self:GetParent():GetAbsOrigin()
		local caster_location = self:GetCaster():GetAbsOrigin()
		local distance = (target_location - caster_location):Length2D()
		local stack = self:GetAbility():GetSpecialValueFor("damage")/100
		local stop_distance = self:GetAbility():GetSpecialValueFor("distance")
		local talent1 = self:GetCaster():FindAbilityByName("special_bonus_thanos_5")
		if talent1 and talent1:GetLevel() > 0 then
		local value = talent1:GetSpecialValueFor("value")
			stack = stack + value/100
		end
		
		if distance >= stop_distance then
			self:Destroy()
		end
		self.damage1 = self.damage * stack
		local damage = {
		victim = thinker, 
		attacker = self:GetCaster(),
		damage = self.damage1, 
		damage_type = self:GetCaster():FindAbilityByName("Thanos_damage_convert"):GetAbilityDamageType()}				
        ApplyDamage(damage)
	elseif 	self:GetAbility() == nil then
		self:Destroy()
	end
end

function modifier_thanos_interval_dmg:OnDestroy()
  ParticleManager:DestroyParticle(self.particle, false)
  ParticleManager:ReleaseParticleIndex(self.particle)

end