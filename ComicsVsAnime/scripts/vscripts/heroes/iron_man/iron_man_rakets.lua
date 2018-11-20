function heat_seeking_missile_seek_targets( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particleName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
	local modifierDudName = "modifier_iron_man_effect"
	local projectileSpeed = ability:GetSpecialValueFor( "speed")
	local radius = ability:GetSpecialValueFor( "radius" )
	local max_targets = ability:GetSpecialValueFor( "targets")
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags() 
	local projectileDodgable = false
	local projectileProvidesVision = false
	
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false
	)

	local count = 0
	for k, v in pairs( units ) do
		if count < max_targets then
			local projTable = {
				Target = v,
				Source = caster,
				Ability = ability,
				EffectName = particleName,
				bDodgeable = projectileDodgable,
				bProvidesVision = projectileProvidesVision,
				iMoveSpeed = projectileSpeed, 
				vSpawnOrigin = caster:GetAbsOrigin()
			}
			ProjectileManager:CreateTrackingProjectile( projTable )
			count = count + 1
		else
			break
		end
	end

	if count == 0 then
		ability:ApplyDataDrivenModifier( caster, caster, modifierDudName, {} )
	end
end