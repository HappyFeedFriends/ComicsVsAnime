thor_lightning_hammer = thor_lightning_hammer or class({})

function thor_lightning_hammer:OnSpellStart()
	self.radius = self:GetSpecialValueFor("radius")
	self.damage = self:GetSpecialValueFor("damage")
	local target_type = self:GetAbilityTargetType()
	local all_vision = false
	local lightning = self:GetCaster():FindModifierByName("modifier_thor_lightning_tooltip")
	if lightning then
		self.damage = self.damage + (lightning:GetStackCount() * self:GetSpecialValueFor("damage_per_electric"))
		self:GetCaster():RemoveModifierByName("modifier_thor_lightning_tooltip")
	end
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_1") then
		self.radius = 999999
		target_type = DOTA_UNIT_TARGET_HERO
		all_vision = true
	end 
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(),nil,self.radius, self:GetAbilityTargetTeam(),target_type,self:GetAbilityTargetFlags(),FIND_ANY_ORDER, false )
	for _,unit in pairs(units) do
		if all_vision then
			unit:AddNewModifier(self:GetCaster(),self,"modifier_vision_target",{duration = 0.8})
		end 
		local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf",  PATTACH_POINT, unit)
		ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin());
		ParticleManager:SetParticleControl(particle, 2, unit:GetAbsOrigin());
		--self:ApplyCustomDamage(unit, self:GetCaster(), self.damage)
		local damageTable = 
		{
			victim = unit,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(damageTable)
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_7") then
			unit:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{duration = self:GetCaster():ComicsVsAnimeTalent("special_bonus_thor_7") })
		end 
	end
end