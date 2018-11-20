sasuke_rinnengan = sasuke_rinnengan or class({})
LinkLuaModifier ("modifier_sasuke_rinnengan", "heroes/sasuke/sasuke_rinnengan", LUA_MODIFIER_MOTION_NONE)
function sasuke_rinnengan:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_sasuke_rinnengan",{duration = self:GetCaster():BonusTalentValue("special_bonus_sasuke_1",self:GetSpecialValueFor("duration"))})
end

modifier_sasuke_rinnengan = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end
})

function modifier_sasuke_rinnengan:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return funcs
end 

function modifier_sasuke_rinnengan:GetModifierEvasion_Constant()
	return self:GetCaster():BonusTalentValue("special_bonus_sasuke_5",self:GetAbility():GetSpecialValueFor("evasion"))
end 

