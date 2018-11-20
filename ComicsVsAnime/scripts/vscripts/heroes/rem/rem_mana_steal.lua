function rem_mana_steal(keys) 
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dur = ability:GetSpecialValueFor("duration")
	caster:AddNewModifier( caster, ability, "modifier_rem_mana_steal",{duration = dur} )
end