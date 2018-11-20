--[[
	Author: HappyFeedFriends
	Data Release: 10.06.2018
	Data Update:  10.06.2018
]]

item_quantum_sphere = class({})

LinkLuaModifier("modifier_orb_of_sphere_passive", "items/item_quantum_sphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orb_of_sphere_target", "items/item_quantum_sphere", LUA_MODIFIER_MOTION_NONE)

function item_quantum_sphere:GetIntrinsicModifierName()
	return "modifier_orb_of_sphere_passive"
end



function item_quantum_sphere:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_orb_of_sphere_target", {duration = self:GetSpecialValueFor("duration")})	
end

modifier_orb_of_sphere_passive = class({})
	
function modifier_orb_of_sphere_passive:IsHidden() 
	return true 
end
function modifier_orb_of_sphere_passive:IsPurgable() 
	return false 
 end
 
function modifier_orb_of_sphere_passive:IsDebuff() 
	return false 
end

function modifier_orb_of_sphere_passive:IsPermanent() 
	return true 
end

function modifier_orb_of_sphere_passive:RemoveOnDeath() 
	return false 
end

function modifier_orb_of_sphere_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return funcs
end

function modifier_orb_of_sphere_passive:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health_bonus")
end	

function modifier_orb_of_sphere_passive:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_orb_of_sphere_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_orb_of_sphere_passive:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_orb_of_sphere_passive:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_orb_of_sphere_passive:GetAbsorbSpell(keys)
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		self.particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_quantiun_osnova.vpcf" ,PATTACH_POINT_FOLLOW, self:GetParent())  
        ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( self.particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex(self.particle)

        EmitSoundOn("DOTA_Item.ComboBreaker", self:GetParent())		
	
		return 1
	else
		return false
	end	
end

modifier_orb_of_sphere_target = class({})

function modifier_orb_of_sphere_target:IsHidden() 
	return false 
end
function modifier_orb_of_sphere_target:IsPurgable() 
	return false 
 end
 
function modifier_orb_of_sphere_target:OnCreated(keys)
	self.particle = ParticleManager:CreateParticle("particles/items3_fx/lotus_orb_shell.vpcf" ,PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end
 
function modifier_orb_of_sphere_target:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex( self.particle )
end
 
function modifier_orb_of_sphere_target:IsDebuff() 
	return false 
end

function modifier_orb_of_sphere_target:RemoveOnDeath() 
	return false 
end

function modifier_orb_of_sphere_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REFLECT_SPELL}

	return funcs
end

function modifier_orb_of_sphere_target:GetReflectSpell(keys)
	local parent = self:GetParent()
		if parent:IsIllusion() then 
			return 
		end
		local originalAbility = keys.ability
		self.absorb_without_check = false
		if originalAbility:GetCaster():GetTeam() == parent:GetTeam() then 
			return 
		end

	if not self.absorb_without_check then
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/arena/items_fx/lotus_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent), 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		parent:EmitSound("Item.LotusOrb.Activate")
		self.absorb_without_check = true
	end

	if self.absorb_without_check then
		if IsValidEntity(self.reflect_stolen_ability) then
			self.reflect_stolen_ability:RemoveSelf()
		end
		local HParent = self:GetParent()
		local hAbility = HParent:AddAbility(originalAbility:GetAbilityName())
		if hAbility then
			hAbility:SetStolen(true)
			hAbility:SetHidden(true)
			hAbility:SetLevel(originalAbility:GetLevel())
			HParent:SetCursorCastTarget(originalAbility:GetCaster())
			hAbility:OnSpellStart()
			hAbility:SetActivated(false)
			self.reflect_stolen_ability = hAbility
		end
	end
end