--[[ ArenaLive Core: Localisation Core
Created by: Vadrak
Creation Date: 17.05.2013
Last Update: 02.06.2013
NOTE: This one is not a real core, but only an addition to the ArenaLiveCore frame.
This way it is easier to interact with the functions.
]]--
local addonName = "ArenaLiveCore";
local L = getglobal("ArenaLiveLoc")

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Define the localisation table.
ArenaLiveCore.localisation = {};
ArenaLiveCore.localisation[addonName] = L;

--[[ Function: AddAddonLocalisation
	 Adds the localisation of an addon to the general localisation table.
	 This function can also be used to update a already existing addon localisation.
	 Arguments:
		addon: The name of the addon the localisation belongs to.
		localisation: (optional) A table that already contains all relevant localisation keys.
	 Returns:
		ArenaLiveCore.localisation[addon]: The newly created localisation table.
]]--
function ArenaLiveCore:AddAddonLocalisation (addon, localisation)
	if ( localisation ) then
		ArenaLiveCore.localisation[addon] = localisation;
	else
		ArenaLiveCore.localisation[addon] = {};
	end

	return ArenaLiveCore.localisation[addon];
end

--[[ Function: SetLocalisation
	 Sets a localisation to a addon's localisation table.
	 This can also be used to update a single key.
	 Arguments:
		addon: The name of the addon the localisation belongs to.
		key: The key of the localisation.
		value: The localisation.
]]--
function ArenaLiveCore:SetLocalisation (addon, key, value)
	if ( not addon ) then
		ArenaLiveCore:Message(L["ERR_SET_LOCALE_ADDON_NOT_GIVEN"], "error");
		return;
	end
	
	if ( ArenaLiveCore.localisation[addon] ) then
		ArenaLiveCore.localisation[addon][key] = value;
	else
		ArenaLiveCore:Message(L["ERR_SET_LOCALE_ADDON_DOESNT_EXIST"], "error");
	end
end

--[[ Function: GetLocalisation
	 Returns the requested localisation string.
	 Arguments:
		addon: The name of the addon the localisation belongs to. (optional) If nil it will return a string of the ArenaLiveCore base localisation
		key: The key to the table entry.
]]--
function ArenaLiveCore:GetLocalisation (addon, key)
	local returnValue;
	
	if (not addon ) then
		if ( ArenaLiveCore.localisation[key] ) then
			returnValue = ArenaLiveCore.localisation[key];
		else
			ArenaLiveCore:Message(L["ERR_GET_LOCALE_ADDON_NOT_GIVEN"], "error");
		end

	else
		if ( ArenaLiveCore.localisation[addon] ) then
			if ( ArenaLiveCore.localisation[addon][key] ) then
				returnValue = ArenaLiveCore.localisation[addon][key];
			else
				ArenaLiveCore:Message(string.format(L["ERR_GET_LOCALE_KEY_DOESNT_EXIST"], key), "error");
			end
		else
			ArenaLiveCore:Message(string.format(L["ERR_GET_LOCALE_ADDON_DOESNT_EXIST"], addon), "error");
		end

	end

	return returnValue;
end