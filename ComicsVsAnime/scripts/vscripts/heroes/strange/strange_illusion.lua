
function strange_illusion( keys )
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local ability = keys.ability
	local unit_name = caster:GetUnitName()
	local images_count = ability:GetSpecialValueFor( "images_count" )
	local duration = ability:GetSpecialValueFor( "illusion_duration" )
	local outgoingDamage = ability:GetSpecialValueFor( "outgoing_damage")
	local incomingDamage = ability:GetSpecialValueFor( "incoming_damage" )
	local chance = RandomInt(1, 100)
	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()
	local talent = caster:FindAbilityByName("special_bonus_strange_3")
	if talent and talent:GetLevel() > 0 then
		local value = talent:GetSpecialValueFor("value")
		incoming_damage = incoming_damage + value
	end
	if caster:ComicsVsAnimeHasTalent("special_bonus_strange_7") then
		images_count = images_count + caster:ComicsVsAnimeTalent("special_bonus_strange_7")
	end 	
	if caster:ComicsVsAnimeHasTalent("special_bonus_strange_5") then
		outgoingDamage = outgoingDamage + 1200--caster:ComicsVsAnimeTalent("special_bonus_strange_5")
	end 
	ComicsVsAnimeCreateIllusion(caster, ability, images_count, incomingDamage, outgoingDamage, duration, false, false,nil,nil)
end