ichigo_footsteps = ichigo_footsteps or class({})

function ichigo_footsteps:OnSpellStart()
	local range = self:GetSpecialValueFor("range")
	local effect = "particles/strange/comics_vs_anime_strange_blink_osnova_end.vpcf"
	local delay = 0.35
	if self:GetCaster():HasTalent("special_bonus_ichigo_4") then delay = 0.01 end
	range = self:GetCaster():BonusTalentValue("special_bonus_ichigo_5",range)
	self:ComicsVsAnimeBlink(self:GetCaster(),range,effect,nil,delay)
end 