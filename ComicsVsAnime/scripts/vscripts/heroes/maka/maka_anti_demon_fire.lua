function maka_cast_spell(keys)
    local caster = keys.caster
    local ability = keys.ability
    local vDirection = caster:GetCursorPosition() - caster:GetOrigin()
	vDirection = vDirection:Normalized()
    local range = ability:GetSpecialValueFor("range")
	local talent = caster:FindAbilityByName("special_bonus_maka_4")
    local info = 
    {
        Ability = ability,													-- 	Какая абилка кастует
        EffectName = "particles/moka/comics_vs_anime_moka_spell.vpcf", 		-- 	Партикля
        vSpawnOrigin = caster:GetOrigin(), 									--	Откуда спавнит
        fDistance = range, 													--	Дальность
        fStartRadius = ability:GetSpecialValueFor("start_radius"), 			--	Старт радиус для урона
        fEndRadius = ability:GetSpecialValueFor("end_radius"), 				-- 	Конец Радиуса для урона 
        Source = caster, 													-- 	Кто кастует
        bHasFrontalCone = true, 											-- 	Что-то типо конуса?
        bReplaceExisting = false, 											-- 	Заменить?
        iUnitTargetTeam = ability:GetAbilityTargetTeam(),					-- 	Кого таргетить(ПРОТИВНИКА/НЕЙТРАЛА/СВОЕГО)? (ИЗ DD)
        iUnitTargetFlags = ability:GetAbilityTargetFlags(),					-- 	Флаги для таргета (из DD)
        iUnitTargetType = ability:GetAbilityTargetType(),					-- 	Кого таргетить?(ГЕРОИ ИЛИ КРИПЫ) (Из DD)
        vVelocity = vDirection * 900, 										-- 	Скорость
        bVisibleToEnemies = true, 											-- 	Противникам видно партиклю?(В тумане)
        bProvidesVision = true, 											-- 	C помощью способности можно увидеть в тумане?  
        iVisionRadius =  ability:GetSpecialValueFor("vision"), 			    -- 	Какой радиус вижена возле партикли 
        iVisionTeamNumber = caster:GetTeamNumber(),						 	-- 	Номер команды для которой вижен
    }

	if talent and talent:GetLevel() > 0 then
		local r = 50
		local value = talent:GetSpecialValueFor("value")
		i = -r
		for k=1,value,1 do
			ProjectileManager:CreateLinearProjectile(info)
			info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * range
			i = i + r
		end
	else
		ProjectileManager:CreateLinearProjectile(info)
		info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,0,0), caster:GetForwardVector()) * range
	end
end

------------------------------------------------
-- Наносит урон при попадании
------------------------------------------------
function maka_spell_end(keys)
    local caster = keys.caster
    local ability = keys.ability
	local target = keys.target
	local damage_soul = ability:GetSpecialValueFor("damage_soul") * caster:GetModifierStackCount( "modifier_maka_soul", ability )
	local damage = ability:GetSpecialValueFor("damage")
	damage = caster:BonusTalentValue("special_bonus_maka_7",damage)
	local pct = ability:GetSpecialValueFor("mana_burn")/100
	local chance = ability:GetSpecialValueFor("chance")
	local radius = ability:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius(
				caster:GetTeamNumber(), 			 -- Ищет номер команды
	            target:GetAbsOrigin(),				 -- Вокруг какой цели наносить урон
	            nil,								 -- Не полностью разобрался,но что-то типо поиска определённой цели
	            radius,								 -- Радиус урона
	            ability:GetAbilityTargetTeam(), 	 -- Цель (ИЗ DD)
	            ability:GetAbilityTargetType(), 	 -- Тип целей (ГЕРОЙ/ЮНИТ) (ИЗ DD)
	            ability:GetAbilityTargetFlags(),	 -- Флаги (ИЗ DD)
	            FIND_ANY_ORDER, 					 -- ПО ПОРЯДКУ
				false)								 -- Кэшить крипов?
				
	for k, unit in pairs( units ) do
		ApplyDamage({
		victim = unit,
		attacker = caster, 
		ability = ability,
		damage_type = ability:GetAbilityDamageType(), 
		damage = damage + damage_soul})
		
		if RollPercentage(chance) == true and unit:GetMana() >= unit:GetMaxMana() * pct and unit:IsHero() then
			unit:ReduceMana(unit:GetMaxMana() * pct)
			caster:GiveMana(unit:GetMaxMana() * pct)
			SendOverheadEventMessage( target, OVERHEAD_ALERT_MANA_LOSS, target,unit:GetMaxMana() * pct, nil )
			SendOverheadEventMessage( caster, OVERHEAD_ALERT_MANA_ADD, caster,unit:GetMaxMana() * pct, nil )
		end
	end
	caster:RemoveModifierByName("modifier_maka_soul")
end