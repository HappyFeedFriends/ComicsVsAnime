LinkLuaModifier ("modifier_hulk_rage", "heroes/hulk/hulk_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_hulk_rage_bonus", "heroes/hulk/hulk_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_hulk_1", "heroes/hulk/hulk_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_hulk_7", "heroes/hulk/hulk_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_hulk_8", "heroes/hulk/hulk_rage", LUA_MODIFIER_MOTION_NONE)

if hulk_rage == nil then
	hulk_rage = class({})
end	

function hulk_rage:GetIntrinsicModifierName()
    return "modifier_hulk_rage"
end

modifier_hulk_rage = class({})

function modifier_hulk_rage:IsHidden()
	return true 
end

function modifier_hulk_rage:IsPurgable() 
	return false
end

function modifier_hulk_rage:RemoveOnDeath()
	return false
end

function modifier_hulk_rage:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_hulk_rage:OnIntervalThink()
    if IsServer() and self:GetAbility() ~= nil  then
		if self:GetCaster():HasTalent("special_bonus_hulk_7") and not self:GetCaster():HasModifier("modifier_special_bonus_hulk_7") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_special_bonus_hulk_7",{duration = -1})
		end		
		if self:GetCaster():HasTalent("special_bonus_hulk_8") and not self:GetCaster():HasModifier("modifier_special_bonus_hulk_8") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_special_bonus_hulk_8",{duration = -1})
		end
		local current_stack = self:GetCaster():GetModifierStackCount( "modifier_hulk_rage_bonus", self:GetAbility() )
		local stack = 100 - self:GetCaster():GetHealth() * 100 / self:GetCaster():GetMaxHealth()
		stack = stack / self:GetAbility():GetSpecialValueFor("stack_per_hp")
		if self:GetCaster():GetHealthPercent() < 100 then
			if current_stack >= 40 and self:GetCaster():HasModifier("modifier_hulk_rage_bonus") then
				self:GetCaster():SetRenderColor(255, 69, 0)
			else
				self:GetCaster():SetRenderColor(255, 255, 255)
			end
			if current_stack >= 70 and self:GetParent():HasModifier("modifier_hulk_rage_bonus")then
				if self:GetCaster():ComicsVsAnimeHasTalent("special_bonus_hulk_1") then
					self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(),"modifier_special_bonus_hulk_1",{duration = 0.2})
				end
				self:GetCaster():SetRenderColor(255, 0, 0)
			end
		ComicsVsAnimeAddStack(self:GetCaster(), self:GetAbility(),stack, stack, "modifier_hulk_rage_bonus", -1, false, true,false,true)
		elseif self:GetCaster():HasModifier("modifier_hulk_rage_bonus") then
			self:GetCaster():SetRenderColor(255, 255, 255)
			self:GetCaster():RemoveModifierByName("modifier_hulk_rage_bonus")		
		end	
	end
end

modifier_hulk_rage_bonus = class({})

function modifier_hulk_rage_bonus:IsHidden()
	return false 
end

function modifier_hulk_rage_bonus:IsPurgable() 
	return false
end

function modifier_hulk_rage_bonus:RemoveOnDeath()
	return false
end

function modifier_hulk_rage_bonus:DeclareFunctions()
local funcs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	return funcs
end

function modifier_hulk_rage_bonus:GetModifierConstantHealthRegen()
local regen = self:GetAbility():GetSpecialValueFor("health")
	if self:GetCaster():HasTalent("special_bonus_hulk_8") then
		regen = regen + self:GetCaster():FindTalentValue("special_bonus_hulk_8")
	end
	return regen * self:GetStackCount()
end	

function modifier_hulk_rage_bonus:GetModifierPhysicalArmorBonus()
local armor = self:GetAbility():GetSpecialValueFor("armor")
	if self:GetCaster():HasTalent("special_bonus_hulk_7") then
		armor = armor + self:GetCaster():FindTalentValue("special_bonus_hulk_7")
	end
	return armor * self:GetStackCount()
end

modifier_special_bonus_hulk_1 = class({})

function modifier_special_bonus_hulk_1:IsHidden()
	return true 
end

function modifier_special_bonus_hulk_1:IsPurgable() 
	return false
end

function modifier_special_bonus_hulk_1:RemoveOnDeath()
	return false
end

function modifier_special_bonus_hulk_1:OnCreated()
	self.particle = ParticleManager:CreateParticle("particles/other/black_king_bar/comics_vs_anime_black_king_bar_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_special_bonus_hulk_1:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex( self.particle) 
end

function modifier_special_bonus_hulk_1:CheckState()
    local state = {
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }

    return state
end
modifier_special_bonus_hulk_7 = modifier_special_bonus_hulk_7 or class({})

function modifier_special_bonus_hulk_7:IsHidden() return true end
function modifier_special_bonus_hulk_7:IsPurgable() return false end
function modifier_special_bonus_hulk_7:RemoveOnDeath()return false end

modifier_special_bonus_hulk_8 = modifier_special_bonus_hulk_8 or class({})

function modifier_special_bonus_hulk_8:IsHidden() return true end
function modifier_special_bonus_hulk_8:IsPurgable() return false end
function modifier_special_bonus_hulk_8:RemoveOnDeath()return false end