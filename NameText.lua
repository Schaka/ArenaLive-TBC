--[[ ArenaLive Core Functions: Name Text Handler
Created by: Vadrak
Creation Date: 09.06.2013
Last Update: "
This file contains all relevant functions for name font strings and name aliases.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local NameText = ArenaLiveCore:AddHandler("NameText", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
NameText:RegisterEvent("UNIT_NAME_UPDATE");
NameText:RegisterEvent("UNIT_FACTION");
NameText:RegisterEvent("PLAYER_FLAGS_CHANGED");

-- Create a local table for name aliases
NameText.displayedNames = {};


-- *** FRAME FUNCTIONS ***
--[[ Function: Update
	 Updates the name fontstring of a unit frame.
	 Arguments:
		self: The name font string.
]]--
local function Update (self)
	
	local unit = self.unitFrame.unit;
	local name;
	local tag;
	
	if ( not unit ) then
		self:Reset();
		return;
	else
		name = GetUnitName(unit);
	end
	
	local nameAlias = NameText:GetNameAlias(unit);
	
	-- Check if unit is AFK or DND (Cool suggestion by Nick lul).
	if ( UnitIsAFK(unit) ) then
		tag = ArenaLiveCore:GetLocalisation(addonName, "<AFK>");
		name = tag..name
		if ( nameAlias )  then
			nameAlias = tag..nameAlias;
		end
	elseif ( UnitIsDND(unit) ) then
		tag = ArenaLiveCore:GetLocalisation(addonName, "<DND>");
		name = tag..name
		if ( nameAlias )  then
			nameAlias = tag..nameAlias;
		end
	end
	
	self:SetColour();
	
	if ( nameAlias ) then
		self:SetText(nameAlias);
	else
		self:SetText(name);
	end

end

--[[ Function: SetUnit
	 Sets the colour of a unit frame's name fontstring.
	 Arguments:
		self: The name font string.
]]--
local function SetColour (self)
	
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end
	
	local colourMode = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/NameText/ColourMode");
	local isPlayer = UnitIsPlayer(unit);
	local red, green, blue = 1, 1, 1;
	
	if ( colourMode == "class" and isPlayer ) then
		local _, class = UnitClass(unit);
		
		if ( class ) then
			red, green, blue = RAID_CLASS_COLORS[class]["r"], RAID_CLASS_COLORS[class]["g"], RAID_CLASS_COLORS[class]["b"];
		end	
	
	elseif ( colourMode == "reaction" or not isPlayer ) then
		
		local reaction = UnitReaction(unit, "player");
		if ( reaction ) then
			red = UnitReactionColor[reaction].r;
			green = UnitReactionColor[reaction].g;
			blue = UnitReactionColor[reaction].b;
		else
			red = 1
			green = 1
			blue = 1
		end
		
		-- If the unit is a NPC that was tapped by another person, I reflect that in the name colour by colouring it grey.
		if ( not UnitPlayerControlled(unit) and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) ) then
			red = 0.5;
			green = 0.5;
			blue = 0.5;
		else
			-- Blue names are very hard to read, so switch to plain white. math.ceil for blue because the colour isn't exactly 1, but 0,999... 
			if ( red == 0 and green == 0 and math.ceil(blue) == 1 ) then
				red = 1;
				green = 1;
				blue = 1;
			end
			
		end
	end
	
	self:SetTextColor(red, green, blue);

end

--[[ Function: Reset
	 Resets the shown name of a unit frame's name fontstring.
	 Arguments:
		self: The name font string.
]]--
local function Reset (self)
	self:SetText();
end

-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a font string to show the name of a unit frame.
	 Arguments:
		nameFontString: The fontstring that will be registered as the name text.
		unitFrame: the unit frame the fontstring belongs to.
]]--
function NameText:AddFrame (nameFontString, unitFrame)

	-- Create a reference for the healthbar inside the unit frame and vice versa.
	unitFrame.nameText = nameFontString;
	nameFontString.unitFrame = unitFrame;
	
	-- Register the healthbar in the unit frame's handler list.
	unitFrame.handlerList.nameText = true;
	
	nameFontString.SetColour = SetColour;
	nameFontString.Update = Update;
	nameFontString.Reset = Reset;

end

--[[ Function: SetNameAlias
	 Sets an alias name for a unit that will be shown on all unit frames instead of the player's true name.
	 Arguments:
		unitFrame: the unit frame the fontstring belongs to.
]]--
function NameText:SetNameAlias (nameKey, alias)
	
	if ( not nameKey or not alias ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_NAME_ALIAS_NOT_GIVEN"), "error");
		return;
	end
	
	NameText.displayedNames[nameKey] = alias;

end

--[[ Function: GetNameAlias
	 Gets the alias name for the specified unit.
	 Arguments:
		unitFrame: the unit frame the fontstring belongs to.
]]--
function NameText:GetNameAlias (unit, nameString)

	if ( not unit and not nameString ) then
		return nil;
	end
	
	local name, realm;
	if ( unit ) then
		name, realm = UnitName(unit);
	
		if ( not name ) then
			return nil;
		end
	
		if ( not realm or realm == "" ) then
			realm = GetRealmName();
		end
	
		name = name.."-"..realm;
	else
		name = nameString;
	end
	
	return NameText.displayedNames[name];
end

--[[ Function: DeleteNameAlias
	 Removes the alias name for the specified unit.
	 Arguments:
		unitFrame: the unit frame the fontstring belongs to.
]]--
function NameText:DeleteNameAlias (nameKey)

	if ( not nameKey ) then
		-- TODO: Error
		return;
	end
	
	if (not NameText.displayedNames[nameKey] ) then
		-- TODO: Error
		return;
	end
	
	NameText.displayedNames[nameKey] = nil;
	
end

--[[ Function: OnEvent
	 OnEvent function for the name text handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function NameText:OnEvent (event, ...)
	
	local unit = ...;
	
	if ( event == "UNIT_NAME_UPDATE" or event == "UNIT_FACTION" or "PLAYER_FLAGS_CHANGED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.nameText ) then
						affectedFrame.nameText:Update();
					end
				end
			end
		end
	end
end