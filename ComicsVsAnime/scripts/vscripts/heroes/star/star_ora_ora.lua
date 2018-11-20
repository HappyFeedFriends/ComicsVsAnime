LinkLuaModifier ("modifier_star_ora_ora", "heroes/star/star_ora_ora", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_star_ora_ora_stack", "heroes/star/star_ora_ora", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_star_attacks", "heroes/star/star_ora_ora", LUA_MODIFIER_MOTION_NONE)
if star_ora_ora == nil then
	star_ora_ora = class({})
end

function star_ora_ora:GetAbilityTextureName() 
	local current_stack = self:GetCaster():GetModifierStackCount( "modifier_star_ora_ora_stack", self )
	if current_stack >= self:GetSpecialValueFor("limit") then
		return "custom_ability/star_ora_ora_start"
	end	
	return self.BaseClass.GetAbilityTextureName(self)  
end 

function star_ora_ora:GetBehavior()
local current_stack = self:GetCaster():GetModifierStackCount( "modifier_star_ora_ora_stack", self )
	if current_stack >= self:GetSpecialValueFor("limit") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end	
end

function star_ora_ora:GetChannelTime()
		--[[if self:GetCaster():HasModifier("modifier_special_bonus_star_1") then
			local current_stack = self:GetCaster():GetModifierStackCount( "modifier_star_ora_ora_stack", self )
			local interval = self:GetSpecialValueFor( "interval_attack" )
			print("CHANNEL")
			return current_stack * interval
		end	]]
	return self.BaseClass.GetChannelTime(self)
end

function star_ora_ora:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end
	return true
end

function star_ora_ora:OnSpellStart() 
	local caster = self:GetCaster() 
	local ability = self 
	local target = self:GetCursorTarget()
	local dur = self:GetChannelTime()
	caster:SetAbsOrigin(target:ComicsVsAnimeBackHero())
	FindClearSpaceForUnit(caster, target:ComicsVsAnimeBackHero(), true)
	caster:SetForwardVector(target:GetForwardVector())
	if self.hVictim == nil then
		return
	end
	self.hVictim:AddNewModifier( caster, self, "modifier_star_attacks", { duration = self:GetChannelTime() } )
	self.hVictim:Interrupt()
	EmitSoundOn("ComicsVsAnime.star_ora_ora",self:GetCaster())
end

function star_ora_ora:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_star_attacks" )
	end
end

function star_ora_ora:GetIntrinsicModifierName()
    return "modifier_star_ora_ora"
end

modifier_star_ora_ora_stack = class({})

function modifier_star_ora_ora_stack:IsHidden()
	return false 
end

function modifier_star_ora_ora_stack:IsPurgable() 
	return false
end

function modifier_star_ora_ora_stack:RemoveOnDeath()
	return false
end

function modifier_star_ora_ora_stack:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_star_ora_ora_stack:GetModifierAttackSpeedBonus_Constant()
local movespeed = self:GetAbility():GetSpecialValueFor("bonus_atk")
movespeed = self:GetCaster():BonusTalentValue("special_bonus_star_6",movespeed)
	return  movespeed * self:GetStackCount()
end	

modifier_star_ora_ora = class({})

function modifier_star_ora_ora:IsHidden()
	return true 
end

function modifier_star_ora_ora:IsPurgable() 
	return false
end

function modifier_star_ora_ora:RemoveOnDeath()
	return false
end

function modifier_star_ora_ora:DeclareFunctions()
local funcs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
	return funcs
end

function modifier_star_ora_ora:OnAttackLanded(params)
	if params.attacker == self:GetCaster() and params.target:IsHero() then
		local dur = self:GetAbility():GetSpecialValueFor("duration")
		local limit = self:GetAbility():GetSpecialValueFor("limit")
		local current_stack = self:GetCaster():GetModifierStackCount( "modifier_star_ora_ora_stack", self:GetAbility() )
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_star_1") then
			current_stack = 0
		end
		if current_stack <= (limit - 1) then
			ComicsVsAnimeAddStack(self:GetCaster(), self:GetAbility(),1, 1, "modifier_star_ora_ora_stack", dur, false, true,true,false)
		end
	end
end

modifier_star_attacks = class({})

function modifier_star_attacks:IsDebuff()
	return true
end

function modifier_star_attacks:IsHidden()
	return true
end

function modifier_star_attacks:IsStunDebuff()
	return true
end

function modifier_star_attacks:OnCreated( kv )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "interval_attack" )

	if IsServer() then
		self.damage_atk = 0
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
		if self:GetCaster():HasModifier("modifier_star_ora_ora_stack") then
			self:GetCaster():RemoveModifierByName("modifier_star_ora_ora_stack") 
		end	
	end
end

function modifier_star_attacks:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
		StopSoundOn("ComicsVsAnime.star_ora_ora",self:GetCaster())
	end
end

function modifier_star_attacks:OnIntervalThink()
	if IsServer() then
		self.damage_atk = self.damage_atk + self:GetAbility():GetSpecialValueFor("damage_per_attack")
		local damage_attacks = self:GetAbility():GetSpecialValueFor("damage_attacks")
		damage_attacks = self:GetCaster():BonusTalentValue("special_bonus_star_3",damage_attacks)
		local damage = self:GetCaster():GetAttackDamage()/100 * damage_attacks
		if self:GetCaster():HasScepter() then
			self.damage_atk = self.damage_atk + self:GetAbility():GetSpecialValueFor("damage_bonus_scepter")
			damage = damage + self.damage_atk
		end
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
		local damage1 = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		}
		ApplyDamage( damage1 )
	end
end

function modifier_star_attacks:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_star_attacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_star_attacks:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

modifier_special_bonus_star_1 = class({})

function modifier_special_bonus_star_1:IsHidden()
	return false 
end

function modifier_special_bonus_star_1:IsPurgable() 
	return false
end

function modifier_special_bonus_star_1:RemoveOnDeath()
	return false
end