LinkLuaModifier( "maka_black_blood_activate", "heroes/maka/maka_black_blood", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_maka_blood_checker", "heroes/maka/maka_black_blood", LUA_MODIFIER_MOTION_NONE )
if maka_black_blood == nil then
    maka_black_blood = class ({})
end

function maka_black_blood:GetCooldown( nLevel )
if IsServer() then
local talent = self:GetCaster():FindAbilityByName("special_bonus_maka_1")
	if talent and talent:GetLevel() > 0  then
	local value = talent:GetSpecialValueFor("value")
		return self.BaseClass.GetCooldown( self, nLevel ) + value
	end
end	
	return self.BaseClass.GetCooldown( self, nLevel )
end

function maka_black_blood:GetIntrinsicModifierName()
    return "modifier_maka_blood_checker"
end

function maka_black_blood:GetManaCost()
	return self:GetCaster():GetMaxMana() / 100 * self:GetSpecialValueFor("mana_cost")
end

function maka_black_blood:OnSpellStart()
	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")
		local talent = self:GetCaster():FindAbilityByName("special_bonus_maka_3")
		if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")
			duration = duration + value
		end
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "maka_black_blood_activate", {duration = duration})
	end
end

maka_black_blood_activate = class({})

function maka_black_blood_activate:IsBuff()
	return true
end

function maka_black_blood_activate:IsPurgable()
	return true
end

function maka_black_blood_activate:CheckState()
	local state = {
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function maka_black_blood_activate:OnCreated(htable)
	if IsServer() then
		local r = RandomInt(1,4)
		local particle = "particles/other/black_king_bar/comics_vs_anime_black_king_bar_white.vpcf"
			if r == 1 then
				particle = "particles/other/black_king_bar/comics_vs_anime_black_king_bar_orange.vpcf"
				elseif r == 2 then
				particle = "particles/other/black_king_bar/comics_vs_anime_black_king_bar_blue.vpcf"
				elseif r == 3 then
				particle = "particles/other/black_king_bar/comics_vs_anime_black_king_bar_azure.vpcf"
				else 
				particle = "particles/other/black_king_bar/comics_vs_anime_black_king_bar_red.vpcf"
			end
		local invis = ParticleManager:CreateParticleForPlayer(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetOwner())
        self:AddParticle(invis, false, true, 1000, false, false)
		local current_stack = self:GetCaster():GetModifierStackCount( "modifier_maka_soul", self:GetAbility() )
		local soul_cast = self:GetAbility():GetSpecialValueFor("soul_cast")
		self:GetCaster():SetModifierStackCount( "modifier_maka_soul", self:GetAbility(), current_stack - soul_cast )
	end
	self.armor = self:GetAbility():GetSpecialValueFor("armor_bonus")
end

function maka_black_blood_activate:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS	
}
	return funcs
end

function maka_black_blood_activate:GetModifierPhysicalArmorBonus()		
	return self.armor
end

modifier_maka_blood_checker = class({})

function modifier_maka_blood_checker:IsBuff()
	return true
end

function modifier_maka_blood_checker:IsPurgable()
	return false
end

function modifier_maka_blood_checker:IsPurgeException()
	return false
end

function modifier_maka_blood_checker:IsHidden()
	return true
end

function modifier_maka_blood_checker:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_maka_blood_checker:OnIntervalThink()
    if IsServer() then
		local current_stack = self:GetCaster():GetModifierStackCount( "modifier_maka_soul", self:GetAbility() )
		local cast_soul = self:GetAbility():GetSpecialValueFor("soul_cast")
			if current_stack < cast_soul then
				self:GetAbility():SetActivated(false)
			else
				self:GetAbility():SetActivated(true)
			end
	end
end
