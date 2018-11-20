LinkLuaModifier("modifier_cva_passived_talents_handler", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_damage", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_all_stats", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_strength", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_agility", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_intelligence", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_armor", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_magic_resistance", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_evasion", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_move_speed", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_attack_speed", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_hp", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_hp_regen", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_mp", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_mp_regen", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_attack_range", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_cast_range", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_attack_life_steal", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_spell_life_steal", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_spell_power", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_cd_reduction", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_base", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_damage_base", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cva_passived_talent_incoming_damage", "modules/talent_manager/modifiers.lua", LUA_MODIFIER_MOTION_NONE )

local function RetrieveValueFromTalentTable(talent_name, level)
	if talent_name and level then
	TALENT_LIST = LoadKeyValues("scripts/kv/passived_talent_list.kv")
		local talent_kv = TALENT_LIST[talent_name]
		if talent_kv then
			local values = talent_kv.value
			if values then
				local value_array = {}
				for v in values:gmatch("%S+") do
					table.insert(value_array, v)
				end
				return value_array[level]
			end
		end
	end
	return nil
end

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
	local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return funcs
end

function modifier_cva_passived_talent_damage:GetModifierPreAttack_BonusDamage()
	return self.value
end
--------------------------------
--		  Damage Base         --
--------------------------------
modifier_cva_passived_talent_damage_base = ShallowCopy(modifier_cva_passived_talent_base)

function modifier_cva_passived_talent_damage_base:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE }
	return funcs
end

function modifier_cva_passived_talent_damage_base:GetModifierBaseAttack_BonusDamage()
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
function modifier_cva_passived_talent_attack_life_steal:ComicsVsAnimeAttackLifeSteal()
	return self.value
end

-----------------------------
--	   Spell Life Steal    --
-----------------------------
modifier_cva_passived_talent_spell_life_steal = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_spell_life_steal:ComicsVsAnimeSpellLifeSteal()
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
--	 Cooldown Reduction    --
-----------------------------
modifier_cva_passived_talent_cd_reduction = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_cd_reduction:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE }
	return funcs
end

function modifier_cva_passived_talent_cd_reduction:GetModifierPercentageCooldown()
	return self.value
end
-----------------------------
--	 Damage Incoming       --
-----------------------------
modifier_cva_passived_talent_incoming_damage = ShallowCopy(modifier_cva_passived_talent_base)
function modifier_cva_passived_talent_incoming_damage:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
	return funcs
end

function modifier_cva_passived_talent_incoming_damage:GetModifierIncomingDamage_Percentage()
	return -self.value
end 