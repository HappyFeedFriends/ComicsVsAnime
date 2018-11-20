
modifier_special_bonus_thanos_4 = class({})

--------------------------------------------------------------------------------

function modifier_special_bonus_thanos_4:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_special_bonus_thanos_4:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_special_bonus_thanos_4:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_special_bonus_thanos_4:RemoveOnDeath()
	return false
end

function modifier_special_bonus_thanos_4:OnCreated()
	local caster = self:GetCaster()
	self:StartIntervalThink(0.1)
	local ability = caster:FindAbilityByName("special_bonus_thanos_4")
	local count_max = ability:GetSpecialValueFor("max")
	local cooldown =  ability:GetSpecialValueFor("cooldown")
	ComicsVsAnimeCharges(caster, "thanos_ult", count_max, nil, cooldown, "modifier_charges_thanos")
end

function modifier_special_bonus_thanos_4:OnIntervalThink()
	local thinker = self:GetParent()
	local caster = self:GetCaster()
	 if IsServer() then
		local ability = caster:FindAbilityByName("thanos_ult")
		if ability then
			if thinker:GetModifierStackCount( "modifier_charges_thanos", thinker ) <= 0 then
				ability:SetActivated(false)
			else
				ability:SetActivated(true)
			end
		end	
	end
end