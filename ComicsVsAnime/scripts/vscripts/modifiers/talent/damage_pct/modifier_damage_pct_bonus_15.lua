
if modifier_special_bonus_damage_pct_bonus_15 == nil then 
	modifier_special_bonus_damage_pct_bonus_15 = class({}) 
end

function modifier_special_bonus_damage_pct_bonus_15:IsHidden()
    return true
end

function modifier_special_bonus_damage_pct_bonus_15:IsPurgable()
	return false
end

function modifier_special_bonus_damage_pct_bonus_15:RemoveOnDeath()
	return false
end

function modifier_special_bonus_damage_pct_bonus_15:IsPurgeException()
	return false
end

function modifier_special_bonus_damage_pct_bonus_15:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.value_damage = value
		self:SetStackCount(self.value_damage)
	end
end

function modifier_special_bonus_damage_pct_bonus_15:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE  
    }
	return funcs
end

function modifier_special_bonus_damage_pct_bonus_15:GetModifierBaseDamageOutgoing_Percentage( params )
    return self:GetStackCount()
end
