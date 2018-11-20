_G.nNEUTRAL_TEAM = 4
_G.nCOUNTDOWNTIMER = 901

if ComicsVsAnime == nil then
	_G.ComicsVsAnime = class({})
end

requires = {
	"settings",
	"util/Precache",
	"util/events", 
	"util/items", 
	"util/Timers",  
	"util/LinkModifier",
	"util/funcs",
	"util/util",
	"util/ComicsInit",	
	"util/filters",
	"util/PlayerResource",
	--"modules/NewDamage/NewDamage",
}

for k,v in pairs (requires) do
	require(v)
end
if CUSTOM_PICK == true then
	require("util/hero_selection/hero_selection")
	require("util/hero_selection/hero_selection_funcs")
end

if TALENT_MANAGER then
	require("modules/talent_manager/funcs")
	require("modules/talent_manager/modifiers")
	require("modules/talent_manager/data")
end 

	--[["util/hero_selection_funcs",
	"api/frontend",
	"util/hero_selection"]]
	

if CUSTOM_RUNE == true then
	RUNE = {
	"util/custom_rune",
	"modules/custom_runes/custom_runes",
	"modules/gold/gold",
	"libraries/animations",
	"libraries/containers",
	}
	for k,v in pairs (RUNE) do
		require(v)
	end
end

function Precache( context )
		for k,v in pairs(MODEL) do
			PrecacheModel( v, context )
		end
		for k,v in pairs(PARTICLE) do
			PrecacheResource( "particle", v, context )
		end
		for k,v in pairs(PARTICLE_FOLDER) do
			PrecacheResource( "particle_folder", particles, context )
		end
		PrecacheResource("soundfile", "soundevents/sounds_customs.vsndevts", context )	
end

function Activate()
	ComicsVsAnime:InitGameMode()
	ComicsVsAnime:CustomSpawnCamps()
	if PRICE_EVENT == true then
		ComicsVsAnime:StartTimerToGoldRain() 
	end
	if GOLD_EVENT == true then
		ComicsVsAnime:StartGoldEvent()
	end
end