ichigo_form_blank = ichigo_form_blank or class({})
LinkLuaModifier ("modifier_ichigo_form_blank", "heroes/ichigo/ichigo_form_blank", LUA_MODIFIER_MOTION_NONE)
function ichigo_form_blank:OnSpellStart()
	self:GetCaster():EmitSound("ComicsVsAnime.ichigo_pust")
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ichigo_form_blank",{duration = self:GetSpecialValueFor("duration")})
end

modifier_ichigo_form_blank = modifier_ichigo_form_blank or class({})

function modifier_ichigo_form_blank:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_ichigo_form_blank:OnCreated()
	if IsServer() then
		self.scale = self:GetCaster():GetModelScale()
		self:GetCaster():SetModelScale(1.4)
	end	
	self.ms = self:GetAbility():GetSpecialValueFor("ms")
	self.ms = self:GetCaster():BonusTalentValue("special_bonus_ichigo_8",self.ms)
end 

function modifier_ichigo_form_blank:OnDestroy()
	if IsServer() then
		self:GetCaster():SetModelScale(self.scale)
	end
end 

function modifier_ichigo_form_blank:GetEffectName()
    return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"
end

function modifier_ichigo_form_blank:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ichigo_form_blank:OnAttackLanded(params)
	if IsServer() and params.attacker == self:GetCaster() then 
		self.damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetAbility():GetSpecialValueFor("damage")
		if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_ichigo_1") then
			self.damage = self.damage + self:GetCaster():ComicsVsAnimeTalent("special_bonus_ichigo_1")
		end
		--self:GetAbility():ApplyCustomDamage(params.target, self:GetCaster(), self.damage, nil)	
		local damageTable = 
		{
			victim = params.target,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
		}
		ApplyDamage(damageTable)		
	end
end 

function modifier_ichigo_form_blank:GetModifierMoveSpeed_Limit()
	return self.ms
end
function modifier_ichigo_form_blank:GetModifierMoveSpeed_Max()
	return self.ms
end 

function modifier_ichigo_form_blank:GetModifierBonusStats_Strength()
	return 	self:GetAbility():GetSpecialValueFor("bonus_all")
end
function modifier_ichigo_form_blank:GetModifierBonusStats_Agility()
	return	self:GetAbility():GetSpecialValueFor("bonus_all")
end
function modifier_ichigo_form_blank:GetModifierBonusStats_Intellect()
	return	self:GetAbility():GetSpecialValueFor("bonus_all")
end

function modifier_ichigo_form_blank:GetModifierMoveSpeedBonus_Constant()
	return	self.ms
end

function modifier_ichigo_form_blank:GetModifierModelChange()
	return "models/heroes/ichigo/ichigo_hollow/ichigo_ult.vmdl"
end 	