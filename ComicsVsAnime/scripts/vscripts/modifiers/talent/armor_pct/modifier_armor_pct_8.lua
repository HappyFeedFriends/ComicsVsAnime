
if 	modifier_special_bonus_armor_pct_8 == nil then 
	modifier_special_bonus_armor_pct_8 = class({}) 
end

function modifier_special_bonus_armor_pct_8:IsHidden ()
    return true
end

function modifier_special_bonus_armor_pct_8:IsPurgable()
	return false
end

function modifier_special_bonus_armor_pct_8:IsPurgeException()
	return false
end

function modifier_special_bonus_armor_pct_8:RemoveOnDeath()
	return false
end


function modifier_special_bonus_armor_pct_8:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local talent = self:GetAbility()
		local value = talent:GetSpecialValueFor("value")
		self.armor_pct = value
		self:SetStackCount(self.armor_pct)
	end
end

function modifier_special_bonus_armor_pct_8:GetModifierPhysicalArmorBonus( params )
  
     if self.flag then
         return 0
     end

    self.flag = true
	local value = self:GetStackCount()/100
    local bonus = self:GetParent():GetPhysicalArmorValue() * value
    self.flag = false
    return bonus
end

function modifier_special_bonus_armor_pct_8:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS  
    }
	return funcs
end