
modifier_pudge_arcana_red = class({})

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:OnCreated()
	if IsClient() then
		local sEffect = "particles/pudge/pudge_arcana_red_back_ambient.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:OnIntervalThink()
end
--------------------------------------------------------------------------------

function modifier_pudge_arcana_red:OnDestroy()
	if IsClient() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
		end
	end
end

function modifier_pudge_arcana_red:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MODEL_CHANGE,
}
	return funcs
end

function modifier_pudge_arcana_red:GetModifierModelChange()
	return "models/items/pudge/arcana/pudge_arcana_base.vmdl"
end
