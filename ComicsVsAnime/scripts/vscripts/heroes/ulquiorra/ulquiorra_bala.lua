function ulquiorra_bala(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local radius = ability:GetSpecialValueFor("radius")
	radius = caster:BonusTalentValue("special_bonus_ulquiorra_4",radius)
	local dummy = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
	dummy:AddAbility("custom_point_dummy")
	local abl = dummy:FindAbilityByName("custom_point_dummy")
	if abl ~= nil then 
		abl:SetLevel(1) 
	end

	dummy:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")

	Timers:CreateTimer(3.0, function ()
		dummy:RemoveSelf()
	end)

	local particleName = "particles/custom/ulquiorra/ulquiorra_skill_1.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl( particle, 0, point )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius, 0, 0) )
	ParticleManager:SetParticleControl( particle, 2, Vector(radius, 0, 0) )
	ParticleManager:SetParticleControl( particle, 3, Vector(radius, 0, 0) )
end

function ulquiorra_bala_damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local target = keys.target
	local talent = caster:FindAbilityByName("special_bonus_ulquiorra_3")
	if talent and talent:GetLevel() > 0 then
	local value = talent:GetSpecialValueFor("value")
		damage = damage + value
	end
	local damageTable = {
	victim = target,
	attacker = caster,
	damage = damage,
	damage_type = ability:GetAbilityDamageType(),}
	ApplyDamage(damageTable)

end