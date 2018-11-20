
if modifier_naruto_ult == nil then
	modifier_naruto_ult = class({})
end

function modifier_naruto_ult:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MODEL_CHANGE,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, 
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS 
}
	return funcs
end

function modifier_naruto_ult:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local spell = caster:FindAbilityByName("naruto_ult")
		local value1 = spell:GetSpecialValueFor("stats")
		local talent = caster:FindAbilityByName("special_bonus_naruto_3")
	
	if talent then
		if talent:GetLevel() == 1 then
			local value_talent = talent:GetSpecialValueFor("value")
			value1 = value1 * value_talent
		end
	end
		self.stats = value1
		
	end
end

function modifier_naruto_ult:IsHidden()
	return false
end

function modifier_naruto_ult:IsPurgable()
    return false
end

function modifier_naruto_ult:OnDestroy()
	if IsServer() and self:GetParent():FindAbilityByName("naruto_illusion1") then
		return self:GetParent():FindAbilityByName("naruto_illusion1"):SetActivated(true)
	end
end

function modifier_naruto_ult:RemoveOnDeath()
    return false
end

function modifier_naruto_ult:GetModifierModelChange()
	return "models/kyuubi_new/kyuubi.vmdl"
end

function modifier_naruto_ult:GetModifierBonusStats_Agility()
	return self.stats
end

function modifier_naruto_ult:GetModifierBonusStats_Intellect()
	return self.stats
end

function modifier_naruto_ult:GetModifierBonusStats_Strength()
	return self.stats
end