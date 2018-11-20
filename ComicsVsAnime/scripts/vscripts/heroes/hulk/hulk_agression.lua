if hulk_agression == nil then 
	hulk_agression = class({}) 
end
LinkLuaModifier( "modifier_special_bonus_hulk_2", "heroes/hulk/hulk_agression", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hulk_agression", "heroes/hulk/hulk_agression", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hulk_attack_team", "heroes/hulk/hulk_agression", LUA_MODIFIER_MOTION_NONE )

function hulk_agression:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor( "duration" )
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_hulk_2") and self:GetCaster():ComicsVsAnimeTalent("special_bonus_hulk_2",nil,nil) > 0 then
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_special_bonus_hulk_2", { duration = duration })
		end
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hulk_agression", { duration = duration })
        for _,v in pairs(HeroList:GetAllHeroes()) do
			if self:GetCaster():GetTeamNumber() == v:GetTeamNumber() and self:GetCaster() ~= v then
				v:AddNewModifier( self:GetCaster(), self, "modifier_hulk_attack_team", { duration = duration })
			end
        end
    end
end

if modifier_hulk_agression == nil then 
	modifier_hulk_agression = class({}) 
end

function modifier_hulk_agression:IsHidden()
	return false
end

function modifier_hulk_agression:IsPurgable()
	return true
end

function modifier_hulk_agression:StatusEffectPriority()
    return 1000
end

function modifier_hulk_agression:GetEffectName()
    return "particles/venom/comics_vs_anime_venom_rage.vpcf"
end

function modifier_hulk_agression:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hulk_agression:SearchTarget()
    if IsServer() then 
        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(),self:GetParent(), 99999, self:GetAbility():GetAbilityTargetTeam(),self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(), FIND_CLOSEST, false )
        if #units > 0 then 
            for k,unit in pairs(units) do
                if unit ~= self:GetParent() and not unit:IsAttackImmune() and not unit:IsInvulnerable() and not unit:IsBosses() and not unit:IsMagicImmune() then
                    print(unit:GetUnitName()) 
                    return unit
                end
            end
        end
    end
    return nil
end

function modifier_hulk_agression:AttackTarget()
    if IsServer() then 
        local order =
		{
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			TargetIndex = self.target:entindex()
		}
        ExecuteOrderFromTable(order)
        
        if self.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then 
            self:GetParent():SetForceAttackTargetAlly(self.target)
        else
            self:GetParent():SetForceAttackTarget(self.target)
        end
    end
end

function modifier_hulk_agression:OnCreated(params)
	if IsServer() then
        self.target = self:SearchTarget()
        if self.target == nil then 
            self:GetAbility():EndCooldown()
			self:GetParent():SetMana(self:GetParent():GetMana() + self:GetAbility():GetManaCost(self:GetAbility():GetLevel()))
            self:Destroy()
		else
			self:GetCaster():SetRenderColor(255, 0, 0)
			local r = RandomInt(1,2)
			if r == 1 then
				EmitSoundOn("ComicsVsAnime.hulk_aggression_2", self:GetCaster())
			else	
				EmitSoundOn("ComicsVsAnime.hulk_aggression_1", self:GetCaster())
			end
        end
        self:StartIntervalThink(0.05)
	end
end

function modifier_hulk_agression:OnDestroy()
	if IsServer() then
        self:GetParent():Interrupt()
		self:GetParent():SetForceAttackTarget(nil)
        self:GetParent():SetForceAttackTargetAlly(nil)
        self:GetParent():Stop()
		self:GetParent():SetRenderColor(255, 255, 255)
		if self:GetParent():HasModifier("modifier_special_bonus_hulk_2") then
			self:GetParent():RemoveModifierByName("modifier_special_bonus_hulk_2")
		end
	end
end

function modifier_hulk_agression:OnIntervalThink()
    if IsServer() then 
        if self.target:IsAlive() == false or self.target:IsAttackImmune() or self.target:IsInvulnerable() or self.target:IsMagicImmune() then 
            self.target = self:SearchTarget()
            if self.target == nil then 
                self:Destroy()
            end
		else
            self:AttackTarget()	
        end
    end
end

function modifier_hulk_agression:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}

	return funcs
end

function modifier_hulk_agression:GetDisableHealing()
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_hulk_3") and self:GetCaster():ComicsVsAnimeTalent("special_bonus_hulk_3",nil,nil) > 0 then
		return 0
	end
	return 1
end	

function modifier_hulk_agression:GetModifierBaseDamageOutgoing_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("damage_bonus_pct")
end

function modifier_hulk_agression:GetModifierExtraHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health")
end	

function modifier_hulk_agression:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_hulk_agression:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = false,
        [MODIFIER_STATE_FAKE_ALLY] = true
	}

	return state
end


if modifier_hulk_attack_team == nil then 
	modifier_hulk_attack_team = class({}) 
end 

function modifier_hulk_attack_team:IsHidden()
	return true
end

function modifier_hulk_attack_team:IsPurgable()
	return false
end

function modifier_hulk_attack_team:RemoveOnDeath()
	return false
end

function modifier_hulk_attack_team:CheckState()
	local state = {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	}

	return state
end

if modifier_special_bonus_hulk_2 == nil then 
	modifier_special_bonus_hulk_2 = class({}) 
end

function modifier_special_bonus_hulk_2:IsHidden()
	return true
end

function modifier_special_bonus_hulk_2:IsPurgable()
	return true
end

function modifier_special_bonus_hulk_2:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_special_bonus_hulk_2:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local sum_damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())	
		local white_damage = (self:GetParent():GetBaseDamageMax() + self:GetParent():GetBaseDamageMin())/2
		local green = sum_damage - white_damage
		self:SetStackCount(green)
	end
end

function modifier_special_bonus_hulk_2:GetModifierPreAttack_BonusDamage()
		 if self.flag then
			 return 0
		 end
		self.flag = true
			local exit_damage = self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_bonus_pct")/100
		self.flag = false
		
    return exit_damage 
end	