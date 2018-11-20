thor_lightning = thor_lightning or class({})
LinkLuaModifier ("modifier_thor_lightning", "heroes/thor/thor_lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_thor_lightning_tooltip", "heroes/thor/thor_lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_thor_8", "heroes/thor/thor_lightning", LUA_MODIFIER_MOTION_NONE)
function thor_lightning:GetIntrinsicModifierName()
	return "modifier_thor_lightning"
end

modifier_thor_lightning = modifier_thor_lightning or class({})

function modifier_thor_lightning:IsHidden() return true end
function modifier_thor_lightning:IsPurgable() return false end
function modifier_thor_lightning:RemoveOnDeath()return false end
function modifier_thor_lightning:OnCreated()
	self:StartIntervalThink(0.03)
end 
function modifier_thor_lightning:OnIntervalThink()
	if IsServer() and self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_8") and not self:GetCaster():HasModifier("modifier_special_bonus_thor_8") then
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_special_bonus_thor_8",{duration = -1})
	end
end 
function modifier_thor_lightning:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ABILITY_EXECUTED}
end

function modifier_thor_lightning:OnAbilityExecuted(params)
	local item = params.ability:GetAbilityName()
	local update = false
	for k,v in pairs(BLOCKED_ITEMS) do
		if item == v then
			return false
		end
	end
	if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_thor_5") then
		update = true
	end	
	if self:GetCaster() == params.unit then
		local electrical = self:GetAbility():GetSpecialValueFor("bonus_electric")
		local dur = self:GetAbility():GetSpecialValueFor("duration")
		self:GetCaster():AddStackModifier(self:GetAbility(),"modifier_thor_lightning_tooltip",dur,electrical,electrical,true,update)
	end
end 

modifier_thor_lightning_tooltip = modifier_thor_lightning_tooltip or class({})

function modifier_thor_lightning_tooltip:OnCreated()
	if IsServer() and self:GetCaster():FindAbilityByName("special_bonus_thor_8") then
	local value = self:GetCaster():FindAbilityByName("special_bonus_thor_8"):GetSpecialValueFor("value")
		NetTablesUtil("thor_lightning",value)
	end	
end 

function modifier_thor_lightning_tooltip:IsHidden() return false end
function modifier_thor_lightning_tooltip:IsPurgable() return false end
function modifier_thor_lightning_tooltip:RemoveOnDeath()return false end	
function modifier_thor_lightning_tooltip:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end
function modifier_thor_lightning_tooltip:GetModifierPreAttack_BonusDamage()
	if self:GetCaster():HasModifier("modifier_special_bonus_thor_8") then
		return self:GetStackCount() * NetTablesUtilUse("thor_lightning")
	end
end

modifier_special_bonus_thor_8 = modifier_special_bonus_thor_8 or class({})
function modifier_special_bonus_thor_8:IsHidden() return true end
function modifier_special_bonus_thor_8:IsPurgable() return false end
function modifier_special_bonus_thor_8:RemoveOnDeath()return false end