ichigo_tensa = ichigo_tensa or class({})

function ichigo_tensa:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/other/ichigo_getsuco.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(3000,0,0))
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_ichigo_3") then
			damage = damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_ichigo_3")
		end
	--self:ApplyCustomDamage(self:GetCursorTarget(), self:GetCaster(), damage, nil)
	local damageTable = 
		{
			victim = self:GetCursorTarget(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
		}
	ApplyDamage(damageTable)
	if self:GetCaster():HasTalent("special_bonus_ichigo_7") then
	local num = self:GetCaster():FindTalentValue("special_bonus_ichigo_7")
	local number = 1
	local unites = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCursorTarget():GetAbsOrigin(), nil,self:GetCaster():FindTalentValue("special_bonus_ichigo_7","radius"),self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_CLOSEST,false)
		for _,unit in pairs(unites) do
			if number <= num and unit ~= self:GetCursorTarget() then
				number = number + 1
				particle = ParticleManager:CreateParticle("particles/other/ichigo_getsuco.vpcf",  PATTACH_POINT, self:GetCaster())
				ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT, "attach_attack1", unit:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
				ParticleManager:SetParticleControl(particle, 2, Vector(3000,0,0))
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end 
		end 
	end
end 