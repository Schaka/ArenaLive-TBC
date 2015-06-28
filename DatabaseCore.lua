--[[ ArenaLive Database Core
Created by: Vadrak
Creation Date: 31.05.2013
Last Update: 02.06.2013
This function set handles the database for ArenaLive. All ArenaLive based addons need to register their defaults to this core on their first launch.
The defaults will then be used to set up a database entry for the addon's saved variables.
]]--


-- Local version is said to be faster.
local addonName = "ArenaLiveCore";

local ArenaLiveCore = ArenaLiveCore;

-- Create a local to store the player's name and realm for the current logged char.
local characterModifier;

-- Create the database table.
ArenaLiveCore.db = {};

local defaultSettings = 
	{
		["CCPriority/defCD"] = 100,
		["CCPriority/offCD"] = 30,
		["CCPriority/stun"] = 90,
		["CCPriority/silence"] = 80,
		["CCPriority/crowdControl"] = 70,
		["CCPriority/defCD"] = 60,
		["CCPriority/disarm"] = 50,
		["CCPriority/root"] = 40,
		["Auras/OnlyShowCastableBuffs"] = false,
		["Auras/OnlyShowDispellableDebuffs"] = false,
		["Auras/ShowOwnDebuffsOnly"] = false,
		["Auras/TournamentFilter"] = false,
	}

--[[ Function: AddDatabase
	 This function adds a addon's default settings to the database on the initial start up. 
	 Arguments:
		databaseName: The databases' name. 
		defaultSettings: A table containing the addon's default variables.
]]--
function ArenaLiveCore:AddDatabase(databaseName, defaultSettings, saveByCharacter)
	
	if ( not databaseName ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_DATABASE_NAME_NOT_GIVEN"), databaseName), "error");
		return;
	end
	local name, realm;

	if ( not ArenaLiveCore.db[databaseName] ) then
		
		if ( saveByCharacter ) then
			ArenaLiveCore.db[databaseName] = {};
			ArenaLiveCore.db[databaseName]["saveByCharacter"] = true;
			ArenaLiveCore.db[databaseName][characterModifier] = defaultSettings;
		else
			ArenaLiveCore.db[databaseName] = defaultSettings;
		end

	elseif ( ArenaLiveCore.db[databaseName] and ArenaLiveCore.db[databaseName]["saveByCharacter"] and not ArenaLiveCore.db[databaseName][characterModifier] ) then
		ArenaLiveCore.db[databaseName][characterModifier] = defaultSettings;
	else
		--[[ If an entry with this name already exists, we don't overwrite it, because this could cause problems.
		     We will print an error messsage instead, if we handle two different addon's that use the same name. 
			 If you want to update your database during the game use the "UpdateAddOn" function instead! ]]--
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_DATABASE_ALREADY_EXISTS"), databaseName), "error");
	end

end

--[[ Function: RemoveDatabase
	 Removes a addon's saved variables from the database.
		databaseName: The databases' name.
]]--
function ArenaLiveCore:RemoveDatabase(databaseName)
	
	if ( not databaseName ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_REMOVE_DATABASE_NAME_NOT_GIVEN"), "error");
		return;
	end
	
	if ( ArenaLiveCore.db[databaseName] ) then
		ArenaLiveCore.db[databaseName] = nil;
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_REMOVE_DATABASE_DOESNT_EXISTS"), databaseName), "error");
	end

end

--[[ Function: UpdateDatabase
	 This function updates a addon's saved variables in the database.
	 In contrast to the AddAddon function, this one overwrites the already existing database entry
	 and returns an error message, if the database entry doesn't exist.
	 Arguments:
		databaseName: The databases' name.
		updatedSettings: A table containing the addon's updated saved variables.
]]--
function ArenaLiveCore:UpdateDatabase(databaseName, updatedSettings)
	
	if ( not databaseName ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_UPDATE_DATABASE_NAME_NOT_GIVEN"), "error");
		return;
	end
	
	if ( ArenaLiveCore.db[databaseName] ) then
		if ( ArenaLiveCore.db[databaseName]["saveByCharacter"] ) then
			ArenaLiveCore.db[databaseName][characterModifier] = updatedSettings;
		else
			ArenaLiveCore.db[databaseName] = updatedSettings;
		end
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_UPDATE_DATABASE_DOESNT_EXISTS"), databaseName), "error");
	end

end

--[[ Function: GetDBEntry
	 Returns the value of the requested saved variable.
	 Arguments:
		databaseName: The databases' name. If no addon name is given, then the function will start at the base of the database. 
		key: String containing the key of the variable.
	 Returns:
		returnValue: The value of specified database entry.
]]--
function ArenaLiveCore:GetDBEntry (databaseName, key)	
	
	if ( databaseName and not ArenaLiveCore.db[databaseName] ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_GET_DATABASE_DOESNT_EXISTS"), key, databaseName), "error");
		return;
	end	
	
	local returnValue;
	
	if ( databaseName ) then
		if ( ArenaLiveCore.db[databaseName]["saveByCharacter"] ) then
			returnValue = ArenaLiveCore.db[databaseName][characterModifier][key];
		
		else
			returnValue = ArenaLiveCore.db[databaseName][key];
		end	
	else
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_GET_DATABASE_NAME_NOT_GIVEN"), "error");
		return;
	end

	return returnValue;
end

--[[ Function: SetDBEntry
	 Sets the value of the specified saved variable.
	 Arguments:
		databaseName: The addon's name. 
		key: String containing the key of the variable.
		value: the new value of the entry.
]]--
function ArenaLiveCore:SetDBEntry(databaseName, key, value)

	if ( databaseName and not ArenaLiveCore.db[databaseName] ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_SET_DATABASE_DOESNT_EXISTS"), name), "error");
		return;
	end	
	
	if ( databaseName ) then
		if ( ArenaLiveCore.db[databaseName]["saveByCharacter"] ) then
			ArenaLiveCore.db[databaseName][characterModifier][key] = value;
		
		else
			ArenaLiveCore.db[databaseName][key] = value;
		end	
	else
		ArenaLiveCore.db[key] = value;
	end
end

--[[ Function: SetDBEntry
	 Returns wether a database with the specified name exists or not.
	 Arguments:
		databaseName: The addon's name. 
	 Returns:
		true, if the database exists, otherwise nil.
]]--
function ArenaLiveCore:DatabaseExists(databaseName)

	if ( not databaseName ) then
		return;
	end
	
	if ( ArenaLiveCore.db[databaseName] ) then
		if ( not ArenaLiveCore.db[databaseName]["saveByCharacter"] ) then
			return true;
		else
			if ( ArenaLiveCore.db[databaseName][characterModifier] ) then
				return true;
			else
				return nil;
			end
		end
	else
		return nil;
	end

end

local function SetCharacterModifier()

	local name, realm;
	name = UnitName("player");
	realm = GetRealmName();

	characterModifier = name.."-"..realm;
end
SetCharacterModifier();
