loki_blink_strike = loki_blink_strike or class({})
LinkLuaModifier ("modifier_loki_blink_strike_critical", "heroes/loki/loki_blink_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_loki_blink_strike_slow", "heroes/loki/loki_blink_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_loki_blink_strike_smoke", "heroes/loki/loki_blink_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_loki_blink_strike_smoke_dmg", "heroes/loki/loki_blink_strike", LUA_MODIFIER_MOTION_NONE)
function loki_blink_strike:OnSpellStart()
	if self:GetCursorTarget() ~= self:GetCaster() then
		self:GetCaster():SetAbsOrigin(self:GetCursorTarget():ComicsVsAnimeBackHero())
		FindClearSpaceForUnit(self:GetCaster(), self:GetCursorTarget():ComicsVsAnimeBackHero(), true)
	else
		self:EndCooldown()
		self:GetCaster():SetMana(self:GetCaster():GetMana() + self:GetManaCost(self:GetLevel()))
		return false
	end
	if self:GetCursorTarget():GetTeam() ~= self:GetCaster():GetTeam() then
		-- Add Particle
        local particle = ParticleManager:CreateParticle( "particles/loki/comics_vs_anime_loki_blink_strike.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
    	ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
    	ParticleManager:SetParticleControlEnt( particle, 1, self:GetCursorTarget(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( particle, 2, self:GetCursorTarget(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( particle, 3, self:GetCursorTarget(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( particle, 4, self:GetCursorTarget(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetOrigin(), true );
    	ParticleManager:ReleaseParticleIndex( particle )
		-- Add Damage
		local damage = self:GetSpecialValueFor("damage")
		local dur_slow = self:GetSpecialValueFor("dur_slow")
		local damage_table =
		{
			victim = self:GetCursorTarget(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}
		ApplyDamage(damage_table)
		-- Add Modifier Critical Damage
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_loki_blink_strike_critical",{duration = 1.2})
		self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_loki_blink_strike_slow",{duration = dur_slow})
		--Talent Smoke
		local talentName = "special_bonus_loki_1"
		if self:GetCaster():ComicsVsAnimeHasTalent(talentName) then
			local radius = self:GetCaster():ComicsVsAnimeTalent(talentName,nil,"radius")
			local duration = self:GetCaster():ComicsVsAnimeTalent(talentName,nil,"duration")
			CreateModifierThinker(self:GetCaster(),self,"modifier_loki_blink_strike_smoke", {duration = duration, radius = radius},  self:GetCursorTarget():GetOrigin(), self:GetCaster():GetTeamNumber(), false)
		end
	end
end

---------------------------------------------------
-- LOKI CRITICAL ATTACK
---------------------------------------------------
modifier_loki_blink_strike_critical = modifier_loki_blink_strike_critical or class({})

function modifier_loki_blink_strike_critical:RemoveOnDeath() return true end
function modifier_loki_blink_strike_critical:IsHidden() return true end
function modifier_loki_blink_strike_critical:IsPurgeException() return false end
function modifier_loki_blink_strike_critical:OnCreated() 
	if IsServer() then
		self.critical = self:GetAbility():GetSpecialValueFor("critical_damage")
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_loki_6") then
			self.critical = self.critical + self:GetCaster():ComicsVsAnimeTalent("special_bonus_loki_6")
		end 
	end
end 
function modifier_loki_blink_strike_critical:DeclareFunctions()
	local funcs =
	{	
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end
	
function modifier_loki_blink_strike_critical:GetModifierPreAttack_CriticalStrike()
	self:Destroy()
	return self.critical
end	
---------------------------------------------------
-- BLINK SLOW MOVESPEED
---------------------------------------------------
modifier_loki_blink_strike_slow = modifier_loki_blink_strike_slow or class({})

function modifier_loki_blink_strike_slow:RemoveOnDeath() return true end
function modifier_loki_blink_strike_slow:IsHidden() return false end
function modifier_loki_blink_strike_slow:IsPurgeException() return false end

function modifier_loki_blink_strike_slow:DeclareFunctions()
	local funcs =
	{	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_loki_blink_strike_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end	

---------------------------------------------------
-- TALENT MODIFIERS
---------------------------------------------------

modifier_loki_blink_strike_smoke = modifier_loki_blink_strike_smoke or class({})
function modifier_loki_blink_strike_smoke:RemoveOnDeath()		return true 										end
function modifier_loki_blink_strike_smoke:IsHidden() 			return true 										end
function modifier_loki_blink_strike_smoke:IsPurgable() 			return false 										end
function modifier_loki_blink_strike_smoke:IsAura() 				return true 										end
function modifier_loki_blink_strike_smoke:GetAuraSearchFlags() 	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES 	end
function modifier_loki_blink_strike_smoke:GetAuraSearchType()	return self:GetAbility():GetAbilityTargetType() 	end
function modifier_loki_blink_strike_smoke:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_ENEMY 					end
function modifier_loki_blink_strike_smoke:GetModifierAura()		return "modifier_loki_blink_strike_smoke_dmg" 		end
function modifier_loki_blink_strike_smoke:GetAuraRadius() 		return self.radius 									end
function modifier_loki_blink_strike_smoke:OnCreated(kv)
	self.radius  = kv.radius
	self.particle =  ParticleManager:CreateParticle( "particles/loki/comics_vs_anime_loki_blink_strike_talent.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, self.radius, self.radius))
end

function modifier_loki_blink_strike_smoke:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, false)
end

modifier_loki_blink_strike_smoke_dmg = class({})

function modifier_loki_blink_strike_smoke_dmg:RemoveOnDeath() return true end
function modifier_loki_blink_strike_smoke_dmg:IsHidden() return true end
function modifier_loki_blink_strike_smoke_dmg:IsPurgable() return false end

modifier_special_bonus_loki_5 = modifier_special_bonus_loki_5 or class({})

function modifier_special_bonus_loki_5:RemoveOnDeath() return true end
function modifier_special_bonus_loki_5:IsHidden() return true end
function modifier_special_bonus_loki_5:IsPurgable() return false end
function modifier_special_bonus_loki_5:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("special_bonus_loki_5")
		if ability then
			local count_max = ability:GetSpecialValueFor("num_charges")
			local cooldown =  ability:GetSpecialValueFor("charges_cooldown")
			ComicsVsAnimeCharges(caster, "loki_blink_strike", count_max, count_max, cooldown, "modifier_charges")
		end
	end
end 