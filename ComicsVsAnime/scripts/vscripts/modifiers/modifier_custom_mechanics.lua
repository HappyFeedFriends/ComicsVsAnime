

if modifier_custom_mechanics == nil then 
	modifier_custom_mechanics = class({}) 
end

function modifier_custom_mechanics:IsHidden() 
	return true 
end

function modifier_custom_mechanics:IsPurgable() 
	return false 
end

function modifier_custom_mechanics:IsPermanent() 
	return true 
end

function modifier_custom_mechanics:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_custom_mechanics:OnTakeDamage( keys )
	if IsServer() then
		local parent = self:GetParent()
		local caster = keys.attacker
		local target = keys.unit
		local damage = keys.damage
		local damage_flags = keys.damage_flags
		local inflictor = keys.inflictor
	
		if caster == parent and inflictor then
			local lifesteal_amount = parent:GetSpellLifesteal()
			if target:IsBuilding() or target:IsIllusion() or (target:GetTeam() == caster:GetTeam()) or (lifesteal_amount <= 0) or bit.band(damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
				return 
			end
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
			caster:Heal(damage * (lifesteal_amount/100), caster)
		end
	end
end

function modifier_custom_mechanics:OnAttackLanded( keys )
	if IsServer() then
		local parent = self:GetParent()
		local attacker = keys.attacker
		if parent ~= attacker then
			return 
		end
		local target = keys.target
		local lifesteal_amount = parent:GetLifesteal()
		if target:IsBuilding() or target:IsIllusion() or (target:GetTeam() == attacker:GetTeam()) or lifesteal_amount <= 0 then
			return 
		end
		local damage = keys.damage
		local target_armor = target:GetPhysicalArmorValue()
		local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
		attacker:Heal(damage * (lifesteal_amount/100) * ComicsVsAnimeReductionArmor(target_armor)/100, attacker)
		local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end
end
