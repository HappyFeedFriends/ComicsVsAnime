LinkLuaModifier ("modifier_ant_man_big", "heroes/antman/Ant_man_big", LUA_MODIFIER_MOTION_NONE)
if Ant_man_big == nil then
	Ant_man_big = class({})
end	

function Ant_man_big:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ant_man_big", { duration = 12 })
end

if modifier_ant_man_big == nil then
	modifier_ant_man_big = class({})
end

function modifier_ant_man_big:IsHidden()
	return false
end

function modifier_ant_man_big:IsPurgable()
	return true
end

function modifier_ant_man_big:OnCreated()
	if IsServer() then
		self.model = self:GetCaster():GetModelScale()
		self.time = GameRules:GetGameTime()
		self:StartIntervalThink(0.01)	
	end	
end	

function modifier_ant_man_big:OnIntervalThink()
		local duration = self:GetAbility():GetSpecialValueFor("dur_big")
		local time = (GameRules:GetGameTime() - self.time)/duration
		local limit = self:GetAbility():GetSpecialValueFor("damage")
		local scale = self:GetAbility():GetSpecialValueFor("scale")
		if self:GetStackCount() <= (limit - 1) then
			self:GetCaster():AddStackModifier(self:GetAbility(),"modifier_ant_man_big",duration)
		end
		if self:GetCaster():GetModelScale() <= scale then
			self:GetCaster():SetModelScale(ComicsVsAnimeModelScale(self.model, scale, time))
		end
end

function modifier_ant_man_big:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_ant_man_big:GetModifierMoveSpeedBonus_Constant()
	local slow = (self:GetAbility():GetSpecialValueFor("slow") * self:GetStackCount())
	return -slow
end

function modifier_ant_man_big:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_ant_man_big:OnDestroy()
	if IsServer() then
		self:GetCaster():SetModelScale(self.model)
	end
end