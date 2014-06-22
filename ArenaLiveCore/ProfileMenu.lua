--[[ ArenaLive Core Functions: Profile Menu Handler
Created by: Vadrak
Creation Date: 05.08.2013
Last Update: "
This file contains a profile menu manager that allows other addon's to create a profile menu for the saved variables which they store in the ArenaLiveCore database.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local ProfileMenu = ArenaLiveCore:AddHandler("ProfileMenu");
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local FrameMover = ArenaLiveCore:GetHandler("FrameMover");
local ArenaHeader = ArenaLiveCore:GetHandler("ArenaHeader");
local PartyHeader = ArenaLiveCore:GetHandler("PartyHeader");

-- Save the current character's name:
local currentProfile, realm;
currentProfile = UnitName("player");
realm = GetRealmName();
currentProfile = currentProfile.."-"..realm;

local function CopyProfile(self, dropdown, copyProfileName)

	-- Update Dropdown text to new value:
	UIDropDownMenu_SetText(dropdown, copyProfileName);

	-- Copy the database entry and overwrite the old one:
	for key, value in pairs(ArenaLiveCore.db[dropdown.databaseName][copyProfileName]) do
		ArenaLiveCore.db[dropdown.databaseName][currentProfile][key] = value;
	end
	
	-- We need to update frame positions, in order for them to update correctly after the UI reload:
	for key, frame in pairs(UnitFrame.UnitFrameTable) do
		if ( frame.addonName == dropdown.databaseName ) then
			-- Update positions:
			if ( frame.handlerList.frameMover ) then
				FrameMover:SetFramePosition(frame);
			end
		end
	end

	for header, value in pairs(ArenaHeader.HeaderTable) do
		if ( header.addonName == dropdown.databaseName ) then
			-- Update positions:
			if ( header.handlerList.frameMover ) then
				FrameMover:SetFramePosition(header);
			end
		end
	end	
	
	for header, value in pairs(PartyHeader.HeaderTable) do
		if ( header.addonName == dropdown.databaseName ) then
			-- Update positions:
			if ( header.handlerList.frameMover ) then
				FrameMover:SetFramePosition(header);
			end
		end
	end	
	
	-- Force a UI reload to apply all of the new settings to the interface:
	ReloadUI();
	
end

local info = {};
local function ProfileCopyDropDownInitFunc(self)

	-- Now create an info table:
	for key, settings in pairs(ArenaLiveCore.db[self.databaseName]) do
		if ( key ~= "saveByCharacter" and key ~= currentProfile ) then
			info.text = key;
			info.value = key;
			info.func = CopyProfile;
			info.arg1 = self;
			info.arg2 = key;
			
			UIDropDownMenu_AddButton(info);
		end
	end
end

function ProfileMenu:AddFrame(profileMenuFrame, parentOptionsPanelName, databaseName, copyDropDown, profileTitle, profileDescription, currentProfileText)

	-- First check if a database with the specified name exists:
	if (not ArenaLiveCore.db[databaseName] ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_ERROR_DATABASE_DOES_NOT_EXIST"), databaseName), "error");
		return;
	end
	
	-- Next check if the database is able to store profiles (by character name, maybe I'll introduce real profiles at another point):
	if (not ArenaLiveCore.db[databaseName]["saveByCharacter"] ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_ERROR_DATABASE_NOT_SAVED_BY_CHARACTER"), databaseName), "error");
		return;
	end
	
	-- Create sub options panel:
	profileMenuFrame.name = ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_PANEL_TITLE");
	profileMenuFrame.parent = parentOptionsPanelName;
	InterfaceOptions_AddCategory(profileMenuFrame);
	
	-- Create reference:
	profileMenuFrame.databaseName = databaseName;
	copyDropDown.databaseName = databaseName;
	
	-- Set Profile Title Text:
	if ( profileTitle ) then
		profileTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_TITLE"));
	end
	
	if ( profileDescription ) then
		profileDescription:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_DESCRIPTION"));
	end
	
	if ( currentProfileText ) then
		local text = ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_CURRENT_PROFILE");
		currentProfileText:SetText(text..currentProfile);
	end

	-- Set "copy from" dropdown text:
	local prefix = copyDropDown:GetName();
	local title = _G[prefix.."Title"];
	title:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PROFILES_COPY_FROM_DROPDOWN_TITLE"));
	
	-- Initialise the "copy from" dropdown using blizzard's standard functionset.
	UIDropDownMenu_Initialize(copyDropDown, function()
		ProfileCopyDropDownInitFunc(copyDropDown)
	end);	
end