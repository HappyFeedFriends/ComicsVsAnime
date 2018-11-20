
if 	modifier_special_bonus_incoming_10 == nil then 
	modifier_special_bonus_incoming_10 = class({}) 
end

function modifier_special_bonus_incoming_10:IsHidden()
    return true 
end

function modifier_special_bonus_incoming_10:IsPurgable()
	return false
end

function modifier_special_bonus_incoming_10:RemoveOnDeath()
	return false
end

function modifier_special_bonus_incoming_10:IsPurgeException()
	return false
end

function modifier_special_bonus_incoming_10:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.value = value
	end
end

function modifier_special_bonus_incoming_10:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
	return funcs
end

function modifier_special_bonus_incoming_10:GetModifierIncomingDamage_Percentage( params )
    return -self.value
end
