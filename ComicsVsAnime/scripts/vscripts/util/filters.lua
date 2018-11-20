function ComicsVsAnime:FiltersOn()
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( ComicsVsAnime, "ComicsVsAnimeBountyFilter" ), self )
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(ComicsVsAnime, 'ComicsVsAnimeDamageFilter'), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( ComicsVsAnime, "ComicsVsAnimeExecuteFilter" ), self )
end

function ComicsVsAnime:ComicsVsAnimeExecuteFilter( filterTable )
	local orderType = filterTable["order_type"]
	if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
		return true
	else
		local item = EntIndexToHScript( filterTable["entindex_target"] )
		if item == nil then
			return true
		end
		local pickedItem = item:GetContainedItem()
		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end
		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 9 then
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()
				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
				return true
			end
		end
	end
	if CUSTOM_RUNE == true then
		local order_type = filterTable.order_type
		local PlayerID = filterTable.issuer_player_id_const
		if order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
			return false
		end
		local target = EntIndexToHScript(filterTable.entindex_target)
		local ability = EntIndexToHScript(filterTable.entindex_ability)
		local abilityname
		if ability and ability.GetAbilityName then
			abilityname = ability:GetAbilityName()
		end
		local entindexes_units = filterTable.units
		local units = {}
		for _, v in pairs(entindexes_units) do
			local u = EntIndexToHScript(v)
			if u then
				table.insert(units, u)
			end
		end
		if order_type == DOTA_UNIT_ORDER_TRAIN_ABILITY and Options:IsEquals("EnableAbilityShop") then
			CustomAbilities:OnAbilityBuy(PlayerID, abilityname)
			return false
		end

		if units[1] and
			order_type == DOTA_UNIT_ORDER_SELL_ITEM and
			ability then
			PanoramaShop:SellItem(PlayerID, units[1], ability)
			return false
		end

		for _,unit in ipairs(units) do
			if unit:IsHero() or unit:IsConsideredHero() then
				GameMode:TrackInventory(unit)
				if unit:IsRealHero() then
					if ability then
						if order_type == DOTA_UNIT_ORDER_CAST_POSITION then
							if not Duel:IsDuelOngoing() and ARENA_NOT_CASTABLE_ABILITIES[abilityname] then
								local orderVector = Vector(filterTable.position_x, filterTable.position_y, 0)
								if type(ARENA_NOT_CASTABLE_ABILITIES[abilityname]) == "number" then
									local ent1len = (orderVector - Entities:FindByName(nil, "target_mark_arena_team2"):GetAbsOrigin()):Length2D()
									local ent2len = (orderVector - Entities:FindByName(nil, "target_mark_arena_team3"):GetAbsOrigin()):Length2D()
									if ent1len <= ARENA_NOT_CASTABLE_ABILITIES[abilityname] + 200 or ent2len <= ARENA_NOT_CASTABLE_ABILITIES[abilityname] + 200 then
										Containers:DisplayError(PlayerID, "#arena_hud_error_cant_target_duel")
										return false
									end
								end
								if IsInBox(orderVector, Entities:FindByName(nil, "target_mark_arena_blocker_1"):GetAbsOrigin(), Entities:FindByName(nil, "target_mark_arena_blocker_2"):GetAbsOrigin()) then
									Containers:DisplayError(PlayerID, "#arena_hud_error_cant_target_duel")
									return false
								end
							end
						elseif order_type == DOTA_UNIT_ORDER_CAST_TARGET and IsValidEntity(target) then
							if abilityname == "rubick_spell_steal" then
								if target == unit then
									Containers:DisplayError(PlayerID, "#dota_hud_error_cant_cast_on_self")
									return false
								end
								if target:HasAbility("doppelganger_mimic") then
									Containers:DisplayError(PlayerID, "#dota_hud_error_cant_steal_spell")
									return false
								end
							end
							if target:IsChampion() and CHAMPIONS_BANNED_ABILITIES[abilityname] then
								Containers:DisplayError(PlayerID, "#dota_hud_error_ability_cant_target_champion")
								return false
							end
							if target:IsBoss() and BOSS_BANNED_ABILITIES[abilityname] then
								Containers:DisplayError(PlayerID, "#dota_hud_error_ability_cant_target_boss")
								return false
							end
							if PlayerResource:IsDisableHelpSetForPlayerID(UnitVarToPlayerID(target), UnitVarToPlayerID(unit)--[[PlayerID]]) and DISABLE_HELP_ABILITIES[abilityname] then
								Containers:DisplayError(PlayerID, "#dota_hud_error_target_has_disable_help")
								return false
							end
							if table.contains(ABILITY_INVULNERABLE_UNITS, target:GetUnitName()) and abilityname ~= "item_casino_coin" then
								filterTable.order_type = DOTA_UNIT_ORDER_MOVE_TO_TARGET
								return true
							end
						end
					end
					if filterTable.position_x ~= 0 and filterTable.position_y ~= 0 then
						if (RandomInt(0, 1) == 1 and (unit:HasModifier("modifier_item_casino_drug_pill3_debuff") or unit:GetModifierStackCount("modifier_item_casino_drug_pill3_addiction", unit) >= 8)) or unit:GetModifierStackCount("modifier_item_casino_drug_pill3_addiction", unit) >= 16 then
							local heroVector = unit:GetAbsOrigin()
							local orderVector = Vector(filterTable.position_x, filterTable.position_y, 0)
							local diff = orderVector - heroVector
							local newVector = heroVector + (diff * -1)
							filterTable.position_x = newVector.x
							filterTable.position_y = newVector.y
						end
					end
				end
			end
		end
	end
	return true
end

function ComicsVsAnime:ComicsVsAnimeBountyFilter( filterTable )
	  local xp = XP_RUNE
	  local gold = GOLD_RUNE
      filterTable["xp_bounty"] = xp
      filterTable["gold_bounty"] = gold
      return true
end

function ComicsVsAnime:ComicsVsAnimeDamageFilter(filterDamage)
	if pcall(function ()
		local attacker = EntIndexToHScript(filterDamage.entindex_attacker_const)
		local ability
		local victim = EntIndexToHScript(filterDamage.entindex_victim_const)
		local damage = filterDamage.damage 
		if entindex_inflictor_const then
			ability = EntIndexToHScript(filterDamage.entindex_inflictor_const )
		end
		local TYPE = filterDamage.damagetype_const
		local NONE = 0 -- Убивает всё
		local PHYSICAL = 1 
		local MAGICAL = 2
		local PURE = 4
		local ALL = 7
		
			if attacker ~= nil then
				if victim:HasModifier("modifier_loki_blink_strike_smoke_dmg") and attacker:ComicsVsAnimeHasTalent("special_bonus_loki_1") then
					local dmg = attacker:ComicsVsAnimeTalent("special_bonus_loki_1",nil,"damage")
					filterDamage.damage = filterDamage.damage + dmg
				end
				if TYPE == MAGICAL  then
					for k,v in pairs(TALENT_MAGICAL_CRIT) do
						if attacker:FindAbilityByName(v) and attacker:FindAbilityByName(v):GetLevel() > 0 then
							if RollPercentage(attacker:FindAbilityByName(v):GetSpecialValueFor("chance_crit")) == true then
								filterDamage.damage = filterDamage.damage * attacker:FindAbilityByName(v):GetSpecialValueFor("Crit_damage")/100
								TooltipCustomDamage(filterDamage.damage,victim,MAGICAL)
								return true 
							end	
						end
					end
					if attacker:HasItemInInventory("item_magic_medallion_1") and RollPercentage(20) == true then
						filterDamage.damage = filterDamage.damage * 2.5
						TooltipCustomDamage(filterDamage.damage,victim,"MAGIC")
					elseif attacker:HasItemInInventory("item_magic_medallion_2") and RollPercentage(25) == true then
						filterDamage.damage = filterDamage.damage * 2.5
						TooltipCustomDamage(filterDamage.damage,victim,"MAGIC")
					elseif attacker:HasItemInInventory("item_magic_medallion_3") and RollPercentage(30) == true then
						filterDamage.damage = filterDamage.damage * 2.5
						TooltipCustomDamage(filterDamage.damage,victim,"MAGIC")
					end
				end	
			end
		end) then
		return true
	end
end