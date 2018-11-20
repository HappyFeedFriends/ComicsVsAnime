
if modifier_strange_shield == nil then 
	modifier_strange_shield = class({}) 
end

function modifier_strange_shield:IsBuff()
	return true
end

function modifier_strange_shield:IsPurgable()
	return true
end



function modifier_strange_shield:OnCreated(htable)
	if IsServer() then
		local particle = "particles/strange/comics_vs_anime_shield_osnova.vpcf"
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self.particle_start = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self:StartIntervalThink(interval)
	end
end

function modifier_strange_shield:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local talent = self:GetCaster():FindAbilityByName("special_bonus_strange_2")
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(), nil, radius,self:GetAbility():GetAbilityTargetTeam(),self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(),FIND_CLOSEST,false)
		self.damage = 0
		--------------------------------------------------------------------------------------------------------------------------------------
		for _,unit in ipairs(units) do
		local damage_table ={attacker = self:GetCaster(),damage = self:GetAbility():GetSpecialValueFor("damage"),damage_type = self:GetAbility():GetAbilityDamageType(),ability = self:GetAbility(),victim = unit}			
			if unit ~= self:GetCaster() then
				local particle = ParticleManager:CreateParticle("particles/strange/comics_vs_anime_shield_damage_osnova.vpcf", PATTACH_POINT_FOLLOW, unit) 
				ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true) 
				ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle)
				ApplyDamage(damage_table)
				self.damage = ApplyDamage(damage_table)
			end
		end
	----------------------------------------
	-- TALENT BONUS
	----------------------------------------
	if talent and talent:GetLevel() > 0  then
		local value = talent:GetSpecialValueFor("value")/100
		local units_friendly = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(), nil, radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO,self:GetAbility():GetAbilityTargetFlags(),FIND_CLOSEST,false)
				for _,unites in ipairs(units_friendly) do
					if self.damage > 0 and unites ~= self:GetCaster() then
						self.particle_heal = ParticleManager:CreateParticle("particles/strange/comics_vs_anime_shield_healing_osnova.vpcf", PATTACH_POINT_FOLLOW, unites) 
						ParticleManager:SetParticleControlEnt(self.particle_heal, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true) 
						ParticleManager:SetParticleControlEnt(self.particle_heal, 1, unites, PATTACH_POINT_FOLLOW, "attach_hitloc", unites:GetAbsOrigin(), true)
						ParticleManager:ReleaseParticleIndex(self.particle_heal)
						ComicsVsAnimeHeal(self.damage * value,self:GetCaster(),unites)
					end
				end
		end
	end
end

function modifier_strange_shield:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_strange_shield:OnTakeDamage(event)
	if IsServer() and self:GetParent() == event.unit then
		local damage = event.damage
		local modifier = "modifier_strange_shield"
		local current_stack = self:GetStackCount()
		if current_stack > damage then
			self:GetCaster():SetModifierStackCount( modifier, self:GetAbility(), current_stack - damage )
			self:GetCaster():SetHealth(self:GetParent():GetHealth() + damage)
		else
			self:GetCaster():SetHealth(self:GetParent():GetHealth() + current_stack)
			self:GetCaster():RemoveModifierByName(modifier)
		end
	end
end

function modifier_strange_shield:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle_start, true)
		ParticleManager:ReleaseParticleIndex( self.particle_start )
	end 
end