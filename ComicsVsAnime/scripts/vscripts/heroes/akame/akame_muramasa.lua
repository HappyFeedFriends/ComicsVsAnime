function akame_muramasa_passive(keys)
	local chance = keys.ability:GetSpecialValueFor("chance")
	if keys.caster:FindAbilityByName("special_bonus_akame_1") and keys.caster:FindAbilityByName("special_bonus_akame_1"):GetLevel() > 0 then
		local value = keys.caster:FindAbilityByName("special_bonus_akame_1"):GetSpecialValueFor("value")
		chance = chance + value
	end
	if RollPercentage(chance) == true and not keys.target:IsBosses() then
		local ability = keys.ability
		local caster = keys.caster		
		local target = keys.target
		local kill_time = ability:GetSpecialValueFor("time_kill")
		if not target:HasModifier("akame_debuff_muramasa") then
			target:AddNewModifier( caster, ability, "akame_debuff_muramasa",{duration = kill_time,} )	
			target:SetModifierStackCount( "akame_debuff_muramasa", ability, kill_time  )
		end
	end
end

function akame_muramasa_activate_attack(keys)
	local ability = keys.ability
	local caster = keys.caster		
	local target = keys.target
	local kill_time = ability:GetSpecialValueFor("time_kill")
	local current_stack = caster:GetModifierStackCount( "modifier_akame_attack_activate", ability )
	if not target:HasModifier("akame_debuff_muramasa") and not target:IsBosses() then
		target:AddNewModifier( caster, ability, "akame_debuff_muramasa",{duration = kill_time,} )	
		target:SetModifierStackCount( "akame_debuff_muramasa", ability, kill_time  )
		caster:SetModifierStackCount( "modifier_akame_attack_activate", ability, current_stack - 1  )
		if current_stack <= 1 then
			caster:RemoveModifierByName("modifier_akame_attack_activate")
		end	
	end
end

function akame_muramasa_created(keys)
	local ability = keys.ability
	local caster = keys.caster		
	local dur = ability:GetSpecialValueFor("duration")
	dur = caster:BonusTalentValue("special_bonus_akame_6",dur)
	local num = ability:GetSpecialValueFor("num_attack")
	num = caster:BonusTalentValue("special_bonus_akame_8",num)
	local spell = caster:FindAbilityByName("akame_ennoodzuno")
	if caster:HasModifier("modifier_akame_ennoodzuno") and spell then
		local num_spell = spell:GetSpecialValueFor("bonus_num_attack")
		num = num + num_spell
	end	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_akame_attack_activate", { Duration = dur })
	caster:SetModifierStackCount( "modifier_akame_attack_activate", ability, num  )
end