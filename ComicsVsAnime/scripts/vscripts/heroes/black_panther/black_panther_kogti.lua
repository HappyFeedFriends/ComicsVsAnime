function black_panther_kogti(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = "black_panther_attack_bonus"
	local stack = ability:GetSpecialValueFor("num_attack")
	local dur = ability:GetSpecialValueFor("duration")
	local talent3 = caster:FindAbilityByName("special_bonus_black_panther_3")	
	if talent3 and talent3:GetLevel() > 0 then
		local value3 = talent3:GetSpecialValueFor("value")
		stack = stack + value3
	end
		ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = dur })
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_black_panther_kogti", { Duration = dur })
		caster:SetModifierStackCount( modifier, ability, stack )	
end

function black_panther_kogti_attack(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = "black_panther_attack_bonus"
	local damage = ability:GetSpecialValueFor("damage")/100
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	local modifier_debuff = "modifier_black_panther_blood"
	local hp = target:GetHealth()
	local talent = caster:FindAbilityByName("special_bonus_black_panther_1")
	local talent2 = caster:FindAbilityByName("special_bonus_black_panther_2")
	
	if talent2 and talent2:GetLevel() > 0 then
		local value = talent2:GetSpecialValueFor("value")
		damage = damage + value/100
	end
	
	if current_stack < 1 then
		caster:RemoveModifierByName(modifier)
		caster:RemoveModifierByName("modifier_black_panther_kogti")
	end	
	
	if caster:HasModifier( modifier ) then	
		if talent and talent:GetLevel() > 0 then
		local chance_spell = talent:GetSpecialValueFor("chance")
		local dur_debuff = talent:GetSpecialValueFor("duration") 
			chance = RandomInt(1,100)
				if chance <= chance_spell then
					target:AddNewModifier( caster, nil, modifier_debuff, {duration = dur_debuff})
				end
		end
		local damage_table = {}
			damage_table.attacker = caster
			damage_table.damage_type = ability:GetAbilityDamageType()
			damage_table.ability = ability
			damage_table.victim = target
			damage_table.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			damage_table.damage = hp * damage
			ApplyDamage(damage_table)
	    --print(ApplyDamage(damage_table)) (Проверка урона)
		caster:SetModifierStackCount( modifier, ability, current_stack - 1 )
	end
end