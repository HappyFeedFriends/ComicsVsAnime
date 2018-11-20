-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------DELETE MODIFIER-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------
-- Silence
---------------------------------------------------
modifier_silence = class({})

function modifier_silence:IsDebuff() 
	return true 
end

function modifier_silence:IsHidden() 
	return false
end

function modifier_silence:IsPurgeException()
	return false
end	
	
function modifier_silence:IsPurgable() 
	return false 
 end

function modifier_silence:CheckState()
	return [MODIFIER_STATE_SILENCED] = true
end
---------------------------------------------------
-- Stunned
---------------------------------------------------
modifier_stunned = class({})

function modifier_stunned:IsDebuff() 
	return true 
end

function modifier_stunned:IsHidden() 
	return false
end

function modifier_stunned:IsPurgeException()
	return false
end	
	
function modifier_stunned:IsPurgable() 
	return false 
 end

function modifier_stunned:CheckState()
	return [MODIFIER_STATE_STUNNED] = true
end

---------------------------------------------------
-- Mute
---------------------------------------------------

modifier_mute = class({})

function modifier_mute:IsDebuff() 
	return true 
end

function modifier_mute:IsHidden() 
	return false
end

function modifier_mute:IsPurgeException()
	return false
end	
	
function modifier_mute:IsPurgable() 
	return false 
 end

function modifier_mute:CheckState()
	return [MODIFIER_STATE_MUTED] = true
end

---------------------------------------------------
-- Disarmed
---------------------------------------------------

modifier_disarmed = class({})

function modifier_disarmed:IsDebuff() 
	return true 
end

function modifier_disarmed:IsHidden() 
	return false
end

function modifier_disarmed:IsPurgeException()
	return false
end	
	
function modifier_disarmed:IsPurgable() 
	return false 
 end

function modifier_disarmed:CheckState()
	return [MODIFIER_STATE_DISARMED] = true
end

---------------------------------------------------
-- Rooted
---------------------------------------------------

modifier_rooted = class({})

function modifier_rooted:IsDebuff() 
	return true 
end

function modifier_rooted:OnCreated()
	
end

function modifier_rooted:IsHidden() 
	return false
end

function modifier_rooted:IsPurgeException()
	return false
end	
	
function modifier_rooted:IsPurgable() 
	return false 
 end

function modifier_rooted:CheckState()
	return [MODIFIER_STATE_ROOTED] = true
end

---------------------------------------------------
-- Frozen
---------------------------------------------------

modifier_frozen = class({})

function modifier_frozen:IsDebuff() 
	return true 
end

function modifier_frozen:IsHidden() 
	return false
end

function modifier_frozen:IsPurgeException()
	return false
end	
	
function modifier_frozen:IsPurgable() 
	return false 
 end

function modifier_frozen:CheckState()
	return [MODIFIER_STATE_STUNNED] = true
end