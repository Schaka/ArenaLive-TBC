--[[ ArenaLive Core Functions: Icon Handler
Created by: Vadrak
Creation Date: 09.06.2013
Last Update: "
This file contains all relevant functions for ArenaLive's icon system.
]]--
local addonName = "ArenaLiveCore";
-- Table of Texture coordinates for the race/gender icons.
local RACE_GENDER_ICON_TCOORDS =
	{
		["Human"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0, 0.125, 0, 0.25},
				[3] = {0, 0.125, 0.50391, 0.75},
			},
		["Dwarf"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.125, 0.25, 0, 0.25},
				[3] = {0.125, 0.25, 0.50391, 0.75},
			},
		["NightElf"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.37695, 0.5, 0, 0.25},
				[3] = {0.37695, 0.5, 0.50391, 0.75},
			},
		["Gnome"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.25195, 0.375, 0, 0.25},
				[3] = {0.25195, 0.375, 0.50391, 0.75},
			},
		["Draenei"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.50195, 0.625, 0, 0.25},
				[3] = {0.50195, 0.625, 0.50391, 0.75},
			},
		["Worgen"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.62891, 0.75391, 0, 0.25},
				[3] = {0.62891, 0.75391, 0.50391, 0.75},
			},
		["Orc"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.37695, 0.5, 0.2539, 0.50},
				[3] = {0.37695, 0.5, 0.75391, 1},
			},
		["Scourge"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.126953125, 0.25, 0.2539, 0.50},
				[3] = {0.126953125, 0.25, 0.75391, 1},
			},
		["Tauren"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0, 0.125, 0.2539, 0.50},
				[3] = {0, 0.125, 0.75391, 1},
			},
		["Troll"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.25195, 0.375, 0.2539, 0.50},
				[3] = {0.25195, 0.375, 0.75391, 1},
			},
		["BloodElf"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.50195, 0.625, 0.2539, 0.50},
				[3] = {0.50195, 0.625, 0.75391, 1},
			},
		["Goblin"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.62891, 0.75391, 0.2539, 0.50},
				[3] = {0.62891, 0.75391, 0.75391, 1},
			},
		["Pandaren"] =
			{
				[1] = {0, 0.25, 0.50, 0.75},
				[2] = {0.75586, 0.88086, 0, 0.25},
				[3] = {0.75586, 0.88086, 0.50391, 0.75},
			},
	};

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local Icon = ArenaLiveCore:AddHandler("Icon", "EventCore");

-- Get the global UnitFrame and Cooldown handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local Cooldown = ArenaLiveCore:GetHandler("Cooldown");

-- Register the handler for all needed events.
Icon:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
Icon:RegisterEvent("UNIT_FACTION");
Icon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
Icon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL");

-- Set up a table that stores the number of icons a unit frame has.
local numIcons = {};

-- Set up 3 tables to store all cooldown related information.
local trinketCooldownStorage = {};
local racialCooldownStorage= {};
local interruptOrDispelCooldownStorage = {};

-- *** FRAME FUNCTIONS ***
--[[ Function: Update
	 Sets up a statusbar to be the healthbar of a unit frame.
	 Arguments:
		self: The icon.
		setTexture: Sets wether the texture needs an update or not.
]]--
local function Update (self)
	
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end	
	
	local iconType = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/Icon"..self.iconNumber.."/Type");
	
	if ( iconType == "class" ) then
		self:UpdateTexture();
		return;
	elseif ( iconType == "race" ) then
		self:UpdateTexture();
		return;
	elseif ( iconType == "specialisation" ) then
		self:UpdateTexture();
		return;
	elseif ( iconType == "reaction" ) then
		self:UpdateTexture();
		return;
	end

	local guid = self.unitFrame.guid;

	if ( not guid ) then
		return;
	end		
	
	local theTime = GetTime();
	local _, class = UnitClass(unit);
	local _, race = UnitRace(unit);
	local _, faction = UnitFactionGroup(unit);
	local isPlayer = UnitIsPlayer(unit);
	local startTime, duration;
	
	if ( not onlyCooldown ) then
		--[[ This is a work around. When the general unit frame function calls the update function,
			 it does so without any arguments given. If the unit frame function calls this update function
			 we always have to update the texture, because the player's target changed or a group member was updated etc. 
			 The event based updates are all cooldown related, so it is not needed to update the texture if they fire. 
			 This should improve performance.]]--
			 self:UpdateTexture();
	end
	
	-- Set cooldowns if there is one.
	if ( iconType == "trinket" and trinketCooldownStorage[guid] ) then
		
		-- Check if the cooldown hasn't run out already.
		if ( trinketCooldownStorage[guid] > theTime ) then
			duration = 120;
			startTime = trinketCooldownStorage[guid] - duration;
			self.cooldown:Set(startTime, duration);
		else
			self.cooldown:Reset();
		end
		
	elseif ( iconType == "racial" and racialCooldownStorage[guid] ) then
		-- Check if the cooldown hasn't run out already, but only if we have a race.
		if ( not race ) then
			self.cooldown:Reset();
		elseif ( racialCooldownStorage[guid] > theTime ) then
			if ( ArenaLiveCore.spellDB["racials"][race][class] ) then
				duration = ArenaLiveCore.spellDB["racials"][race][class][2]
				startTime = racialCooldownStorage[guid] - duration;
			else
				duration = ArenaLiveCore.spellDB["racials"][race][2]
				startTime = racialCooldownStorage[guid] - duration;
			end
			
			self.cooldown:Set(startTime, duration);
		else
			self.cooldown:Reset();
		end
		
	elseif ( iconType == "interruptOrDispel" and interruptOrDispelCooldownStorage[guid] ) then
		
		-- Check if the cooldown hasn't run out already, but only if we have a class.
		if ( not class ) then
			self.cooldown:Reset();
		elseif ( interruptOrDispelCooldownStorage[guid] > theTime ) then
			local varType = type(ArenaLiveCore.spellDB["dispelsOrInterrupts"][class][1]);
			
			if ( varType == "number" ) then
				duration = ArenaLiveCore.spellDB["dispelsOrInterrupts"][class][2];
				startTime = interruptOrDispelCooldownStorage[guid] - duration;		
			elseif ( varType == "table" ) then
				-- Warlocks have more than 1 spellID for their interrupt.
				-- TODO: Need to change the system somehow to be more flexible.
				duration = ArenaLiveCore.spellDB["dispelsOrInterrupts"][class][1][2];
				startTime = interruptOrDispelCooldownStorage[guid] - duration;
			end
			
			self.cooldown:Set(startTime, duration);
		else
			self.cooldown:Reset();
		end
	else
		-- Reset the cooldown if nothing of the above applies.
		self.cooldown:Reset();
	end

end

local function UpdateTexture(self)
	
	local unit = self.unitFrame.unit;
	local _, class = UnitClass(unit);
	local _, race = UnitRace(unit);
	local faction = UnitFactionGroup(unit);
	local isPlayer = UnitIsPlayer(unit);
	local gender = UnitSex(unit);
	local spellID;
	local startTime, duration;
	local texture = "Interface\\Icons\\INV_Misc_QuestionMark";
	local iconType = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/Icon"..self.iconNumber.."/Type");
	self.texture:SetTexCoord(0, 1, 0, 1);
	
	if ( iconType == "race" and isPlayer and race and gender ) then
		
		if ( gender > 1 ) then
			texture = "Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES";
			self.texture:SetTexCoord(unpack(RACE_GENDER_ICON_TCOORDS[race][gender]));
		end
		
	elseif ( iconType == "class" and class ) then
		
		if ( class ) then
			texture = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes";
			self.texture:SetTexCoord(unpack(CLASS_BUTTONS[class]));
		end
		
	elseif ( iconType == "trinket" and isPlayer and faction ) then
		
		if ( faction == "Alliance" ) then
			texture = "Interface\\ICONS\\INV_Jewelry_TrinketPVP_01";
		else
			texture = "Interface\\ICONS\\INV_Jewelry_TrinketPVP_02";
		end
		
		self.texture:SetTexCoord(0, 1, 0, 1);
		
	elseif ( iconType == "racial" and isPlayer and race and class ) then
		
		if ( ArenaLiveCore.spellDB["racials"][race][class] ) then
			spellID = ArenaLiveCore.spellDB["racials"][race][class][1];
		else
			spellID = ArenaLiveCore.spellDB["racials"][race][1];
		end

		local _, _, icon = GetSpellInfo(spellID);
	
		if ( icon ) then
			texture = icon;
			self.texture:SetTexCoord(0, 1, 0, 1);
		end
		
	elseif ( iconType == "specialisation" ) then
		-- have to think of something here for later when implementing arenaframes
		
	elseif ( iconType == "interruptOrDispel" and isPlayer and class ) then
		local varType = type(ArenaLiveCore.spellDB["dispelsOrInterrupts"][class][1]);
		if ( varType == "table") then
			spellID = ArenaLiveCore.spellDB["dispelsOrInterrupts"][class][1][1];
		elseif ( varType == "number") then
			spellID = ArenaLiveCore.spellDB["dispelsOrInterrupts"][class][1];
		end
		
		local _, _, icon = GetSpellInfo(spellID);
	
		if ( icon ) then
			texture = icon;
			self.texture:SetTexCoord(0, 1, 0, 1);
		end
		
	elseif ( iconType == "reaction" ) then
		
		local red, green, blue = UnitSelectionColor(unit);

		if ( not UnitPlayerControlled(unit) and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit) ) then
			self.texture:SetTexture(0.5, 0.5, 0.5, 1);
		else
			self.texture:SetTexture(red, green, blue, 1);
		end
		
		self.texture:SetTexCoord(0, 1, 0, 1);
		return;
		
	end

	self.texture:SetTexture(texture);
end

local function Reset(self)
	self.cooldown:Reset();
	self.texture:SetTexCoord(0, 1, 0, 1);
	self.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
end

-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up an icon of a unit frame.
	 Arguments:
		icon: The icon that will be registered.
		texture: The icon's texture to set the background image.
		cooldown: The icon's cooldown frame.
		cooldownText: The icon's cooldown timer text.
		unitFrame: The unit frame the icon belongs to.
]]--
function Icon:AddFrame (icon, texture, cooldown, cooldownText, unitFrame)

	-- Get the current number of icons the unitFrame has and add 1.
	local iconNumber = (numIcons[unitFrame] or 0) + 1;
	
	-- Create a reference for the icon inside the unit frame and vice versa.
	unitFrame["icon"..iconNumber] = icon;
	icon.unitFrame = unitFrame;
	
	-- Register the icon in the unit frame's handler list.
	unitFrame.handlerList["icon"..iconNumber] = true;
	
	icon.texture = texture;
	icon.iconNumber = iconNumber;
	Cooldown:AddFrame(cooldown, cooldownText, icon);
	icon.Update = Update;
	icon.UpdateTexture = UpdateTexture;
	icon.Reset = Reset;
	
	numIcons[unitFrame] = iconNumber;
end

--[[ Function: GetSpellMatch
	 This function compares a list of spells in ArenaLive's spellDB with the specified spellID.
	 If the spellID matches one in the DB it will return the match type. This is mainly to keep
	 the OnEvent function a bit tidier.
	 Arguments:
		event: The event that fired.
		spellID: ID of the spell for which the event fired.
	 Returns:
		match: The match type that was found.
		spellCD: The spell's cooldown.
		sharedCD: The cooldown the spell shared with another one (trinket <-> racial).
]]--
function Icon:GetSpellMatch(event, spellID, race, class)
	local match, spellCD, sharedCD, varType;
	
	if ( event == "UNIT_SPELLCAST_SUCCEEDED" and race and class ) then
		-- Fix: Since 5.4 it is possible that NPCs are partyX or raidX unitIDs due to proving grounds. Since these don't have a race we need to ignore them.
		if ( spellID == ArenaLiveCore.spellDB.trinket ) then
			match = "trinket"
			spellCD = 120;
			
			-- Racial shared CD
			if ( ArenaLiveCore.spellDB["racials"][race][class] ) then
				sharedCD = ArenaLiveCore.spellDB["racials"][race][class][3];
			else
				sharedCD = ArenaLiveCore.spellDB["racials"][race][3];
			end
			
		elseif ( ArenaLiveCore.spellDB["racials"][race][class] and spellID == ArenaLiveCore.spellDB["racials"][race][class][1] ) then
			
			match = "racial";
			spellCD = ArenaLiveCore.spellDB["racials"][race][class][2];
			
			-- trinket shared CD
			sharedCD = ArenaLiveCore.spellDB["racials"][race][class][3];
			
		elseif ( ArenaLiveCore.spellDB["racials"][race][1] and spellID == ArenaLiveCore.spellDB["racials"][race][1] ) then
			match = "racial"
			spellCD = ArenaLiveCore.spellDB["racials"][race][2];
			
			-- trinket shared CD
			sharedCD = ArenaLiveCore.spellDB["racials"][race][3];
		else
			-- Warlocks have more than one spell ID for their interrupt...
			varType = type(ArenaLiveCore.spellDB.dispelsOrInterrupts[class][1]);
			
			if ( varType == "number" ) then
				if ( not ArenaLiveCore.spellDB.dispelsOrInterrupts[class][3] and spellID == ArenaLiveCore.spellDB.dispelsOrInterrupts[class][1] ) then
					match = "interruptOrDispel";
					spellCD = ArenaLiveCore.spellDB.dispelsOrInterrupts[class][2]
				end
			elseif ( varType == "table" ) then
				for numEntry, entryTable in pairs(ArenaLiveCore.spellDB.dispelsOrInterrupts[class] ) do
					if ( not entryTable[3] and spellID == entryTable[1] ) then
						match = "interruptOrDispel";
						spellCD = entryTable[2];
						break;
					end
				end
			end			
		end		
	
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL" ) then
		
		for classFilename, classTable in pairs(ArenaLiveCore.spellDB.dispelsOrInterrupts ) do
			-- Warlocks have more than one spell ID for their interrupt...
			varType = type(classTable[1]);
			
			if (varType == "number") then
				if ( classTable[3] and spellID == classTable[1] ) then
					match = "interruptOrDispel";
					spellCD = classTable[2];
					break;
				end
			elseif (varType == "table" ) then
				for key, value in ipairs(classTable[1]) do
					if ( classTable[key][3] and spellID == classTable[key][1] ) then
						match = "interruptOrDispel";
						spellCD = classTable[2];
						break;
					end
				end
			end
		end		
	
	end
	
	return match, spellCD, sharedCD;
end

--[[ Function: OnEvent
	 OnEvent function for the Icon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame, affectedCDTable, affectedSharedTable;
function Icon:OnEvent (event, ...)
	local unit, guid, race, match, class, spellID, spellCD, sharedCD, isPlayer, _;
	
	-- *** SIMPLE ICON HANDLING ***
	if ( event == "PLAYER_SPECIALIZATION_CHANGED" ) then
		local unit = ...;
		
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					if ( numIcons[affectedFrame] and numIcons[affectedFrame] > 0 ) then
						for i = 1, numIcons[affectedFrame] do
							local iconType = ArenaLiveCore:GetDBEntry(affectedFrame.addonName, affectedFrame.frameType.."/Icon"..i.."/Type");
							if ( iconType == "specialisation" ) then
								affectedFrame["icon"..i]:Update();
							end
						end
					end
				end
			end
		end
		
	elseif ( event == "UNIT_FACTION" ) then
		unit = ...;
		
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					if ( numIcons[affectedFrame] and numIcons[affectedFrame] > 0 ) then
						for i = 1, numIcons[affectedFrame] do
							local iconType = ArenaLiveCore:GetDBEntry(affectedFrame.addonName, affectedFrame.frameType.."/Icon"..i.."/Type");
							if ( iconType == "reaction" ) then
								affectedFrame["icon"..i]:Update();
							end
						end
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
	
		unit = ...;
		_, race = UnitRace(unit);
		_, class = UnitClass(unit);
		isPlayer = UnitIsPlayer(unit);
		spellID = select(5, ...);	
		
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL" ) then
		guid = select(4, ...);
		spellID = select(15, ...);
		match = true;
	end
	
	
	-- *** COOLDOWN HANDLING ***
	-- Check if there is a matching spell in our spell database.
	if ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL" or (event == "UNIT_SPELLCAST_SUCCEEDED" and isPlayer ) ) then
		match, spellCD, sharedCD = Icon:GetSpellMatch(event, spellID, race, class);
	end
	
	if ( not match ) then
		return;
	end
	
	-- There is a match. Now update the tables accordingly.
	if ( match == "trinket" or match == "racial" ) then
		guid = UnitGUID(unit);
		
		if ( match == "trinket" ) then
			affectedCDTable = trinketCooldownStorage;
			affectedSharedTable = racialCooldownStorage;
			
			-- Clear the affected table of all unnecessary entries to save memory.
			for affectedGuid, expirationTime in pairs(affectedCDTable) do
				if ( expirationTime < GetTime() ) then
					affectedCDTable[affectedGuid] = nil;
				end
			end
		else
			affectedCDTable = racialCooldownStorage;
			affectedSharedTable = trinketCooldownStorage;
		end
		
		affectedCDTable[guid]= GetTime() + spellCD;
		
		local sharedMatch;
		if ( sharedCD > 0 ) then
			if ( affectedSharedTable[guid] ) then
				-- Only update the shared CD if it is larger than the spells current CD.
				if ( affectedSharedTable[guid] < (GetTime() + sharedCD) ) then
					affectedSharedTable[guid] = GetTime() + sharedCD;		
				end
			else
				affectedSharedTable[guid] = GetTime() + sharedCD;
			end
			
			if (  match == "trinket" ) then
				sharedMatch = "racial"
			else
				sharedMatch = "trinket";
			end
		end

		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					if ( numIcons[affectedFrame] and numIcons[affectedFrame] > 0 ) then
						for i = 1, numIcons[affectedFrame] do
							local iconType = ArenaLiveCore:GetDBEntry(affectedFrame.addonName, affectedFrame.frameType.."/Icon"..i.."/Type");
							if ( iconType == match or iconType == sharedMatch  ) then
								affectedFrame["icon"..i]:Update(true);
							end
						end
					end
				end
			end
		end
		
	elseif ( match == "interruptOrDispel" ) then
		if ( not guid ) then
			guid = UnitGUID(unit);
		end
		-- Clear the interrupt and dispel table of all unnecessary entries to save memory.
		for guid, expirationTime in pairs(trinketCooldownStorage) do
			if ( expirationTime < GetTime() ) then
				interruptOrDispelCooldownStorage[guid] = nil;
			end
		end
				
		interruptOrDispelCooldownStorage[guid] = GetTime() + spellCD;
		
		
		if ( UnitFrame.UnitGUIDTable[guid] ) then
			for key, value in pairs(UnitFrame.UnitGUIDTable[guid]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					if ( numIcons[affectedFrame] and numIcons[affectedFrame] > 0 ) then
						for i = 1, numIcons[affectedFrame] do
							local iconType = ArenaLiveCore:GetDBEntry(affectedFrame.addonName, affectedFrame.frameType.."/Icon"..i.."/Type");
							if ( iconType == match ) then
								affectedFrame["icon"..i]:Update(true);
							end
						end
					end
				end
			end
		end		
	end

end