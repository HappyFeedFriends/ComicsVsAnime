----------------------------------------------
-- Maka Aura vision
----------------------------------------------
if modifier_maka_vision_aura == nil then 
	modifier_maka_vision_aura = class({})
end

function modifier_maka_vision_aura:IsAura() 
	return true 
end

function modifier_maka_vision_aura:IsHidden()
	return true 
end

function modifier_maka_vision_aura:IsDebuff()
	return false 
end

function modifier_maka_vision_aura:IsPurgable()
	return false 
end

function modifier_maka_vision_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end
	
function modifier_maka_vision_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO 
end
	
function modifier_maka_vision_aura:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_maka_vision"
		else
			return nil
		end
	end
end
	
function modifier_maka_vision_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") 
end
----------------------------------------------
-- Maka Vision
----------------------------------------------
if modifier_maka_vision == nil then 
	modifier_maka_vision = class({}) 
end

function modifier_maka_vision:IsDebuff()
	return true
end

function modifier_maka_vision:IsPurgable()
	return true
end

function modifier_maka_vision:IsHidden()
	return true 
end

function modifier_maka_vision:CheckState()
	local state = {
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_maka_vision:OnCreated(htable)
	if IsServer() then
		local invis = ParticleManager:CreateParticleForPlayer("particles/particles_all/myparticles/fnaf_surprise.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetOwner())
        self:AddParticle(invis, false, true, 1000, false, false)
	end
end

