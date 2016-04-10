--[[ ArenaLive Core Functions: HealthBar Handler
Created by: Vadrak
Creation Date: 02.06.2013
Last Update: 06.06.2013
This file contains all relevant functions for health bars and their behaviour.
]]--
local addonName = "ArenaLiveCore";
-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local HealthBar = ArenaLiveCore:AddHandler("HealthBar", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
HealthBar:RegisterEvent("UNIT_HEALTH");
HealthBar:RegisterEvent("UNIT_MAXHEALTH");


-- *** FRAME FUNCTIONS ***
--[[ Function: SetColour
	 Sets the colour of the healthbar.
]]--
local function SetColour (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit or self.lockColour or self.disconnected ) then
		self:SetStatusBarColor(0.5, 0.5, 0.5);
		return;
	end
	
	
	local red, green, blue = 0, 1, 0;
	local isPlayer = UnitIsPlayer(unit);
	local colourMode = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/HealthBar/ColourMode");
	
	if ( colourMode == "class" and isPlayer ) then
	
		local _, class = UnitClass(unit);
		
		if ( class ) then
			red, green, blue = RAID_CLASS_COLORS[class]["r"], RAID_CLASS_COLORS[class]["g"], RAID_CLASS_COLORS[class]["b"];
		end
	
	elseif ( colourMode == "reaction" ) then
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
	elseif ( colourMode == "smooth" ) then
		-- Luckily Blizzard has already written a perfect function for smooth health bar colour. I just adjust this to the addon's needs.
		local value = UnitHealth(unit);
		local minValue = 0;
		local maxValue = UnitHealthMax(unit);

		if ( (maxValue - minValue) > 0 ) then
			value = (value - minValue) / (maxValue - minValue);
		else
			value = 0;
		end
		
		if( value > 0.5 ) then
			red = (1.0 - value) * 2;
			green = 1.0;
		else
			red = 1.0;
			green = value * 2;
		end

		blue = 0;
	end
	
	self:SetStatusBarColor(red, green, blue);
end

--[[ Function: OnUpdate
	 OnUpdate function for the healthbar.
]]--
local function OnUpdate (self, elapsed)
	
	if ( not self.disconnected and not self.lockValues) then
	
		local unit = self.unitFrame.unit;
		if ( not unit ) then
			return;
		end	
	
		local currValue = UnitHealth(unit);

		if ( currValue ~= self.currValue ) then
			if ( not self.ignoreNoUnit or UnitGUID(unit) ) then
				self:SetValue(currValue);
				self.currValue = currValue;
			end
		end
	end
end

--[[ Function: OnValueChanged
	 OnValueChanged function for the healthbar.
]]--
local function OnValueChanged(self)
	local colourMode = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/HealthBar/ColourMode");
	
	if ( colourMode == "smooth" and self.frequentUpdates ) then
		self:SetColour();
	end
	
	if ( self.unitFrame.handlerList.absorbBar ) then
		self.unitFrame.absorbBar:Update();
	end
				
	if ( self.unitFrame.handlerList.healPredictionBar ) then
		self.unitFrame.healPredictionBar:Update();
	end	
	
	if ( self.unitFrame.healthBarText ) then
		self.unitFrame.healthBarText:Update();
	end
end

--[[ Function: Update
	 General update function for the healthbar.
]]--
local function Update(self)
	local unit = self.unitFrame.unit;
	
	if ( not unit or self.lockValues ) then
		return;
	end
	
	local maxValue = UnitHealthMax(unit);
	local currValue = UnitHealth(unit);
		
	self.forceHideText = false;
		
	if ( maxValue == 0 ) then
		maxValue = 1;
		self.forceHideText = true;
	end
	
	self:SetMinMaxValues(0, maxValue);

	self.disconnected = not UnitIsConnected(unit);
		
	if ( self.disconnected ) then
		currValue = maxValue;
	end
		
	self:SetValue(currValue);
	self:SetColour();
	self.currValue = currValue;
		

end

--[[ Function: Reset
	 Reset the healthbar's values.
]]--
local function Reset(self)
	self:SetMinMaxValues(0, 1);
	self:SetValue(1);
	self:SetStatusBarColor(0.5, 0.5, 0.5);
end



-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a statusbar to be the healthbar of a unit frame.
	 Arguments:
		healthBar: The statusBar that will be registered as a healthbar.
		unitFrame: the unit frame the healthbar belongs to.
		frequentUpdates: If true, the healthbar will update itself via an OnUpdate script.
]]--
function HealthBar:AddFrame (healthBar, unitFrame, frequentUpdates)

	-- Create a reference for the healthbar inside the unit frame and vice versa.
	unitFrame.healthBar = healthBar;
	healthBar.unitFrame = unitFrame;
	
	-- Register the healthbar in the unit frame's handler list.
	unitFrame.handlerList.healthBar = true;
	
	-- Set the colour type for the unit frame.
	healthBar.lockColour = false;
	healthBar.frequentUpdates = frequentUpdates;
	
	healthBar.SetColour = SetColour;
	healthBar.OnUpdate = OnUpdate;
	healthBar.OnValueChanged = OnValueChanged;
	healthBar.Update = Update;
	healthBar.Reset = Reset;

	-- Set reverse fill
	--HealthBar:SetReverseFill(unitFrame);
	
	if ( frequentUpdates ) then
		healthBar:SetScript("OnUpdate", healthBar.OnUpdate);
	end
	
	healthBar:SetScript("OnValueChanged", healthBar.OnValueChanged);
end

--[[ Function: SetReverseFill
	 Sets the colour mode for the healthbar of the specified unit frame.
	 Arguments:
		unitFrame: the unit frame the healthbar belongs to.
]]--
function HealthBar:SetReverseFill (unitFrame)
	if ( unitFrame.healthBar ) then
		local DBKey = unitFrame.frameType.."/StatusBars/ReverseFill";
		local reverseFill = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
		unitFrame.healthBar:SetReverseFill(reverseFill);
	end
end

--[[ Function: OnEvent
	 OnEvent function for the HealthBar handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function HealthBar:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_HEALTH" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.healthBar and not affectedFrame.healthBar.frequentUpdates  ) then
						affectedFrame.healthBar:Update();
					end
				end
			end
		end
	elseif ( event == "UNIT_MAXHEALTH" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.healthBar ) then
						affectedFrame.healthBar:Update();
					end
				end
			end
		end
	end

end