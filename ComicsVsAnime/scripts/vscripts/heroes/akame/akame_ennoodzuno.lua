function akame_ennoodzuno(keys)
	local ability = keys.ability
	local caster = keys.caster		
	local dur = ability:GetSpecialValueFor("duration")
	dur = caster:BonusTalentValue("special_bonus_akame_4",dur)
	caster:AddNewModifier( caster, ability, "modifier_akame_ennoodzuno",{duration = dur} )
end