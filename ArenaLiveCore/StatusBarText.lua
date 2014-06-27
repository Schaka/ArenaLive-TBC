--[[ ArenaLive Core Functions: Statusbar Text Handler
Created by: Vadrak
Creation Date: 09.06.2013
Last Update: "
This file contains all relevant functions for different status bar text types.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local StatusBarText = ArenaLiveCore:AddHandler("StatusBarText");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

local ABBREVIATION_THOUSAND = "K";
local ABBREVIATION_MILLION = "M";
-- *** FRAME FUNCTIONS ***
--[[ Function: Update
	 Updates the name fontstring of a unit frame.
	 Arguments:
		self: The name font string.
]]--
local function Update (self)
	
	local unit = self.unitFrame.unit;
	local text;
	local value, maxValue, absorb;
	
	if ( unit ) then
		if ( self.type == "HealthBarText" ) then
			value = UnitHealth(unit) or 0;
			maxValue = UnitHealthMax(unit);
			text = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/HealthBar/Text")
		elseif ( self.type == "PowerBarText" ) then
			value = UnitMana(unit) or 0;
			maxValue = UnitManaMax(unit);
			text = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/PowerBar/Text")
		end
	end
	
	if ( not unit or not text ) then
		text = "";
	elseif ( UnitExists(unit) and not UnitIsConnected(unit) and self.showDisconnect ) then
		text = ArenaLiveCore:GetLocalisation(addonName, "DISCONNECTED");
	elseif ( UnitExists(unit) and not UnitIsConnected(unit) and not self.alwaysShowText ) then
		text = "";
	elseif ( UnitIsDead(unit) and self.zeroText == "DEAD_OR_GHOST" ) then
		text = ArenaLiveCore:GetLocalisation(addonName, "DEAD");
	elseif ( UnitIsGhost(unit) and self.zeroText == "DEAD_OR_GHOST" ) then
		text = ArenaLiveCore:GetLocalisation(addonName, "GHOST");
	elseif ( value > 0 or ( value == 0 and maxValue ~= 0 and self.alwaysShowText ) ) then
		text = StatusBarText:FormatText(text, value, maxValue);
	elseif ( value == 0 and self.zeroText and self.zeroText ~= "DEAD_OR_GHOST" ) then
		text = self.zeroText;
	else
		text = "";
	end
	
	self:SetText(text);
end

--[[ Function: Reset
	 Resets the shown value of a unit frame's statusbar.
	 Arguments:
		self: The name font string.
]]--
local function Reset (self)
	self:SetText();
end

-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a font string to show the value of the text of a unit frame's status bar.
	 Arguments:
		nameFontString: The fontstring that will be registered as the name text.
		unitFrame: the unit frame the fontstring belongs to.
]]--
function StatusBarText:AddFrame (statusBarFontString, statusBarType, zeroText, alwaysShowText, showDisconnect, unitFrame)

	-- Create a reference for the text inside the unit frame and vice versa.
	if ( statusBarType == "HealthBarText" ) then
		unitFrame.healthBarText = statusBarFontString;
		unitFrame.handlerList.healthBarText = true;
	elseif ( statusBarType == "PowerBarText" ) then
		unitFrame.powerBarText = statusBarFontString;
		unitFrame.handlerList.powerBarText = true;
	end
	statusBarFontString.unitFrame = unitFrame;	
	statusBarFontString.type = statusBarType;
	statusBarFontString.zeroText = zeroText;
	statusBarFontString.alwaysShowText = alwaysShowText;
	statusBarFontString.showDisconnect = showDisconnect;
	
	statusBarFontString.Update = Update;
	statusBarFontString.Reset = Reset;
end

--[[ Function: FormatText
	 Sets an alias name for a unit that will be shown on all unit frames instead of the player's true name.
	 Arguments:
		text: textstring that contains aliases for things that should be displayed.
		statusBarType: The type of the status bar the text is shown for.
]]--
function StatusBarText:FormatText (text, value, maxValue)
	
	-- Percent display:
	local percent, percent_short, decimal;
	if ( maxValue > 0 ) then
		percent = ( value / maxValue ) * 100; 
		percent_short = ( value / maxValue ) * 100; 
		decimal = math.floor(percent_short * 10);
		percent = percent;
		decimal = tonumber(string.sub(decimal, -1)) or 0;

		if ( decimal > 5 or math.floor(percent_short) == 0 ) then
			percent_short = math.ceil(percent_short);
		else
			percent_short = math.floor(percent_short);
		end
	else
		percent = 0;
		percent_short = 0;
	end
	
	text = string.gsub(text, "%%PERCENT_SHORT%%", percent_short);
	text = string.gsub(text, "%%PERCENT%%", percent);
	
	-- Current Health/Power Display
	local current = value;
	local current_short = value;
	local strLen = string.len(value);
	
	if ( strLen > 6 ) then
		if ( strLen == 7 ) then
			local decimal = "."..string.sub(value, 2, 2);
			current_short = string.sub(value, 1, -7)..decimal..ABBREVIATION_MILLION;
		else
			current_short = string.sub(value, 1, -7)..ABBREVIATION_MILLION;
		end
	elseif ( strLen > 4 ) then
		current_short = string.sub(value, 1, -4)..ABBREVIATION_THOUSAND;
	elseif (strLen > 3 ) then
		current_short = value;
	end
	
	text = string.gsub(text, "%%CURR_SHORT%%", current_short);
	text = string.gsub(text, "%%CURR%%", current);
	
	
	-- Max Health/Power Display
	local maximal = maxValue;
	local maximal_short = maxValue;
	strLen = string.len(maxValue);
	
	if ( strLen > 6 ) then
		if ( strLen == 7 ) then
			local decimal = "."..string.sub(maxValue, 2, 2);
			maximal_short = string.sub(maxValue, 1, -7)..decimal..ABBREVIATION_MILLION
		else
			maximal_short = string.sub(maxValue, 1, -7)..ABBREVIATION_MILLION;
		end
		
	elseif ( strLen > 4 ) then
		maximal_short = string.sub(maxValue, 1, -4)..ABBREVIATION_THOUSAND;
	elseif (strLen > 3 ) then
		maximal_short = maxValue;
	end
	
	text = string.gsub(text, "%%MAX_SHORT%%", maximal_short);
	text = string.gsub(text, "%%MAX%%", maximal);
	
	return text;
end