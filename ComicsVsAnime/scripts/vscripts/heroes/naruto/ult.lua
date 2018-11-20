function naruto_ult(keys)
    local caster = keys.caster
	local ability = keys.ability	
	local ability_activate = caster:FindAbilityByName("naruto_illusion1")
	local dur = caster:BonusTalentValue("special_bonus_naruto_6",ability:GetSpecialValueFor("duration"))
	caster:AddNewModifier(caster,ability,"modifier_naruto_ult",{duration = dur})
	if ability_activate then
		ability_activate:SetActivated(false)
	end
end