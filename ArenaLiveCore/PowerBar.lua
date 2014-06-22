--[[ ArenaLive Core Functions: PowerBar Handler
Created by: Vadrak
Creation Date: 07.06.2013
Last Update: "
This file contains all relevant functions for power bars and their behaviour.
]]--

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local PowerBar = ArenaLiveCore:AddHandler("PowerBar", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
PowerBar:RegisterEvent("UNIT_DISPLAYPOWER");
PowerBar:RegisterEvent("UNIT_MANA");
PowerBar:RegisterEvent("UNIT_MAXMANA");


local powerTypeTable = {
	[0] = "MANA",
	[1] = "RAGE",
	[2] = "FOCUS",
	[3] = "ENERGY",
}

PowerBarColor = {};
PowerBarColor["MANA"] = { r = 0.00, g = 0.00, b = 1.00 };
PowerBarColor["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 };
PowerBarColor["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 };
PowerBarColor["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 };


-- *** FRAME FUNCTIONS ***
--[[ Function: SetPowerType
	 Sets the power type and the colour of the powerbar.
]]--
local function SetPowerType(self)

	if ( not self or self.lockColour or self.disconnected ) then
		self:SetStatusBarColor(0.5, 0.5, 0.5);
		return;
	end
	local unit = self.unitFrame.unit;
	local powerType, powerToken, red, green, blue = UnitPowerType(unit)
	powerToken = powerTypeTable[powerType]
	local info = PowerBarColor[powerToken];
	
	if ( info ) then
		red = info.r
		green = info.g
		blue = info.b
	else
		if ( not red ) then
			info = PowerBarColor[powerType] or PowerBarColor["MANA"];
			red = info.r
			green = info.g
			blue = info.b
		end
	end
	
	self.powerType = powerType;
	self:SetStatusBarColor(red, green, blue);

end

--[[ Function: OnUpdate
	 OnUpdate function for the powerbar.
]]--
local function OnUpdate(self, elapsed)

	if ( not self.disconnected and not self.lockValues ) then
		
		local unit = self.unitFrame.unit;
		if ( not unit ) then
			return;
		end
			
		local currValue = UnitMana(unit, self.powerType);
		
		if ( currValue ~= self.currValue ) then
			if ( not self.ignoreNoUnit or UnitGUID(unit) ) then
				self:SetValue(currValue);
				self.currValue = currValue;
			end
		end
	end
end

--[[ Function: OnValueChanged
	 OnValueChanged function for the powerbar.
]]--
local function OnValueChanged(self)
	if ( self.unitFrame.powerBarText ) then
		self.unitFrame.powerBarText:Update();
	end
end

--[[ Function: Update
	 General update function for the powerbar.
]]--
local function Update (self)
	
	local unit = self.unitFrame.unit;
	
	if ( not unit or self.lockValues ) then
		return;
	end
	
	self.disconnected = not UnitIsConnected(unit);
	self:SetPowerType(self);
	
	local maxValue = UnitManaMax(unit, self.powerType);
	self.forceHideText = false;
	
	if (maxValue == 0 ) then
		maxValue = 1;
		self.forceHideText = true;
	end
	
	self:SetMinMaxValues(0, maxValue);
	self:SetValue(maxValue);
	self.currValue = maxValue;

	local currValue = UnitMana(unit, self.powerType);
	self:SetValue(currValue);
	self.currValue = currValue;

end

--[[ Function: Reset
	 Reset the powerbar's values.
]]--
local function Reset (self)
	self:SetMinMaxValues(0, 1);
	self:SetValue(1);
	self:SetStatusBarColor(0.5, 0.5, 0.5);
end



-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a statusbar to be the powerbar of a unit frame.
	 Arguments:
		powerBar: The statusBar that will be registered as a powerbar.
		unitFrame: the unit frame the powerbar belongs to.
		frequentUpdates: If true, the powerbar will update itself via an OnUpdate script.
]]--
function PowerBar:AddFrame (powerBar, unitFrame, frequentUpdates)

	-- Create a reference for the powerbar inside the unit frame and vice versa.
	unitFrame.powerBar = powerBar;
	powerBar.unitFrame = unitFrame;
	
	-- Register the powerBar in the unit frame's handler list.
	unitFrame.handlerList.powerBar = true;

	powerBar.lockColour = false;
	powerBar.frequentUpdates = frequentUpdates;
	
	powerBar.SetPowerType = SetPowerType;
	powerBar.OnUpdate = OnUpdate;
	powerBar.OnValueChanged = OnValueChanged;
	powerBar.Update = Update;
	powerBar.Reset = Reset;
	
	-- Set reverse fill
	--PowerBar:SetReverseFill(unitFrame);
	
	if ( frequentUpdates ) then
		powerBar:SetScript("OnUpdate", powerBar.OnUpdate);
	end
	
	powerBar:SetScript("OnValueChanged", powerBar.OnValueChanged);
end

--[[ Function: SetReverseFill
	 Sets reverse fill mode for the powerbar of the specified unit frame.
	 Arguments:
		unitFrame: the unit frame the healthbar belongs to.
]]--
function PowerBar:SetReverseFill (unitFrame)
	if ( unitFrame.powerBar ) then
		local DBKey = unitFrame.frameType.."/StatusBars/ReverseFill";
		local reverseFill = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
		unitFrame.powerBar:SetReverseFill(reverseFill);
	end
end

--[[ Function: OnEvent
	 OnEvent function for the PowerBar handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function PowerBar:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_POWER" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.powerBar and not affectedFrame.powerBar.frequentUpdates  ) then
						affectedFrame.powerBar:Update();
					end
				end
			end
		end
	elseif ( event == "UNIT_DISPLAYPOWER" or event == "UNIT_MAXPOWER" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.powerBar ) then
						affectedFrame.powerBar:Update();
					end
				end
			end
		end
	end

end