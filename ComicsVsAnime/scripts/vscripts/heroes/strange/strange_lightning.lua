function strange_lightning( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local dur_stun = ability:GetSpecialValueFor("dur_stun")
	local talent = caster:FindAbilityByName("special_bonus_strange_1")
	local particle = "particles/strange/comics_vs_anime_lightning_osnova.vpcf"
	local water_mult = ability:GetSpecialValueFor("water_mult")
	local lightningBolt = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	if caster:ComicsVsAnimeHasTalent("special_bonus_strange_4") then
		damage = damage + caster:ComicsVsAnimeTalent("special_bonus_strange_4")
	end 
if not target:TriggerSpellReflect( ability ) then
	if talent and talent:GetLevel() > 0 then
		local radius = talent:GetSpecialValueFor("radius")
		local units = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),ability:GetAbilityTargetFlags(),FIND_ANY_ORDER,false)
		local targets = 1
		local value = talent:GetSpecialValueFor("value")
		for k,unit in pairs(units) do
			if ComicsVsAnimeMultDamageWater(unit) == true then
				damage = damage * water_mult
				dur_stun = dur_stun * water_mult
			end
			if targets <= value then
				local origin = unit:GetAbsOrigin()
				targets = targets + 1
				local lightningBolt = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))	
				ApplyDamage({ 
				victim = unit,
				attacker = caster,
				damage = damage,
				damage_type = ability:GetAbilityDamageType()})
				unit:AddNewModifier( caster, ability, "modifier_stunned", {duration = dur_stun})
			end
		end
	else
	if ComicsVsAnimeMultDamageWater(target) == true then
		damage = damage * water_mult
		dur_stun = dur_stun * water_mult
	end
	ApplyDamage({ victim = target,attacker = caster,damage = damage,damage_type = ability:GetAbilityDamageType()})target:AddNewModifier( caster, ability, "modifier_stunned", {duration = dur_stun})
	end
end
end