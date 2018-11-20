modifier_rem_mana_steal = class({})

function modifier_rem_mana_steal:IsHidden()
	return true 
end

function modifier_rem_mana_steal:IsPurgable() 
	return false
end

function modifier_rem_mana_steal:OnCreated()
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
	end	
end

function modifier_rem_mana_steal:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local mana =  self:GetAbility():GetSpecialValueFor("mana_steal")/100
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(), nil, radius,self:GetAbility():GetAbilityTargetTeam(),self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(),FIND_CLOSEST,false)
		for _,unit in ipairs(units) do
			if unit ~= self:GetCaster() then
				if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_rem_2") == true then
					mana = mana + self:GetCaster():ComicsVsAnimeTalent("special_bonus_rem_2",nil,nil)/100
				end
				self.mana_target = unit:GetMana() * mana 
				self.particle = ParticleManager:CreateParticle("particles/strange/comics_vs_anime_shield_damage_osnova.vpcf", PATTACH_POINT_FOLLOW, unit) 
				ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true) 
				ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.particle)
				self:GetCaster():ComicsVsAnimeMana(self.mana_target,1,nil)
				unit:ComicsVsAnimeMana(self.mana_target,2,false)
				local dmg = self:GetAbility():GetSpecialValueFor("damage")
				dmg = self:GetCaster():BonusTalentValue("special_bonus_rem_3",dmg)
				local damage = (unit:GetMaxMana() - unit:GetMana())/100 * dmg
				local damageTable = {
				attacker = self:GetCaster(),
				victim = unit,
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self:GetAbility()}
				ApplyDamage(damageTable)
			end
		end
	end
end	