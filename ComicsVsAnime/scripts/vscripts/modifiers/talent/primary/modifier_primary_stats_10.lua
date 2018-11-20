
if 	modifier_special_bonus_primary_stats_10 == nil then 
	modifier_special_bonus_primary_stats_10 = class({}) 
end

function modifier_special_bonus_primary_stats_10:IsHidden ()
    return true 
end

function modifier_special_bonus_primary_stats_10:IsPurgable()
	return false
end

function modifier_special_bonus_primary_stats_10:RemoveOnDeath()
	return false
end

function modifier_special_bonus_primary_stats_10:IsPurgeException()
	return false
end

function modifier_special_bonus_primary_stats_10:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
	return funcs
end

function modifier_special_bonus_primary_stats_10:GetModifierBonusStats_Strength( params )
    return self.value_str
end

function modifier_special_bonus_primary_stats_10:GetModifierBonusStats_Intellect( params )
    return self.value_int
end
function modifier_special_bonus_primary_stats_10:GetModifierBonusStats_Agility( params )
    return self.value_agi
end

function modifier_special_bonus_primary_stats_10:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
    	local primary_atr = caster:GetPrimaryAttribute()
    	if primary_atr == 0 then
    		self.value_str = value
    		self.value_int = 0
    		self.value_agi = 0
		elseif primary_atr == 1 then
			self.value_str = 0
    		self.value_int = 0
    		self.value_agi = value
		else
			self.value_str = 0
    		self.value_int = value
    		self.value_agi = 0
		end
    end
end