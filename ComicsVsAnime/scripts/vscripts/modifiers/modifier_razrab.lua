
modifier_razrab = class({})

--------------------------------------------------------------------------------

function modifier_razrab:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_razrab:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_razrab:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_razrab:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_razrab:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_razrab:OnCreated()
	if IsClient() then
		local sEffect = "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient_loadout.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_razrab:OnIntervalThink()
--	self:GetCaster():CalculateStatBonus()
end
--------------------------------------------------------------------------------

function modifier_razrab:OnDestroy()
	if IsClient() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_razrab:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_razrab:OnDeath(params)
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hVictim == self:GetParent() and self:GetParent():IsRealHero() then
			local sEffect = "particles/particles_all/myparticles/nightmare_blink.vpcf"
			local nFXIndex = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
			ParticleManager:ReleaseParticleIndex( nFXIndex )	
		end
	end
	return 0	
end

function modifier_razrab:CheckState()
    local state = {
    [MODIFIER_STATE_INVULNERABLE] = false,
    [MODIFIER_STATE_NO_HEALTH_BAR] = false,
                  }
    return state
end

function modifier_razrab:GetTexture()
  return ""
end

--------------------------------------------------------------------------------