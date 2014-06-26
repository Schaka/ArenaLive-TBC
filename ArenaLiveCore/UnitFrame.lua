--[[ ArenaLive Core Functions: UnitFrame Handler
Created by: Vadrak
Creation Date: 25.05.2013
Last Update: 06.07.2013
These functions are used to set up every standard unit frame. For grouped unit frames (party/raid/arena) see also GroupHeader.lua.
The UnitFrame handler will store all ArenaLive based unit frames inside a table, where every unit frame has a single index. These indexes will register the frames in two other
tables that store the information about the frame's unitID and GUID. This way, it will be very easy to distribute event informations only to those frames, that actually need them
without having to iterate over the frames every single time an event occurs.
]]--
local addonName = "ArenaLiveCore";
-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local UnitFrame = ArenaLiveCore:AddHandler("UnitFrame", "EventCore");
UnitFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
UnitFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
UnitFrame:RegisterEvent("PLAYER_FOCUS_CHANGED");
UnitFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
UnitFrame:RegisterEvent("UNIT_PET");
UnitFrame:RegisterEvent("UNIT_CONNECTION");
UnitFrame:RegisterEvent("UNIT_NAME_UPDATE");
UnitFrame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT");


-- Set up the 3 UnitFrame tables.
UnitFrame.UnitFrameTable = {};
UnitFrame.UnitIDTable = {};
UnitFrame.UnitGUIDTable = {};

-- This table will store unused tables, so that they can be reused, if a new unitID or GUID entry is created.
local TrashTableStorage = {};

-- Set up a table for frames that need a unitID update after CombatLockDown fades.
local framesToUpdate = {};


-- *** FRAME FUNCTIONS ***
--[[ Function: SetUnit
	 Sets the attribute "unit" for the frame to the specified unit, if not in combat lockdown.
	 Otherwise it will set a note to change the unit to the specified one after combat lockdown
	 fades.
	 Arguments:
		unit: The unitID that will be set for the frame.
]]--
local function SetUnit (self, unit)
	if ( not InCombatLockdown() ) then
		self.updateUnit = nil;	
		self:SetAttribute("unit", unit);
	else
		framesToUpdate[self.tableKey] = true;
		self.updateUnit = unit;
	end
end

--[[ Function: SetUnitID
	 Sets a new UnitID for a unit frame.
	 Arguments:
		unit: The unitID that will be set for the frame.
]]--
local function SetUnitID (self, unit)

	-- If the old unitID is the same as the new one, we don't need to update anything.
	if (self.unit and self.unit == unit ) then
		return;
	end	
	
	--[[ If a unitID was already defined, we need to reset it first,
		 otherwise the frame would be updated for the old and the new unitID events. ]]--
	if ( self.unit ) then
		UnitFrame:UnregisterUnitID(self.tableKey, self.unit);
		self.unit = nil;
	end	
	
	self.unit = unit;
	UnitFrame:RegisterUnitID(self.tableKey, unit);
	
end

--[[ Function: SetUnitGUID
	 Sets a new UnitGUID for a unit frame.
	 Arguments:
		unit: The unit's unitID to determine the new GUID for the frame.
]]--
local function SetUnitGUID (self, unit)
	
	local guid = UnitGUID(unit);
	
	-- If the old guid is the same as the new one, we don't need to update anything.
	if ( not UnitExists(unit) or self.guid == guid ) then
		return;
	end
	
	--[[ If a unitGUID was already defined, we need to reset it first,
		 otherwise the frame would be updated for the old and the new GUID events. ]]--
	if ( self.guid ) then
		UnitFrame:UnregisterUnitGUID(self.tableKey, self.guid);
		self.guid = nil;
	end
	
	if ( guid ) then
		self.guid = guid;	
		UnitFrame:RegisterUnitGUID(self.tableKey, guid);
	end
end

--[[ Function: ResetUnit
	 Resets all unit data for a unit frame.
]]--
local function ResetUnit (self)
	if ( not InCombatLockdown()) then
		self.updateUnit = nil;
		self:SetAttribute("unit", nil);
	else
		framesToUpdate[self.tableKey] = true;
		self.updateUnit = "reset";
	end
end

--[[ Function: ResetUnitID
	 Resets unitID for a unit frame.
]]--
local function ResetUnitID (self)
	UnitFrame:UnregisterUnitID (self.tableKey, self.unit);
	self.unit = nil;
end

--[[ Function: ResetUnitGUID
	 Resets unitGUID for a unit frame.
]]--
local function ResetUnitGUID (self)
	UnitFrame:UnregisterUnitGUID (self.tableKey, self.guid);
	self.guid = nil;
end

--[[ Function: Update
	Updates all frame parts of a unit frame.
]]--
local function Update (self)
	for handlerKey, value  in pairs(self.handlerList) do
		if ( self[handlerKey] and value and self[handlerKey].Update ) then
			self[handlerKey]:Update();
		end
	end
end

local function Reset (self)

	for handlerKey, value  in pairs(self.handlerList) do
		if ( self[handlerKey] and value and self[handlerKey].Reset ) then
			self[handlerKey]:Reset();
		end
	end

end

local function OnAttributeChanged (self, name, value)
	if ( name ~= "unit" ) then
		return;
	end
	
	-- Unit was reset, so call reset functions.
	if ( not value ) then
		self:ResetUnitID(self);
		self:ResetUnitGUID(self);
		self:Update();
		self:Hide()
		return;
	end
		
	local updateFrame;
	if ( not self.unit or value ~= self.unit ) then
		self:SetUnitID(value);
		updateFrame = true;
	end	

	if ( not self.guid or UnitGUID(value) ~= self.guid ) then
		self:SetUnitGUID(value);	
		updateFrame = true;
	end
	
	if ( updateFrame ) then
		self:Update();
	end
	
end

local function OnEnter (self)
	if ( self.unit and UnitExists(self.unit) ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
		GameTooltip:SetUnit(self.unit, self.hideStatusOnTooltip)
		local r, g, b = GameTooltip_UnitColor(self.unit);
		GameTooltipTextLeft1:SetTextColor(r, g, b);
		GameTooltip:Show();
	end
end

local function OnLeave (self)
	GameTooltip:FadeOut();
end

-- *** HANDLER FUNCTIONS ***
-- First I create a snippet string for the onAttributeChanged handling:
-- self, name, value
local onAttributeChangedSnippet = [[
 if ( name ~= "state-unitexists" and name ~= "alforceshow" and name ~= "alframelock" ) then
  return;
 end

 if ( self:GetAttribute("alforceshow") ) then
  self:Show();
 elseif (not self:GetAttribute("alframelock") ) then
  self:Show();
 elseif ( self:GetAttribute("state-unitexists") ) then
  self:Show();
 else
  self:Hide();
 end
]];
--[[ Function: AddFrame
	 Sets up a unit frame to contain all relevant unitFrame functions and adds it to the general unitFrame table.
	 It then is able to register itself for a particular unitID and GUID. It's children will be updated every
	 time a handler receives an event with either the unitFrame's GUID or UnitID.
	 
	 Arguments:
		frame: The frame that needs to be registered.
		addon: Name of the addon the frame belongs to. (used for getting and setting SavedVariables)
		frameType: Name of the frameType the frame belongs to. (used for getting and setting SavedVariables)
		onRightClick: The function that should be called when right clicking the frame. This can either be a string containing a action/unit button command for *type2
					(e.g. "togglemenu"; "focus")or a function for showing an individual menu.
		forceShow: If true, the frame will always be visible. Regardless of the existence or visibility of its later defined unit.
		hasHeader: States wether the unit frame is part of a group header or not. If not, then it needs to check it's hidden/shown status itself.
					Therefore it is registered as a Secure State Handler gets the onAttributeChangedSnippet from above as a code snippet. as a state handler
	 Sets frame data:
		frame.tableKey: The index the chosen frame has inside the general unitframe table. This will be used to reference it
		inside the unitID and GUID tables.
]]--
function UnitFrame:AddFrame (frame, addon, frameType, rightClick, forceShow, hasHeader)
	
	if ( not frame ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addon, "ERR_ADD_UNITFRAME_NOT_GIVEN"), "error");
		return;
	end
	
	local rightClickType = type(rightClick);
	
	if ( not InCombatLockdown() ) then
		frame.addonName = addon;
		frame.frameType = frameType;
		
		frame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		
		frame:SetAttribute("*type1", "target");
		
		frame:SetAttribute("*type2", "menu");
		frame:SetAttribute("alforceshow", forceShow);
		
		table.insert(UnitFrame.UnitFrameTable, frame);
		frame.tableKey = #UnitFrame.UnitFrameTable;
	else
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_UNITFRAME_COMBATLOCKDOWN"), "error");
	end	
	
	--[[ Create a list, where all handlers can add themselves into, so that we know which frame parts the unit frame consists of.
		 We will need this, when we want to update all frame parts at once. ]]--
	frame.handlerList = {};
	
	-- Set the frame up with unit handling functions
	frame.SetUnit = SetUnit;
	frame.SetUnitID = SetUnitID;
	frame.SetUnitGUID = SetUnitGUID;
	frame.ResetUnit = ResetUnit;
	frame.ResetUnitID = ResetUnitID;
	frame.ResetUnitGUID = ResetUnitGUID;
	frame.Update = Update;
	frame.Reset = Reset;
	frame.OnAttributeChanged = OnAttributeChanged;
	frame.OnEnter = OnEnter;
	frame.OnLeave = OnLeave;
	
	frame:SetScript("OnAttributeChanged", frame.OnAttributeChanged);
	frame:SetScript("OnEnter", frame.OnEnter);
	frame:SetScript("OnLeave", frame.OnLeave);
	
	
	local showmenu = function()
		local u = frame:GetAttribute("unit")
		if u == "player" then
			ToggleDropDownMenu(1, nil, PlayerFrameDropDown, frame, 60, 10);
		elseif u == "target" then
			ToggleDropDownMenu(1, nil, TargetFrameDropDown, frame, 60, 10);
		elseif u == "party1" then
			ToggleDropDownMenu(1, nil, PartyMemberFrame1DropDown, frame, 60, 10);
		elseif u == "party2" then
			ToggleDropDownMenu(1, nil, PartyMemberFrame2DropDown, frame, 60, 10);
		elseif u == "party3" then
			ToggleDropDownMenu(1, nil, PartyMemberFrame3DropDown, frame, 60, 10);
		elseif u == "party4" then
			ToggleDropDownMenu(1, nil, PartyMemberFrame4DropDown, frame, 60, 10);		
		end
	end
	
	-- Set up a secure OnAttributeChanged function and RegisterUnitWatch with asState = true. This way I can decide myself if the frame should be shown or not.
	SecureUnitButton_OnLoad(frame, frame:GetAttribute("unit"), showmenu);
	RegisterUnitWatch(frame, false);
	
	-- Add ClickCast functionality.
	UnitFrame:RegisterClickCast(frame);
end

function UnitFrame:RemoveFrame (frame)
	
	if ( not frame ) then
		return;
	end
	
	if ( not InCombatLockdown() ) then
		frame.addonName = nil;
		frame.frameType = nil;

		frame:SetAttribute("*type1", nil);
		frame:SetAttribute("*type2", nil);
		frame.menu = nil;

		
		frame:SetAttribute("forceShow", nil);
		
		-- Remove the frame from our general unit frame table.
		table.remove(UnitFrame.UnitFrameTable, frame.tableKey);
		
		-- Rest unit and guid for this frame
		if ( frame.unit or frame.guid ) then
			frame:ResetUnit();
		end
		
		-- Adjust frameKeys and unitID/GUID entries for all frames that have another frameKey due to table.remove.
		for key, unitFrame in ipairs(UnitFrame.UnitFrameTable) do
			if ( unitFrame.tableKey ~= key ) then
				local oldKey = unitFrame.tableKey;
				unitFrame.tableKey = key;
				
				-- Adjust entries in the UnitID table.
				if ( unitFrame.unit ) then
					UnitFrame:UnregisterUnitID(oldKey, unitFrame.unit);
					UnitFrame:RegisterUnitID(unitFrame.tableKey, unitFrame.unit);
				end
				
				-- Adjust entries in the UnitGUID table.
				if ( unitFrame.guid ) then
					UnitFrame:UnregisterUnitGUID (oldKey, unitFrame.guid);
					UnitFrame:RegisterUnitGUID(unitFrame.tableKey, unitFrame.guid);
				end
				
			end
		end
		
		-- Reset the registered handlers for this frame.
		for handlerKey, value  in pairs(frame.handlerList) do
			if ( frame[handlerKey] and value ) then
				frame[handlerKey]:RemoveFrame();
			end
		end
		table.wipe(frame.handlerList);
		
		frame.tableKey = nil;
	else
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_REMOVE_UNITFRAME_COMBATLOCKDOWN"), "error");
	end	
	
end

--[[ Function: RegisterUnitID
	 Registers the frame to the specified unitID, so that other handlers will alter its children based on events that fire for the specified unit.
	 Arguments:
		frame: The frame that needs to be registered.
		unit: The UnitID that the frame will be registerd to.
]]--
function UnitFrame:RegisterUnitID (key, unit)
	
	local numTrashTables = #TrashTableStorage or 0;
	
	if (not UnitFrame.UnitIDTable[unit] ) then
		-- We must create a new entry, If the frame's unit currently isn't stored in the unitID frame.
		if ( numTrashTables > 0 ) then
			-- If there are unused tables left, we can use one of them.
			UnitFrame.UnitIDTable[unit] = TrashTableStorage[1];
			-- Remove the table from the table storage.
			table.remove(TrashTableStorage, 1);
		else
			UnitFrame.UnitIDTable[unit] = {};
		end
	end
	
	UnitFrame.UnitIDTable[unit][key] = true;
	UnitFrame.UnitIDTable[unit]["n"] = (UnitFrame.UnitIDTable[unit]["n"] or 0) + 1;
end

--[[ Function: RegisterUnitGUID
	 Registers the frame to the specified UnitGUID, so that other handlers will alter its children based on events that fire for the specified UnitGUID.
	 Arguments:
		frame: The frame that needs to be registered.
		guid: The UnitGUID that the frame will be registerd to.
]]--
function UnitFrame:RegisterUnitGUID (key, guid)

	local numTrashTables = #TrashTableStorage or 0;
	
	if (not UnitFrame.UnitGUIDTable[guid] ) then
		-- We must create a new entry, if the frame's unit currently isn't stored in the unitID frame.
		if ( numTrashTables > 0 ) then
			-- If there are unused tables left, we can use one of them.
			UnitFrame.UnitGUIDTable[guid] = TrashTableStorage[1];
			-- Remove the table from the table storage.
			
			table.remove(TrashTableStorage, 1);
		else
			
			UnitFrame.UnitGUIDTable[guid] = {};
		end
	end
	
	UnitFrame.UnitGUIDTable[guid][key] = true;
	UnitFrame.UnitGUIDTable[guid]["n"] = (UnitFrame.UnitGUIDTable[guid]["n"] or 0) + 1;
end

--[[ Function: UnregisterUnitID
	 Unregisters the frame from the specified UnitID.
	 Arguments:
		frame: The frame that will be unregistered.
		unit: The UnitID the frame was registerd to.
]]--
function UnitFrame:UnregisterUnitID (key, unit)

	if ( not unit ) then
		return;
	end
	
	-- Safety check if the frame isn't registered for the specified unit.
	if ( not UnitFrame.UnitIDTable[unit] or not UnitFrame.UnitIDTable[unit][key] ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_REMOVE_UNITFRAME_UNITID_NOT_REGISTERED"), "error");
		return;
	end
	
	UnitFrame.UnitIDTable[unit]["n"] = UnitFrame.UnitIDTable[unit]["n"] - 1;
	
	if ( UnitFrame.UnitIDTable[unit]["n"] < 1 ) then
		-- If the GUID is empty, we store the table in the TrashTableStorage for later use.
		
		-- First reset the table completely
		table.wipe(UnitFrame.UnitIDTable[unit]);
		
		table.insert(TrashTableStorage, UnitFrame.UnitIDTable[unit]);
		UnitFrame.UnitIDTable[unit] = nil;
	else
		UnitFrame.UnitIDTable[unit][key] = nil;
	end
	
end

--[[ Function: UnregisterUnitGUID
	 Unregisters the frame from the specified UnitGUID.
	 Arguments:
		frame: The frame that will be unregistered.
		guid: The UnitGUID the frame was registerd to.
]]--
function UnitFrame:UnregisterUnitGUID (key, guid)

	if ( not guid ) then
		return;
	end
	
	-- Safety check if the frame isn't registered for the specified guid.
	if ( not UnitFrame.UnitGUIDTable[guid] or not UnitFrame.UnitGUIDTable[guid][key] ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_REMOVE_UNITFRAME_GUID_NOT_REGISTERED"), "debug");
		return;
	end
	
	UnitFrame.UnitGUIDTable[guid]["n"] = UnitFrame.UnitGUIDTable[guid]["n"] - 1;
	
	if ( UnitFrame.UnitGUIDTable[guid]["n"] < 1 ) then
		-- If the GUID is empty, we store the table in the TrashTableStorage for later use.
		
		-- First reset the table completely
		table.wipe(UnitFrame.UnitGUIDTable[guid]);
		
		table.insert(TrashTableStorage, UnitFrame.UnitGUIDTable[guid]);
		UnitFrame.UnitGUIDTable[guid] = nil;
	else
		UnitFrame.UnitGUIDTable[guid][key] = nil;
	end
	
end

--[[ Function: RegisterClickCast
	 Registers the frame for click cast addons like clique.
	 Arguments:
		frame: The frame that will be registered.
]]--
function UnitFrame:RegisterClickCast(frame)

	-- If the addon is loaded before the click cast addon set up the table for these addon's first.
	if ( not ClickCastFrames ) then
		ClickCastFrames = {};
	end
	
	ClickCastFrames[frame] = true;

end

--[[ Function: RegisterClickCast
	 Unregisters the frame for click cast addons like clique.
	 Arguments:
		frame: The frame that will be unregistered.
]]--
function UnitFrame:UnregisterClickCast(frame)

	if ( ClickCastFrames ) then
		ClickCastFrames[frame] = nil;
	end

end

--[[ Function: OnEvent
	 Handles the OnEvent functions for this handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
function UnitFrame:OnEvent(event, ...)

	if ( event == "PLAYER_REGEN_ENABLED" ) then
	
		for key, value in pairs(framesToUpdate) do
			local frame = UnitFrame.UnitFrameTable[key];
			
			if (value and frame and frame.updateUnit ) then
				if ( frame.updateUnit == "reset" ) then
					frame:ResetUnit();
				else
					frame:SetUnit(frame.updateUnit);
				end
			end
			
			framesToUpdate[key] = nil;
		end
		
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		local unit = "target";
		if ( UnitExists(unit) and UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				local frame = UnitFrame.UnitFrameTable[key];
					
				if ( value and frame ) then
					frame:SetUnitGUID(unit);
					frame:Update();
				end
			end
		end
	elseif ( event == "PLAYER_FOCUS_CHANGED" ) then
		local unit = "focus";
		if ( UnitExists(unit) and UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				local frame = UnitFrame.UnitFrameTable[key];
					
				if ( value and frame ) then
					frame:SetUnitGUID(unit);
					frame:Update();
				end
			end
		end
	elseif ( event == "UNIT_PET" ) then
		
		local unit = ...;
		
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		local unitNumber = tonumber(string.match(unit, "^[a-z]+([0-9]+)$"));		
		
		if ( unitType == "player" ) then
			unit = "pet";
		elseif ( unitNumber ) then
			unit = unitType.."pet"..unitNumber;
		else
			unit = unit.."pet";
		end

		if ( UnitExists(unit) and UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				local frame = UnitFrame.UnitFrameTable[key];
					
				if ( value and frame ) then
					frame:SetUnitGUID(unit);
					frame:Update();
				end
			end
		end
	elseif ( event == "UNIT_CONNECTION" ) then
		local unit = select(1, ...);
		if ( UnitExists(unit) and UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				local frame = UnitFrame.UnitFrameTable[key];
					
				if ( value and frame ) then
					frame:SetUnitGUID(unit);
					frame:Update();
				end
			end
		end
	elseif ( event == "UNIT_NAME_UPDATE" ) then
		local unit = select(1, ...);
		if ( UnitExists(unit) and UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				local frame = UnitFrame.UnitFrameTable[key];
					
				if ( value and frame ) then
					frame:SetUnitGUID(unit);
					frame:Update();
				end
			end
		end
	elseif ( event == "PARTY_MEMBERS_CHANGED" ) then
		for i=1,4 do
			local unit = "party"..i;
			if ( UnitExists(unit) and UnitFrame.UnitIDTable[unit] ) then
				for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
					local frame = UnitFrame.UnitFrameTable[key];
						
					if ( value and frame ) then
						frame:SetUnitGUID(unit);
						frame:Update();
					end
				end
			end	
		end
	end
end