
if modifier_shinobu_hp == nil then
	modifier_shinobu_hp = class({})
end

function modifier_shinobu_hp:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
	return funcs
end

function modifier_shinobu_hp:OnCreated(htable)
    if IsServer() and self:GetParent():FindAbilityByName("shinobu_hp_dmg") then
    	local caster = self:GetParent()
		local spell = caster:FindAbilityByName("shinobu_hp_dmg")
		local value = spell:GetSpecialValueFor("regeneration")
		local talant = caster:FindAbilityByName("special_bonus_shinobu_2")
		if talant then
			if talant:GetLevel() == 1 then
			local value1 = talant:GetSpecialValueFor("value")
				value = value1
			end
		end
		self.value = value
		self:SetStackCount(self.value)
		self:StartIntervalThink(0.05)
	end
end

function modifier_shinobu_hp:OnIntervalThink()
	if self:GetAbility() == nil then
		self:Destroy()
	end	
end

function modifier_shinobu_hp:IsHidden()
	return true
end

function modifier_shinobu_hp:IsPurgable()
    return false
end

function modifier_shinobu_hp:GetModifierHealthRegenPercentage()
	return self.value
end