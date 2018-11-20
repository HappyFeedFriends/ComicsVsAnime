
if akame_debuff_muramasa == nil then
	akame_debuff_muramasa = class({})
end

function akame_debuff_muramasa:OnCreated( kv )
    self:StartIntervalThink(1)
	self.stack_modifier = self:GetAbility():GetSpecialValueFor("time_kill")
	self.stackParticle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_numbers_osnova.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl( self.stackParticle, 1, Vector( 0, self.stack_modifier, 0 ) )
end

function akame_debuff_muramasa:IsBuff()
    return true
end

function akame_debuff_muramasa:IsHidden()
	return false
end

function akame_debuff_muramasa:IsPurgable()
    return false
end

function akame_debuff_muramasa:RemoveOnDeath()
    return true
end

function akame_debuff_muramasa:OnIntervalThink()
		self.stack_modifier = self.stack_modifier - 1
		if self.stack_modifier <= 6 then
			ParticleManager:DestroyParticle(self.stackParticle, true)
			self.stackParticle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_numbers_osnova_2.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		end
		if self.stack_modifier <= 3 then
			ParticleManager:DestroyParticle(self.stackParticle, true)
			self.stackParticle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_numbers_osnova_3.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		end
		ParticleManager:SetParticleControl( self.stackParticle, 1, Vector( 0, self.stack_modifier, 0 ) )
		if IsServer() then
			self:GetParent():SetModifierStackCount( "akame_debuff_muramasa", self:GetAbility(), self.stack_modifier  )
		end
end

function akame_debuff_muramasa:OnDestroy()
  ParticleManager:DestroyParticle(self.stackParticle, true)
  ParticleManager:ReleaseParticleIndex( self.stackParticle )
  if IsServer() then
	  self:GetParent():Kill(self:GetAbility(), self:GetCaster())
	  if self:GetParent():IsAlive() then
		self:GetParent():Purge(true,false,true,true,true)
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
	  end
  end
end