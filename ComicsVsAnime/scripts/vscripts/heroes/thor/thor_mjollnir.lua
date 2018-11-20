thor_mjollnir = thor_mjollnir or class({})

function thor_mjollnir:OnSpellStart()
	self.num = 1
	self.radius = self:GetSpecialValueFor("radius")
	self.base_damage = self:GetSpecialValueFor("base_damage")
	self.axes = self:GetSpecialValueFor("num_targets")
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_2") then
		self.axes = self.axes + self:GetCaster():ComicsVsAnimeTalent("special_bonus_thor_2")
	end	
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_4") then
		self.base_damage = self.base_damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_thor_4")
	end 
	self.damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetSpecialValueFor("damage") + self.base_damage
	self.bonus_damage = self:GetSpecialValueFor("bonus_damage")
	self:SetActivated(false)
	self.info = 
	{
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/heroes/thor_mjolnier.vpcf",
		bDodgeable = false,
		bProvidesVision = true,
		iMoveSpeed = 1000,
		iVisionRadius = 250,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
	}
	ProjectileManager:CreateTrackingProjectile( self.info )
	RemoveWearables( self:GetCaster() )
end

function thor_mjollnir:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= self:GetCaster() then
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(),nil,self.radius, self:GetAbilityTargetTeam(),self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_ANY_ORDER, false )
		--self:ApplyCustomDamage(hTarget, self:GetCaster(), self.damage)
	local damageTable = 
	{
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damageTable)
		self.damage = self.damage + (self.damage / 100 * self.bonus_damage)
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_3") then
			hTarget:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{duration = self:GetCaster():ComicsVsAnimeTalent("special_bonus_thor_3")})
		end 
		for k,v in pairs(units) do
			if v ~= self.info.Target then
				self.info.Target = v
				self.info.Source = hTarget
				if self.num <= self.axes then	
					ProjectileManager:CreateTrackingProjectile( self.info )
					self.num = self.num + 1
					return true
				end
			end	
		end
		self.info.Target = self:GetCaster()
		self.info.Source = hTarget
		ProjectileManager:CreateTrackingProjectile( self.info )
	else
		ComicsVsAnime:OnHeroInGame(self:GetCaster())
		self:SetActivated(true)
	end	
end 