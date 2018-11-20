-----------------------------------------------------
-- TOWER ABILITY 1
-----------------------------------------------------

LinkLuaModifier("modifier_tower_tier_4_1", "heroes/tower_ability/tower_ability_lvl4", LUA_MODIFIER_MOTION_NONE)
tower_tier_4_1 = class({})

function tower_tier_4_1:GetIntrinsicModifierName()
	return "modifier_tower_tier_4_1"
end
	
modifier_tower_tier_4_1 = class({})

function modifier_tower_tier_4_1:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier_4_1:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_4_1:IsHidden()
	return true
end

function modifier_tower_tier_4_1:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}

	return decFuncs
end

function modifier_tower_tier_4_1:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen_health") + GameRules:GetGameTime()/60 * self:GetAbility():GetSpecialValueFor("bonus_heal")
end

-----------------------------------------------------
-- TOWER ABILITY 2
-----------------------------------------------------
LinkLuaModifier("modifier_tower_tier_4_2", "heroes/tower_ability/tower_ability_lvl4", LUA_MODIFIER_MOTION_NONE)
modifier_tower_tier_4_2 = class({})

function modifier_tower_tier_4_2:OnCreated()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
end

function modifier_tower_tier_4_2:OnRefresh()
	self:OnCreated()
end

function modifier_tower_tier_4_2:IsHidden()
	return true
end

function modifier_tower_tier_4_2:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

function tower_tier_4_2(keys)
	if keys.ability:IsCooldownReady() and IsServer() then
		local ability = keys.ability
		local caster = keys.caster
		local target = keys.target
		local dur = ability:GetSpecialValueFor("duration")
		local radius_search =  ability:GetSpecialValueFor("aura_radius")
		local min_hero = ability:GetSpecialValueFor("min_hero")
		local unites = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius_search,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(unites) do
			enemy:AddNewModifier(caster,ability,"modifier_tower_tier_4_2",{duration = dur})
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end	
	end
end

-----------------------------------------------------
-- TOWER ABILITY 3
-----------------------------------------------------

LinkLuaModifier("modifier_tower_tier_4_3", "heroes/tower_ability/tower_ability_lvl4", LUA_MODIFIER_MOTION_NONE)
modifier_tower_tier_4_3 = class({})

function modifier_tower_tier_4_3:OnCreated()
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self.particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_tower_damage.vpcf", PATTACH_POINT_FOLLOW, self:GetParent()) 
		ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:StartIntervalThink(interval)
end

function modifier_tower_tier_4_3:OnIntervalThink()
	if IsServer() and self:GetCaster():IsAlive() then
	local max_distance = self:GetAbility():GetSpecialValueFor("aura_radius")
	local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
	local damage = self:GetAbility():GetSpecialValueFor("damage")
		if distance > max_distance then
			self:GetParent():RemoveModifierByName("modifier_tower_tier_4_3")
			--self:Destroy()
		end
		local DamageTable = 
		{
			attacker = self:GetCaster(), 
			victim = self:GetParent(), 
			ability = self:GetAbility(), 
			damage = damage,  
			damage_type = self:GetAbility():GetAbilityDamageType(),
		}
		ApplyDamage(DamageTable)
	else
		self:Destroy()
	end	
end

function modifier_tower_tier_4_3:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex( self.particle )
end


function modifier_tower_tier_4_3:IsHidden()
	return true
end

function tower_tier_4_3(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("aura_radius") + 20
	local unites = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	for _,targets in pairs(unites) do
		if not targets:HasModifier("modifier_tower_tier_4_3") then
			targets:AddNewModifier(caster,ability,"modifier_tower_tier_4_3",{duration = -1})
		end
	end
end
-----------------------------------------------------
-- TOWER ABILITY 4
-----------------------------------------------------
function tower_tier_4_4(keys)
	if keys.ability:IsCooldownReady() then
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local hp = caster:GetMaxHealth()
		local min_hp = ability:GetSpecialValueFor("min_hp")
		local hp_perc = hp/100 * min_hp
		if caster:GetHealth() <= hp_perc then
			ComicsVsAnimeHeal(caster:GetMaxHealth()-caster:GetHealth(),caster)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end
	
	