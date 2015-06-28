--[[ ArenaLive Core Functions: Level Text Handler
Created by: Vadrak
Creation Date: 09.06.2013
Last Update: "
This file contains all relevant functions for name font strings and name aliases.
]]--

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local LevelText = ArenaLiveCore:AddHandler("LevelText", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
LevelText:RegisterEvent("UNIT_LEVEL");
LevelText:RegisterEvent("UNIT_FACTION");
LevelText:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	
	local unit = self.unitFrame.unit

	if ( not unit ) then
		self:Reset();
		return;
	end
	
	local level = UnitLevel(unit);
	local classificationModifier;
	local classification = UnitClassification(unit);
	local text;
	
	local red, green, blue;
	

	-- Find the correct text for the unit's level.
	if ( UnitIsCorpse(unit) ) then
		text = "??";
	elseif ( level > 0 ) then
		-- Normal display of level.
		text = UnitLevel(unit);
	else
		-- Target is too high level to tell
		text = "??";
	end
	
	-- Set the colour for the level text according to the level difference.
	if ( text == "??" ) then
		red, green, blue = 1, 0, 0
	elseif ( UnitCanAttack("player", unit) ) then
		local colour =  GetDifficultyColor(level);
		red, green, blue = colour.r, colour.g, colour.b;
	else
		red, green, blue = 1.0, 0.82, 0.0
	end
	
	
	-- Set our classification modifier to reflect elite/rare mobs.
	if ( classification == "worldboss" or classification == "elite" ) then
		classificationModifier = "+";
	elseif ( classification == "rareelite" ) then
		classificationModifier = "R+";
	elseif ( classification == "rare" ) then
		classificationModifier = "R";
	else
		classificationModifier = "";
	end	
	
	-- Combine modifier and text if app appropriate.
	if ( text ~= "??" ) then
		text = text..classificationModifier;

		if ( self.highLevelTexture ) then
			self.highLevelTexture:Hide();
		end
	else
		-- Hide text, if there is a high level texture that should replace it.
		if ( self.highLevelTexture ) then
			self:Hide();
			self.highLevelTexture:Show();
			return;
		end
	end
	
	self:Show();
	self:SetTextColor(red, green, blue);
	
	if ( self.textTemplate ) then
		-- Apply the text template if there is one.
		text = string.format(self.textTemplate, text);
	end
	self:SetText(text);
end

local function Reset (self)

	self:SetText("");
	if ( self.highLevelTexture ) then
		self.highLevelTexture:Hide();
	end

end

-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a font string to show the level of a unit.
	 Arguments:
		levelFontString: The fontstring that will be registered as the level text.
		highLevelTexture: A texture that will be shown for high level units or bosses (optional).
		levelTextTemplate:  A text string in which the level is inserted (optional).
		unitFrame: the unit frame the fontstring belongs to.
]]--
function LevelText:AddFrame (levelFontString, highLevelTexture, textTemplate, unitFrame)

	-- Create a reference for the healthbar inside the unit frame and vice versa.
	unitFrame.levelText = levelFontString;
	levelFontString.highLevelTexture = highLevelTexture;
	levelFontString.unitFrame = unitFrame;
	levelFontString.textTemplate = textTemplate;
	-- Register the healthbar in the unit frame's handler list.
	unitFrame.handlerList.levelText = true;
	
	levelFontString.Update = Update;
	levelFontString.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the level text handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function LevelText:OnEvent (event, ...)
	
	local unit = ...;
	
	if ( event == "UNIT_LEVEL" or event == "UNIT_FACTION" or event == "UNIT_CLASSIFICATION_CHANGED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.levelText ) then
						affectedFrame.levelText:Update();
					end
				end
			end
		end
	end
end
