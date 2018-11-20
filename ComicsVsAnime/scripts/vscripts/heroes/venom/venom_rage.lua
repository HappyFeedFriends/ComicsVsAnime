function venom_rage_activate( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage") 
	local mult = ability:GetSpecialValueFor("mult_str")/100
	local talent1 = caster:FindAbilityByName("special_bonus_venom_3")
	if talent1 and talent1:GetLevel() > 0 then
	local value = talent1:GetSpecialValueFor("value")
	mult = mult + value/100
	end
	local damage_str =  caster:GetStrength() * mult
	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability
	damageTable.damage = damage + damage_str

		ApplyDamage(damageTable)
		print(ApplyDamage(damageTable))
end

function venom_rage_activate_talent( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local dur = ability:GetSpecialValueFor("duration") 
	local talent = caster:FindAbilityByName("special_bonus_venom_2")
	if talent and talent:GetLevel() > 0 and talent:GetSpecialValueFor("value") > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_venom_talent", {Duration = dur })
	end 
end