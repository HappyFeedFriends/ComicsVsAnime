if modifier_check_talent == nil then
	modifier_check_talent = class({})
end

function modifier_check_talent:IsHidden()
	return true
end

function modifier_check_talent:IsPurgable()
	return true
end

function modifier_check_talent:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.01)	
	end	
end	

function modifier_check_talent:OnIntervalThink()
	for k,v in pairs(TALENT) do
		local talent = self:GetCaster():FindAbilityByName(v)
		if talent and talent:GetLevel() > 0 and not self:GetCaster():HasModifier("modifier_"..v) then
			self:GetCaster():AddNewModifier( self:GetCaster(), talent, "modifier_"..v, {duration = -1})
		end
	end
end