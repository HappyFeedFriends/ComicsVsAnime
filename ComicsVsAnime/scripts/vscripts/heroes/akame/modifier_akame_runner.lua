
if modifier_akame_runner == nil then
	modifier_akame_runner = class({})
end

function modifier_akame_runner:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(kv.movespeed)
	end
end

function modifier_akame_runner:IsBuff()
    return true
end

function modifier_akame_runner:IsHidden()
	return false
end

function modifier_akame_runner:IsPurgable()
    return true
end

function modifier_akame_runner:RemoveOnDeath()
    return true
end

function modifier_akame_runner:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_MOVESPEED_MAX 
}
	return funcs
end

function modifier_akame_runner:GetModifierMoveSpeedBonus_Constant()
	return 	self:GetStackCount()
end

function modifier_akame_runner:GetModifierMoveSpeed_Limit()
	return	self:GetStackCount()
end

function modifier_akame_runner:GetModifierMoveSpeed_Max()
	return	self:GetStackCount()
end

function modifier_akame_runner:GetModifierEvasion_Constant()
	return  self:GetCaster():BonusTalentValue("special_bonus_akame_7",self:GetAbility():GetSpecialValueFor("evasion"))
end