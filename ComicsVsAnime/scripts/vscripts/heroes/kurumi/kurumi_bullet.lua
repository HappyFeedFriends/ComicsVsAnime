LinkLuaModifier ("modifier_first_bullet_aleph", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_first_bullet_aleph_buff", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_first_bullet_aleph_buff", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_second_bullet", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier ("modifier_second_bullet_debuff", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_seventh_bullet_zayin_debuff", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_seventh_bullet_zayin", "heroes/kurumi/kurumi_bullet", LUA_MODIFIER_MOTION_NONE)
-----------------------------------------------------------
-- Kurumi Billet Swap
-----------------------------------------------------------
if kurumi_bullet_swap == nil then
    kurumi_bullet_swap = class ({})
end

function kurumi_bullet_swap:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end 

function kurumi_bullet_swap:OnChannelFinish() 
	local lvl = self:GetLevel()
	local caster = self:GetCaster()
	local first_bullet = "kurumi_first_bullet_aleph"
	local second_bullet = "kurumi_second_bullet"
	local one_ability = "kurumi_empty_slot_bullet"
	local seventh_bullet_zayin = "kurumi_seventh_bullet_zayin"
	local sound = "kurumi.kurumi_swap"
	if caster:FindAbilityByName(one_ability) then
		caster:AddAbility(first_bullet)
		caster:SwapAbilities( one_ability, first_bullet, false, true )
		caster:RemoveAbility(one_ability)
		local first_bullet_lvl = caster:FindAbilityByName(first_bullet)
		first_bullet_lvl:SetLevel(lvl)
		sound = "ComicsVsAnime.kurumi_Alef"
	elseif caster:FindAbilityByName(first_bullet) then
		caster:AddAbility(second_bullet)
		caster:SwapAbilities( first_bullet, second_bullet, false, true )
		caster:RemoveAbility(first_bullet)
		local second_bullet_lvl = caster:FindAbilityByName(second_bullet)
		second_bullet_lvl:SetLevel(lvl)
		--sound = "ComicsVsAnime.kurumi_ZafKiel"
	elseif caster:FindAbilityByName(second_bullet) then
		caster:AddAbility(seventh_bullet_zayin)
		caster:SwapAbilities( second_bullet, seventh_bullet_zayin, false, true )
		caster:RemoveAbility(second_bullet)
		local seventh_bullet_zayin_lvl = caster:FindAbilityByName(seventh_bullet_zayin)
		seventh_bullet_zayin_lvl:SetLevel(lvl)
		sound = "ComicsVsAnime.kurumi_Zayin"
	elseif caster:FindAbilityByName(seventh_bullet_zayin) then
		caster:AddAbility(first_bullet)
		caster:SwapAbilities( seventh_bullet_zayin, first_bullet, false, true )
		caster:RemoveAbility(seventh_bullet_zayin)
		local bullet_back = caster:FindAbilityByName(first_bullet)
		bullet_back:SetLevel(lvl)
	end
	EmitSoundOn(sound,caster)
end
-----------------------------------------------------------
--	First Bullet: Aleph
-----------------------------------------------------------
if kurumi_first_bullet_aleph == nil then
    kurumi_first_bullet_aleph = class ({})
end

function kurumi_first_bullet_aleph:GetIntrinsicModifierName()
    return "modifier_first_bullet_aleph"
end

modifier_first_bullet_aleph = class({}) 

function modifier_first_bullet_aleph:OnCreated()
	if IsServer() then
		ChangeAttacksComicsVsAnime(self:GetParent())
	end
end

function modifier_first_bullet_aleph:OnDestroy()
	if IsServer() then
		ChangeAttacksComicsVsAnime(self:GetParent())
		if self:GetParent():HasModifier("modifier_first_bullet_aleph_buff") then
			self:GetParent():RemoveModifierByName("modifier_first_bullet_aleph_buff")
		end
	end
end


function modifier_first_bullet_aleph:IsHidden()
    return false
end

function modifier_first_bullet_aleph:IsPurgable()
	return false
end

function modifier_first_bullet_aleph:RemoveOnDeath()
	return false
end

function modifier_first_bullet_aleph:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_first_bullet_aleph:OnAttacked(params) 
	if IsServer() and not self:GetCaster():IsIllusion() and params.attacker == self:GetCaster() then
		local caster = self:GetCaster()
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		if RollPercentage(chance) == true then
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			caster:AddNewModifier( caster, self:GetAbility(), "modifier_first_bullet_aleph_buff",{duration = duration} )
		end
	end
end

modifier_first_bullet_aleph_buff = class({}) 

function modifier_first_bullet_aleph_buff:IsHidden()
    return false
end

function modifier_first_bullet_aleph_buff:IsPurgable()
	return false
end

function modifier_first_bullet_aleph_buff:RemoveOnDeath()
	return false
end

function modifier_first_bullet_aleph_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_first_bullet_aleph_buff:GetModifierMoveSpeedBonus_Percentage() 
local move = self:GetCaster():BonusTalentValue("special_bonus_kurumi_2",self:GetAbility():GetSpecialValueFor("movespeed"))
	return move
end


-----------------------------------------------------------
--	Second Bullet: Yud Bet
-----------------------------------------------------------
if kurumi_second_bullet == nil then
    kurumi_second_bullet = class ({})
end

function kurumi_second_bullet:GetIntrinsicModifierName()
    return "modifier_second_bullet"
end

modifier_second_bullet = class({}) 

function modifier_second_bullet:OnCreated()
	if IsServer() then
		ChangeAttacksComicsVsAnime(self:GetParent())
	end
end

function modifier_second_bullet:OnDestroy()
	if IsServer() then
		ChangeAttacksComicsVsAnime(self:GetParent())
	end
end


function modifier_second_bullet:IsHidden()
    return false
end

function modifier_second_bullet:IsPurgable()
	return false
end

function modifier_second_bullet:RemoveOnDeath()
	return false
end

function modifier_second_bullet:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_second_bullet:OnAttackLanded( event ) 
	if IsServer() and self:GetCaster() == event.attacker and self:GetCaster() ~= event.target and not self:GetCaster():IsIllusion() then
		local caster = self:GetCaster()
		local target = event.target
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		if RollPercentage(chance) == true then
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			target:AddNewModifier( caster, self:GetAbility(), "modifier_second_bullet_debuff",{duration = duration} )
		end
	end
end

modifier_second_bullet_debuff = class({}) 

function modifier_second_bullet_debuff:IsHidden()
    return false
end

function modifier_second_bullet_debuff:OnCreated() 
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_second_bullet_debuff:OnIntervalThink()
    if IsServer() and not self:GetCaster():FindAbilityByName("kurumi_second_bullet") then
		local thinker = self:GetParent()
		thinker:RemoveModifierByName("modifier_second_bullet_debuff")
	end
end
function modifier_second_bullet_debuff:IsPurgable()
	return false
end

function modifier_second_bullet_debuff:RemoveOnDeath()
	return false
end

function modifier_second_bullet_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_second_bullet_debuff:GetModifierMoveSpeedBonus_Percentage() 
	if self:GetCaster():HasModifier("modifier_second_bullet") then
	local move = self:GetCaster():BonusTalentValue("special_bonus_kurumi_6",self:GetAbility():GetSpecialValueFor("movespeed"))
		return move
	end
end
-----------------------------------------------------------
--	Seventh Bullet: Zayin
-----------------------------------------------------------
if kurumi_seventh_bullet_zayin == nil then
    kurumi_seventh_bullet_zayin = class ({})
end

function kurumi_seventh_bullet_zayin:GetIntrinsicModifierName()
    return "modifier_seventh_bullet_zayin"
end

modifier_seventh_bullet_zayin = class({}) 

function modifier_seventh_bullet_zayin:OnCreated()
	if IsServer() then
		ChangeAttacksComicsVsAnime(self:GetParent())
	end
end

function modifier_seventh_bullet_zayin:OnDestroy()
	if IsServer() then
		ChangeAttacksComicsVsAnime(self:GetParent())
	end
end


function modifier_seventh_bullet_zayin:IsHidden()
    return false
end

function modifier_seventh_bullet_zayin:IsPurgable()
	return false
end

function modifier_seventh_bullet_zayin:RemoveOnDeath()
	return false
end

function modifier_seventh_bullet_zayin:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_seventh_bullet_zayin:OnAttackLanded( event ) 
	if IsServer() and self:GetCaster() == event.attacker and not self:GetCaster():IsIllusion() then
		local caster = self:GetCaster()
		local target = event.target
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		chance = self:GetCaster():BonusTalentValue("special_bonus_kurumi_7",chance)
		if RollPercentage(chance) == true then
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			duration = self:GetCaster():BonusTalentValue("special_bonus_kurumi_4",duration)
			target:AddNewModifier( caster, self:GetAbility(), "modifier_seventh_bullet_zayin_debuff",{duration = duration} )
		end
	end
end

modifier_seventh_bullet_zayin_debuff = class({}) 

function modifier_seventh_bullet_zayin_debuff:IsHidden()
    return false
end

function modifier_seventh_bullet_zayin_debuff:OnCreated() 
    if IsServer () then
		self.damage = 0
    end
end

function modifier_seventh_bullet_zayin_debuff:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_seventh_bullet_zayin_debuff:OnTakeDamage(event)
	if IsServer() and self:GetParent() == event.unit then
		self.damage = self.damage + event.damage
		self:GetParent():SetHealth(self:GetParent():GetHealth() + event.damage)
	end
end

function modifier_seventh_bullet_zayin_debuff:IsPurgable()
	return false
end

function modifier_seventh_bullet_zayin_debuff:RemoveOnDeath()
	return false
end

function modifier_seventh_bullet_zayin_debuff:OnDestroy()
	if IsServer() then
		local damage_table ={attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PURE,
							ability = self:GetAbility(),
							victim = self:GetParent()}
		ApplyDamage(damage_table)
	end
end

function modifier_seventh_bullet_zayin_debuff:CheckState()
    local state = {
    [MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function modifier_seventh_bullet_zayin_debuff:GetTexture()
    return "custom_ability/kurumi_seventh_bullet_zayin"
end
