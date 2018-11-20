item_dragon_staff = item_dragon_staff or class({})

function item_dragon_staff:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_dragon_staff.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end 

item_dragon_staff_2 = item_dragon_staff_2 or class({})

function item_dragon_staff_2:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_dragon_staff.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end 

item_dragon_staff_3 = item_dragon_staff_3 or class({})

function item_dragon_staff_3:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_dragon_staff.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end

item_dragon_staff_4 = item_dragon_staff_4 or class({})

function item_dragon_staff_4:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_dragon_staff.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end

item_dragon_staff_5 = item_dragon_staff_5 or class({})

function item_dragon_staff_5:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/other/comics_vs_anime_dragon_staff.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end