--[[ ArenaLive Core Functions: Import and Export Lua Table Handler
Created by: Vadrak (Original code by Shishei).
Creation Date: 15.08.2013
Last Update: "
These functions are used to import / export lua table values. Thanks and props to Shishei for coding this.
]]--
local addonName = "ArenaLiveCore";
-- Create Handler:
local ImportExport = ArenaLiveCore:AddHandler("ImportExport");

function ImportExport:TableToLuaData(t)
	local output = "\n{\n"
	local i = 0

	for key, value in pairs(t) do
		if ( i > 0 ) then
			output = output .. ",\n"
		end

		if ( type(key) == "string" ) then
			output = output .. "[\"" .. key .. "\"] = "
		else
             output = output .. "[" .. key .. "\"] = "
		end

		if ( type(value) == "string" ) then
			output = output .. "\"" .. ImportExport:Escape(value) .."\""
		elseif ( type(value) == "table" ) then
			output = output .. self:TableToLuaData(value)
		else
			output = output .. value
		end

		i = i + 1
	end
	
	output = output .. "\n}\n"

	return output
end

-- this function takes lua code and executes it in an isolated environment
-- this environment is then returned, and variables set in the code via
-- varname = value
-- can then outside be addressed via emptyenv.varname or [returnvalue].varname
function ImportExport:LuaDataToTable(text)
	local func = assert(loadstring(text))
	--local smallenv = { format=format, tostring=tostring, getglobal=getglobal}
	local emptyenv = {}
	setfenv(func, emptyenv)
	func()

	return emptyenv
end

function ImportExport:Escape(text)

	text = string.gsub(text, [[\]], [[\\]] );
	
	return text;
end