modifier_slow_custom = class({})

function modifier_slow_custom:IsDebuff()
	return true
end

function modifier_slow_custom:IsHidden()
	return false
end

function modifier_slow_custom:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(kv.slow)
	end
end
	
function modifier_slow_custom:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
	
function modifier_slow_custom:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end