function maka_reflect_passive( event )
	if RollPercentage(event.ability:GetSpecialValueFor("chance")) == true then
		local ability = event.ability
		local caster = event.caster
		local attacker = event.attacker
		local pct = ability:GetSpecialValueFor("reflect_dmg")
		pct = caster:BonusTalentValue("special_bonus_maka_5",pct)/100
		local damage = event.DamageTaken * pct
		local damageTable = {
				attacker = caster,
				victim = attacker,
				damage_type = ability:GetAbilityDamageType(),
				damage = damage }
		ApplyDamage(damageTable)
	end
end

function maka_reflect_activate( event )
		local ability = event.ability
		local caster = event.caster
		local attacker = event.attacker
		local absorb = ability:GetSpecialValueFor("absorb_damage")
		absorb = caster:BonusTalentValue("special_bonus_maka_2",absorb)/100
		print(absorb,"ABSORB")
		local pct = ability:GetSpecialValueFor("reflect_dmg")
		pct = caster:BonusTalentValue("special_bonus_maka_5",pct)/100
		local damage = event.DamageTaken * pct
		local damageTable = {
				attacker = caster,
				victim = attacker,
				damage_type = ability:GetAbilityDamageType(),
				damage = damage }
		ApplyDamage(damageTable)
		caster:SetHealth(caster:GetHealth() + event.DamageTaken * absorb)
end