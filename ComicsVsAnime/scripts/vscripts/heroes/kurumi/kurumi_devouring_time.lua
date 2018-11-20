LinkLuaModifier("modifier_kurumi_stop_time", "heroes/kurumi/kurumi_devouring_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kurumi_stop_time_aura", "heroes/kurumi/kurumi_devouring_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kurumi_stop_time_activatation", "heroes/kurumi/kurumi_devouring_time", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
--	Devouring Time
--------------------------------------------------------------------------------
kurumi_devouring_time = class ({})

function kurumi_devouring_time:OnSpellStart()
	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")	
		CreateModifierThinker(self:GetCaster()	, self, "modifier_kurumi_stop_time_aura", {duration = duration},  self:GetCaster():GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
		local sound 
		local r = RandomInt(1,2)
		if r == 1 then
			sound = "ComicsVsAnime.kurumi_ult"
		else
			sound = "ComicsVsAnime.kurumi_ZafKiel"
		end
		EmitSoundOn(sound,self:GetCaster())
		Timers:CreateTimer(duration, function()	
			StopSoundOn(sound,self:GetCaster())
		end)
	end
end

function kurumi_devouring_time:OnProjectileHit( hTarget, vLocation )
	local talent = self:GetCaster():FindAbilityByName("special_bonus_kurumi_1")
	if talent and talent:GetLevel() > 0 then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAttackDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}
		ApplyDamage(damage)
	end
end
--------------------------------------------------------------------------------
-- AURA
--------------------------------------------------------------------------------
modifier_kurumi_stop_time_aura = class({})

function modifier_kurumi_stop_time_aura:IsHidden()
	return true 
end
function modifier_kurumi_stop_time_aura:IsAura() 
	return true
end

function modifier_kurumi_stop_time_aura:IsPurgable() 
	return false
end

function modifier_kurumi_stop_time_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_kurumi_stop_time_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE 
end

function modifier_kurumi_stop_time_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_kurumi_stop_time_aura:GetModifierAura()
	return "modifier_kurumi_stop_time" 
end

function modifier_kurumi_stop_time_aura:GetAuraRadius()
	return self.radius
end

function modifier_kurumi_stop_time_aura:OnCreated()
	if IsServer() then
		self.radius = self:GetCaster():BonusTalentValue("special_bonus_kurumi_5",self:GetAbility():GetSpecialValueFor("radius"))
		self.particle = ParticleManager:CreateParticle("particles/kurumi/comics_vs_anime_kurumi_kurumi_devouring_time.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_kurumi_stop_time_aura:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_kurumi_stop_time_aura:OnAttack(event)
	if IsServer() and not self:GetCaster():IsIllusion() then
	local talent = self:GetCaster():FindAbilityByName("special_bonus_kurumi_1")
		if talent and talent:GetLevel() > 0 then
			local split_shot = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(),nil, self:GetAbility():GetSpecialValueFor("radius"),DOTA_UNIT_TARGET_TEAM_ENEMY,self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(),0,false)
			if self:GetCaster():HasModifier("modifier_first_bullet_aleph") then
				self.projectile_attacks = "particles/kurumi/comics_vs_anime_kurumi_first_bullet_aleph.vpcf"
			elseif self:GetCaster():HasModifier("modifier_second_bullet") then
				self.projectile_attacks = "particles/kurumi/comics_vs_anime_kurumi_second_bullet.vpcf"
			elseif self:GetCaster():HasModifier("modifier_seventh_bullet_zayin") then	
				self.projectile_attacks = "particles/kurumi/comics_vs_anime_kurumi_seventh_bullet_zayin.vpcf"
			else
				self.projectile_attacks = self:GetCaster():GetKeyValue("ProjectileModel")	
			end	
			local max_targets = talent:GetSpecialValueFor("value")
			for _,targets in pairs(split_shot) do
				if targets ~= self:GetCaster():GetAttackTarget() and targets:HasModifier("modifier_kurumi_stop_time_activatation") and max_targets ~= 0 and not targets:IsAttackImmune() then
					local projectile_info = 
					{
						EffectName = self.projectile_attacks,
						Ability = self:GetAbility(),
						vSourceLoc = self:GetCaster():GetAbsOrigin(),
						Target = targets,
						Source = self:GetCaster(),
						bHasFrontalCone = false,
						iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
						bReplaceExisting = false,
						bProvidesVision = false,
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
					}
					ProjectileManager:CreateTrackingProjectile(projectile_info)
					max_targets = max_targets - 1
				end
				if max_targets == 0 then 
					break
				end
			end	
		end
	end
end

function modifier_kurumi_stop_time_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end
-------------------------------------------------------------------------------
-- CHECK HERO
--------------------------------------------------------------------------------
modifier_kurumi_stop_time = class({})

function modifier_kurumi_stop_time:IsHidden() 
	return true 
end
 
function modifier_kurumi_stop_time:IsPurgable() 
	return false 
end

function modifier_kurumi_stop_time:OnCreated()
	if IsServer() then
		if self:GetParent() ~= self:GetCaster() then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kurumi_stop_time_activatation", {})
		end
	end	
end

function modifier_kurumi_stop_time:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_kurumi_stop_time_activatation")
	end
end
-------------------------------------------------------------------------------
-- MODIFIER FROZEN HEROES
--------------------------------------------------------------------------------
modifier_kurumi_stop_time_activatation = class({})

function modifier_kurumi_stop_time_activatation:IsDebuff() 
	return true 
end
function modifier_kurumi_stop_time_activatation:IsPurgable() 
	return false 
 end

function modifier_kurumi_stop_time_activatation:CheckState()
	local state = {
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_STUNNED] = true,
				}
	return state
end

function modifier_kurumi_stop_time_activatation:OnCreated()
	if IsServer() then
	self.damage = 0
	end
end

function modifier_kurumi_stop_time_activatation:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_kurumi_stop_time_activatation:OnTakeDamage(event)
	if IsServer() and self:GetParent() == event.unit and not self:GetCaster():HasTalent("special_bonus_kurumi_7") then
		self.damage = self.damage + event.damage
		self:GetParent():SetHealth(self:GetParent():GetHealth() + event.damage)
	end
end

function modifier_kurumi_stop_time_activatation:OnDestroy()
	if IsServer() then
		local damage_table ={attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PURE,
						ability = self:GetAbility(),
						victim = self:GetParent()}
		ApplyDamage(damage_table)
	end
end