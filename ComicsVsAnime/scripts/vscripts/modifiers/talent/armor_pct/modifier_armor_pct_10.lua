
if 	modifier_special_bonus_armor_pct_10 == nil then 
	modifier_special_bonus_armor_pct_10 = class({}) 
end

function modifier_special_bonus_armor_pct_10:IsHidden ()
    return true
end

function modifier_special_bonus_armor_pct_10:IsPurgable()
	return false
end

function modifier_special_bonus_armor_pct_10:IsPurgeException()
	return false
end

function modifier_special_bonus_armor_pct_10:RemoveOnDeath()
	return false
end


function modifier_special_bonus_armor_pct_10:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.armor_pct = value
		self:SetStackCount(self.armor_pct)
	end
end

function modifier_special_bonus_armor_pct_10:GetModifierPhysicalArmorBonus( params )
  
     if self.flag then
         return 0
     end

    self.flag = true
	local value = self:GetStackCount()/100
    local bonus = self:GetParent():GetPhysicalArmorValue() * value
    self.flag = false
    return bonus
end

function modifier_special_bonus_armor_pct_10:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS  
    }
	return funcs
end