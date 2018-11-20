LinkLuaModifier( "modifier_thanos_ult_thinker", "heroes/thanos/thanos_ult.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "thanos_ult_modifier", "heroes/thanos/thanos_ult.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

thanos_ult = class ( {})

function thanos_ult:GetAbilityTextureName()
    return "custom_ability/thanos_ult"
end

function thanos_ult:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_charges_thanos") then
			return 0
		end
    return self.BaseClass.GetCooldown( self, nLevel )
end

function thanos_ult:OnSpellStart()
	if IsServer() then 
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()
		local team_id = caster:GetTeamNumber()
		local duration = self:GetSpecialValueFor("duration")
		local thinker = CreateModifierThinker(caster, self, "modifier_thanos_ult_thinker", {duration = duration}, point, team_id, false)
		local talent1 = caster:FindAbilityByName("special_bonus_thanos_4")
		if talent1 and talent1:GetLevel() > 0 then
			if caster:HasModifier("modifier_charges_thanos") and caster:GetModifierStackCount( "modifier_charges_thanos", caster ) > 0 then
			self:EndCooldown()
			end
		end	
	end
end

modifier_thanos_ult_thinker = class ({})
function modifier_thanos_ult_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
		local caster = self:GetCaster()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
		local interval = ability:GetSpecialValueFor("interval")
		local talent = caster:FindAbilityByName("special_bonus_thanos_3")
        self.damage_per = ability:GetSpecialValueFor("damage_per")/100
		if caster:ComicsVsAnimeHasTalent("special_bonus_thanos_7") then
			self.damage_per = self.damage_per + caster:ComicsVsAnimeTalent("special_bonus_thanos_7")/100
		end
		self.damage_end = ability:GetSpecialValueFor("damage_end")/100
        self.radius = ability:GetSpecialValueFor("radius")
        self:StartIntervalThink(interval)
		if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")
			self.damage_end = self.damage_end + value/100
		end
            local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova.vpcf", PATTACH_CUSTOMORIGIN, thinker )
            ParticleManager:SetParticleControl( nFXIndex, 0, target)
            ParticleManager:SetParticleControl( nFXIndex, 1, target)
            ParticleManager:SetParticleControl( nFXIndex, 3, target)
            self:AddParticle( nFXIndex, false, false, -1, false, true )
            EmitSoundOn("Hero_Phoenix.SuperNova.Cast", thinker)
            self.sound = "Hero_Phoenix.SuperNova.Begin"
            StartSoundEvent( self.sound, thinker)
			AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
			GridNav:DestroyTreesAroundPoint(target, 1500, false)
    end
end

function modifier_thanos_ult_thinker:OnIntervalThink()
	if self:GetAbility() ~= nil then
		local thinker = self:GetParent()
		local thinker_pos = thinker:GetAbsOrigin()
		local nearby_targets = FindUnitsInRadius(thinker:GetTeam(),
			thinker:GetAbsOrigin(), nil, self.radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER,
			false)

		for i, target in ipairs(nearby_targets) do
			local damage =  target:GetMaxHealth() * self.damage_per
			local damageTable = {
			victim = target,
			attacker = self:GetAbility():GetCaster(),
			ability = self:GetAbility(), 
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(), }
			ApplyDamage(damageTable)
		end
	end
end

function modifier_thanos_ult_thinker:OnDestroy()
    if IsServer() then
        StopSoundEvent(self.sound, self:GetParent())
			local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 5, Vector(self.radius, self.radius, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex )
       local duration_stunned = self:GetAbility():GetSpecialValueFor("duration_stunned")
        local caster = self:GetParent()
        EmitSoundOn( "Hero_EarthShaker.EchoSlam", caster )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", caster )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster )
        EmitSoundOn( "PudgeWarsClassic.echo_slam", caster )
        local thinker =  self:GetParent()
        local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), 
			thinker:GetAbsOrigin(), 
			nil, 
			self.radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false)

        for i, target in ipairs(nearby_targets) do
            local damage =  target:GetMaxHealth() * self.damage_end
			if not target:IsBosses() then
				ApplyDamage({
				victim = target, 
				attacker = self:GetAbility():GetCaster(),
				ability = self:GetAbility(),
				damage = damage, 
				damage_type = self:GetAbility():GetAbilityDamageType(),})
			end
			
            target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {duration = duration_stunned})
        end
    end
end

function modifier_thanos_ult_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function modifier_thanos_ult_thinker:IsAura()
    return true
end

function modifier_thanos_ult_thinker:GetAuraRadius()
    return self.radius
end

function modifier_thanos_ult_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_thanos_ult_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_thanos_ult_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_thanos_ult_thinker:GetModifierAura()
    return "thanos_ult_modifier"
end

thanos_ult_modifier = class ({})

function thanos_ult_modifier:IsDebuff()
    return true
end

function thanos_ult_modifier:IsHidden()
    return true
end

function thanos_ult_modifier:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function thanos_ult_modifier:GetEffectAttachType ()
    return PATTACH_POINT_FOLLOW
end
