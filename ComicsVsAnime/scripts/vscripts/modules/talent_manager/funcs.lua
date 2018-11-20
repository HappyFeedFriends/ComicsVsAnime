function RetrieveValueFromTalentTable(talent_name, level)
	for k,v in pairs(PASSIVED_TALENT_LIST) do
		print(k,v)
	end	
	if talent_name and level then
		local talent_kv = PASSIVED_TALENT_LIST[talent_name]
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