if item_mkb == nil then item_mkb = class({}) end
LinkLuaModifier( "modifier_item_mkb", "items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_item_mkb_unique", "items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )	

function item_mkb:GetIntrinsicModifierName()
	return "modifier_item_mkb" 
end


-----------------------------------------------------------------------------------------------------------
--	Monkey King Bar owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_mkb == nil then modifier_item_mkb = class({}) end
function modifier_item_mkb:IsHidden() return true end
function modifier_item_mkb:IsDebuff() return false end
function modifier_item_mkb:IsPurgable() return false end
function modifier_item_mkb:IsPermanent() return true end
function modifier_item_mkb:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the caster when created
function modifier_item_mkb:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_mkb_unique") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_mkb_unique", {})
		end
	end
end

-- Removes the unique modifier from the caster if this is the last MKB in its inventory
function modifier_item_mkb:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_mkb") then
			parent:RemoveModifierByName("modifier_item_mkb_unique")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_mkb:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_item_mkb:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

if modifier_item_mkb_unique == nil then modifier_item_mkb_unique = class({}) end
function modifier_item_mkb_unique:IsHidden() return true end
function modifier_item_mkb_unique:IsDebuff() return false end
function modifier_item_mkb_unique:IsPurgable() return false end
function modifier_item_mkb_unique:IsPermanent() return true end

function modifier_item_mkb_unique:OnCreated()
	self.bonus_range = self:GetAbility():GetSpecialValueFor("bonus_range")
	self.pulverize_count = self:GetAbility():GetSpecialValueFor("pulverize_count")
	self.pulverize_damage = self:GetAbility():GetSpecialValueFor("pulverize_damage")
	self.pulverize_stun = self:GetAbility():GetSpecialValueFor("pulverize_stun")
end
function modifier_item_mkb_unique:CheckState()
	local states = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
	return states
end
function modifier_item_mkb_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_mkb_unique:OnAttackLanded(keys)
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target
		if owner ~= keys.attacker then
			return end

		if owner:IsIllusion() then
			return 
		end
		if target:HasModifier("modifier_imba_juggernaut_blade_fury") and owner:IsRangedAttacker() then
			return nil
		end
			self:SetStackCount(self:GetStackCount() + 1)
			if self:GetStackCount() >= (self.pulverize_count - 1)then
				self:SetStackCount(0)
				target:EmitSound("DOTA_Item.MKB.Minibash")
				if target:IsMagicImmune() then
					return nil
				end
				target:AddNewModifier(owner, self:GetAbility(), "modifier_stunned", {duration = self.pulverize_stun})
				ApplyDamage({attacker = owner, victim = target, ability = self:GetAbility(), damage = self.pulverize_damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
