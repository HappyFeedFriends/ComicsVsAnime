function Ulquiorra_passive(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
	local chance = 100
	if RollPercentage(chance) then
		local r = RandomInt(1,2)
		local spell1 = caster:FindAbilityByName("ulquiorra_sero")
		local spell2 = caster:FindAbilityByName("ulquiorra_ult")
		--local spell3 = caster:FindAbilityByName("ulquiorra_sero")
		--local spell4 = caster:FindAbilityByName("ulquiorra_sero")
		if r == 1 and spell1 and spell1:GetLevel() > 0 then
		spell1:EndCooldown()
	end

end