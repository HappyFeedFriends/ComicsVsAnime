function akame_runner(keys)
	local ability = keys.ability
	local caster = keys.caster		
	local move = ability:GetSpecialValueFor("movespeed")
	local evasion = ability:GetSpecialValueFor("evasion")
	local dur = ability:GetSpecialValueFor("duration")
	local talent = caster:FindAbilityByName("special_bonus_akame_3")
	local spell = caster:FindAbilityByName("akame_ennoodzuno")
	if caster:HasModifier("modifier_akame_ennoodzuno") and spell then
		local move_spell = spell:GetSpecialValueFor("bonus_movespeed")
		move = move + move_spell
	end
	if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")
		move = move + value
	end
		caster:AddNewModifier( caster, ability, "modifier_akame_runner",{duration = dur, movespeed = move} )
end