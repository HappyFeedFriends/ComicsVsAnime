item_stone_intellegence = item_stone_intellegence or class({})

LinkLuaModifier("modifier_item_stone_intellegence", "items/item_stone_intellegence", LUA_MODIFIER_MOTION_NONE)

function item_stone_intellegence:GetIntrinsicModifierName()
	return "modifier_item_stone_intellegence"
end

modifier_item_stone_intellegence = modifier_item_stone_intellegence  or class({})

function modifier_item_stone_intellegence:IsHidden() return true end
function modifier_item_stone_intellegence:IsPurgable() return false end
function modifier_item_stone_intellegence:IsDebuff() return false end
function modifier_item_stone_intellegence:RemoveOnDeath() return false end
function modifier_item_stone_intellegence:IsPurgeException() return false end

function modifier_item_stone_intellegence:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_item_stone_intellegence:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() and self:GetCaster():GetPrimaryAttribute() == 2 then
		local int = self:GetAbility():GetSpecialValueFor("bonus_int")
		self:GetCaster():ModifyIntellect(int)
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	end
end