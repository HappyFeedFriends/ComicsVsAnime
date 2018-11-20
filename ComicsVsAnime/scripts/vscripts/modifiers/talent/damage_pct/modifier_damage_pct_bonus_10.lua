
if 	modifier_special_bonus_damage_pct_bonus_10 == nil then 
	modifier_special_bonus_damage_pct_bonus_10 = class({}) 
end

function modifier_special_bonus_damage_pct_bonus_10:IsHidden ()
    return true
end

function modifier_special_bonus_damage_pct_bonus_10:IsPurgable()
	return false
end

function modifier_special_bonus_damage_pct_bonus_10:RemoveOnDeath()
	return false
end

function modifier_special_bonus_damage_pct_bonus_10:IsPurgeException()
	return false
end

function modifier_special_bonus_damage_pct_bonus_10:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.value = value
		self.value_damage = value
		self:SetStackCount(self.value_damage)
	end
end

function modifier_special_bonus_damage_pct_bonus_10:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE 
    }
	return funcs
end

function modifier_special_bonus_damage_pct_bonus_10:GetModifierBaseDamageOutgoing_Percentage( params )
    return self:GetStackCount()
end
