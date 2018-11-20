
if 	modifier_reduction_armor_desolator2 == nil then 
	modifier_reduction_armor_desolator2 = class({}) 
end

function modifier_reduction_armor_desolator2:IsHidden ()
    return false
end

function modifier_reduction_armor_desolator2:IsPurgable()
	return false
end

function modifier_reduction_armor_desolator2:RemoveOnDeath()
	return true
end

function modifier_reduction_armor_desolator2:IsDebuff()
	return true
end

function modifier_reduction_armor_desolator2:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local value = 1
		self.value = value
	    self:SetStackCount(self.value)
	end
end

function modifier_reduction_armor_desolator2:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS       
    }
	return funcs
end
function modifier_reduction_armor_desolator2:GetModifierPhysicalArmorBonus( params )
  
     if self.flag then
         return 0
     end

    self.flag = true
	local value = self:GetStackCount()/100
    local bonus = self:GetParent():GetPhysicalArmorValue() * value
    self.flag = false
    return -bonus
end
