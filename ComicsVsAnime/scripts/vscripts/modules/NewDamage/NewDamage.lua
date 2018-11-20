if NewDamage == nil then
    print ( '[NewDamage] creating NewDamage' )
    NewDamage = {}
    NewDamage.__index = NewDamage
    NewDamage.kv_abilities 	= CUSTOM_ABILITY
    NewDamage.kv_hero     	= HEROES_CUSTOM
    NewDamage.kv_units    	= UNITES_CUSTOM
    NewDamage.units_dota    = UNITES_DOTA

end

function NewDamage:CreateAbility(ability)
	local kvblock = self.kv_abilities[ability:GetName()]	
    if not kvblock then
        print('[NewDamage] couldnt find this ability')
        return false
    end  
    print('[NewDamage] creating ability for ', ability:GetAbilityName())
     ability.custom_damage_type = kvblock.AbilityDamageTypeTooltip or kvblock.AbilityUnitDamageType or ""
	if ability.custom_damage_type == "DAMAGE_TYPE_HP_REMOVAL" then
		ability.custom_damage_type = "SPIRITUAL"
	end     
    return true
end

function CDOTABaseAbility:GetCustomDamageType()
	return self.custom_damage_type
end

function CDOTABaseAbility:SetCustomDamageType(value)
	self.custom_damage_type = value
end
   
function CDOTABaseAbility:GetCustomDamageModifier()
	return self.custom_damage_modifier
end

function CDOTABaseAbility:SetCustomDamageModifier(value)
	self.custom_damage_modifier = value
end 

function NewDamage:CreateResistances(npc)
	if npc ~= nil then
		local kvblock = self.kv_hero[npc:GetUnitName()] or self.kv_units[npc:GetUnitName()] or self.units_dota[npc:GetUnitName()]	
		if not kvblock then
			print('[NewDamage] couldnt find this unit')
			return false
		end
		print('[NewDamage] creating resistance for ', npc:GetName())
		if kvblock.resistances == nil then
			kvblock.resistances = {SPIRITUAL = 0, DAMAGE_TYPE_ELECTRICAL = 0}
		end	
		if kvblock.blocked == nil then
			kvblock.blocked = {SPIRITUAL = 0, DAMAGE_TYPE_ELECTRICAL = 0}
		end	
		npc.resistances = kvblock.resistances  or {}
		npc.blocked = kvblock.blocked or {}
		npc.custom_damage_type = kvblock.damagetype or ""
		npc.custom_damage_modifier = kvblock.amplifier or 1  
		return true
	end	
end

function CDOTA_BaseNPC:AddResistance(resistance,value)
	self.resistances[resistance] = self.resistances[resistance] + value
end

function CDOTA_BaseNPC:BlockedDamage(resistance, value)
	self.blocked[resistance] = self.blocked[resistance] + value
end

function CDOTA_BaseNPC:GetBlockedDamage(resistance)
	return self.blocked[resistance] or 0
end

function CDOTA_BaseNPC:SetBlockedDamage(resistance, value)
	self.blocked[resistance] = value
end

function CDOTA_BaseNPC:SetResistance(resistance, value)
	self.resistances[resistance] = value
end

function CDOTA_BaseNPC:GetResistance(resistance)
	return self.resistances[resistance] or 0
end

function CDOTA_BaseNPC:GetCustomDamageType()
	return self.custom_damage_type
end

function CDOTA_BaseNPC:SetCustomDamageType(value)
	self.custom_damage_type = value
end   

function CDOTA_BaseNPC:GetCustomDamageModifier()
	return self.custom_damage_modifier or 1
end

function CDOTA_BaseNPC:SetCustomDamageModifier(value)
	self.custom_damage_modifier = value
end
 
 
function CDOTABaseAbility:ApplyCustomDamage(victim, attacker, damage)
	if victim ~= nil then
		NewDamage:CreateResistances(victim) 
		NewDamage:CreateAbility(self)
		local hp = victim:GetHealth()
		local resistance_block = damage / 100 * tonumber(victim:GetResistance(self:GetCustomDamageType()))
		local blocked_damage =  victim:GetBlockedDamage(self:GetCustomDamageType())
		local newdamage = damage - blocked_damage - resistance_block
		local damageTable = 
		{
			victim = victim,
			attacker = attacker,
			damage = newdamage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}
		local dmg = ApplyDamage(damageTable)
		TooltipCustomDamage(dmg , victim , self:GetCustomDamageType())
		print()
		print("******************CUSTOM DAMAGE******************")
		print("[NewDamage] Damage Type:    ", self:GetCustomDamageType()) 										
		print("[NewDamage] Base Damage:    ", damage) 													
		print("[NewDamage] Resist damage:  ",tonumber(victim:GetResistance(self:GetCustomDamageType())).."%") 	
		print("[NewDamage] Blocked Damage: ",resistance_block) 															
		print("[NewDamage] Blocked Damage: ",blocked_damage,"NO PERNCETAGE") 								
		print("[NewDamage] Damage:  ", dmg) 																
		print("******************CUSTOM DAMAGE******************")
		print()
	end
end
