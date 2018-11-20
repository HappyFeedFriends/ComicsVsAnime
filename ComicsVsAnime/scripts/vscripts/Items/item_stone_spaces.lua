if item_stone_spaces == nil then
	item_stone_spaces = class({})
end
LinkLuaModifier("modifier_item_stone_spaces", "items/item_stone_spaces", LUA_MODIFIER_MOTION_NONE)

function item_stone_spaces:GetIntrinsicModifierName()
	return "modifier_item_stone_spaces"
end	

modifier_item_stone_spaces = modifier_item_stone_spaces or class({})

function modifier_item_stone_spaces:IsHidden() return true end
function modifier_item_stone_spaces:IsPurgable() return false end
function modifier_item_stone_spaces:IsDebuff() return false end
function modifier_item_stone_spaces:RemoveOnDeath() return false end

function modifier_item_stone_spaces:DeclareFunctions()
	return {MODIFIER_PROPERTY_REINCARNATION,MODIFIER_EVENT_ON_DEATH}
end

function modifier_item_stone_spaces:ReincarnateTime(params)
	if self:GetAbility():IsCooldownReady() and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) then
		return self:GetAbility():GetSpecialValueFor("time_respawn")
	end
end	

function modifier_item_stone_spaces:OnDeath(params)
	if params.unit == self:GetParent() and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) and self:GetAbility():IsCooldownReady() then
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	end
end