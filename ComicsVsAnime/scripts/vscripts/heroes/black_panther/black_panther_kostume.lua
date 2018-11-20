LinkLuaModifier ("modifier_black_panther_kostume", "heroes/black_panther/black_panther_kostume", LUA_MODIFIER_MOTION_NONE)

if black_panther_kostume == nil then
    black_panther_kostume = class ( {})
end

function black_panther_kostume:GetIntrinsicModifierName()
    return "modifier_black_panther_kostume"
end



modifier_black_panther_kostume = class({}) 

function modifier_black_panther_kostume:IsHidden()
    return true
end

function modifier_black_panther_kostume:IsPurgable()
	return false
end

function modifier_black_panther_kostume:RemoveOnDeath()
	return true
end

function modifier_black_panther_kostume:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
	return funcs
end


function modifier_black_panther_kostume:GetModifierPhysicalArmorBonus( params )
local armor = self:GetAbility():GetSpecialValueFor("armor_bonus")
    return armor
end

function modifier_black_panther_kostume:GetModifierMoveSpeedBonus_Constant( params )
local move = self:GetAbility():GetSpecialValueFor("move_bonus")
move = self:GetCaster():BonusTalentValue("special_bonus_black_panther_7",move)
    return move
end

function modifier_black_panther_kostume:GetModifierPreAttack_BonusDamage( params )
local damage = self:GetAbility():GetSpecialValueFor("damage_bonus")
    return damage
end

function modifier_black_panther_kostume:GetModifierAttackSpeedBonus_Constant( params )
local attack = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
    return attack
end

