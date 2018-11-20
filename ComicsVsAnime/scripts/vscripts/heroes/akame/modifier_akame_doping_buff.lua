
if modifier_akame_doping_buff == nil then
	modifier_akame_doping_buff = class({})
end

function modifier_akame_doping_buff:OnCreated( kv )
	if IsServer() then
		self.str = kv.str
		self.int = kv.int
		self.agi = kv.agi
		self.mult = kv.mult
	end	
end

function modifier_akame_doping_buff:IsBuff()
    return true
end

function modifier_akame_doping_buff:IsHidden()
	return false
end

function modifier_akame_doping_buff:IsPurgable()
    return true
end

function modifier_akame_doping_buff:RemoveOnDeath()
    return true
end

function modifier_akame_doping_buff:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
	return funcs
end

function modifier_akame_doping_buff:GetModifierBonusStats_Agility()
	if IsServer() then
		return self.agi * self.mult
	end	
end

function modifier_akame_doping_buff:GetModifierBonusStats_Strength()
	if IsServer() then
		return self.str * self.mult
	end
end

function modifier_akame_doping_buff:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self.int * self.mult
	end
end