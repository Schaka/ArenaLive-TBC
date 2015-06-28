--[[ ArenaLive Core Functions: VoiceChat Icon Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
This file contains all relevant functions for ready check display.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local ReadyCheck = ArenaLiveCore:AddHandler("ReadyCheck", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
ReadyCheck:RegisterEvent("READY_CHECK");
ReadyCheck:RegisterEvent("READY_CHECK_CONFIRM");
ReadyCheck:RegisterEvent("READY_CHECK_FINISHED");

-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end

	local readyCheckStatus = GetReadyCheckStatus(unit);
	if ( readyCheckStatus ) then
		if ( readyCheckStatus == "ready" ) then
			ReadyCheck_Confirm(self, 1);
		elseif ( readyCheckStatus == "notready" ) then
			ReadyCheck_Confirm(self, 0);
		else -- "waiting"
			ReadyCheck_Start(self);
		end
	else
		self:Reset();
	end	

end

local function Reset (self)
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function ReadyCheck:AddFrame (readyCheckFrame, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.readyCheck = readyCheckFrame;
	readyCheckFrame.unitFrame = unitFrame;
	
	unitFrame.handlerList.readyCheck = true;
	
	-- Set the basic functions for the castbar.
	readyCheckFrame.Update = Update;
	readyCheckFrame.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the ready check handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function ReadyCheck:OnEvent (event, ...)

	if ( event == "READY_CHECK_CONFIRM" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.readyCheck ) then
						affectedFrame.readyCheck:Update();
					end
				end
			end
		end
	elseif ( event == "READY_CHECK" or event == "READY_CHECK_FINISHED" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.readyCheck ) then
					frame.readyCheck:Update();
				end
			end
		end
	end

end