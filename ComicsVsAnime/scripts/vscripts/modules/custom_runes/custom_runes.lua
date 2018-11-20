ModuleRequire(..., "data")
if CustomRunes == nil  then
	CustomRunes = class({})
	CustomRunes.ModifierApplier = CreateItem("item_dummy", nil, nil)
	print("Loading custom runes...")
end

local modifiers = {
	"tripledamage",
	"haste",
	"invisibility",
	"arcane",
	--"flame",
	--"acceleration",
	--"vibration",
	--"spikes",
	--"soul_steal",
	--soul_steal_effect = "soul_steal"
}
for k,v in pairs(modifiers) do
	if type(k) == "string" then
		k, v = v, k
	else
		k = nil
	end
	ModuleLinkLuaModifier(..., "modifier_arena_rune_" .. v, "modifiers/modifier_arena_rune_" .. (k or v))
end

function CustomRunes:ActivateRune(unit, runeType, rune_multiplier)
	local settings = {}
	local merge = {}
	table.merge(settings, RUNE_SETTINGS[runeType])
	if unit.GetPlayerID then
		CustomGameEventManager:Send_ServerToTeam(unit:GetTeam(), "create_custom_toast", {
			type = "generic",
			text = "#custom_toast_ActivatedRune",
			player = unit:GetPlayerID(),
			runeType = runeType
		})
	end
	if rune_multiplier then
		for k, v in pairs(settings) do
			if type(v) == "number" and k ~= "interval" and k ~= "illusion_incoming_damage" and k ~= "movespeed" and k ~= "z_modify" then
				settings[k] = v * rune_multiplier
			end
		end
	end
	if runeType == ARENA_RUNE_BOUNTY then
		local gold = settings.GetValues(unit)
		local xp = settings.GetValues(unit)
		Gold:AddGoldWithMessage(unit, gold * settings.special_value_multiplier)
		unit:AddExperience(xp * settings.special_value_multiplier, DOTA_ModifyXP_Unspecified, false, true)
	elseif runeType == ARENA_RUNE_TRIPLEDAMAGE then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_tripledamage", {duration = settings.duration}):SetStackCount(settings.damage_pct)
	elseif runeType == ARENA_RUNE_HASTE then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_haste", {duration = settings.duration}):SetStackCount(settings.movespeed)
	elseif runeType == ARENA_RUNE_ILLUSION then
		for i = 1, settings.illusion_count do
			CreateIllusion(unit, CustomRunes.ModifierApplier, unit:GetAbsOrigin() + RandomVector(100), settings.illusion_incoming_damage - 100, settings.illusion_outgoing_damage - 100, settings.duration):SetForwardVector(unit:GetForwardVector())
		end
	elseif runeType == ARENA_RUNE_INVISIBILITY then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_invisibility", {duration = settings.duration})
	elseif runeType == ARENA_RUNE_REGENERATION then
		unit:SetHealth(unit:GetMaxHealth())
		unit:SetMana(unit:GetMaxMana())
	elseif runeType == ARENA_RUNE_ARCANE then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_arcane", {duration = settings.duration})
	elseif runeType == ARENA_RUNE_FLAME then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_flame", {duration = settings.duration, damage_per_second_max_hp_pct = settings.damage_per_second_max_hp_pct})
	elseif runeType == ARENA_RUNE_ACCELERATION then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_acceleration", {duration = settings.duration, xp_multiplier = settings.xp_multiplier})
	elseif runeType == ARENA_RUNE_VIBRATION then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_vibration", {
			duration = settings.duration,
			minRadius = settings.minRadius,
			fullRadius = settings.fullRadius,
			minForce = settings.minForce,
			fullForce = settings.fullForce,
			interval = settings.interval,
		})
	elseif runeType == ARENA_RUNE_SOUL_STEAL then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_soul_steal", {duration = settings.duration, radius = settings.aura_radius}):SetStackCount(settings.damage_heal_pct)
	elseif runeType == ARENA_RUNE_SPIKES then
		unit:AddNewModifier(unit, CustomRunes.ModifierApplier, "modifier_arena_rune_spikes", {duration = settings.duration}):SetStackCount(settings.damage_reflection_pct)
	end

	unit:EmitSound(settings.sound or "General.RunePickUp")
end

function CustomRunes:CreateRune(position, runeType)
	local settings = RUNE_SETTINGS[runeType]
	if settings.z_modify then
		position.z = position.z + settings.z_modify
	end
	local entity = CreateUnitByName("npc_comics_vs_anime_rune", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	entity.RuneType = runeType
	entity:SetModel(settings.model)
	entity:SetOriginalModel(settings.model)
	StartAnimation(entity, {duration=-1, activity=ACT_DOTA_IDLE})
	entity:SetAbsOrigin(position)
	if settings.angles then
		entity:SetAngles(unpack(settings.angles))
	end
	local pfx = ParticleManager:CreateParticle(settings.particle, settings.particle_attach or PATTACH_ABSORIGIN_FOLLOW, entity)
	if settings.color then
		entity:SetRenderColor(unpack(settings.color))
	end
	if settings.oncreated then
		settings.oncreated(entity)
	end
	entity:SetNetworkableEntityInfo("custom_tooltip", {
		title = "#custom_runes_rune_" .. runeType .. "_title",
		text = "#custom_runes_rune_" .. runeType .. "_text"
	})
	return entity
end

function CustomRunes:Init()
	for _,v in ipairs(Entities:FindAllByName("dota_item_rune_spawner")) do
		DynamicMinimap:CreateMinimapPoint(v:GetAbsOrigin(), "icon_rune")
	end
end

function CustomRunes:SpawnRunes()
	local spawners = Entities:FindAllByName("dota_item_rune_spawner")
	local bountySpawner = RandomInt(1, #spawners)
	for k,v in ipairs(spawners) do
		if IsValidEntity(v.RuneEntity) then
			v.RuneEntity:ClearNetworkableEntityInfo()
			UTIL_Remove(v.RuneEntity)
		end
		v.RuneEntity = CustomRunes:CreateRune(v:GetAbsOrigin(), k == bountySpawner and ARENA_RUNE_BOUNTY or RandomInt(ARENA_RUNE_FIRST, ARENA_RUNE_LAST))
	end
end

function CustomRunes:ExecuteOrderFilter(order)
	if order.units["0"] and (order.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or order.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) then
		local unit = EntIndexToHScript(order.units["0"])
		local rune = EntIndexToHScript(order.entindex_target)

		if IsValidEntity(unit) and IsValidEntity(rune) and rune:IsCustomRune() then
			local pos = rune:GetAbsOrigin()
			order.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
			order.position_x = pos.x
			order.position_y = pos.y
			order.position_z = pos.z
			if unit:IsRealHero() then
				local issuerID = order.issuer_player_id_const
				Containers.rangeActions[order.units["0"]] = {
					unit = unit,
					position = rune:GetAbsOrigin(),
					range = 100,
					playerID = issuerID,
					action = function()
						if IsValidEntity(unit) and IsValidEntity(rune) then
							local runeType = rune.RuneType
							rune:ClearNetworkableEntityInfo()
							UTIL_Remove(rune)
							unit:Stop()

							--[[local bottle
							local runeKeeper
							local runic_mekansm
							for i = 0, 5 do
								local item = unit:GetItemInSlot(i)
								if item then
									if not runeKeeper and item:GetAbilityName() == "item_rune_keeper" then
										runeKeeper = item
									elseif not bottle and item:GetAbilityName() == "item_bottle_arena" and not item.RuneStorage then
										bottle = item
									elseif not runic_mekansm and item:GetAbilityName() == "item_runic_mekansm" and not item.RuneStorage then
										runic_mekansm = item
									end
								end
							end

							if runic_mekansm then
								runic_mekansm:SetStorageRune(runeType)
							elseif runeKeeper and runeKeeper.RuneContainer then
								table.insert(runeKeeper.RuneContainer, {rune=runeType, expireGameTime = GameRules:GetGameTime() + runeKeeper:GetAbilitySpecial("store_duration")})
								Notifications:Bottom(issuerID, {text="#item_rune_keeper_rune_picked_up", duration = 8})
								Notifications:Bottom(issuerID, {text="#custom_runes_rune_" .. runeType .. "_title", continue=true})
								Notifications:Bottom(issuerID, {text="#item_rune_keeper_rune_picked_up_cont", continue=true})
								for i,v in ipairs(runeKeeper.RuneContainer) do
									Notifications:Bottom(issuerID, {text="#custom_runes_rune_" .. v.rune .. "_title", continue=true})
									Notifications:Bottom(issuerID, {text=" ,", continue=true})
								end
							elseif bottle then
								bottle:SetStorageRune(runeType)
							else]]
								CustomRunes:ActivateRune(unit, runeType)
							--end
						end
					end,
				}
			end
		end
	end
end

function CEntityInstance:IsCustomRune()
	return self.GetUnitName and self:GetUnitName() == "npc_comics_vs_anime_rune"
end