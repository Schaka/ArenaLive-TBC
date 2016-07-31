--[[ ArenaLive Core Functions: MasterLooter Icon Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
This file contains all relevant functions for in combat and resting display.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local StatusIcon = ArenaLiveCore:AddHandler("StatusIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
StatusIcon:RegisterEvent("PLAYER_REGEN_DISABLED");
StatusIcon:RegisterEvent("PLAYER_REGEN_ENABLED");
StatusIcon:RegisterEvent("PLAYER_UPDATE_RESTING");

-- *** FRAME FUNCTIONS ***
local function OnUpdate (self, elapsed)
	self:Update();
end

local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end

	if ( IsResting() and unit == "player" ) then
		
		self:SetTexCoord(0, 0.5, 0, 0.421875);
		self:Show();
	elseif ( UnitAffectingCombat(unit) ) then
		self:SetWidth(self.width);
		self:SetHeight(self.height);
		self:SetTexCoord(0.5, 1 , 0, 0.5);
		self:Show();
	else
		self:Reset();
	end

end

local function Reset (self)
	--[[ Set width to 1 so that an icon that is anchored to this one reduces the
		 distance between itself and the frame the leader icon is anchored to. ]]--
	if ( self.stacking == "HORIZONTAL" ) then
		self:SetWidth(1);
	else
		self:SetHeight(1);
	end
	self:Hide();
	
	-- BUGFIX: For some reason the distance set by anchors is only updated, if we get the current with of the frame.
	self:GetWidth();
	
end


-- *** HANDLER FUNCTIONS ***
function StatusIcon:AddFrame (statusIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.statusIcon = statusIcon;
	statusIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.statusIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	statusIcon.width = width;
	statusIcon.height = height;
	statusIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the StatusIcon.
	statusIcon.Update = Update;
	statusIcon.Reset = Reset;
	statusIcon.OnUpdate = OnUpdate;
	local updateFrame = CreateFrame("Frame", statusIcon:GetName().."UpdateFrame");
	updateFrame:SetScript("OnUpdate", function(self, elapsed)
		statusIcon:OnUpdate(statusIcon, elapsed);
	end);

end

--[[ Function: OnEvent
	 OnEvent function for the master looter icon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function StatusIcon:OnEvent (event, ...)
	
	if ( event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_UPDATE_RESTING" ) then
		local unit = "player";
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.statusIcon ) then
						affectedFrame.statusIcon:Update();
					end
				end
			end
		end
	end

end