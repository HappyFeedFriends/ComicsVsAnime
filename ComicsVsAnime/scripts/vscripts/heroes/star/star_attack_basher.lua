LinkLuaModifier("modifier_star_basher_passive", "heroes/star/star_attack_basher", LUA_MODIFIER_MOTION_NONE)
if star_attack_basher == nil then
	star_attack_basher = class({})
end

function star_attack_basher:GetIntrinsicModifierName()
    return "modifier_star_basher_passive"
end

	
modifier_star_basher_passive = class({})

function modifier_star_basher_passive:IsHidden()
	return true 
end

function modifier_star_basher_passive:IsPurgable() 
	return false
end

function modifier_star_basher_passive:RemoveOnDeath()
	return false
end

function modifier_star_basher_passive:DeclareFunctions()
local funcs = {MODIFIER_EVENT_ON_ATTACK}
	return funcs
end

function modifier_star_basher_passive:OnAttack(params)
	if params.attacker == self:GetCaster() then
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		chance = self:GetCaster():BonusTalentValue("special_bonus_star_5",chance)
		local target = params.target
		local dur = self:GetAbility():GetSpecialValueFor("duration")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		damage = self:GetCaster():BonusTalentValue("special_bonus_star_4",damage)
		local damageTable = {victim = target,attacker = self:GetCaster(),damage = damage,damage_type = self:GetAbility():GetAbilityDamageType()}
		if self:GetAbility():IsCooldownReady() then
			target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = dur}) 
			ApplyDamage(damageTable)
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		elseif RollPercentage(chance) == true then
			target:AddNewModifier( caster, self:GetAbility(), "modifier_stunned", {duration = dur}) 
			ApplyDamage(damageTable)
		end	
	end
end	