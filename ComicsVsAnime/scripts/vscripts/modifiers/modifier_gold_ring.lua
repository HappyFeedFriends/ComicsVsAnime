if modifier_gold_ring == nil then
	modifier_gold_ring = class({})
end

function modifier_gold_ring:OnCreated( kv )
local interval = 4 --GOLD_TICK_RING
    self:StartIntervalThink(interval)
end

function modifier_gold_ring:IsHidden()
	return false
end

function modifier_gold_ring:IsPurgable()
    return false
end

function modifier_gold_ring:RemoveOnDeath()
    return true
end

function modifier_gold_ring:OnIntervalThink()
    if IsServer() then
        if self:GetParent():IsAlive() == false then
            self:Destroy()
        end
		local expirience = 222 --EXP_RING
		local gold = 2222 --GOLD_RING
		self:GetParent():AddExperience( expirience, 0, false, false )
		self:GetParent():ModifyGold( self:GetParent(), gold, true, 0 )
	end
end