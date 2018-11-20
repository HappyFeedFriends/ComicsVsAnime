-----------------------------------------------------
-- TOWER ABILITY 1
-----------------------------------------------------
function tower_tier_3_1(keys)
	if keys.ability:IsCooldownReady() then
		local ability = keys.ability
		local caster = keys.caster
		local target = keys.target
		local radius = ability:GetSpecialValueFor("aura_radius")
		local healing = ability:GetSpecialValueFor("healing")
		local mana_heal = ability:GetSpecialValueFor("mana_regen")
		local healing_creep = ability:GetSpecialValueFor("healing_creep")/100
		local min_creep = ability:GetSpecialValueFor("min_creep")
		local unites = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),nil,radius,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		for _,hero in pairs(unites) do
			if hero:GetHealth() <= hero:GetMaxHealth() - hero:GetMaxHealth()/100 * healing then
				if hero:IsHero() then
					local heal = hero:GetMaxHealth()/100 * healing
					local particle_heal = ParticleManager:CreateParticle("particles/strange/comics_vs_anime_shield_healing_osnova.vpcf", PATTACH_POINT_FOLLOW, hero) 
					ParticleManager:SetParticleControlEnt(particle_heal, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
					ParticleManager:SetParticleControlEnt(particle_heal, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_heal)
					ComicsVsAnimeHeal(heal,hero)
					ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
				end
				if hero:IsCreep() and #hero > min_creep then
					local heal = (hero:GetMaxHealth()/100 * healing) * healing_creep
					local particle_heal = ParticleManager:CreateParticle("particles/strange/comics_vs_anime_shield_healing_osnova.vpcf", PATTACH_POINT_FOLLOW, hero) 
					ParticleManager:SetParticleControlEnt(particle_heal, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
					ParticleManager:SetParticleControlEnt(particle_heal, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_heal)
					ComicsVsAnimeHeal(heal,hero)
					ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
				end
			end
			if hero:GetMana() <= hero:GetMaxMana() -  mana_heal and hero:IsHero() then
					local particle_mana = ParticleManager:CreateParticle("particles/strange/comics_vs_anime_shield_healing_osnova.vpcf", PATTACH_POINT_FOLLOW, hero) 
					ParticleManager:SetParticleControlEnt(particle_mana, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
					ParticleManager:SetParticleControlEnt(particle_mana, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_mana)
					hero:ComicsVsAnimeMana(mana_heal,1,nil)
					ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			end
		end
	end
end

-----------------------------------------------------
-- TOWER ABILITY 2
-----------------------------------------------------

LinkLuaModifier("modifier_tower_tier_3_2", "heroes/tower_ability/tower_ability_lvl3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_tier_3_2_buff", "heroes/tower_ability/tower_ability_lvl3", LUA_MODIFIER_MOTION_NONE)
tower_tier_3_2 = class({})

function tower_tier_3_2:GetIntrinsicModifierName()
	return "modifier_tower_tier_3_2"
end


modifier_tower_tier_3_2 = class({})

function modifier_tower_tier_3_2:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_tower_tier_3_2:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_3_2:GetAuraRadius()
	return self.aura_radius
end

function modifier_tower_tier_3_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_tower_tier_3_2:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_tower_tier_3_2:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_tower_tier_3_2:GetModifierAura()
	return "modifier_tower_tier_3_2_buff"
end

function modifier_tower_tier_3_2:IsAura()
	return true
end

function modifier_tower_tier_3_2:IsDebuff()
	return false
end

function modifier_tower_tier_3_2:IsHidden()
	return true
end
modifier_tower_tier_3_2_buff = class({})

function modifier_tower_tier_3_2_buff:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier_3_2_buff:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_3_2_buff:IsHidden()
	return true
end

function modifier_tower_tier_3_2_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_DISABLE_HEALING}

	return decFuncs
end

function modifier_tower_tier_3_2_buff:GetDisableHealing()
	return 1
end
-----------------------------------------------------
-- TOWER ABILITY 3
-----------------------------------------------------

LinkLuaModifier("modifier_tower_tier_3_3", "heroes/tower_ability/tower_ability_lvl3", LUA_MODIFIER_MOTION_NONE)
tower_tier_3_3 = class({})

function tower_tier_3_3:GetIntrinsicModifierName()
	return "modifier_tower_tier_3_3"
end
	
modifier_tower_tier_3_3 = class({})

function modifier_tower_tier_3_3:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier_3_3:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_3_3:IsHidden()
	return true
end

function modifier_tower_tier_3_3:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_tower_tier_3_3:OnTakeDamage(event)
	if IsServer() and event.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and event.unit == self:GetParent() then
		local attacker = event.attacker
		local damageTable =
		{
			victim = attacker,
			attacker = self:GetCaster(),
			damage = event.damage/100 * self:GetAbility():GetSpecialValueFor("return_damage"),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		}
		ApplyDamage(damageTable)
	end
end
