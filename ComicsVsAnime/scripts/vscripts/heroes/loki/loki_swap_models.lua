loki_swap_models = loki_swap_models or class({})

LinkLuaModifier ("modifier_loki_swap", "heroes/loki/loki_swap_models", LUA_MODIFIER_MOTION_NONE)
--[[
	AUTHOR: HAPPYFEEDFRIENDS
	DATE CREATION: 04.07.2018
  ]]
  	
function loki_swap_models:OnSpellStart()
	self.target = self:GetCursorTarget()
	if self.target ~= self:GetCaster() then
		local projectile_info = 
		{
			EffectName = "particles/loki/comics_vs_anime_loki_swap_models.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCursorTarget():GetAbsOrigin(),
			Target = self:GetCaster(),
			Source = self.target,
			bHasFrontalCone = false,
			iMoveSpeed = 600,
			bReplaceExisting = false,
			bProvidesVision = false,
			bDodgeable = false,
			bVisibleToEnemies = true,
		}
		ProjectileManager:CreateTrackingProjectile(projectile_info)
	end
end

function loki_swap_models:OnProjectileHit( hTarget, vLocation )
	local dur = self:GetSpecialValueFor("duration")
	hTarget:AddNewModifier(self.target,self,"modifier_loki_swap",{duration = dur})
end

modifier_loki_swap = modifier_loki_swap or class({})

function modifier_loki_swap:IsBuff()
	return true
end

function modifier_loki_swap:IsDebuff()
	return false
end	

function modifier_loki_swap:OnCreated(params)
	self.hero = "heroes/"..self:GetCaster():GetUnitName()
	self.caster_name = self:GetCaster():GetUnitName()
	self.target_name = self:GetParent():GetUnitName()
	if IsServer() then
		self.Caster_spells = {}
		if self:GetParent():ComicsVsAnimeHasTalent("special_bonus_loki_2") == false and self:GetAbility() then
			self:GetAbility():SetActivated(false) 
		end
		self.model = self:GetCaster():GetKeyValue("Model")
		self.model_scale = self:GetCaster():GetKeyValue("ModelScale")
		self.model_scale_end = self:GetParent():GetKeyValue("ModelScale")
		self:GetParent():SetUnitName(self.caster_name)
		self:GetParent():SetModelScale(self.model_scale)
		RemoveWearables(self:GetParent())
		ComicsVsAnime:OnHeroInGame(self:GetParent())
		local DOTA_ABILITY = LoadKeyValues("scripts/npc/npc_abilities.txt")
		local ult = true
		for slot = 0, self:GetCaster():GetAbilityCount() - 1 do
			local ability_caster = self:GetCaster():GetAbilityByIndex(slot)
			local ability_target = self:GetParent():GetAbilityByIndex(slot)
			local ability_caster_type = ability_caster:GetKeyValue("AbilityType")
			local ability_target_type = ability_target:GetKeyValue("AbilityType")
			if ability_caster_type == "DOTA_ABILITY_TYPE_ULTIMATE" and ability_target_type == "DOTA_ABILITY_TYPE_ULTIMATE" and  self:GetParent():ComicsVsAnimeHasTalent("special_bonus_loki_2") == false then
				ult = false
			end
			if ability_caster and ability_target and DOTA_ABILITY ~= ability_target and DOTA_ABILITY ~= ability_caster then
				ability_caster = ability_caster:GetAbilityName()
				ability_target = ability_target:GetAbilityName()
				if  ability_target and ability_caster and not string.find(ability_target,"special_bonus_") and not string.find(ability_caster,"special_bonus_") then
					if ability_caster ~= "generic_hidden" and ability_target ~= "generic_hidden" and ult then
						self.Caster_spells[slot] = 
						{
							AbilityName = ability_target,
							LevelAbility = self:GetParent():GetAbilityByIndex(slot):GetLevel(),
						}
						self:GetParent():SwapAbility(ability_target,ability_caster)
						self:GetParent():GetAbilityByIndex(slot):SetLevel(self:GetCaster():GetAbilityByIndex(slot):GetLevel())
						self:GetParent():GetAbilityByIndex(slot):SetStolen(true)
					end	
				else    
					break
				end
			end
		end	
	end
end

function modifier_loki_swap:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE,MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_loki_swap:OnTooltip()
	return self:GetCaster():GetUnitName()
end	
function modifier_loki_swap:GetModifierModelChange()
	return self.model
end	
	
function modifier_loki_swap:OnDestroy()
	if IsServer() then
		self:GetParent():SetModelScale(self.model_scale_end)
		self:GetParent():SetUnitName(self.target_name)
		RemoveWearables(self:GetParent())
		ComicsVsAnime:OnHeroInGame(self:GetParent())
		if self:GetAbility() then
			self:GetAbility():SetActivated(true) 
		end	
		for slot = 0, self:GetCaster():GetAbilityCount() - 1 do
			if self.Caster_spells and self.Caster_spells[slot] and self.Caster_spells[slot].AbilityName then
				local NewAbility = self.Caster_spells[slot].AbilityName
				local OldAbility = self:GetParent():GetAbilityByIndex(slot):GetAbilityName()
				RemoveAbilityWithModifiers(self:GetParent(),self:GetParent():GetAbilityByIndex(slot) )
				self:GetParent():SwapAbility(OldAbility, NewAbility)
				self:GetParent():GetAbilityByIndex(slot):SetLevel(self.Caster_spells[slot].LevelAbility)
			end			
		end
	end
end	

function modifier_loki_swap:GetTexture()
    return self.hero
end