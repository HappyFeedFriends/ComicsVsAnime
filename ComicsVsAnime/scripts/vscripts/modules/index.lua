local modules = {
	"custom_runes",
	--"spawner",
	"gold",
}

local errors = {}
for k, v in ipairs(modules) do
	if type(k) == "string" then
		k, v = v, k
	else
		k = nil
	end
	local status, nextCall = xpcall(function() require("modules/" .. v .. "/" .. (k or v)) end, function(msg)
		local trace = debug.traceback()
		local limiter = trace:find("in function 'xpcall'") - 8
		return msg .. '\n' .. trace:sub(0, limiter) .. '\n'
	end)
	if not status then
		table.insert(errors, nextCall)
		print("NEXT CALL",nextCall)
	end
end

--require("custom_rune/verify")
