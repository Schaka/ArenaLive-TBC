--[[ ArenaLive Core Functions: Cooldown
Created by: Vadrak
Creation Date: 09.06.2013
Last Update: "
This file contains handling of cooldowns and cooldown text.
]]--

-- AddOnName to get SavedVariables.
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local Cooldown = ArenaLiveCore:AddHandler("Cooldown");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Set abbreviations for hours and minutes
local minute_abbreviation = "m";
local hour_abbreviation = "h";

-- Set up a table to store references for all registered cooldowns. This way it will be easier to enable/disable OmniCC support.
local cooldownFrames = {};

-- *** FRAME FUNCTIONS ***
local function Set (self, startTime, duration)

	local remainingDuration = duration - (GetTime() - startTime);
	self.duration = remainingDuration;
	self.elapsedTillNow = 0;
	self:SetCooldown(startTime, duration);
	self:Update();	
	self:Show();

end

--[[ Function: Update
	 This function Updates the cooldown text, if there is one.
	 Arguments:
		cooldown: The cooldown frame that will be changed.
]]--
local function Update(self)

	if ( not self.text ) then
		return;
	end
	
	if ( self.duration and self.duration > 0 and self.showText ) then
		self.text:Show();
		self.text:SetText(Cooldown:FormatText(self.duration));
	else
		self.text:Hide();
		self:Hide()
	end

end

local function Reset (self)
	self:Hide();
	self.duration = 0;
	self.elapsedTillNow = 0;
	
	if ( self.text ) then
		self.text:SetText();
	end
end

--[[ Function: OnUpdate
	 OnUpdate handler for the cooldown.
	 Arguments:
		cooldown: The cooldown frame that will be changed.
]]--
local function OnUpdate (self, elapsed)
	
	-- I try to reduce needed performance here by updating the text only when more than 0.1 second has passed, because we only show 1 decimal digit max anyway.
	self.elapsedTillNow = self.elapsedTillNow + elapsed;
	
	if ( self.elapsedTillNow > 0.1 ) then
		self.duration = self.duration - self.elapsedTillNow;
		self.elapsedTillNow = 0;
		
		-- If duration is 0 the cooldown has finished, if the frame is not visible it means that the cooldown isn't needed anymore (e.g. wenn CC is dispelled and PortraitOverlay therefore hidden). 
		if ( ( self.duration <= 0 ) ) then 
			self:Reset();

		else
			if (self.text and self.showText) then
				self:Update()
			end	
		end
	end
end



-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a cooldown frame for specified parent frame.
	 Arguments:
		cooldown: The cooldown frame that will be registered.
		cooldownText: A FontString that is shown, when the cooldown is active (optional).
		parent: The cooldown frame's parent.
		staticSize: If true the cooldown font size won't be changed.
]]--
function Cooldown:AddFrame (cooldown, cooldownText, parent, staticSize)

	if ( not cooldown or not parent ) then
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_COOLDOWN_NOT_GIVEN"), "error");
		return;
	end
	
	-- Create a reference for the healthbar inside the unit frame and vice versa.
	parent.cooldown = cooldown;
	cooldown.parent = parent;
	
	-- Create a reference for the cooldown text.
	cooldown.text = cooldownText;
	
	-- Set up the standard variables.
	cooldown.duration = 0;
	cooldown.elapsedTillNow = 0;
	cooldown.staticSize = staticSize;
	
	-- Set basic functions for the cooldown.
	cooldown.Set = Set;
	cooldown.Update = Update;
	cooldown.Reset = Reset;
	
	if ( cooldown.text ) then
		cooldown.OnUpdate = OnUpdate;
		cooldown:SetScript("OnUpdate", cooldown.OnUpdate);
	end
	
	cooldownFrames[cooldown] = true;
	-- Set up wether font is shown or not, if there is a cooldown text. And update the text size.
	Cooldown:SetTextMode(cooldown);
	Cooldown:UpdateTextSize(cooldown);
end

--[[ Function: SetTextMode
	 This function sets the cooldown up according to saved variables to show a cooldown text or hide it.
	 Arguments:
		cooldown: The cooldown frame that will be changed.
]]--
function Cooldown:SetTextMode(cooldown)
	
	if ( cooldown.text ) then
		cooldown.showText = ArenaLiveCore:GetDBEntry(addonName, "Cooldown/ShowText");
	
		if ( cooldown.showText ) then
			cooldown.noCooldownCount = 1;
		else
			cooldown.noCooldownCount = nil;
			cooldown:Reset();
		end
	else
		cooldown.showText = nil;
		cooldown.noCooldownCount = nil;
	end	
end

function Cooldown:UpdateAll()

	for cooldown, value in pairs(cooldownFrames) do
		Cooldown:SetTextMode(cooldown);
	end

end


--[[ Function: SetTextMode
	 This function sets the cooldown up according to saved variables to show a cooldown text or hide it.
	 Arguments:
		cooldown: The cooldown frame that will be changed.
]]--
function Cooldown:UpdateTextSize(cooldown)
	
	if ( cooldown.text and not cooldown.staticSize ) then
		local size;
		local sizeX = cooldown.parent:GetWidth();
		local sizeY = cooldown.parent:GetHeight();
		
		if ( sizeX < sizeY ) then
			size = sizeX;
		else
			size = sizeY;
		end
		
		sizeY = math.floor(sizeY / 2 );
		
		local filename, fontHeight, flags = cooldown.text:GetFont()
		fontHeight = sizeY;
		cooldown.text:SetFont(filename, fontHeight, flags)
	end

end

--[[ Function: SetTextMode
	 This function sets the cooldown up according to saved variables to show a cooldown text or hide it.
	 Arguments:
		cooldown: The cooldown frame that will be changed.
]]--
function Cooldown:FormatText(cooldownTime)

	if ( not cooldownTime ) then
		return;
	end

	local cooldownTimeText;
	local timeType = "seconds";
	local decimal;
	
	-- Minutes
	if ( cooldownTime > 59 ) then
	
		cooldownTime = cooldownTime / 60;
		timeType = "minutes"
		
		-- Hours
		if ( cooldownTime > 60 ) then
			cooldownTime = cooldownTime / 60;
			timeType = "hours"
		end
		
		-- We need to round up or down correctly on this one.
		decimal = math.floor(cooldownTime * 10);
		decimal =  tonumber(string.sub(decimal, -1));
		
		if ( decimal < 5 ) then
			cooldownTime = math.floor(cooldownTime);
		else
			cooldownTime = math.ceil(cooldownTime);
		end

	else
		if (cooldownTime < 10 and math.floor(cooldownTime) > 0 ) then
			decimal = (math.floor(cooldownTime*10));
			cooldownTime = string.sub(decimal, 1, -2);
			cooldownTime = cooldownTime..".";
			cooldownTime = cooldownTime..string.sub(decimal, -1);
			return cooldownTime;
		end
			
		if (math.floor(cooldownTime) == 0 ) then
			cooldownTime = string.sub(cooldownTime, 1, 3);
		else
			cooldownTime = math.floor(cooldownTime)
		end
	end
	
	if ( timeType == "hours" ) then
		cooldownTimeText = cooldownTime..hour_abbreviation;
	elseif ( timeType == "minutes" ) then 
		cooldownTimeText = cooldownTime..minute_abbreviation;
	else
		if ( tonumber(cooldownTime) <= 0 ) then
			cooldownTimeText = "";
		else
			cooldownTimeText = cooldownTime;
		end
	end
	
	
	return cooldownTimeText;

end