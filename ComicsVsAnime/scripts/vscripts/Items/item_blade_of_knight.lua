item_blade_of_knight_1 = class({})

LinkLuaModifier("modifier_blade_of_knight", "items/item_blade_of_knight", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_blade_of_knight_silence", "items/item_blade_of_knight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blade_of_knight_crit", "items/item_blade_of_knight", LUA_MODIFIER_MOTION_NONE)

function item_blade_of_knight_1:GetIntrinsicModifierName()
	return "modifier_blade_of_knight"
end

function item_blade_of_knight_1:OnSpellStart()
	if IsServer() and not self:GetCursorTarget():TriggerSpellAbsorb( self ) then
	local dur = self:GetSpecialValueFor("duration")
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_blade_of_knight_silence", {duration = dur})
	end
end

modifier_blade_of_knight_silence = class({})

function modifier_blade_of_knight_silence:IsHidden() 
	return false 
end
function modifier_blade_of_knight_silence:IsPurgable() 
	return true 
 end
 
function modifier_blade_of_knight_silence:IsDebuff() 
	return true 
end

function modifier_blade_of_knight_silence:RemoveOnDeath() 
	return true 
end

function modifier_blade_of_knight_silence:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_EVENT_ON_ATTACK_START,MODIFIER_PROPERTY_TOOLTIP }

	return funcs
end

function modifier_blade_of_knight_silence:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("damage_saved")
end

function modifier_blade_of_knight_silence:OnCreated()
	if IsServer() then
		self.particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_silence_2_pink.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self.damage = 0
	end
end

function modifier_blade_of_knight_silence:OnAttackStart(keys)
	local parent = self:GetParent()
	if parent == keys.target then
		local ability = self:GetAbility()
		if not keys.attacker:IsIllusion() then
			keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_blade_of_knight_crit", {duration = 1.5})
		end
	end
end

function modifier_blade_of_knight_silence:OnTakeDamage(event)
	if IsServer() and self:GetParent() == event.unit then
		self.damage = self.damage + (event.damage * self:GetAbility():GetSpecialValueFor("damage_saved")/100)
	end
end

function modifier_blade_of_knight_silence:OnDestroy()
	if IsServer() then
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage(damage)
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex( self.particle)
	end
end

function modifier_blade_of_knight_silence:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end

modifier_blade_of_knight_crit = class({})

function modifier_blade_of_knight_crit:IsHidden() 
	return true 
end
function modifier_blade_of_knight_crit:IsPurgable() 
	return false 
 end
 
function modifier_blade_of_knight_crit:IsDebuff() 
	return false 
end

function modifier_blade_of_knight_crit:RemoveOnDeath() 
	return false 
end

if IsServer() then
	function modifier_blade_of_knight_crit:DeclareFunctions()
		return {
			MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
			MODIFIER_EVENT_ON_ATTACK_LANDED
		}
	end

	function modifier_blade_of_knight_crit:GetModifierPreAttack_CriticalStrike(keys)
		if keys.target == self:GetCaster() and keys.target:HasModifier("modifier_blade_of_knight_silence") then
			return self:GetAbility():GetSpecialValueFor("damage_crit")
		else
			self:Destroy()
		end
	end

	function modifier_blade_of_knight_crit:OnAttackLanded(keys)
		if self:GetParent() == keys.attacker then
			keys.attacker:RemoveModifierByName("modifier_blade_of_knight_crit")
		end
	end
end


modifier_blade_of_knight = class({})

function modifier_blade_of_knight:IsHidden() 
	return true 
end
function modifier_blade_of_knight:IsPurgable() 
	return false 
 end
 
function modifier_blade_of_knight:IsDebuff() 
	return false 
end

function modifier_blade_of_knight:RemoveOnDeath() 
	return false 
end

function modifier_blade_of_knight:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}

	return funcs
end

function modifier_blade_of_knight:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all")
end

function modifier_blade_of_knight:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all")
end

function modifier_blade_of_knight:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all")
end

function modifier_blade_of_knight:GetModifierPreAttack_CriticalStrike(keys)
	if RollPercentage(self:GetAbility():GetSpecialValueFor("chance_crit")) == true and IsServer() and not keys.attacker:IsIllusion() then
		return self:GetAbility():GetSpecialValueFor("damage_crit")
	end
end