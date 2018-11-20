LinkLuaModifier ("modifier_flash_kulak", "heroes/flash/flash_kulak", LUA_MODIFIER_MOTION_NONE)

if flash_kulak == nil then
	flash_kulak = class({})
end

function flash_kulak:GetIntrinsicModifierName()
	return "modifier_flash_kulak"
end	

if modifier_flash_kulak == nil then
	modifier_flash_kulak = class({})
end

function modifier_flash_kulak:RemoveOnDeath()
	return true
end

function modifier_flash_kulak:IsHidden()
	return true
end

function modifier_flash_kulak:IsPurgeException()
	return false
end

function modifier_flash_kulak:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK
	}
	return funcs
end	

function modifier_flash_kulak:OnAttack(params) 
	if params.attacker == self:GetCaster() then
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_6") then
			chance = chance + self:GetCaster():ComicsVsAnimeTalent("special_bonus_flash_6")
		end
		if IsServer() and self:GetAbility():IsCooldownReady() and RollPercentage(chance) and not params.target:IsBuilding() and not params.target:IsBosses() then
			local damage = self:GetAbility():GetSpecialValueFor("damage_movespeed")
			if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_5") then
				damage = damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_flash_5")
			end 
			local damageTable = 
				{
					victim = params.target,
					attacker = self:GetCaster(),
					damage = self:GetCaster():GetIdealSpeed()/100 * damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
				}
			ApplyDamage(damageTable)
			local dur = self:GetAbility():GetSpecialValueFor("duration_stunned")
			params.target:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{duration = dur})
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		end
	end
end
