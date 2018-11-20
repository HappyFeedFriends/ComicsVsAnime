function rem_demon(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dur = ability:GetSpecialValueFor("duration")
	caster:AddNewModifier( caster, ability, "modifier_rem_demon",{duration = dur} )
end

function rem_demon_attack(keys)
	keys.caster:ComicsVsAnimeSplitShotDamage(keys.target,keys.ability,DAMAGE_TYPE_PHYSICAL)
	--[[
		1. Цель
		2. Какая абилка
		3. Тип урона (Default - DAMAGE_TYPE_PHYSICAL)
	]]
end