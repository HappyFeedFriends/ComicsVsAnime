function Stacks(keys)
	if keys.ability ~= nil then
		local caster = keys.caster
		local ability = keys.ability
		local modifier = "modifier_chakra_bonus"
		local stack = ability:GetLevelSpecialValueFor("stacks", ability:GetLevel())
		local dur = inf
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		local modifier_ult = caster:FindModifierByName("modifier_naruto_ult")
		local spell = caster:FindAbilityByName("naruto_ult")
		if modifier_ult and spell then
			local value_modifier = spell:GetSpecialValueFor("bonus_chakra")
			stack = stack + value_modifier
		end
		
		if caster:HasModifier( modifier ) then
			caster:AddNewModifier( caster, ability, modifier, { Duration = dur })
			caster:SetModifierStackCount( modifier, ability, current_stack + stack )
		else
			caster:AddNewModifier( caster, ability, modifier, { Duration = dur })
			caster:SetModifierStackCount( modifier, ability, stack )
		end
	end
end

function check(keys)
	if keys.ability ~= nil then
		local caster = keys.caster
		local ability = keys.ability
		local modifier = "modifier_chakra_bonus"
		local limit = ability:GetLevelSpecialValueFor("limit", ability:GetLevel())
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		local talent = caster:FindAbilityByName("special_bonus_naruto_1")
		
		if talent then
			if talent:GetLevel() == 1 then
			local value_talent = talent:GetSpecialValueFor("value")
				limit = limit + value_talent
			end
		end
		if current_stack >= limit  then
			caster:SetModifierStackCount( modifier, ability, limit )
		end	
	end	
end