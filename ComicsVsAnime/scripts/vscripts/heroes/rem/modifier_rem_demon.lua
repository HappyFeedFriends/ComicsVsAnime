modifier_rem_demon = class({})

function modifier_rem_demon:IsHidden()
	return false 
end

function modifier_rem_demon:IsPurgable() 
	return false
end

function modifier_rem_demon:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_rem_demon:GetModifierIncomingDamage_Percentage()
local incoming = self:GetCaster():BonusTalentValue("special_bonus_rem_6",0)
	return incoming 
end 

function modifier_rem_demon:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end
function modifier_rem_demon:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end
function modifier_rem_demon:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_rem_demon:GetModifierAttackRangeBonus()
	return 450
end

function modifier_rem_demon:OnAttack(params)
	if IsServer() and params.attacker == self:GetCaster() then
	self:GetParent():ComicsVsAnimeSplitShot(self:GetAbility(),self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("split_hero")) 
	end
end

function modifier_rem_demon:OnCreated()
	if IsServer() then
		r = RandomInt(1,2)
		if r == 1 then
			self.sound = "ComicsVsAnime.rem_demon_1"
		else
			self.sound = "ComicsVsAnime.rem_demon_2"
		end
		EmitSoundOn(self.sound, self:GetCaster() )
		self:GetCaster():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end
end

function modifier_rem_demon:GetModifierModelChange()
	return "models/items/terrorblade/knight_of_foulfell_demon/knight_of_foulfell_demon.vmdl"
end

function modifier_rem_demon:OnDestroy()
	if IsServer() then
		StopSoundOn(self.sound,self:GetCaster())
		self:GetCaster():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex( self.particle )
		ParticleManager:DestroyParticle(self.particle2, true)
		ParticleManager:ReleaseParticleIndex( self.particle2 )
	end	
end

