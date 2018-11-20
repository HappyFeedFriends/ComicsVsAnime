
modifier_gold_bonusx100 = class({})

--------------------------------------------------------------------------------

function modifier_gold_bonusx100:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_gold_bonusx100:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_gold_bonusx100:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_gold_bonusx100:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_gold_bonusx100:AllowIllusionDuplicate()
	return true
end

function modifier_gold_bonusx100:OnCreated()
	if IsClient() then
		local sEffect = "particles/frostivus_herofx/juggernaut_omnislash_ascension_sparks.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end


--------------------------------------------------------------------------------