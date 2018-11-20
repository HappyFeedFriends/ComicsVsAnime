function AddChakraTick(keys)
	local caster = keys.caster	
	local ability = keys.ability
	local limit = ability:GetSpecialValueFor("limit")	
	--local cooldown_reduction = ability:GetSpecialValueFor("limit")
	local chakra = ability:GetSpecialValueFor("chakra_bonus_damage")
	local modifier = "modifier_chakra_nachalo"
	local interval = ability:GetSpecialValueFor("interval")
	local stats = ability:GetSpecialValueFor("bonus_Chakra_stats")
	local stack = ability:GetSpecialValueFor("bonus_Chakra")
	local modifier1 = caster:FindModifierByName(modifier)
	local current_stack_2 = caster:GetModifierStackCount( modifier, ability )
	local spell = caster:FindAbilityByName("naruto_rasenshuriken")
    local stack_chakra = spell:GetSpecialValueFor("chakra_stack")

	ability:StartCooldown(interval)
	ability.cooldownStarted = true
	if current_stack_2 >= (limit - 1)  then
	ability.currentStacks = limit	
	end	
	ability.currentStacks = ability.currentStacks + stack
	caster:SetModifierStackCount(modifier, ability, ability.currentStacks)

end 

function CheckCooldown(keys)
	if keys.ability ~= nil then
		local caster = keys.caster	
		local ability = keys.ability
		local limit = ability:GetSpecialValueFor("limit")	
		local modifier = "modifier_chakra_nachalo"	
		local current_stack_2 = caster:GetModifierStackCount( modifier, ability )
		local spell = caster:FindAbilityByName("naruto_rasenshuriken")
		local stack_chakra = spell:GetSpecialValueFor("chakra_stack")
		local stack = ability:GetSpecialValueFor("bonus_Chakra")
		local interval = ability:GetSpecialValueFor("interval")
		
		if current_stack_2 >= limit then
			caster:SetModifierStackCount(modifier, ability, limit - stack_chakra + stack)
		end
		if ability:IsCooldownReady() and ability.cooldownStarted then
			AddChakraTick(keys)
		end
	else
		keys.caster:RemoveModifierByName("naruto_chakra_start")
	end
end




function StartCooldown(keys)
	local caster = keys.caster	
	local ability = keys.ability
	local interval = ability:GetSpecialValueFor("interval")	
	local modifier = "modifier_chakra_nachalo"
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	ability:StartCooldown(interval)
	ability.cooldownStarted = true
		
	caster:SetModifierStackCount(modifier, ability, ability.currentStacks)
end


function StopCooldown(keys)
	keys.ability:EndCooldown()
	ability.cooldownStarted = false
end
