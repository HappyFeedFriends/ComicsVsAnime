function stone_soul(keys)
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local dur = ability:GetSpecialValueFor("dur")
		local target_team = target:GetTeamNumber()
		target:SetControllableByPlayer(caster:GetPlayerID(), true)
		target:SetTeam(caster:GetTeamNumber())
		target:SetHasInventory(false)
		Timers:CreateTimer(dur, function()
			target:SetTeam(target_team)
			target:SetControllableByPlayer(target:GetPlayerID(), true)
			target:SetHasInventory(true)
		end)
end