function rem_water_waves(keys)
    local caster = keys.caster
    local ability = keys.ability
    local vDirection = caster:GetCursorPosition() - caster:GetOrigin()
	vDirection = vDirection:Normalized()
    local range = ability:GetSpecialValueFor("range")
	local value = ability:GetSpecialValueFor("ice_balls")
	local particle = "particles/frostivus_gameplay/holdout_ancient_apparition_ice_blast_final.vpcf"
	if caster:HasModifier("modifier_rem_demon") then
		particle = "particles/rem/comics_vs_anime_rem_demon_ice_osnova.vpcf"
	end
    local info = 
    {
        Ability = ability,													
        EffectName = particle, 	--particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_ice.vpcf	
        vSpawnOrigin = caster:GetAbsOrigin(), 									
        fDistance = range, 													
        fStartRadius = 200,		
        fEndRadius = 100,				
        Source = caster, 												
        bHasFrontalCone = true, 										
        bReplaceExisting = false, 											
        iUnitTargetTeam = ability:GetAbilityTargetTeam(),					
        iUnitTargetFlags = ability:GetAbilityTargetFlags(),					
        iUnitTargetType = ability:GetAbilityTargetType(),					
        vVelocity = vDirection * range, 										
        bVisibleToEnemies = true, 											
        bProvidesVision = true, 											  
        iVisionRadius =  ability:GetSpecialValueFor("vision_radius"), 			     
        iVisionTeamNumber = caster:GetTeamNumber(),						 	
    }
	local r = 0
	local i = 0
	if caster:ComicsVsAnimeHasTalent("special_bonus_rem_1") == true then
		value = value + caster:ComicsVsAnimeTalent("special_bonus_rem_1",nil,nil)
		r = 60/value
		i = -r
	end

	for k=1,value do
		info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * range
		ProjectileManager:CreateLinearProjectile(info)
		i = i + r
	end	
end

function rem_water_waves_hit(keys)
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
	local dur = ability:GetSpecialValueFor("duration")
	CreateModifierThinker(caster,ability, "modifier_rem_water_waves_aura", {duration = 12},  target:GetAbsOrigin(), caster:GetTeamNumber(), false)
end