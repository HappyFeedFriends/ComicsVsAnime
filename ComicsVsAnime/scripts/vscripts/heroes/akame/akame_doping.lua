function akame_doping_activate(keys)
	local ability = keys.ability
	local caster = keys.caster		
	local mult = ability:GetSpecialValueFor("mult")/100
	local dur = ability:GetSpecialValueFor("dur")
	dur = caster:BonusTalentValue("special_bonus_akame_5",dur)
	local talent = caster:FindAbilityByName("special_bonus_akame_2")
	local spell = caster:FindAbilityByName("akame_ennoodzuno")
	if caster:HasModifier("modifier_akame_ennoodzuno") and spell then
		local mult_spell = spell:GetSpecialValueFor("bonus_stats")
		mult = mult + mult_spell/100
	end
	if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")
		mult = mult + value/100
	end
		caster:AddNewModifier( caster, ability, "modifier_akame_doping_buff",{duration = dur, agi = caster:GetAgility(), str = caster:GetStrength(), int = caster:GetIntellect(), mult = mult} )
end