modifier_rem_water_waves_aura = class({})

function modifier_rem_water_waves_aura:IsHidden()
	return true 
end
function modifier_rem_water_waves_aura:IsAura() 	
	return true
end

function modifier_rem_water_waves_aura:IsPurgable() 
	return false
end

function modifier_rem_water_waves_aura:GetModifierAura()
	return "modifier_rem_waves_slow" 
end

function modifier_rem_water_waves_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_rem_water_waves_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end
function modifier_rem_water_waves_aura:GetAuraRadius()
	return self.radius
end

function modifier_rem_water_waves_aura:OnCreated()
	if IsServer() then
		local color = Vector(7, 245, 246)
		if self:GetCaster():HasModifier("modifier_rem_demon") then
			color = Vector(75, 0, 130)
		end	
		self.radius  = self:GetCaster():BonusTalentValue("special_bonus_rem_7",self:GetAbility():GetSpecialValueFor("radius"))
		self.particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_luzha.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 1, 1))
		ParticleManager:SetParticleControl(self.particle, 15, color)
		ParticleManager:SetParticleControl(self.particle, 16, Vector(25, 150, 25))
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_rem_water_waves_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end

modifier_rem_waves_slow = class({})

function modifier_rem_waves_slow:IsDebuff() 
	return true 
end

function modifier_rem_waves_slow:IsPurgable() 
	return false 
 end

function modifier_rem_waves_slow:DeclareFunctions()
	return {MODIFIER_EVENT_ON_UNIT_MOVED,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_rem_waves_slow:OnUnitMoved(event)
	if IsServer() and self:GetParent() == event.unit then
		self.damage = (self:GetAbility():GetSpecialValueFor("damage")/100)
		if self:GetCaster():HasModifier("modifier_rem_demon") and self:GetCaster():FindAbilityByName("rem_demon") and self:GetCaster():FindAbilityByName("rem_demon"):GetLevel() > 0 then
			self.damage = self.damage + (self:GetCaster():FindAbilityByName("rem_demon"):GetSpecialValueFor("damage_ice")/100)
		end
			self.damage = self:GetParent():GetMaxHealth() * self.damage
				local damage_table ={attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
						ability = self:GetAbility(),
						victim = self:GetParent()}
		if not self:GetParent():IsBosses() then			
			ApplyDamage(damage_table)
		end
	end
end

function modifier_rem_waves_slow:GetModifierMoveSpeedBonus_Percentage() 
local slow =  self:GetAbility():GetSpecialValueFor("Slow")
slow = self:GetCaster():BonusTalentValue("special_bonus_rem_5",slow)
	return slow
end