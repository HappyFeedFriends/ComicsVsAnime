sasuke_amaterrasu = sasuke_amaterrasu or class({})
LinkLuaModifier ("modifier_sasuke_amaterrasu", "heroes/sasuke/sasuke_amaterrasu", LUA_MODIFIER_MOTION_NONE)
function sasuke_amaterrasu:OnSpellStart()
	self:GetCaster().amaterrasu_table = {}
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_sasuke_amaterrasu",{duration = self:GetSpecialValueFor("duration")})
end 

modifier_sasuke_amaterrasu = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end
})
 
function modifier_sasuke_amaterrasu:OnCreated()
	self:StartIntervalThink(0.23)
end 

function modifier_sasuke_amaterrasu:OnIntervalThink()
	if IsServer() then
	local radius = 1100
	local caster = self:GetCaster()
	local manacost = self:GetAbility():GetManaCost(self:GetAbility():GetLevel())
		if caster:GetMana() >= manacost then
			caster:SetMana(caster:GetMana() - manacost)
			local units =  FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil,radius,self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(),FIND_CLOSEST,false)
			for _,enemy in pairs(units) do
				local caster_location = caster:GetAbsOrigin()
				local target_location = enemy:GetAbsOrigin()
				local direction = (caster_location - target_location):Normalized()
				local forward_vector = enemy:GetForwardVector()
				local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
				if angle <= 42.5 then
				local check = false
				for _,v in ipairs(caster.amaterrasu_table) do
					if v == enemy then
						check = true
					end
				end
				local damage = self:GetCaster():BonusTalentValue("special_bonus_sasuke_4",self:GetAbility():GetSpecialValueFor("damage"))
				local damageTable = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
					}
					if check then
						ApplyDamage(damageTable)
					else
						table.insert(caster.amaterrasu_table, enemy)
						ApplyDamage(damageTable)
					end
				end 
			end
		end	
	end
end