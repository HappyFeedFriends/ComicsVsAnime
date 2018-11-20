if flash_thunder == nil then
	flash_thunder = class({})
end	

function flash_thunder:OnSpellStart()
	self.num = 0
	self.targets = 0
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_7") then
		self.num = 1
		self.targets = self:GetCaster():FindAbilityByName("special_bonus_flash_7"):GetSpecialValueFor("value")
	end
	self.projTable = 
	{
	    EffectName = "particles/flash/comics_vs_anime_flash_lighning.vpcf",
	    Ability = self,
	    Target = self:GetCursorTarget(),
	    Source = self:GetCaster(),
	    bDodgeable = true,
	    bProvidesVision = true,
	    vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
	    iMoveSpeed = 1400,
	    iVisionRadius = 200,
	    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
	    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}
	    ProjectileManager:CreateTrackingProjectile(self.projTable)
end

function flash_thunder:OnProjectileHit( hTarget, vLocation )
	local damage = self:GetSpecialValueFor("damage")
	local dur = self:GetSpecialValueFor("dur_stunned")
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_1") then
		damage = damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_flash_1",nil,nil)
	end
	local damageTable = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damageTable)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = dur})
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_7") then
		local radius = self:GetCaster():FindAbilityByName("special_bonus_flash_7"):GetSpecialValueFor("radius")
		local target = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),hTarget:GetOrigin(),nil,radius,self:GetAbilityTargetTeam(),self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_ANY_ORDER, false )
		for k,v in pairs(target) do
			if v ~= self.projTable.Target and self.num <= self.targets then
				self.projTable.Target = v
				self.projTable.Source = hTarget
				self.projTable.vSpawnOrigin = hTarget:GetAbsOrigin()
				ProjectileManager:CreateTrackingProjectile( self.projTable )
				self.num = self.num + 1
				return true
			end 
		end
	end
end