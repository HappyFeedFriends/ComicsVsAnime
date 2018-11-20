
if modifier_damage_bonus == nil then
	modifier_damage_bonus = class({})
end

function modifier_damage_bonus:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS 
}
	return funcs
end

function modifier_damage_bonus:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local spell = caster:FindAbilityByName("death_passive")
		local damage_death = spell:GetSpecialValueFor("damage")
		self.value = damage_death
	end
end

function modifier_damage_bonus:IsHidden()
	return false
end

function modifier_damage_bonus:IsPurgable()
    return false
end

function modifier_damage_bonus:RemoveOnDeath()
	return false
end

function modifier_damage_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_damage_bonus:AllowIllusionDuplicate()
	return true
end

function modifier_damage_bonus:GetModifierPreAttack_BonusDamage()
	return self.value * self:GetStackCount()
end