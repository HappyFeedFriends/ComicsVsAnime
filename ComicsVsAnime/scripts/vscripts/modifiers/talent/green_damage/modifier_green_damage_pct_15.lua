
if 	modifier_special_bonus_green_damage_pct_15 == nil then 
	modifier_special_bonus_green_damage_pct_15 = class({}) 
end

function modifier_special_bonus_green_damage_pct_15:IsHidden ()
    return true
end

function modifier_special_bonus_green_damage_pct_15:IsPurgable()
	return false
end

function modifier_special_bonus_green_damage_pct_15:RemoveOnDeath()
	return false
end

function modifier_special_bonus_green_damage_pct_15:IsPurgeException()
	return false
end

function modifier_special_bonus_green_damage_pct_15:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.value = value
	    self:SetStackCount(self.value)
	end
end

function modifier_special_bonus_green_damage_pct_15:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE       
    }
	return funcs
end

function modifier_special_bonus_green_damage_pct_15:GetModifierDamageOutgoing_Percentage( params )
    return self:GetStackCount()
end
