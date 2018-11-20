
if modifier_damage_per_second == nil then
	modifier_damage_per_second = class({})
end

function modifier_damage_per_second:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(kv.interval)
		self.dmg = kv.damage
	end
end

function modifier_damage_per_second:IsDeBuff()
    return true
end

function modifier_damage_per_second:IsHidden()
	return true
end

function modifier_damage_per_second:IsPurgable()
    return true
end

function modifier_damage_per_second:RemoveOnDeath()
    return true
end

function modifier_damage_per_second:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() then
        if self:GetCaster():IsAlive() == false then
            self:Destroy()
        end
		self.damage = self.dmg
		local damage = {
		victim = thinker,
		attacker = self:GetCaster(), 
		damage = self.damage, 
		damage_type = self:GetAbility():GetAbilityDamageType()}				
        ApplyDamage(damage)
		print(ApplyDamage(damage))
	end
end