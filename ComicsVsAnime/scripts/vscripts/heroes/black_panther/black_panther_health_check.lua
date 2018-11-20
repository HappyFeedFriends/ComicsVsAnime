LinkLuaModifier ("modifier_black_panther_rage_activate", "heroes/black_panther/black_panther_health_check", LUA_MODIFIER_MOTION_NONE)
function black_panther_check_hp(keys)
	local ability = keys.ability
	if ability:IsCooldownReady() then
		local caster = keys.caster		
		local modifier = "modifier_black_panther_rage_activate"
		local health_pct = caster:GetHealthPercent()
		local health_limit = ability:GetSpecialValueFor("health_limit")
		local dur = ability:GetSpecialValueFor("duration")
		if health_pct <= health_limit then
			ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = dur})
			caster:AddNewModifier(caster, ability, modifier, {duration = dur})
				local model = 1.45
			caster:SetModelScale( model )
			caster:SetRenderColor(255, 0, 0)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end

function black_panther_back_model(keys)
	local caster = keys.caster
	caster:SetModelScale( 1.15 )
	caster:SetRenderColor(255, 255, 255)
end

modifier_black_panther_rage_activate = modifier_black_panther_rage_activate or class({})

function modifier_black_panther_rage_activate:IsHidden()return true end
function modifier_black_panther_rage_activate:IsPurgable()return false end
function modifier_black_panther_rage_activate:RemoveOnDeath()return true end

function modifier_black_panther_rage_activate:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
	return funcs
end

function modifier_black_panther_rage_activate:GetModifierPreAttack_BonusDamage( params )
local damage = self:GetAbility():GetSpecialValueFor("damage")
damage = self:GetCaster():BonusTalentValue("special_bonus_black_panther_6",damage)
    return damage
end

function modifier_black_panther_rage_activate:GetModifierAttackSpeedBonus_Constant( params )
local attack = self:GetAbility():GetSpecialValueFor("attack_speed")
attack = self:GetCaster():BonusTalentValue("special_bonus_black_panther_5",attack)
    return attack
end