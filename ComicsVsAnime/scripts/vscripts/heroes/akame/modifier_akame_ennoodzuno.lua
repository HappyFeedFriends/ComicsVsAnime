
if modifier_akame_ennoodzuno == nil then
	modifier_akame_ennoodzuno = class({})
end

function modifier_akame_ennoodzuno:OnCreated( kv )
	if IsServer() then
		self.stackParticle = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:GetCaster():SetRenderColor(128, 128, 128)
	end	
end

function modifier_akame_ennoodzuno:IsBuff()
    return true
end

function modifier_akame_ennoodzuno:IsHidden()
	return false
end

function modifier_akame_ennoodzuno:IsPurgable()
    return true
end

function modifier_akame_ennoodzuno:RemoveOnDeath()
    return true
end

function modifier_akame_ennoodzuno:OnDestroy()
	if IsServer() then
		self:GetCaster():SetRenderColor(255, 255, 255)	
		ParticleManager:DestroyParticle(self.stackParticle, true)
		ParticleManager:ReleaseParticleIndex( self.stackParticle )	
	end	
end