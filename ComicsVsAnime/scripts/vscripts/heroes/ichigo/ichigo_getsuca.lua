ichigo_getsuca = ichigo_getsuca or class({})

function ichigo_getsuca:OnSpellStart()
	self:GetCaster():EmitSound("ComicsVsAnime.ichigo_getsuca")
    local vDirection = (self:GetCaster():GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
	local projectile_info = 
	{
        Ability = self,
        EffectName = "particles/invoker_deafening_blast.vpcf", 		
        vSpawnOrigin = self:GetCaster():GetOrigin(), 						
        fDistance = self:GetSpecialValueFor("range"), 						
        fStartRadius = 500,									 				
        fEndRadius = 500,													
        Source = self:GetCaster(), 											
        bHasFrontalCone = true, 											
        bReplaceExisting = false, 											
        iUnitTargetTeam = self:GetAbilityTargetTeam(),						
        iUnitTargetFlags = self:GetAbilityTargetFlags(),					
        iUnitTargetType = self:GetAbilityTargetType(),						
        vVelocity = vDirection * 900, 										
        bVisibleToEnemies = true, 
		iVisionRadius = 200													
	}
	ProjectileManager:CreateLinearProjectile(projectile_info)
end 

function ichigo_getsuca:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = self:GetSpecialValueFor("damage")
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_ichigo_2") then
			damage = damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_ichigo_2")
		end
		--self:ApplyCustomDamage(hTarget, self:GetCaster(), damage, nil)
		local damageTable = 
		{
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(damageTable)
	end
end