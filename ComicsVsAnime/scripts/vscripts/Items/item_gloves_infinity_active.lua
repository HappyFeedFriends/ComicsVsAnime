item_gloves_infinity_active = item_gloves_infinity_active or class({})
LinkLuaModifier("modifier_item_gloves_infinity_active", "items/item_gloves_infinity_active", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_gloves_infinity_active_stats", "items/item_gloves_infinity_active", LUA_MODIFIER_MOTION_NONE)

function item_gloves_infinity_active:GetIntrinsicModifierName()
	return "modifier_item_gloves_infinity_active"
end	

function item_gloves_infinity_active:OnOwnerDied()
	self:ComicsVsAnimeItemDrop(self:GetCaster())
end

function item_gloves_infinity_active:OnChannelFinish()
	if IsServer() and self:GetCurrentCharges() <= self:GetSpecialValueFor("max_charges")then
		local current_charges = self:GetCurrentCharges()
		print(current_charges,"charges")
		self:SetCurrentCharges(current_charges - 1)
		local num = 0
		local unites = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(),nil,999999,self:GetAbilityTargetTeam(),self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_ANY_ORDER,false)
		for k,v in pairs(unites) do
			if not v:IsBosses() and not string.find(v:GetUnitName(), "fort") then
				num = num + 1 
				if  num == self:GetSpecialValueFor("kill_unit") then
					ComicsVsAnimeKill(self:GetCaster(), v, self)
					num = 0
				end
			end
		end
	end
end	

modifier_item_gloves_infinity_active = modifier_item_gloves_infinity_active or class({})

function modifier_item_gloves_infinity_active:RemoveOnDeath()return true end
function modifier_item_gloves_infinity_active:IsHidden()return true end
function modifier_item_gloves_infinity_active:IsPurgeException()return false end

function modifier_item_gloves_infinity_active:OnCreated()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_gloves_infinity_active_stats",{duration = -1 })
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("cooldown_charges"))	
	end
end

function modifier_item_gloves_infinity_active:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end	

function modifier_item_gloves_infinity_active:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all")
end
function modifier_item_gloves_infinity_active:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all")
end
function modifier_item_gloves_infinity_active:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all")
end	

function modifier_item_gloves_infinity_active:OnIntervalThink() 
	if IsServer() and self:GetAbility():GetCurrentCharges() < self:GetAbility():GetSpecialValueFor("max_charges") then
		local current_charges = self:GetAbility():GetCurrentCharges()
		self:GetAbility():SetCurrentCharges(current_charges + 1)	
	end
end

modifier_item_gloves_infinity_active_stats = modifier_item_gloves_infinity_active_stats or class({})

function modifier_item_gloves_infinity_active_stats:RemoveOnDeath()return true end
function modifier_item_gloves_infinity_active_stats:IsHidden()return true end
function modifier_item_gloves_infinity_active_stats:IsPurgeException()return false end

function modifier_item_gloves_infinity_active_stats:OnCreated()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("cooldown_bonus_stat"))	
end

function modifier_item_gloves_infinity_active_stats:OnIntervalThink()
	if self:GetCaster():HasModifier("modifier_item_gloves_infinity_active") and IsServer() then
		local stat = self:GetAbility():GetSpecialValueFor("bonus_stat")
		if self:GetCaster():GetPrimaryAttribute() == 0 then
			self:GetCaster():ModifyStrength(stat)
		elseif self:GetCaster():GetPrimaryAttribute() == 1 then
			self:GetCaster():ModifyAgility(stat)
		elseif 	self:GetCaster():GetPrimaryAttribute() == 2 then
			self:GetCaster():ModifyIntellect(stat)
		end
	else
		self:Destroy()
	end
end