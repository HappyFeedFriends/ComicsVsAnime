function kurumi_spell_end( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability	
	local radius = ability:GetSpecialValueFor( "target_radius")
	target:RemoveNoDraw()	
	target:SetAbsOrigin(target.doppleganger_position)
	FindClearSpaceForUnit(target, target.doppleganger_position, true)
	
	if target == caster then
		local player = caster:GetPlayerID()
		local unit_name = caster:GetUnitName()
		local duration = ability:GetSpecialValueFor( "illusion_duration" )
		local illusion_kolvo = ability:GetSpecialValueFor( "illusion_kol" )
		local talent = caster:FindAbilityByName("special_bonus_kurumi_2")
		if talent and talent:GetLevel() > 0 then
			local value = talent:GetSpecialValueFor("value")
			illusion_kolvo = illusion_kolvo + value
		end
		
		for j=1,illusion_kolvo do
			local rand_distance = math.random(0,radius)
			local origin = caster:GetAbsOrigin() + RandomVector(rand_distance)
			local outgoingDamage = ability:GetSpecialValueFor( "illusion_outgoing_damage" )
			local incomingDamage = ability:GetSpecialValueFor( "illusion_incoming_damage" )
			local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
			illusion:SetPlayerID(caster:GetPlayerID())
			illusion:SetControllableByPlayer(player, true)
			local casterLevel = caster:GetLevel()
			for i=0,casterLevel do
				illusion:HeroLevelUp(false)
			end
			illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			illusion:AddNewModifier(caster, ability, "modifier_phased", {duration = 0.03})
			illusion:MakeIllusion()
			if caster:HasModifier("modifier_first_bullet_aleph") then
				projectile_attacks = "particles/kurumi/comics_vs_anime_kurumi_first_bullet_aleph.vpcf"
			elseif caster:HasModifier("modifier_second_bullet") then
				projectile_attacks = "particles/kurumi/comics_vs_anime_kurumi_second_bullet.vpcf"
			elseif caster:HasModifier("modifier_seventh_bullet_zayin") then	
				projectile_attacks = "particles/kurumi/comics_vs_anime_kurumi_seventh_bullet_zayin.vpcf"
			else
				projectile_attacks = caster:GetKeyValue("ProjectileModel")	
			end
			illusion:SetRangedProjectileName(projectile_attacks)
		end
	end
end

function kurumi_spell_start( keys )
	local target = keys.target
	local caster = keys.caster
	caster:Purge( false, true, false, false, false)
	caster:AddNoDraw()
end

function kurumi_check_units(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor( "delay" )
	local radius = ability:GetSpecialValueFor( "target_radius")
	
	if target:GetUnitName() == caster:GetUnitName() and target:GetMainControllingPlayer() == caster:GetMainControllingPlayer() then
		local rand_distance = math.random(0,radius)	
		local rand_position = ability:GetCursorPosition() + RandomVector(rand_distance)
		target.doppleganger_position = rand_position

		local dopple_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_doppleganger_illlmove.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControl(dopple_particle,0,target:GetAbsOrigin())
		ParticleManager:SetParticleControl(dopple_particle,1,rand_position)
		ParticleManager:ReleaseParticleIndex(dopple_particle)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_kurumi_start", {Duration = duration})
	end
end