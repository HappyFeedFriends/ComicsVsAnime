
modifier_pudge_arcana_green = class({})

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:OnCreated()
	if IsClient() then
		local sEffect = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_back_ambient.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:OnIntervalThink()
end
--------------------------------------------------------------------------------

function modifier_pudge_arcana_green:OnDestroy()
	if IsClient() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
		end
	end
end

function modifier_pudge_arcana_green:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MODEL_CHANGE,
}
	return funcs
end

function modifier_pudge_arcana_green:GetModifierModelChange()
	return "models/items/pudge/arcana/pudge_arcana_base.vmdl"
end
