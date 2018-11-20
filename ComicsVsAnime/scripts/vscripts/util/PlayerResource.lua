function IsPlayerAbandoned(playerID)
	return PLAYER_DATA[playerID].IsAbandoned == true
end

function CDOTA_PlayerResource:IsPlayerAbandoned(playerID)
	return IsPlayerAbandoned(playerID)
end

function GetTeamPlayerCount(iTeam)
	local counter = 0
	for i = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID(i) and not IsPlayerAbandoned(i) and PlayerResource:GetTeam(i) == iTeam then
			counter = counter + 1
		end
	end
	return counter
end


function GetOneRemainingTeam()
	local teamLeft
	for i = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
		local count = GetTeamPlayerCount(i)
		if count > 0 then
			if teamLeft then
				return
			else
				teamLeft = i
			end
		end
	end
	return teamLeft
end

function GetTeamAbandonedPlayerCount(iTeam)
	local counter = 0
	for i = 0, 23 do
		if PlayerResource:IsValidPlayerID(i) and IsPlayerAbandoned(i) and PlayerResource:GetTeam(i) == iTeam then
			counter = counter + 1
		end
	end
	return counter
end

function CDOTA_PlayerResource:GetRealSteamID(PlayerID)
	local id = tostring(PlayerResource:GetSteamID(PlayerID))
	return id == "0" and tostring(PlayerID) or id
end