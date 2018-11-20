modifier_charges_thanos = class({})

if IsServer() then
    function modifier_charges_thanos:Update()
        if self:GetDuration() == -1 then
            self:SetDuration(self.kv.cooldown, true)
            self:StartIntervalThink(self.kv.cooldown)
        end

        if self:GetStackCount() == 0 then
            self:GetAbility():StartCooldown(self:GetRemainingTime())
        end
    end

    function modifier_charges_thanos:OnCreated(kv)
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv
        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
        end
    end


	
    function modifier_charges_thanos:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_EXECUTED
        }

        return funcs
    end

    function modifier_charges_thanos:OnAbilityExecuted(params)
        if params.unit == self:GetParent() then
            local ability = params.ability

            if params.ability == self:GetAbility() then
                self:DecrementStackCount()
                self:Update()
            end
        end

        return 0
    end

    function modifier_charges_thanos:OnIntervalThink()
        local stacks = self:GetStackCount()

        if stacks < self.kv.max_count then
            self:SetDuration(self.kv.cooldown, true)
            self:IncrementStackCount()

            if stacks == self.kv.max_count - 1 then
                self:SetDuration(-1, true)
                self:StartIntervalThink(-1)
            end
        end
    end
end

function modifier_charges_thanos:DestroyOnExpire()
    return false
end

function modifier_charges_thanos:IsPurgable()
    return false
end

function modifier_charges_thanos:RemoveOnDeath()
    return false
end