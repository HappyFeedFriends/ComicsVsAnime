item_black_king_bar_1 = class({})
item_black_king_bar_2 = class({})
item_black_king_bar_3 = class({})

LinkLuaModifier("modifier_black_king_bar_passive", "items/item_black_king_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_king_bar_activate", "items/item_black_king_bar", LUA_MODIFIER_MOTION_NONE)

function item_black_king_bar_1:GetIntrinsicModifierName()
	return "modifier_black_king_bar_passive"
end

function item_black_king_bar_1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_black_king_bar_activate", {duration = self:GetSpecialValueFor("duration")})
end

function item_black_king_bar_2:GetIntrinsicModifierName()
	return "modifier_black_king_bar_passive"
end

function item_black_king_bar_2:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_black_king_bar_activate", {duration = self:GetSpecialValueFor("duration")})
end

function item_black_king_bar_3:GetIntrinsicModifierName()
	return "modifier_black_king_bar_passive"
end

function item_black_king_bar_3:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_black_king_bar_activate", {duration = self:GetSpecialValueFor("duration")})
end

modifier_black_king_bar_activate = class({})
	
function modifier_black_king_bar_activate:IsHidden() 
	return false 
end
function modifier_black_king_bar_activate:IsPurgable() 
	return false 
 end
 
function modifier_black_king_bar_activate:IsDebuff() 
	return false 
end

function modifier_black_king_bar_activate:IsPermanent() 
	return true 
end

function modifier_black_king_bar_activate:RemoveOnDeath() 
	return false 
end

function modifier_black_king_bar_activate:CheckState()
	local state = {
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
				}
	return state
end

function modifier_black_king_bar_activate:OnCreated()
	self.particle = ParticleManager:CreateParticle("particles/other/black_king_bar/comics_vs_anime_black_king_bar_purple.vpcf" ,PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_black_king_bar_activate:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex( self.particle )
end

modifier_black_king_bar_passive = class({})
	
function modifier_black_king_bar_passive:IsHidden() 
	return true 
end
function modifier_black_king_bar_passive:IsPurgable() 
	return false 
 end
 
function modifier_black_king_bar_passive:IsDebuff() 
	return false 
end

function modifier_black_king_bar_passive:IsPermanent() 
	return true 
end

function modifier_black_king_bar_passive:RemoveOnDeath() 
	return false 
end

function modifier_black_king_bar_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return funcs
end

function modifier_black_king_bar_passive:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end	


function modifier_black_king_bar_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end