sasuke_kirin = sasuke_kirin or class({})
function sasuke_kirin:GetManaCost(level)
	if self:GetCaster():HasTalent("special_bonus_sasuke_6") then
		return 0
	end
	return 333
end 
function sasuke_kirin:OnSpellStart()
PrintTable(self)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local damage_type = self:GetAbilityDamageType()
	if caster:HasTalent("special_bonus_sasuke_7") then
		damage_type = DAMAGE_TYPE_PURE
	end
	for i = 0,4 do
		ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_POINT_FOLLOW, target )
	end
	local damage = self:GetCaster():BonusTalentValue("special_bonus_sasuke_8",self:GetSpecialValueFor("damage"))
	local damage_table =
		{
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
		}
	ApplyDamage(damage_table)
	target:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{duration = self:GetSpecialValueFor("duration_stunned")})
end