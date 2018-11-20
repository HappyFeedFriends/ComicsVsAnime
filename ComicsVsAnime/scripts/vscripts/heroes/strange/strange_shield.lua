function strange_shield( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stacks = ability:GetSpecialValueFor("block_damage")
	if caster:ComicsVsAnimeHasTalent("special_bonus_strange_8") then
		stacks = stacks + caster:ComicsVsAnimeTalent("special_bonus_strange_8")
	end 
	local dur = ability:GetSpecialValueFor("duration")
	local modifier = "modifier_strange_shield"
	ComicsVsAnimeAddStack(caster, ability, nil, stacks, modifier, dur, false, true,false,false)
	--[[
	1. Цель
	2. Кто выдаёт
	3. Начальное количество стаков (nil = 1)
	4. Стаков Выдавать
	5. Какой модификатор выдавать
	6. Длительность
	7. DD модификатор? (True/false)
	8. Lua модификатор? (True/false)
	9. Увеличивать с последующим использованием,количество стаков? (True/false)
	10.Обновлять стаки при получении
	]]
end