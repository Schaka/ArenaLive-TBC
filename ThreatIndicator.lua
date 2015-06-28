--[[ ArenaLive Core Functions: ThreatIndicator Handler
Created by: Vadrak
Creation Date: 21.06.2013
Last Update: "
This file contains all relevant functions for threat indicators and their behaviour.
Mabye this one doesn't work correctly the way it is coded now.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local ThreatIndicator = ArenaLiveCore:AddHandler("ThreatIndicator", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
ThreatIndicator:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit or not self.feedbackUnit ) then
		return;
	end
	
	local status;
		
	if ( self.feedbackUnit ~= unit ) then
		status = UnitThreatSituation(self.feedbackUnit, unit);
	else
		status = UnitThreatSituation(self.feedbackUnit);
	end
		
	if ( status and status > 0 ) then
		self:SetVertexColor(GetThreatStatusColor(status));
		self:Show();
	else
		self:Hide();
	end

end

local function SetFeedbackUnit (self, unit)
	self.feedbackUnit = unit;
end

local function Reset (self)
	--[[ Set width to 1 so that an icon that is anchored to the frame reduces it's
		 distance between itself and the frame the pvp icon is attached to. ]]--
	if ( self.stacking == "HORIZONTAL" ) then
		self:SetWidth(1);
	else
		self:SetHeight(1);
	end
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function ThreatIndicator:AddFrame (threatIndicator, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.threatIndicator = threatIndicator;
	threatIndicator.unitFrame = unitFrame;
	
	unitFrame.handlerList.threatIndicator = true;
	
	-- Set the basic functions for the castbar.
	threatIndicator.Update = Update;
	threatIndicator.Reset = Reset;
	threatIndicator.SetFeedbackUnit = SetFeedbackUnit;

end

--[[ Function: OnEvent
	 OnEvent function for the threat indicator handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function ThreatIndicator:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_THREAT_SITUATION_UPDATE" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.threatIndicator ) then
						affectedFrame.threatIndicator:Update();
					end
				end
			end
		end
	end

end