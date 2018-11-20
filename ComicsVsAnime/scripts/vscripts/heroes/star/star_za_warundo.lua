LinkLuaModifier("modifier_star_za_warundo_frozen", "heroes/star/star_za_warundo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_za_warundo_ms", "heroes/star/star_za_warundo", LUA_MODIFIER_MOTION_NONE)
if star_za_warundo == nil then
	star_za_warundo = class({})
end

function star_za_warundo:OnSpellStart()
	local caster = self:GetCaster()
	local all_hero = HeroList:GetAllHeroes()
	local dur = self:GetSpecialValueFor("duration")
	if caster:ComicsVsAnimeHasTalent("special_bonus_star_2") then
		dur = dur + caster:ComicsVsAnimeTalent("special_bonus_star_2",nil,nil)
	end
	EmitSoundOn("ComicsVsAnime.star_za_warado",caster)
	for k,enemy in pairs(all_hero) do
		if enemy ~= self:GetCaster() then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_star_za_warundo_frozen", {duration = dur})
		elseif not enemy:HasModifier("modifier_star_za_warundo_ms") then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_star_za_warundo_ms", {duration = dur})
		end
	end
end
	
modifier_star_za_warundo_frozen = class({})

function modifier_star_za_warundo_frozen:IsHidden()
	return true 
end

function modifier_star_za_warundo_frozen:IsPurgable() 
	return false
end

function modifier_star_za_warundo_frozen:OnCreated()
	if IsServer() then
		local radius  = self:GetAbility():GetSpecialValueFor("radius")
		self.particle = ParticleManager:CreateParticle("particles/kurumi/comics_vs_anime_kurumi_kurumi_devouring_time.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, Vector(radius, radius, radius))
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_star_za_warundo_frozen:CheckState()
	local state = {
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_STUNNED] = true,
				}
	return state
end

function modifier_star_za_warundo_frozen:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end

modifier_star_za_warundo_ms = class({})

function modifier_star_za_warundo_ms:IsHidden()
	return false 
end

function modifier_star_za_warundo_ms:IsPurgable() 
	return false
end

function modifier_star_za_warundo_ms:RemoveOnDeath()
    return true
end

function modifier_star_za_warundo_ms:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
	return funcs
end
function modifier_star_za_warundo_ms:OnCreated()
	self.ms = self:GetAbility():GetSpecialValueFor("ms")
	self.ms = self:GetCaster():BonusTalentValue("special_bonus_star_7",self.ms)
end 
function modifier_star_za_warundo_ms:GetModifierMoveSpeedBonus_Constant()
	return self.ms
end

function modifier_star_za_warundo_ms:GetModifierMoveSpeed_Limit()
	return self.ms
end	

function modifier_star_za_warundo_ms:GetModifierMoveSpeed_Max()
	return self.ms
end	