function SetMaxLevel(keys)
	local ability = keys.ability
	ability:SetLevel(ability:GetMaxLevel())
end

function ring_gold( keys )
    if keys.target:IsRealHero() and keys.target:GetUnitName() ~= "npc_dota_hero_target_dummy" then
        local expirience = EXP_RING
        local gold = GOLD_RING
        local target = keys.target
		ComicsVsAnimeXp(Xp,target,overhead,target,false)
        ComicsVsAnimeGold(gold,target,target,false,nil,false)
    end
end

function global_gold( keys )
    if keys.target:IsRealHero() and keys.target:GetUnitName() ~= "npc_dota_hero_target_dummy" then
        local expirience = EXP_GLOBAL
        local gold = GOLD_GLOBAL
        local target = keys.target
        target:AddExperience( expirience,0,false,false )
        ComicsVsAnimeGold(gold,target,target,false,nil,false)
    end
end