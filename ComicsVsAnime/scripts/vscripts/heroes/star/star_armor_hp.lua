LinkLuaModifier("modifier_star_hp_armor", "heroes/star/star_armor_hp", LUA_MODIFIER_MOTION_NONE)

if star_armor_hp == nil then
	star_armor_hp = class({})
end

function star_armor_hp:GetIntrinsicModifierName()
    return "modifier_star_hp_armor"
end

modifier_star_hp_armor = class({})

function modifier_star_hp_armor:IsHidden()
	return true 
end

function modifier_star_hp_armor:IsPurgable() 
	return false
end

function modifier_star_hp_armor:RemoveOnDeath()
	return false
end

function modifier_star_hp_armor:OnCreated()
	self.hp = 0
end

function modifier_star_hp_armor:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_EVENT_ON_HERO_KILLED,}
	return funcs
end

function modifier_star_hp_armor:OnHeroKilled(params)
	if self:GetCaster():HasTalent("special_bonus_star_8") then
		self.hp = self.hp + params.target:GetMaxHealth()/100 * self:GetCaster():FindTalentValue("special_bonus_star_8")
	end
end

function modifier_star_hp_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_star_hp_armor:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health") + self.hp 
end
