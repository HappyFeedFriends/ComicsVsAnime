function thanos_damage(keys)
	if keys.ability ~= nil and keys.ability:IsCooldownReady() and keys.target:IsHero() and keys.caster:GetMana() >= keys.ability:GetManaCost(keys.ability:GetLevel()) then
		local caster = keys.caster
		local ability = keys.ability
		local damage = ability:GetSpecialValueFor("damage")
		local target = keys.target
		local cooldown = ability:GetCooldown(ability:GetLevel())
		local talent = caster:FindAbilityByName("special_bonus_thanos_1")
		if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")
			damage = damage + value
		end
		
		local vCaster = caster:GetAbsOrigin()
		local vTarget = target:GetAbsOrigin()
		local len = ( vTarget - vCaster ):Length2D()
		local radius = 150
		local duration = ability:GetSpecialValueFor("knock_duration")
		local height =  ability:GetSpecialValueFor("knockback_height")
		local duration_sleep = ability:GetSpecialValueFor("duration_vision")
		local knockbackModifierTable =
		{
			should_stun = 1,
			knockback_duration = duration,
			duration = duration,
			knockback_distance = len,
			knockback_height = height,
			center_x = caster:GetAbsOrigin().x,
			center_y = caster:GetAbsOrigin().y,
			center_z = caster:GetAbsOrigin().z
		}
		target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable ) 
		target:AddNewModifier( caster, nil, "modifier_blind_custom", {duration = duration_sleep} )
		
		local talent1 = caster:FindAbilityByName("special_bonus_thanos_2")
		if talent1 and talent1:GetLevel() > 0 then
			local value1 = talent1:GetSpecialValueFor("value")
			target:AddNewModifier( caster, nil, "modifier_stunned",{duration = value1} )
		end
		
		local particle = ParticleManager:CreateParticle("particles/arena/econ/units/heroes/hero_stargazer/gamma_ray_sunray.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() ) --particles/dev/curlnoise_test.vpcf
		ParticleManager:SetParticleControl( particle, 1, Vector(radius, radius, radius) )
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),}
		ApplyDamage(damageTable)
		print(ApplyDamage(damageTable))
		caster:SpendMana(ability:GetManaCost(ability:GetLevel()), ability)
		ability:StartCooldown(cooldown)
	end
end