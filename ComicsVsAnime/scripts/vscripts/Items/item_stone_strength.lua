function stone_str(keys)
	local caster = keys.caster
	local ability = keys.ability
	if ability:IsCooldownReady() then
	local str = ability:GetSpecialValueFor("str")
	local chance = ability:GetSpecialValueFor("chance")
	local mult = ability:GetSpecialValueFor("mult")
		if RollPercentage(chance) == true then
			str = str * mult
		end
		if caster:GetPrimaryAttribute() == 0 then
			caster:ModifyStrength(str)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		elseif caster:GetPrimaryAttribute() == 1 then
			caster:ModifyAgility(str)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end