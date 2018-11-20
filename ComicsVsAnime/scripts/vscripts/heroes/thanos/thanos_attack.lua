function thanos_damage_attack( event )
	if event.ability ~= nil then
		if event.caster:GetModifierStackCount( "modifier_thanos_Stack_damage", event.ability ) > 0  then
			local target = event.target
			local caster = event.caster
			local ability = event.ability
			local dur = ability:GetSpecialValueFor("duration")
			local current_stack = caster:GetModifierStackCount( "modifier_thanos_Stack_damage", ability )
			target:AddNewModifier( caster, ability, "modifier_thanos_interval_dmg", {duration = dur})
			caster:RemoveModifierByName("modifier_thanos_Stack_damage")
		end
	end
end

function ConvertDamageStack( event )
	if event.attacker:IsHero() and not event.attacker:IsIllusion() and event.ability ~= nil then
		local ability = event.ability
		local caster = event.caster
		local pct = ability:GetSpecialValueFor("stack_bonus_dmg")/100
		if caster:ComicsVsAnimeHasTalent("special_bonus_thanos_6") then
			pct = pct + caster:ComicsVsAnimeTalent("special_bonus_thanos_6")/100
		end
		local modifier = "modifier_thanos_Stack_damage"
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		local damage = event.DamageTaken * pct
		if caster:HasModifier(modifier) then
			caster:SetModifierStackCount( modifier, ability, current_stack + damage  )
		else
			ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = -1 })
			caster:SetModifierStackCount( modifier, ability, damage  )
		end
	end
end

function thanos_tick( event )
	if event.ability ~= nil then
		local ability = event.ability
		local caster = event.caster
		local limit_stack = ability:GetSpecialValueFor("limit")
		local modifier = "modifier_thanos_Stack_damage"
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		
		if current_stack <= 0 then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
		
		if current_stack >= limit_stack and not caster:ComicsVsAnimeHasTalent("special_bonus_thanos_8") then
			caster:SetModifierStackCount( modifier, ability, limit_stack )
		end
	elseif event.caster:HasModifier("modifier_thanos_Stack_damage") then
		event.caster:RemoveModifierByName("modifier_thanos_Stack_damage")
	end	
end

function thanos_remove_stack( event )
	local ability = event.ability
	local caster = event.caster
	local limit_stack = ability:GetSpecialValueFor("limit")
	local modifier = "modifier_thanos_Stack_damage"
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	local remove_stack = ability:GetSpecialValueFor("remove_stack")/100
	if current_stack > 2 and caster:HasModifier(modifier) then
		caster:SetModifierStackCount( modifier, ability, current_stack * remove_stack )
	end
end



