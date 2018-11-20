function kurumi_target_kill( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability	
	local healing = ability:GetSpecialValueFor("healing")/100
	caster:Heal(target:GetMaxHealth() * healing,caster)
	SendOverheadEventMessage( caster, OVERHEAD_ALERT_HEAL, caster, target:GetMaxHealth() * healing, nil )
	local talent = caster:FindAbilityByName("special_bonus_kurumi_3")
	if talent and talent:GetLevel() > 0 then
		local damage = talent:GetSpecialValueFor("value")
		local modifier = "modifier_kurumi_absorcia_damage"
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		if caster:HasModifier(modifier) then
			caster:SetModifierStackCount( modifier, ability, current_stack + damage  )
		else
			caster:AddNewModifier( caster, ability,modifier,{duration = -1} )	
			caster:SetModifierStackCount( modifier, ability, damage  )
		end
	end
end