
if 	modifier_special_bonus_green_damage_pct_25 == nil then 
	modifier_special_bonus_green_damage_pct_25 = class({}) 
end

function modifier_special_bonus_green_damage_pct_25:IsHidden ()
    return true
end

function modifier_special_bonus_green_damage_pct_25:IsPurgable()
	return false
end

function modifier_special_bonus_green_damage_pct_25:IsPurgeException()
	return false
end

function modifier_special_bonus_green_damage_pct_25:RemoveOnDeath()
	return false
end

function modifier_special_bonus_green_damage_pct_25:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.value_damage = value
		self:SetStackCount(self.value_damage)
	end
end

function modifier_special_bonus_green_damage_pct_25:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE  
    }
	return funcs
end

function modifier_special_bonus_green_damage_pct_25:GetModifierBaseDamageOutgoing_Percentage( params )
    return self:GetStackCount()
end
