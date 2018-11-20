
function AddEffect( keys )
	local particle = ParticleManager:CreateParticle("particles/naruto/raseng_model.vpcf", PATTACH_POINT_FOLLOW, keys.caster) 
	ParticleManager:SetParticleControlEnt(particle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_right_hand", keys.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, keys.caster, PATTACH_POINT_FOLLOW, "attach_right_hand", keys.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 3, keys.caster, PATTACH_POINT_FOLLOW, "attach_right_hand", keys.caster:GetAbsOrigin(), true)
 	keys.caster.rasenParticle = particle

end

function rasenshuriken_start( keys )

	local info = {
		Target = keys.target,
		Source = keys.caster,
		Ability = keys.ability,
		EffectName = "particles/naruto/rasenshuriken_alt.vpcf",
		bDodgeable = true,
		bProvidesVision = true,
		iMoveSpeed = keys.speed,
        iVisionRadius = keys.vision_radius,
        iVisionTeamNumber = keys.caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile( info )

end

function removeEffect( keys )
	ParticleManager:DestroyParticle(keys.caster.rasenParticle, true)
end

function rasenshuriken_impact(keys)
if not( keys.target:TriggerSpellAbsorb(keys.ability) ) then
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local damage_scepter = ability:GetSpecialValueFor("damage_scepter")
	local damage_type = ability:GetAbilityDamageType()
	local target_flags = ability:GetAbilityTargetType()
	local chakra_bonus1 = ability:GetSpecialValueFor("damage_chakra")
	local chakra_bonus = ability:GetSpecialValueFor("chakra_stack")
	local modifier1 = caster:FindModifierByName("modifier_chakra_start_bonus")		
	local aoe = keys.AoE
	local modifier = keys.modifier
	local targetEntities = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	local talent = caster:FindAbilityByName("special_bonus_naruto_2")
	local talent1 = caster:FindAbilityByName("special_bonus_naruto_4")
	
	if talent1 then
		if talent1:GetLevel() == 1 then
		local value_talent1 = talent1:GetSpecialValueFor("value")
			damage = damage + value_talent1
		end
	end
	if talent then
		if talent:GetLevel() == 1 then
			local value_talent = talent:GetSpecialValueFor("value")
			chakra_bonus = chakra_bonus + value_talent
		end
	end
	if modifier1 then
	local stack = modifier1:GetStackCount()	
		if caster:HasScepter() == true then
			damage = damage + damage_scepter  
		end
	end
	if( not targetEntities )then
		return
	end
	if modifier1 then
	local stack = modifier1:GetStackCount()
		if stack >= chakra_bonus  then
			damage = damage + chakra_bonus1
			stack = modifier1:SetStackCount(stack - chakra_bonus)
		end
	end
	
	for i,value in pairs(targetEntities) do

	ability:ApplyDataDrivenModifier(caster,value,modifier,{})
	local damage1 = {
		attacker = caster, 
		victim = value, 
		ability = ability, 
		damage = damage,  
		damage_type = damage_type}
-----------------------------------		
	ApplyDamage(damage1)
	end
end	
end








