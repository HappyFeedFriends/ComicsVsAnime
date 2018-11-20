modifier_vision_target = modifier_vision_target or class({})

function modifier_vision_target:IsDeBuff()
    return true
end

function modifier_vision_target:IsHidden()return true end
function modifier_vision_target:IsPurgable()return true end
function modifier_vision_target:RemoveOnDeath()return true end

function modifier_vision_target:CheckState()
local state ={[MODIFIER_STATE_PROVIDES_VISION] = true}
	return state
end