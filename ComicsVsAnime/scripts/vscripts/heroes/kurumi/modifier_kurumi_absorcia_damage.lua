modifier_kurumi_absorcia_damage = class({}) 

function modifier_kurumi_absorcia_damage:IsHidden()
    return false
end

function modifier_kurumi_absorcia_damage:IsPurgable()
	return false
end

function modifier_kurumi_absorcia_damage:RemoveOnDeath()
	return true
end

function modifier_kurumi_absorcia_damage:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
	return funcs
end

function modifier_kurumi_absorcia_damage:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()
end