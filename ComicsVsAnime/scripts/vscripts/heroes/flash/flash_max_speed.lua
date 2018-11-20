LinkLuaModifier ("modifier_flash_max_speed", "heroes/flash/flash_max_speed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_flash_8_aura", "heroes/flash/flash_max_speed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_flash_8", "heroes/flash/flash_max_speed", LUA_MODIFIER_MOTION_NONE)

if flash_max_speed == nil then
	flash_max_speed = class({})
end

function flash_max_speed:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_flash_max_speed", {duration = -1})
	if IsServer() and self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_8") then
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_special_bonus_flash_8_aura",{duration = -1,radius = self:GetCaster():ComicsVsAnimeTalent("special_bonus_flash_8",nil,"radius")})
	end
end	

if modifier_flash_max_speed == nil then
	modifier_flash_max_speed = class({})
end

function modifier_flash_max_speed:OnCreated()
	self:OnIntervalThink()
	self:StartIntervalThink( 0.03 )
	self.p = 0 
end
	
function modifier_flash_max_speed:RemoveOnDeath()
	return true
end

function modifier_flash_max_speed:IsHidden()
	return false
end

function modifier_flash_max_speed:IsPurgeException()
	return false
end

function modifier_flash_max_speed:OnIntervalThink()
	if IsServer() and self:GetCaster():GetIdealSpeed() >= self:GetAbility():GetSpecialValueFor("ms_active") then
		if self.p < 1 then
			self.Particle1 = ParticleManager:CreateParticle("particles/flash/comics_vs_anime_flash_infinity_speed_osnova.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self.p = self.p + 1
		end
		local unites = FindUnitsInRadius(
			self:GetCaster():GetTeam(), 
			self:GetCaster():GetAbsOrigin(), 
			nil,
			300,
			self:GetAbility():GetAbilityTargetTeam(), 
			self:GetAbility():GetAbilityTargetType(),
			self:GetAbility():GetAbilityTargetFlags(),
			FIND_CLOSEST,
			false
		)
		for k,v in pairs (unites) do
			if not self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_flash_2") then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetCaster():GetIdealSpeed() * self:GetAbility():GetSpecialValueFor("dur_stunned")})
			end
			v:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetCaster():GetIdealSpeed() * self:GetAbility():GetSpecialValueFor("dur_stunned")})
			local damageTable = 
			{
				victim = v,
				attacker = self:GetCaster(),
				damage = self:GetCaster():GetIdealSpeed(),
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}
			ApplyDamage(damageTable)
			self:GetParent():RemoveModifierByName("modifier_flash_max_speed")
		end
	end
end

function modifier_flash_max_speed:OnDestroy() 
	if self.Particle1 then
		ParticleManager:DestroyParticle( self.Particle1, true)
		ParticleManager:ReleaseParticleIndex( self.Particle1 )
	end
end

function modifier_flash_max_speed:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_flash_max_speed:OnUnitMoved(params)
	if params.unit == self:GetParent() then
		self:GetCaster():AddStackModifier(self:GetAbility(),"modifier_flash_max_speed",-1)
	end	
end

function modifier_flash_max_speed:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_spd")
end	

function modifier_flash_max_speed:GetModifierMoveSpeed_Max()
	return 999999
end

function modifier_flash_max_speed:GetModifierMoveSpeed_Limit()
	return 999999
end	

modifier_special_bonus_flash_8_aura = modifier_special_bonus_flash_8_aura or class({})

function modifier_special_bonus_flash_8_aura:RemoveOnDeath()		return true 										end
function modifier_special_bonus_flash_8_aura:IsHidden() 			return true 										end
function modifier_special_bonus_flash_8_aura:IsPurgable() 			return false 										end
function modifier_special_bonus_flash_8_aura:IsAura() 				return true 										end
function modifier_special_bonus_flash_8_aura:GetAuraSearchFlags() 	return self:GetAbility():GetAbilityTargetFlags() 	end
function modifier_special_bonus_flash_8_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO 						end
function modifier_special_bonus_flash_8_aura:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_FRIENDLY				end
function modifier_special_bonus_flash_8_aura:GetModifierAura()		return "modifier_special_bonus_flash_8"				end
function modifier_special_bonus_flash_8_aura:GetAuraRadius() 		return self.radius 									end
function modifier_special_bonus_flash_8_aura:OnCreated(kv)
	self.radius = kv.radius
end 

modifier_special_bonus_flash_8 = modifier_special_bonus_flash_8 or class({})

function modifier_special_bonus_flash_8:RemoveOnDeath()		return true 										end
function modifier_special_bonus_flash_8:IsHidden() 			return false 										end
function modifier_special_bonus_flash_8:IsPurgable() 		return false 										end
function modifier_special_bonus_flash_8:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
 
function modifier_special_bonus_flash_8:GetModifierMoveSpeedBonus_Constant()
	if self:GetParent() ~= self:GetCaster() and IsServer() then
		return self:GetCaster():GetIdealSpeed()/100 * self:GetCaster():ComicsVsAnimeTalent("special_bonus_flash_8",nil,"bonus_hero")
	end
		return 0
end	

function modifier_special_bonus_flash_8:GetModifierMoveSpeed_Max()
	return 999999
end

function modifier_special_bonus_flash_8:GetModifierMoveSpeed_Limit()
	return 999999
end