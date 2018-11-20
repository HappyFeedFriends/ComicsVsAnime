modifier_special_bonus_movespeed_800= class({})

function modifier_special_bonus_movespeed_800:RemoveOnDeath()
	return false
end

function modifier_special_bonus_movespeed_800:IsHidden()
	return true
end

function modifier_special_bonus_movespeed_800:IsPurgeException()
	return false
end

function modifier_special_bonus_movespeed_800:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local spell = self:GetAbility()
		local value = spell:GetSpecialValueFor("value")
		self.value = value
		self:SetStackCount(self.value)
	end
end

function modifier_special_bonus_movespeed_800:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_special_bonus_movespeed_800:GetModifierMoveSpeed_Limit()
	return 1000
end

function modifier_special_bonus_movespeed_800:GetModifierMoveSpeed_Max()
	return self:GetStackCount()
end