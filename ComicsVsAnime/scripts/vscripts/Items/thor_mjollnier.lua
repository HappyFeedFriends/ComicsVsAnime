function thor_mjollnier(keys)
	if not  keys.caster:IsIllusion() then
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local chance = ability:GetSpecialValueFor("chance")
		if RollPercentage(chance) == true then
		local damage = 0
		if caster:IsRangedAttacker() then
			damage = ability:GetSpecialValueFor("damage_ranged")
		else
			damage = ability:GetSpecialValueFor("damage_melee")
		end
			local damage_table = { victim = target, 
								attacker = caster,
								damage = damage,
								damage_type = DAMAGE_TYPE_MAGICAL }
			ApplyDamage(damage_table)
			local lightningBolt = ParticleManager:CreateParticle("particles/other/comics_vs_anime_thor_mjollnier.vpcf", PATTACH_POINT_FOLLOW, caster)
			local origin = target:GetAbsOrigin()
				ParticleManager:SetParticleControlEnt(lightningBolt, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
				ParticleManager:SetParticleControlEnt(lightningBolt, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end
	end
end

function thor_mjollnier_activate(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local dur = ability:GetSpecialValueFor("duration_stun")
	local damage = 0
	if caster:IsRangedAttacker() then
		damage = ability:GetSpecialValueFor("damage_ranged")
	else
		damage = ability:GetSpecialValueFor("damage_melee")
	end
	local water_mult = ability:GetSpecialValueFor("Water_Mult")/100
	local unites = FindUnitsInRadius(caster:GetTeamNumber(),
	            caster:GetAbsOrigin(),
	            nil,
	            radius,
	            DOTA_UNIT_TARGET_TEAM_ENEMY,
	            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	            DOTA_UNIT_TARGET_FLAG_NONE,
	            FIND_ANY_ORDER,
	            false)
	for k,targets in pairs(unites) do
		if ComicsVsAnimeMultDamageWater(targets) == true then
			damage = damage + damage * water_mult
		end	
		targets:AddNewModifier( caster, ability, "modifier_stunned", {duration = dur})
		local damage_table = { victim = targets, 
							attacker = caster,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL }
		ApplyDamage(damage_table)
		ParticleManager:CreateParticle("particles/other/comics_vs_anime_thor_mjollnier_activate.vpcf", PATTACH_POINT_FOLLOW, targets)
	end
end

function thor_mjollnier_activate_4(keys)
	if not keys.target:TriggerSpellReflect( keys.ability ) then
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local radius = ability:GetSpecialValueFor("radius")
		local dur = ability:GetSpecialValueFor("duration")
		target:AddNewModifier(caster, ability,"modifier_item_thor_mjollnier_4",{duration = dur})
	end	
end


--------------------------------------------------------------------------------------------
-- Modifier MJOLNIER
--------------------------------------------------------------------------------------------
if modifier_item_thor_mjollnier_4 == nil then 
	modifier_item_thor_mjollnier_4 = class({}) 
end

function modifier_item_thor_mjollnier_4:IsDeBuff()
	return true
end

function modifier_item_thor_mjollnier_4:IsPurgable()
	return true
end



function modifier_item_thor_mjollnier_4:OnCreated(htable)
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self.particle_start = ParticleManager:CreateParticle("particles/other/comics_vs_anime_thor_mjollnier_activate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(interval)
	end
end

function modifier_item_thor_mjollnier_4:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetParent():GetAbsOrigin(), nil, radius,self:GetAbility():GetAbilityTargetTeam(),self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(),FIND_CLOSEST,false)
		local water_mult = self:GetAbility():GetSpecialValueFor("Water_Mult")/100

		for _,unit in ipairs(units) do
			self.particle_start = ParticleManager:CreateParticle("particles/other/comics_vs_anime_thor_mjollnier_activate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			local damage =  0
			if self:GetCaster():IsRangedAttacker() then
				damage = self:GetAbility():GetSpecialValueFor("damage_ranged")
			else
				damage = self:GetAbility():GetSpecialValueFor("damage_melee")
			end
			if ComicsVsAnimeMultDamageWater(unit) == true then
				damage = damage + damage * water_mult
			end	
			local damage_table ={attacker = self:GetCaster(),damage = damage,damage_type = DAMAGE_TYPE_MAGICAL,ability = self:GetAbility(),victim = unit}			
			ApplyDamage(damage_table)
		end
	end
end

function modifier_item_thor_mjollnier_4:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle_start, true)
		ParticleManager:ReleaseParticleIndex( self.particle_start )
	end 
end