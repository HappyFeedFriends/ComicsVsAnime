if hulk_cry == nil then
	hulk_cry = class({})
end

function hulk_cry:OnSpellStart()
	if IsServer() then
	local caster = self:GetCaster()
	local chance = self:GetSpecialValueFor("chance")
	local dur = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	damage = (caster:BonusTalentValue("special_bonus_hulk_6",damage))/100 * caster:GetStrength()
	local Unites = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,self:GetAbilityTargetTeam(),self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_UNITS_EVERYWHERE,false)
	local particle = ParticleManager:CreateParticle( "particles/hulk/comics_vs_anime_hulk_cry.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		for k,enemy in pairs(Unites) do
			if RollPercentage(chance) then
				MODIFIER_HULK = {"modifier_stunned","modifier_slow_custom","modifier_rooted","modifier_disarmed"}
				self.hulk_m = {}
				local v = PickRandomShuffle( MODIFIER_HULK, self.hulk_m )
				if v == "modifier_slow_custom" then
					local move_slow = self:GetSpecialValueFor("slow")
					enemy:AddNewModifier( caster, self, v, {duration = dur * 2, slow = move_slow})
				else
					enemy:AddNewModifier( caster, self, v, {duration = dur * 2})
				end
			end	
			enemy:AddNewModifier( caster, self, "modifier_stunned", {duration = dur})	
			ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = damage,  damage_type = self:GetAbilityDamageType()})
		end	
	end
end	