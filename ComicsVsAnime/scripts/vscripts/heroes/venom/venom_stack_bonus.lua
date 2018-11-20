function venom_stack_bonus( event )
if event.caster:FindAbilityByName("venom_block_damage"):GetToggleState() == false then
		local target = event.target
		local caster = event.caster
		local ability = event.ability
		local dmg = ability:GetSpecialValueFor("pct_dmg")
		if caster:ComicsVsAnimeHasTalent("special_bonus_venom_7") then
			dmg = dmg + caster:ComicsVsAnimeTalent("special_bonus_venom_7")
		end 
		local damage = event.DamageTaken * (dmg/100)
		local modifier = "modifier_venom_attack"
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		if caster:HasModifier(modifier) then
			caster:SetModifierStackCount( modifier, ability, current_stack + damage  )
		else
			ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = -1 })
			caster:SetModifierStackCount( modifier, ability, damage  )
		end
	end
end

function venom_stack_remove( event )
	if event.caster:HasModifier("modifier_venom_attack") and event.caster:FindAbilityByName("venom_damage_bonus"):GetToggleState() == false and event.caster:GetModifierStackCount( "modifier_venom_attack", ability ) > 0 then
		local target = event.target
		local caster = event.caster
		local ability = event.ability
		local damage = event.DamageTaken
		local modifier = "modifier_venom_attack"
		local mana_burn = ability:GetSpecialValueFor("mana_burn")
		if caster:ComicsVsAnimeHasTalent("special_bonus_venom_8") then
			mana_burn = mana_burn + caster:ComicsVsAnimeTalent("special_bonus_venom_8")
		end
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		local talent = caster:FindAbilityByName("special_bonus_venom_2")
		if talent and talent:GetLevel() > 0 and talent:GetSpecialValueFor("value") > 0 and caster:HasModifier("modifier_venom_talent") then
			mana_burn = 0
		end
		if current_stack < damage then
			caster:SetHealth(caster:GetHealth() + current_stack)
			caster:SpendMana(current_stack * mana_burn, ability)
			caster:RemoveModifierByName(modifier)
		elseif caster:HasModifier(modifier) and current_stack > 0 and caster:GetMana() >= damage * mana_burn then
			caster:SpendMana(damage * mana_burn, ability)
			caster:SetHealth(caster:GetHealth() + damage)
			caster:SetModifierStackCount( modifier, ability, current_stack - damage  )
		elseif caster:GetMana() <= current_stack * mana_burn then
			caster:SpendMana(caster:GetMana(), ability)
			caster:SetHealth(caster:GetHealth() + caster:GetMana())
			caster:SetModifierStackCount( modifier, ability, current_stack - caster:GetMana()  )
		else
			caster:RemoveModifierByName(modifier)
		end
	end
end

function venom_stack_tick( event )

		local target = event.target
		local caster = event.caster
		local ability = event.ability
		local damage = event.DamageTaken
		local modifier = "modifier_venom_attack"
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		if current_stack <= 0 then
			caster:FindAbilityByName("venom_block_damage"):SetActivated(false)
			if caster:FindAbilityByName("venom_block_damage"):GetToggleState() == true then
				caster:FindAbilityByName("venom_block_damage"):OnToggle()
			end
		else
			caster:FindAbilityByName("venom_block_damage"):SetActivated(true)
		end
		
end
