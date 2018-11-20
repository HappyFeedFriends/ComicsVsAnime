
if 	modifier_damage_pct_bonus_30 == nil then 
	modifier_damage_pct_bonus_30 = class({}) 
end

function modifier_damage_pct_bonus_30:IsHidden ()
    return false
end

function modifier_damage_pct_bonus_30:IsPurgable()
	return false
end

function modifier_damage_pct_bonus_30:RemoveOnDeath()
	return false
end

function modifier_damage_pct_bonus_30:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE 
    }
	return funcs
end

function modifier_damage_pct_bonus_30:GetModifierBaseDamageOutgoing_Percentage( params )
    return 30
end
