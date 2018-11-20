
local function ShallowCopy(orig)
	local copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	return copy
end

local modifier_cva_passived_talent_base = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end
})

function modifier_cva_passived_talent_base:updateValue()
	local stack_count = self:GetStackCount()
	if stack_count > 0 then
		local talent_name = self:GetName():gsub("modifier_", "")
		local table_value = RetrieveValueFromTalentTable(talent_name, stack_count)

		if table_value == nil then
			self:Destroy()
		else
			self.value = tonumber(table_value)
		end
	end
end

function modifier_cva_passived_talent_base:OnCreated()
	self:updateValue()
end

function modifier_cva_passived_talent_base:OnRefresh()
	self:updateValue()
end

-----------------------------
--		    Damage         --
-----------------------------
modifier_cva_passived_talent_damage = ShallowCopy(modifier_cva_passived_talent_base)

function modifier_cva_passived_talent_damage:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE }
	return funcs
end

function modifier_cva_passived_talent_damage:GetModifierBaseAttack_BonusDamage()
	return self.value
end

-----------------------------
--		  All Stats        --
-----------------------------
modifier_cva_passived_talent_all_stats = ShallowCopy(modifier_cva_passived_talent_base)

function modifier_cva_passived_talent_all_stats:DeclareFunctions()
	local funcs = { 
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_cva_passived_talent_all_stats:OnCreated()
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

function modifier_cva_passived_talent_all_stats:GetModifierBonusStats_Agility()
	return self.value
end
function modifier_cva_passived_talent_all_stats:GetModifierBonusStats_Intellect()
	return self.value
end
function modifier_cva_passived_talent_all_stats:GetModifierBonusStats_Strength()
	return self.value
end

-----------------------------
--		  Strength         --
-----------------------------
modifier_cva_passived_talent_strength = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_strength:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS }
	return funcs
end

function modifier_cva_passived_talent_strength:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

function modifier_cva_passived_talent_strength:GetModifierBonusStats_Strength()
	return self.value
end

-----------------------------
--		  Agility         --
-----------------------------
modifier_cva_passived_talent_agility = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_agility:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_STATS_AGILITY_BONUS }
	return funcs
end

function modifier_cva_passived_talent_agility:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

function modifier_cva_passived_talent_agility:GetModifierBonusStats_Agility()
	return self.value
end

-----------------------------
--		Intelligence       --
-----------------------------
modifier_cva_passived_talent_intelligence = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_intelligence:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
	return funcs
end

function modifier_cva_passived_talent_intelligence:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

function modifier_cva_passived_talent_intelligence:GetModifierBonusStats_Intellect()
	return self.value
end

-----------------------------
--		    Armor          --
-----------------------------
modifier_cva_passived_talent_armor = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_armor:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
	return funcs
end

function modifier_cva_passived_talent_armor:GetModifierPhysicalArmorBonus()
	return self.value
end

-----------------------------
--	   Magic Resistance    --
-----------------------------
modifier_cva_passived_talent_magic_resistance = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_magic_resistance:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }
	return funcs
end

function modifier_cva_passived_talent_magic_resistance:GetModifierMagicalResistanceBonus()
	return self.value
end

-----------------------------
--		   Evasion         --
-----------------------------
modifier_cva_passived_talent_evasion = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_evasion:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_EVASION_CONSTANT }
	return funcs
end

function modifier_cva_passived_talent_evasion:GetModifierEvasion_Constant()
	return self.value
end

-----------------------------
--		  Move Speed       --
-----------------------------
modifier_cva_passived_talent_move_speed = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_move_speed:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_MAX }
	return funcs
end

function modifier_cva_passived_talent_move_speed:GetModifierMoveSpeedBonus_Constant()
	return self.value
end

function modifier_cva_passived_talent_move_speed:GetModifierMoveSpeed_Max()
	return 550 + self.value
end

-----------------------------
--	     Attack Speed      --
-----------------------------
modifier_cva_passived_talent_attack_speed = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_attack_speed:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
	return funcs
end

function modifier_cva_passived_talent_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self.value
end

-----------------------------
--	       Health          --
-----------------------------
modifier_cva_passived_talent_hp = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_hp:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_HEALTH_BONUS }
	return funcs
end

function modifier_cva_passived_talent_hp:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

function modifier_cva_passived_talent_hp:GetModifierHealthBonus()
	return self.value
end

-----------------------------
--	    Health Regen       --
-----------------------------
modifier_cva_passived_talent_hp_regen = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_hp_regen:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT }
	return funcs
end

function modifier_cva_passived_talent_hp_regen:GetModifierConstantHealthRegen()
	return self.value
end

-----------------------------
--	        Mana           --
-----------------------------
modifier_cva_passived_talent_mp = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_mp:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MANA_BONUS }
	return funcs
end

function modifier_cva_passived_talent_mp:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

function modifier_cva_passived_talent_mp:GetModifierManaBonus()
	return self.value
end

-----------------------------
--	     Mana Regen        --
-----------------------------
modifier_cva_passived_talent_mp_regen = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_mp_regen:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MANA_REGEN_CONSTANT }
	return funcs
end

function modifier_cva_passived_talent_mp_regen:GetModifierConstantManaRegen()
	return self.value
end

-----------------------------
--	     Attack Range      --
-----------------------------
modifier_cva_passived_talent_attack_range = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_attack_range:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACK_RANGE_BONUS }
	return funcs
end

function modifier_cva_passived_talent_attack_range:GetModifierAttackRangeBonus()
	return self.value
end

-----------------------------
--	      Cast Range       --
-----------------------------
modifier_cva_passived_talent_cast_range = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_cast_range:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING }
	return funcs
end

function modifier_cva_passived_talent_cast_range:GetModifierCastRangeBonusStacking()
	return self.value
end

-----------------------------
--	  Attack Life Steal    --
-----------------------------
modifier_cva_passived_talent_attack_life_steal = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_attack_life_steal:GetModifierLifesteal()
	-- Handled by modifier_cva_passived_talents_handler
	return self.value
end

-----------------------------
--	   Spell Life Steal    --
-----------------------------
modifier_cva_passived_talent_spell_life_steal = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_spell_life_steal:GetModifierSpellLifesteal()
	-- Handled by modifier_cva_passived_talents_handler
	return self.value
end

-----------------------------
--	      Spell Power      --
-----------------------------
modifier_cva_passived_talent_spell_power = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_spell_power:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE }
	return funcs
end

function modifier_cva_passived_talent_spell_power:GetModifierSpellAmplify_Percentage()
	return self.value
end

-----------------------------
--	  Cooldown Reduction   --
-----------------------------
modifier_cva_passived_talent_cd_reduction = ShallowCopy(modifier_cva_passived_talent_base)

function modifier_cva_passived_talent_cd_reduction:GetCustomCooldownReductionStacking()
	return self.value
end

-----------------------------
--	     Bonus EXP         --
-----------------------------
modifier_cva_passived_talent_bonus_xp = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_bonus_xp:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_EXP_RATE_BOOST }
	return funcs
end

function modifier_cva_passived_talent_bonus_xp:GetModifierPercentageExpRateBoost()
	return self.value
end

-----------------------------
--	  Respawn Reduction    --
-----------------------------
modifier_cva_passived_talent_respawn_reduction = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_respawn_reduction:RespawnTimeStacking()
	-- Return negative value
	return -(self.value)
end