item_katanes_deadpool = class({})
item_left_katana_deadpool = class({})
item_right_katana_deadpool = class({})

LinkLuaModifier("modifier_katana_debuff", "items/item_katanes_deadpool", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_katana_buff", "items/item_katanes_deadpool", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_katana_and_katana", "items/item_katanes_deadpool", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_katanes_disables", "items/item_katanes_deadpool", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_left_katana", "items/item_katanes_deadpool", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_right_katana", "items/item_katanes_deadpool", LUA_MODIFIER_MOTION_NONE)

function item_katanes_deadpool:GetIntrinsicModifierName()
	return "modifier_katana_and_katana"
end

function item_left_katana_deadpool:GetIntrinsicModifierName()
	return "modifier_left_katana"
end

function item_right_katana_deadpool:GetIntrinsicModifierName()
	return "modifier_right_katana"
end

function item_katanes_deadpool:OnSpellStart()
	if IsServer() and not self:GetCursorTarget():TriggerSpellAbsorb( self ) then
		local dur = self:GetSpecialValueFor("dur_active")
		if not self:GetCursorTarget():TriggerSpellAbsorb(self)  then
			self:GetCursorTarget():AddNewModifier(caster, self, "modifier_katanes_disables",{duration = dur} )
		end
	end
end

modifier_left_katana = class({})

function modifier_left_katana:IsHidden() 
	return true 
end

function modifier_left_katana:RemoveOnDeath() 
	return false 
end

function modifier_left_katana:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return funcs
end


function modifier_left_katana:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_left_katana:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_left_katana:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_left_katana:OnAttackLanded( params )
	if params.attacker == self:GetCaster() and not self:GetCaster():IsIllusion() then
		local caster = self:GetParent()
		local target = params.target
		local ability = self:GetAbility()
		local debuff = "modifier_katana_debuff"
		local buff = "modifier_katana_buff"
		local dur = ability:GetSpecialValueFor("duration")
		if target:HasModifier(debuff)  then
			local current_stack = target:GetModifierStackCount( debuff, ability )
			target:SetModifierStackCount( debuff, ability, current_stack + 1  )
			target:FindModifierByName(debuff):SetDuration(dur, true)
			Timers:CreateTimer(dur, function()
			local current_stack = target:GetModifierStackCount( debuff, ability )
				if target:HasModifier(debuff) and current_stack > 0 then
					target:SetModifierStackCount( debuff, ability, current_stack - 1  )
				end    
			end)
		else
			target:AddNewModifier(caster, ability, debuff,{duration = dur} )
			target:SetModifierStackCount( debuff, ability, 1  )
		end	
	end
end

modifier_right_katana = class({})

function modifier_right_katana:IsHidden() 
	return true 
end

function modifier_right_katana:RemoveOnDeath() 
	return false 
end

function modifier_right_katana:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return funcs
end


function modifier_right_katana:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_right_katana:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_right_katana:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_right_katana:OnAttackLanded( params )
	if params.attacker == self:GetCaster() and not self:GetCaster():IsIllusion() then
		local caster = self:GetParent()
		local target = params.target
		local ability = self:GetAbility()
		local debuff = "modifier_katana_debuff"
		local buff = "modifier_katana_buff"
		local dur = ability:GetSpecialValueFor("duration")
		if caster:HasModifier(buff) then
			local current_stack = caster:GetModifierStackCount( buff, ability )
			caster:SetModifierStackCount( buff, ability, current_stack + 1  )
			caster:FindModifierByName(buff):SetDuration(dur, true)
			Timers:CreateTimer(dur, function()
				local current_stack = caster:GetModifierStackCount( buff, ability )
				if caster:HasModifier(buff) and current_stack > 0 then
					caster:SetModifierStackCount( buff, ability, current_stack - 1  )
				end    
			end)
		else
			caster:AddNewModifier(caster, ability, buff,{duration = dur} )
			caster:SetModifierStackCount( buff, ability, 1  )
		end	
	end
end

modifier_katana_and_katana = class({})

function modifier_katana_and_katana:IsHidden() 
	return true 
end

function modifier_katana_and_katana:RemoveOnDeath() 
	return false 
end

function modifier_katana_and_katana:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return funcs
end


function modifier_katana_and_katana:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_katana_and_katana:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_katana_and_katana:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_katana_and_katana:OnAttackLanded( params )
	if params.attacker == self:GetCaster() and not self:GetCaster():IsIllusion() then
		local caster = self:GetParent()
		local target = params.target
		local ability = self:GetAbility()
		local debuff = "modifier_katana_debuff"
		local buff = "modifier_katana_buff"
		local dur = ability:GetSpecialValueFor("duration")
		if target:HasModifier(debuff)  then
			local current_stack = target:GetModifierStackCount( debuff, ability )
			target:SetModifierStackCount( debuff, ability, current_stack + 1  )
			target:FindModifierByName(debuff):SetDuration(dur, true)
			Timers:CreateTimer(dur, function()
			local current_stacks = target:GetModifierStackCount( debuff, ability )
				if target:HasModifier(debuff) and current_stacks > 0 then
					target:SetModifierStackCount( debuff, ability, current_stacks - 1  )
				end    
			end)
		else
			target:AddNewModifier(caster, ability, debuff,{duration = dur} )
			target:SetModifierStackCount( debuff, ability, 1  )
		end
		if caster:HasModifier(buff) then
			local current_stack = caster:GetModifierStackCount( buff, ability )
			caster:SetModifierStackCount( buff, ability, current_stack + 1  )
			caster:FindModifierByName(buff):SetDuration(dur, true)
			Timers:CreateTimer(dur, function()
				local current_stack = caster:GetModifierStackCount( buff, ability )
				if caster:HasModifier(buff) and current_stack > 0 then
					caster:SetModifierStackCount( buff, ability, current_stack - 1  )
				end    
			end)
		else
			caster:AddNewModifier(caster, ability, buff,{duration = dur} )
			caster:SetModifierStackCount( buff, ability, 1  )
		end	
	end
end

modifier_katana_debuff = class({})

function modifier_katana_debuff:IsHidden() 
	return false 
end

function modifier_katana_debuff:RemoveOnDeath() 
	return true 
end

function modifier_katana_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return funcs
end

function modifier_katana_debuff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage_attack") * self:GetStackCount() * (-1)
end

function modifier_katana_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * self:GetStackCount() * (-1)
end	

modifier_katana_buff = class({})

function modifier_katana_buff:IsHidden() 
	return false 
end

function modifier_katana_buff:RemoveOnDeath() 
	return true 
end

function modifier_katana_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return funcs
end

function modifier_katana_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage_attack") * self:GetStackCount()
end

function modifier_katana_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * self:GetStackCount()
end

modifier_katanes_disables = class({})

function modifier_katanes_disables:IsHidden() 
	return false 
end

function modifier_katanes_disables:OnCreated()
	self.particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_purge_root_ring_rev.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_katanes_disables:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex( self.particle) 
end

function modifier_katanes_disables:RemoveOnDeath() 
	return true 
end

function modifier_katanes_disables:CheckState()
    local state = {
    [MODIFIER_STATE_MUTED] = true,
    [MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_INVISIBLE] = false,
	[MODIFIER_STATE_NIGHTMARED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_DISARMED] = true,
    }

    return state
end