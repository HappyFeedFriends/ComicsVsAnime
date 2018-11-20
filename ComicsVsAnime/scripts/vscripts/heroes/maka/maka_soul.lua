function maka_soul(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local modifier = "modifier_maka_soul"
	local dur = inf	
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	local stack_hero = ability:GetSpecialValueFor("soul_hero")
	stack_hero = caster:BonusTalentValue("special_bonus_maka_6",stack_hero)
	local stack_creep = ability:GetSpecialValueFor("soul_creep")
	if caster:HasModifier( modifier ) and target:IsRealHero() then
		caster:SetModifierStackCount( modifier, ability, current_stack + stack_hero )
	elseif caster:HasModifier( modifier ) and target:IsCreep() then
		caster:SetModifierStackCount( modifier, ability, current_stack + stack_creep )
	elseif not caster:HasModifier( modifier ) and target:IsCreep() then	
		ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = dur })
		caster:SetModifierStackCount( modifier, ability, stack_creep )
	elseif not caster:HasModifier( modifier ) and target:IsRealHero() then	
		ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = dur })
		caster:SetModifierStackCount( modifier, ability, stack_hero )	
	end
end

function maka_soul_activate(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local duration = ability:GetSpecialValueFor("duration")
	local heroes = HeroList:GetAllHeroes()
		caster:AddNewModifier(caster, ability, "modifier_maka_vision_aura", {duration = duration})
end