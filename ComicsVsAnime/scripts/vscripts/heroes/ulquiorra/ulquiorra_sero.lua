function ulquiorra_sero(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = ability:GetSpecialValueFor("damage" )
	damage = caster:BonusTalentValue("special_bonus_ulquiorra_5",damage)
    local multi = ability:GetSpecialValueFor("agi_multi" )
	local chance = ability:GetSpecialValueFor("chance" )
	local radius = ability:GetSpecialValueFor("radius" )
	local burn = caster:GetMana()
	local r = RandomInt(1,100)
	local talent = caster:FindAbilityByName("special_bonus_ulquiorra_2")
	local units = FindUnitsInRadius(caster:GetTeamNumber(),
	        target:GetAbsOrigin(),
	        nil,
	        radius,
	        DOTA_UNIT_TARGET_TEAM_ENEMY,
	        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        DOTA_UNIT_TARGET_FLAG_NONE,
	        FIND_ANY_ORDER,
	        false)
			
	if talent and talent:GetLevel() > 0 then
		if talent:GetSpecialValueFor("value") > 0 then
			burn = 0
		end
	end
	if r < chance and target:IsRealHero() then
		target:Kill(ability, caster)
		caster:SpendMana(burn,ability)
	end
	    local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),}
		ApplyDamage(damageTable)
	if caster:HasScepter() == true then
	local damage_scepter = ability:GetSpecialValueFor("damage_scepter" )/100
		for _,unit in pairs(units) do
		local damageTable1 = {
			victim = unit,
			attacker = caster,
			damage = damage * damage_scepter,
			damage_type = ability:GetAbilityDamageType(),
		}
		ApplyDamage(damageTable1)
		local particle = ParticleManager:CreateParticle("particles/custom/ulquiorra/ulquiorra_skill_5_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector(radius, radius, radius) )
			if r < chance and target:IsRealHero() then
				unit:Kill(ability, caster)
				caster:SpendMana(burn,ability)
			end
		end
	end
	print(r)
end