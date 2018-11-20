item_aghanim2 = item_aghanim2 or class({})
LinkLuaModifier( "item_aghanim_buff", "items/item_aghanim.lua", LUA_MODIFIER_MOTION_NONE )
function item_aghanim2:OnSpellStart()
	if not self:GetCaster():HasModifier("modifier_item_ultimate_scepter_consumed") then
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_ultimate_scepter_consumed",{})
		self:GetCaster():EmitSound("Hero_Alchemist.Scepter.Cast")
	end 
	self:GetCaster():RemoveModifierByName("item_aghanim_buff")
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"item_aghanim_buff",{})
	self:GetCaster():RemoveItem(self)
end 

function item_aghanim2:GetIntrinsicModifierName()
	return "item_aghanim_buff"
end

item_aghanim_buff = item_aghanim_buff or class({})

function item_aghanim_buff:RemoveOnDeath()return false end
function item_aghanim_buff:IsHidden()return true end
function item_aghanim_buff:IsPurgeException()return false end

function item_aghanim_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function item_aghanim_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS
	}
	return funcs
end	

function item_aghanim_buff:OnCreated()
	self.stats = self:GetAbility():GetSpecialValueFor("all_stats")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
	self.mp = self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function item_aghanim_buff:GetModifierBonusStats_Agility()
	return self.stats
end
function item_aghanim_buff:GetModifierBonusStats_Intellect()
	return self.stats
end
function item_aghanim_buff:GetModifierBonusStats_Strength()
	return self.stats
end
function item_aghanim_buff:GetModifierManaBonus()
	return self.mp
end