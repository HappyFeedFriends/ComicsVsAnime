loki_poison = loki_poison or class({})

LinkLuaModifier ("modifier_loki_poison", "heroes/loki/loki_poison", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_loki_poison_debuff", "heroes/loki/loki_poison", LUA_MODIFIER_MOTION_NONE)

function loki_poison:GetIntrinsicModifierName()
	return "modifier_loki_poison"
end	

modifier_loki_poison = modifier_loki_poison or class({})

function modifier_loki_poison:RemoveOnDeath()return true end
function modifier_loki_poison:IsHidden()return true end
function modifier_loki_poison:IsPurgeException()return false end

function modifier_loki_poison:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_loki_poison:OnAttackLanded(params)
	if IsServer() and self:GetAbility():IsCooldownReady() and params.attacker == self:GetCaster() then 
		local dur = self:GetAbility():GetSpecialValueFor("duration")
		local slow = self:GetAbility():GetSpecialValueFor("slowdown")
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_loki_8") then
			slow = slow + self:GetCaster():ComicsVsAnimeTalent("special_bonus_loki_8")
		end
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		params.target:AddStackModifier(self:GetAbility(),"modifier_loki_poison_debuff",dur,slow,0)
	end
end 

modifier_loki_poison_debuff = modifier_loki_poison_debuff or class({})

function modifier_loki_poison_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
	return funcs
end	
 
function modifier_loki_poison_debuff:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("blind")
end 

function modifier_loki_poison_debuff:OnCreated(kv)
	self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("interval") )
	self.slow = kv.slow
end		

function modifier_loki_poison_debuff:OnIntervalThink()
	if IsServer() then
		local damage_per = self:GetAbility():GetSpecialValueFor("damage")
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_loki_3") then
			damage_per = damage_per + self:GetCaster():ComicsVsAnimeTalent("special_bonus_loki_3")
		end	
		local damage = (damage_per * self:GetAbility():GetSpecialValueFor("interval")) / self:GetAbility():GetSpecialValueFor("duration")
		local damage_table =
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
		}
		ApplyDamage(damage_table)
	end
end 

function modifier_loki_poison_debuff:GetModifierMoveSpeedBonus_Constant()
	return -self:GetStackCount()
end	