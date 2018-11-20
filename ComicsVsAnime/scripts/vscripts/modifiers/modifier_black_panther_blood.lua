
if modifier_black_panther_blood == nil then
	modifier_black_panther_blood = class({})
end

function modifier_black_panther_blood:OnCreated( kv )
    self:StartIntervalThink(1)
	if IsClient() then
		local sEffect = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring_splatters_lv.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

function modifier_black_panther_blood:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_black_panther_blood:IsDeBuff()
    return true
end

function modifier_black_panther_blood:IsHidden()
	return false
end

function modifier_black_panther_blood:IsPurgable()
    return false
end

function modifier_black_panther_blood:RemoveOnDeath()
    return true
end

function modifier_black_panther_blood:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() then
        if self:GetCaster():IsAlive() == false then
            self:Destroy()
        end
		self.damage = self:GetCaster():FindAbilityByName("special_bonus_black_panther_1"):GetSpecialValueFor("damage")
		local damage = {victim = thinker, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL}				
        ApplyDamage(damage)
		print(ApplyDamage(damage))
	end
end

function modifier_black_panther_blood:GetTexture()
	return "custom_ability/black_panther_kogti" 
end