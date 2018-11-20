function venom_poison( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetSpecialValueFor("damage")
	if caster:ComicsVsAnimeHasTalent("special_bonus_venom_6") then
		damage = damage + caster:ComicsVsAnimeTalent("special_bonus_venom_6")
	end 
	local chance = ability:GetSpecialValueFor("chance")
	local dur = ability:GetSpecialValueFor("duration")
	local interval = ability:GetSpecialValueFor("interval")
	if RollPercentage(chance) == true then
		target:AddNewModifier( caster, ability, "modifier_damage_per_second", {duration = dur, interval = interval, damage = damage})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_venom_effect", {Duration = dur })
	end
end

function venom_poison_attacker( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local damage = ability:GetSpecialValueFor("damage") - ability:GetSpecialValueFor("damage") * (ability:GetSpecialValueFor("attacker_dmg")/100)
	if caster:ComicsVsAnimeHasTalent("special_bonus_venom_5") then
		damage = ability:GetSpecialValueFor("damage")
	end
	if caster:ComicsVsAnimeHasTalent("special_bonus_venom_6") then
		damage = damage + caster:ComicsVsAnimeTalent("special_bonus_venom_6")
	end
	local chance = ability:GetSpecialValueFor("chance")
	local dur = ability:GetSpecialValueFor("duration")
	local interval = ability:GetSpecialValueFor("interval")
	if RollPercentage(chance) == true then
		attacker:AddNewModifier( caster, ability, "modifier_damage_per_second", {duration = dur, interval = interval, damage = damage})
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_venom_effect", {Duration = dur })
	end
end