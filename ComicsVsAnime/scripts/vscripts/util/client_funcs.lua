function NetTablesUtil(key,table)
	if IsServer() then
		CustomNetTables:SetTableValue("util", key, {value=table})
	end
end 

function NetTablesUtilUse(key)
	return CustomNetTables:GetTableValue( "util", key ).value
end

function C_DOTA_BaseNPC:ComicsVsAnimeHasTalent(talentName)
	if self:HasModifier("modifier_"..talentName) then
		return true
	else
		return false
	end	
end

function C_DOTA_BaseNPC:ComicsVsAnimeTalent(talentName, value)
	if self:HasModifier("modifier_"..talentName) then  
	CUSTOM_ABILITIES = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
		local value_name = value or "value"
		local specialVal = CUSTOM_ABILITIES[talentName]["AbilitySpecial"]
		for l,m in pairs(specialVal) do
			if m[value_name] then
				return m[value_name]
			end
		end
	end    
	return 0
end

function C_DOTA_BaseNPC:BonusTalentValue(talentName,start_value,value)
	if self:HasTalent(talentName) then
		return start_value + self:FindTalentValue(talentName, value)
	end 
	return start_value
end

function C_DOTA_BaseNPC:HasTalent(talentName)
	if self:HasModifier("modifier_"..talentName) then
		return true 
	end
	return false
end

function C_DOTA_BaseNPC:FindTalentValue(talentName, key)
	if self:HasModifier("modifier_"..talentName) then  
		local value_name = key or "value"
		CUSTOM_ABILITIES = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
		local specialVal = CUSTOM_ABILITIES[talentName]["AbilitySpecial"]
		for l,m in pairs(specialVal) do
			if m[value_name] then
				return m[value_name]
			end
		end
	end    
	return 0
end
