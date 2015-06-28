--[[ ArenaLive Core Functions: TargetIndicator Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
TargetIndicator is used to indicate which unit the player is currently targeting.
Usually a border is shown around the frames to indicate that.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local TargetIndicator = ArenaLiveCore:AddHandler("TargetIndicator", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
TargetIndicator:RegisterEvent("PLAYER_TARGET_CHANGED");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	if ( UnitIsUnit(unit, "target") ) then
		self:Show();
	else
		self:Reset();
	end

end

local function Reset (self)
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function TargetIndicator:AddFrame (targetIndicator, unitFrame)

	-- Create a reference for the target indicator inside the unit frame and vice versa.
	unitFrame.targetIndicator = targetIndicator;
	targetIndicator.unitFrame = unitFrame;
	
	unitFrame.handlerList.targetIndicator = true;
	
	-- Set the basic functions for the castbar.
	targetIndicator.Update = Update;
	targetIndicator.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the threat indicator handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function TargetIndicator:OnEvent (event, ...)

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.targetIndicator ) then
					frame.targetIndicator:Update();
				end
			end
		end
	end

end