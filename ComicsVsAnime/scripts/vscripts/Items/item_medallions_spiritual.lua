item_medallions_spiritual = item_medallions_spiritual or class({})
LinkLuaModifier("modifier_medallions_spiritual", "items/item_medallions_spiritual", LUA_MODIFIER_MOTION_NONE)

function item_medallions_spiritual:GetIntrinsicModifierName()
	return "modifier_medallions_spiritual"
end 

modifier_medallions_spiritual = modifier_medallions_spiritual or class({})

function modifier_medallions_spiritual:OnCreated()
	if IsServer() then
		self:GetCaster():BonusCustomResistance("SPIRITUAL",self:GetAbility():GetSpecialValueFor("block_spiritual"))
	end
end 

function modifier_medallions_spiritual:OnDestroy()
	self:GetCaster():BonusCustomResistance("SPIRITUAL",self:GetAbility():GetSpecialValueFor("block_spiritual") * (-1))
end 

function modifier_medallions_spiritual:IsHidden() 
	return true 
end
function modifier_medallions_spiritual:IsPurgable() 
	return false 
 end
 
function modifier_medallions_spiritual:IsDebuff() 
	return false 
end

function modifier_medallions_spiritual:RemoveOnDeath() 
	return false 
end

function modifier_medallions_spiritual:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,}

	return funcs
end

function modifier_medallions_spiritual:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_amplify")
end

function modifier_medallions_spiritual:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end