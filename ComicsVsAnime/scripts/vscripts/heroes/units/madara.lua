madara_health_bonus = madara_health_bonus or class({})

LinkLuaModifier ("modifier_madara_health_bonus", "heroes/units/madara", LUA_MODIFIER_MOTION_NONE)

function madara_health_bonus:GetIntrinsicModifierName()
	return "modifier_madara_health_bonus"
end

modifier_madara_health_bonus = modifier_madara_health_bonus or class({})

function modifier_madara_health_bonus:RemoveOnDeath()return true end

function modifier_madara_health_bonus:IsHidden()return false end

function modifier_madara_health_bonus:IsPurgeException()return false end

function modifier_madara_health_bonus:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_BONUS}
end

function modifier_madara_health_bonus:GetModifierHealthBonus()
	return 20000--GameRules:GetGameTime()/60 * self:GetAbility():GetSpecialValueFor("health_bonus")
end	