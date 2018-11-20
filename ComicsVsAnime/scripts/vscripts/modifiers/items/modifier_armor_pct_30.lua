
if 	modifier_armor_pct_30 == nil then 
	modifier_armor_pct_30 = class({}) 
end

function modifier_armor_pct_30:IsHidden ()
    return false
end

function modifier_armor_pct_30:IsPurgable()
	return false
end

function modifier_armor_pct_30:RemoveOnDeath()
	return false
end


function modifier_armor_pct_30:GetModifierPhysicalArmorBonus( params )
  
     if self.flag then
         return 0
     end

    self.flag = true
    local bonus = self:GetParent():GetPhysicalArmorValue() * 0.3
    self.flag = false
    return bonus
end

function modifier_armor_pct_30:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS  
    }
	return funcs
end