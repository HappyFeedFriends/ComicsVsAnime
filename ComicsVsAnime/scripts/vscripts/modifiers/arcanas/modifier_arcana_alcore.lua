
if modifier_arcana_alcore == nil then
	modifier_arcana_alcore = class({})
end

function modifier_arcana_alcore:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MODEL_CHANGE,
	MODIFIER_PROPERTY_MODEL_SCALE,
}
	return funcs
end

function modifier_arcana_alcore:IsHidden()
	return true
end

function modifier_arcana_alcore:IsPurgable()
    return false
end

function modifier_arcana_alcore:RemoveOnDeath()
    return false
end

function modifier_arcana_alcore:GetModifierModelChange()
	return "models/hero_ulquiorra/hero_ulquiorra_base.vmdl"
end

function modifier_arcana_alcore:GetModifierModelScale()
	return 2.3
end