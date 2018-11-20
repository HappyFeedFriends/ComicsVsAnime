LinkLuaModifier ("modifier_flash_double_attack", "heroes/flash/flash_double_attack", LUA_MODIFIER_MOTION_NONE)

if flash_double_attack == nil then
	flash_double_attack = class({})
end

function flash_double_attack:GetIntrinsicModifierName()
	return "modifier_flash_double_attack"
end	

if modifier_flash_double_attack == nil then
	modifier_flash_double_attack = class({})
end

function modifier_flash_double_attack:RemoveOnDeath()
	return true
end

function modifier_flash_double_attack:IsHidden()
	return true
end

function modifier_flash_double_attack:IsPurgeException()
	return false
end

function modifier_flash_double_attack:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end	

function modifier_flash_double_attack:OnAttackLanded(params)
	if IsServer() and self:GetAbility():IsCooldownReady() and params.attacker == self:GetCaster() then	
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		local num = self:GetAbility():GetSpecialValueFor("attack_num")
		local dur = 0
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_3") then
			num = num + self:GetCaster():ComicsVsAnimeTalent("special_bonus_flash_3",nil,nil)
		end
		for k=1,num,1 do
			Timers:CreateTimer(dur, function()
				self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
				self:GetParent():PerformAttack( params.target, true, true, true, true, true, false, true )
			end)
			dur = dur + 0.1
		end
	end
end