LinkLuaModifier ("modifier_rem_gates_aura", "heroes/rem/rem_gates", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_rem_gates", "heroes/rem/rem_gates", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_rem_gates_buff", "heroes/rem/rem_gates", LUA_MODIFIER_MOTION_NONE)
if rem_gates == nil then
	rem_gates = class({})
end

function rem_gates:GetIntrinsicModifierName()
    return "modifier_rem_gates_aura"
end

modifier_rem_gates_aura = class({})

function modifier_rem_gates_aura:IsHidden()
	return true 
end
function modifier_rem_gates_aura:IsAura() 	
	return true
end

function modifier_rem_gates_aura:IsPurgable() 
	return false
end

function modifier_rem_gates_aura:GetModifierAura()
	return "modifier_rem_gates" 
end

function modifier_rem_gates_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_rem_gates_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_rem_gates_aura:GetAuraRadius()
local radius = self:GetAbility():GetSpecialValueFor("radius")
radius = self:GetCaster():BonusTalentValue("special_bonus_rem_4",radius)
	return radius
end


modifier_rem_gates = class({})

function modifier_rem_gates:IsDebuff() 
	return true 
end

function modifier_rem_gates:IsHidden() 
	return true 
end

function modifier_rem_gates:IsPurgable() 
	return false 
 end

function modifier_rem_gates:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_rem_gates:OnDeath(event)
	if IsServer() and self:GetParent() == event.unit and not self:GetParent():IsIllusion() then
		ComicsVsAnimeAddStack(self:GetCaster(), self:GetAbility(),1, 1, "modifier_rem_gates_buff", -1, false, true,true,false)
	end
end


modifier_rem_gates_buff = class({})

function modifier_rem_gates_buff:Isbuff() 
	return true 
end

function modifier_rem_gates_buff:IsHidden() 
	return false 
end

function modifier_rem_gates_buff:IsPurgable() 
	return false 
 end

function modifier_rem_gates_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_rem_gates_buff:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("int") * self:GetStackCount()
end

function modifier_rem_gates_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end
