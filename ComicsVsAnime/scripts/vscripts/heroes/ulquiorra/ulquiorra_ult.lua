
function ulqiorra_ult( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]

	local dummy = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
	dummy:AddAbility("custom_point_dummy")
	local abl = dummy:FindAbilityByName("custom_point_dummy")
	if abl ~= nil then
		abl:SetLevel(1)
	end
	
	if dummy ~= nil then
		local projTable = {
	        EffectName = "particles/custom/ulquiorra_skill_5.vpcf",
	        Ability = ability,
	        Target = dummy,
	        Source = caster,
	        bDodgeable = false,
	        bProvidesVision = false,
	        vSpawnOrigin = caster:GetAbsOrigin(),
	        iMoveSpeed = 2400,
	        iVisionRadius = 0,
	        iVisionTeamNumber = caster:GetTeamNumber(),
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	    }
	    ProjectileManager:CreateTrackingProjectile(projTable)
	end
end

function ulqiorra_ult_hit(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local radius = ability:GetSpecialValueFor("radius")
	local multi = ability:GetSpecialValueFor("mult" )/100
    local damage = ability:GetSpecialValueFor("damage" ) + (caster:GetIntellect() * multi)
	local talent = caster:FindAbilityByName("special_bonus_ulquiorra_1")
	local duration_stun = ability:GetSpecialValueFor("duration_stun" )
	duration_stun = caster:BonusTalentValue("special_bonus_ulquiorra_7",duration_stun)
    local particleName = "particles/custom/ulquiorra/ulquiorra_skill_5_1.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius, radius, radius) )

	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	            target:GetAbsOrigin(),
	            nil,
	            radius,
	            DOTA_UNIT_TARGET_TEAM_ENEMY,
	            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	            DOTA_UNIT_TARGET_FLAG_NONE,
	            FIND_ANY_ORDER,
	            false)

	for _,unit in pairs(localUnits) do
	if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")/100
		damage = damage + (unit:GetHealth() * value)
	end
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
		}
		if not unit:IsBosses() then
			ApplyDamage(damageTable)
			unit:AddNewModifier( caster, caster, "modifier_stunned", {duration = duration_stun})
		end
	end

	Timers:CreateTimer(3.0, function ()
		target:RemoveSelf()
	end)
end
modifier_special_bonus_ulquiorra_8 = modifier_special_bonus_ulquiorra_8 or class({})

function modifier_special_bonus_ulquiorra_8:RemoveOnDeath() return true end
function modifier_special_bonus_ulquiorra_8:IsHidden() return true end
function modifier_special_bonus_ulquiorra_8:IsPurgable() return false end

function modifier_special_bonus_ulquiorra_8:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasTalent("special_bonus_ulquiorra_8") then
			local count_max = caster:FindTalentValue("special_bonus_ulquiorra_8")
			local cooldown =  caster:FindTalentValue("special_bonus_ulquiorra_8","cooldown")
			ComicsVsAnimeCharges(caster, "ulquiorra_ult", count_max, count_max, cooldown, "modifier_charges")
		end
	end
end 