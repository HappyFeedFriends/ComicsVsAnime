sasuke_chidori = sasuke_chidori or class({})
LinkLuaModifier ("modifier_sasuke_chidori", "heroes/sasuke/sasuke_chidori", LUA_MODIFIER_MOTION_NONE)
function sasuke_chidori:OnToggle()
	if self:GetCaster():HasModifier("modifier_sasuke_chidori") then
		self:GetCaster():RemoveModifierByName("modifier_sasuke_chidori")
	else
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_sasuke_chidori",{duration = -1})
	end
end

modifier_sasuke_chidori = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end
})
function modifier_sasuke_chidori:OnCreated()
local hTarget = self:GetCaster()
	self.nFXIndex = ParticleManager:CreateParticle( "particles/cva/heroes/sasuke/sasuke_chidori.vpcf", PATTACH_POINT_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_sword" , hTarget:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_sword" , hTarget:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_sword" , hTarget:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector(1, 0, 0) )
			ParticleManager:SetParticleControl( self.nFXIndex, 4, Vector(1, 0, 0) )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 6, hTarget, PATTACH_POINT_FOLLOW, "attach_sword" , hTarget:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 8, Vector(1, 0, 0) )
			self:AddParticle( self.nFXIndex, false, false, -1, false, true )
end
function modifier_sasuke_chidori:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_sasuke_chidori:OnAttackLanded(params)
local manacost = self:GetAbility():GetManaCost( self:GetAbility():GetLevel())
manacost = self:GetCaster():BonusTalentValue("special_bonus_sasuke_3",manacost)
	if params.attacker == self:GetCaster() and self:GetAbility():IsCooldownReady() and self:GetCaster():GetMana() >= manacost then
			local damage = self:GetCaster():BonusTalentValue("special_bonus_sasuke_2",self:GetAbility():GetSpecialValueFor("damage"))
			damage = self:GetCaster():GetAgility()/100 * damage
			local damage_table =
			{
				victim = params.target,
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}
			ApplyDamage(damage_table)
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		self:GetCaster():SetMana(self:GetCaster():GetMana() - manacost)
	end
end
function modifier_sasuke_chidori:OnDestroy()
	if self.nFXIndex then
		ParticleManager:DestroyParticle( self.nFXIndex, true)
		ParticleManager:ReleaseParticleIndex( self.nFXIndex )
	end
end  