function strange_blink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local range = ability:GetSpecialValueFor("blink_range")
	local effect = "particles/strange/comics_vs_anime_strange_blink_osnovnoy.vpcf"
	local effect_end = "particles/strange/comics_vs_anime_strange_blink_osnova_end.vpcf"
	ability:ComicsVsAnimeBlink(caster,range,effect,effect_end,0.25)
	Timers:CreateTimer(0.26, function()
		if caster:ComicsVsAnimeHasTalent("special_bonus_strange_6") then
			local radius = caster:ComicsVsAnimeTalent("special_bonus_strange_6",nil,"radius")
			local damage = caster:ComicsVsAnimeTalent("special_bonus_strange_6")
			local unites = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil, radius, ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),ability:GetAbilityTargetFlags(),FIND_ANY_ORDER,false)
			for _,unites in pairs(unites) do
				ApplyDamage({ 
					victim = unites,
					attacker = caster,
					damage = damage,
					damage_type = ability:GetAbilityDamageType()})
			end
		end
	end) 
end