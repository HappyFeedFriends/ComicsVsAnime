if black_panther_ultimate == nil then 
	black_panther_ultimate = class({})
 end

LinkLuaModifier( "modifier_black_panther_ultimate", "heroes/black_panther/black_panther_ultimate.lua", LUA_MODIFIER_MOTION_NONE )


function black_panther_ultimate:OnAbilityPhaseStart()
local name1 = "black_panther_attack_bonus"
local modifier = self:GetCaster():FindModifierByName(name1)
local health_pct = self:GetCaster():GetHealthPercent()
	self.damage = self:GetCaster():GetHealth()
	if modifier then
		self.damage = self:GetCaster():GetHealth() + (self:GetCaster():GetHealth() * (modifier:GetStackCount()/100 * self:GetSpecialValueFor("stack_dmg_bonus")))
		self:GetCaster():RemoveModifierByName(name1)
	end
    return true
end

function black_panther_ultimate:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_black_panther_ultimate", {damage = self.damage}  )
	EmitSoundOn( "Hero_ObsidianDestroyer.EssenceAura", self:GetCaster() )
end

function black_panther_ultimate:GetManaCost(iLevel)
local mana_cost = self:GetSpecialValueFor("mana")
mana_cost = self:GetCaster():BonusTalentValue("special_bonus_black_panther_8",mana_cost)
    return self:GetCaster():GetMaxMana() * (mana_cost/100)
end

if modifier_black_panther_ultimate == nil then modifier_black_panther_ultimate = class({}) end

function modifier_black_panther_ultimate:IsPurgable()
	return false
end

function modifier_black_panther_ultimate:GetStatusEffectName()
	return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

function modifier_black_panther_ultimate:StatusEffectPriority()
	return 1000
end

function modifier_black_panther_ultimate:OnCreated( kv )
	if IsServer() then
		self.damage = (self:GetAbility():GetSpecialValueFor( "hp_damage" ) / 100) * kv.damage
		
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/elder_titan/elder_titan_fissured_soul/elder_titan_fissured_soul_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector(1, 0, 0) )
			ParticleManager:SetParticleControl( nFXIndex, 4, Vector(1, 0, 0) )
			ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 8, Vector(1, 0, 0) )
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		end
end

function modifier_black_panther_ultimate:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_black_panther_ultimate:OnAttackLanded (params)
    if IsServer() and  params.attacker == self:GetParent() and not params.target:IsBosses() then
            local hTarget = params.target
			if hTarget:IsHero() then
				EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
				EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", hTarget )
				EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
				EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )

				local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
				ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0) )
				ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0, 255, 0) )
				ParticleManager:SetParticleControl( nFXIndex, 3, Vector(0, 0.4, 0) )
				ParticleManager:SetParticleControl( nFXIndex, 11, hTarget:GetAbsOrigin())
				ParticleManager:SetParticleControl( nFXIndex, 12, hTarget:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex( nFXIndex );

				local distanation = (self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self:GetAbility():GetSpecialValueFor("lenght"))
				local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
				local unit_table = FindUnitsInLine(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), distanation, nil, self:GetAbility():GetSpecialValueFor("width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags)

				local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_line.vpcf", PATTACH_CUSTOMORIGIN, nil );
				ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
				ParticleManager:SetParticleControl( nFXIndex, 1, distanation );
				ParticleManager:ReleaseParticleIndex( nFXIndex );
				self:Destroy()
				local damage_table = {}
					damage_table.attacker = self:GetCaster()
					damage_table.damage_type = self:GetAbility():GetAbilityDamageType()
					damage_table.ability = self:GetAbility()
					damage_table.victim = hTarget
					damage_table.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					damage_table.damage = self.damage
					ApplyDamage(damage_table)
					local talent = self:GetCaster():FindAbilityByName("special_bonus_black_panther_4")
					if talent and talent:GetLevel() > 0 then
						local talent_value = talent:GetSpecialValueFor("value")
						if RollPercentage(talent_value) == false then	
							self:GetCaster():Kill(self:GetAbility(), self:GetCaster())	
						end
					else
						self:GetCaster():Kill(self:GetAbility(), self:GetCaster())					
					end
				end
			end
	return 0
end

function black_panther_ultimate:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_black_panther_ultimate") then
		return "custom_ability/black_panther_ult_activated"
	end	
	return self.BaseClass.GetAbilityTextureName(self)
end

modifier_special_bonus_black_panther_8 = modifier_special_bonus_black_panther_8 or class({})

function modifier_special_bonus_black_panther_8:IsHidden()return true end
function modifier_special_bonus_black_panther_8:IsPurgable()return false end
function modifier_special_bonus_black_panther_8:RemoveOnDeath()return false end