function desolator2(keys)
	local target = keys.target
	local ability = keys.ability
	local modifier = "modifier_reduction_armor_desolator2"
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel())
	local stacks = ability:GetLevelSpecialValueFor( "coruprion_armor" , ability:GetLevel())
	local limit = ability:GetLevelSpecialValueFor( "limit_armor" , ability:GetLevel())

	
	if target:HasModifier( modifier ) then
		local current_stack = target:GetModifierStackCount( modifier, ability )
		ability:ApplyDataDrivenModifier( target, target, modifier, { Duration = duration })
		target:SetModifierStackCount( modifier, ability, current_stack + stacks )
	else
		ability:ApplyDataDrivenModifier( target, target, modifier, { Duration = duration })
		target:SetModifierStackCount( modifier, ability, stacks )
	end    
	local stack = target:GetModifierStackCount( modifier, ability )	
	if stack >= limit then
		target:SetModifierStackCount( modifier, ability, limit )
    end
end