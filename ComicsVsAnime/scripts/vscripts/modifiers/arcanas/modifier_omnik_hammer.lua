
modifier_omnik_hammer = class({})

--------------------------------------------------------------------------------

function modifier_omnik_hammer:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_omnik_hammer:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_omnik_hammer:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_omnik_hammer:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_omnik_hammer:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_omnik_hammer:OnCreated()
	if IsClient() then
		local sEffect = "particles/omniknight/omniknight_hammer_ambient.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_CUSTOMORIGIN, self:GetParent())
		self.particle = ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		self.particle = ParticleManager:SetParticleControl(particle, 1, Vector(particle_radius,0,0))
	end
end
