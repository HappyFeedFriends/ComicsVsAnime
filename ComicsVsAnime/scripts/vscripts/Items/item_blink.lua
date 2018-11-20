LinkLuaModifier("modifier_item_blink", "items/item_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_blink_godly", "items/item_blink", LUA_MODIFIER_MOTION_NONE)
if item_blink_1 == nil then
	item_blink_1 = class({})
end

if item_blink_2 == nil then
	item_blink_2 = class({})
end

if item_blink_3 == nil then
	item_blink_3 = class({})
end

if item_blink_4 == nil then
	item_blink_4 = class({})
end

if item_blink_godly == nil then
	item_blink_godly = class({})
end

function item_blink_1:GetIntrinsicModifierName()
	return "modifier_item_blink"
end

function item_blink_2:GetIntrinsicModifierName()
	return "modifier_item_blink"
end

function item_blink_3:GetIntrinsicModifierName()
	return "modifier_item_blink"
end

function item_blink_godly:OnSpellStart()
	if IsServer() and self:GetCurrentCharges() > 0 then
		self:EndCooldown()
		self:SetCurrentCharges(self:GetCurrentCharges() - 1)
		local bonus_stack = self:GetSpecialValueFor("bonus_range")
		local range = self:GetSpecialValueFor("range")
		ComicsVsAnimeAddStack(self:GetCaster(), self,bonus_stack, bonus_stack, "modifier_item_blink_godly", -1, false, true,true,false)
		if self:GetCaster():HasModifier("modifier_item_blink_godly") then
			local modifier = self:GetCaster():FindModifierByName("modifier_item_blink_godly")
			range = range + modifier:GetStackCount()
		end
		particle = "particles/other/comics_vs_anime_blink_godly.vpcf"
		self:ComicsVsAnimeBlink(self:GetCaster(),range,particle,particle,0.03)
	else
		return nil
	end
end

function item_blink_1:OnSpellStart()
	if IsServer() then
		local range = self:GetSpecialValueFor("range")
		local effect = "particles/other/comics_vs_anime_blink_1_start.vpcf"
		local end_effect = "particles/other/comics_vs_anime_blink_1_end.vpcf"
		self:ComicsVsAnimeBlink(self:GetCaster(),range,effect,end_effect,0.15)
	end	
end	

function item_blink_2:OnSpellStart()
	if IsServer() then
		local range = self:GetSpecialValueFor("range")
		local effect = "particles/other/comics_vs_anime_blink_2_start.vpcf"
		local end_effect = "particles/other/comics_vs_anime_blink_2_end.vpcf"
		self:ComicsVsAnimeBlink(self:GetCaster(),range,effect,end_effect,0.25)
	end	
end	

function item_blink_3:OnSpellStart()
	if IsServer() then
		local range = self:GetSpecialValueFor("range")
		local effect = "particles/other/comics_vs_anime_blink_3_start.vpcf"
		local end_effect = "particles/other/comics_vs_anime_blink_3_end.vpcf"
		self:ComicsVsAnimeBlink(self:GetCaster(),range,effect,end_effect,0.25)
	end	
end	

function item_blink_4:OnSpellStart()
	if IsServer() then
		local range = self:GetSpecialValueFor("range")
		local effect = "particles/other/comics_vs_anime_blink_4_start.vpcf"
		local end_effect = "particles/other/comics_vs_anime_blink_4_end.vpcf"
		self:ComicsVsAnimeBlink(self:GetCaster(),range,effect,end_effect,0.25)
	end	
end	

if modifier_item_blink_godly == nil then
	modifier_item_blink_godly = class({})
end

function modifier_item_blink_godly:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("cooldown_charges"))	
	end
end

function modifier_item_blink_godly:OnIntervalThink() 
	if IsServer() and self:GetAbility():GetCurrentCharges() <= self:GetAbility():GetSpecialValueFor("max_charges") then
		local current_charges = self:GetAbility():GetCurrentCharges()
		self:GetAbility():SetCurrentCharges(current_charges + 1)	
	end
end

function modifier_item_blink_godly:IsHidden() 
	return true 
end

function modifier_item_blink_godly:IsPurgable() 
	return false 
end
 
function modifier_item_blink_godly:RemoveOnDeath() 
	return false 
end	

if modifier_item_blink == nil then
	modifier_item_blink = class({})
end

function modifier_item_blink:IsHidden() 
	return true 
end

function modifier_item_blink:IsPurgable() 
	return false 
end
 
function modifier_item_blink:RemoveOnDeath() 
	return false 
end

function modifier_item_blink:DeclareFunctions()
		local funcs =
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return funcs
end
	
function modifier_item_blink:OnTakeDamage(params)	
	if self:GetParent() ~= params.attacker and params.attacker:IsHero() or params.attacker:IsAncient() and self:GetAbility():GetCooldown(self:GetAbility():GetLevel()) < self:GetAbility():GetSpecialValueFor("dur") or self:GetAbility():GetCooldown(self:GetAbility():GetLevel()) == 0  then
		self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("dur"))
	end	
	
end