--[[ ArenaLive Core Functions: RaidIcon Handler
Created by: Vadrak
Creation Date: 21.06.2013
Last Update: "
TargetIndicator is used to indicate which unit the player is currently targeting.
Usually a border is shown around the frames to indicate that.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local RaidIcon = ArenaLiveCore:AddHandler("RaidIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
RaidIcon:RegisterEvent("RAID_TARGET_UPDATE");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	local index = GetRaidTargetIndex(unit);
	if ( index ) then
		SetRaidTargetIconTexture(self, index);
		self:Show();
	else
		self:Hide();
	end

end

local function Reset (self)
	self:SetTexture();
	self:Hide();

	--[[ Set width to 1 so that an icon that is anchored to the frame reduces it's
		 distance between itself and the frame the pvp icon is attached to. ]]--
	if ( self.stacking == "HORIZONTAL" ) then
		self:SetWidth(1);
	else
		self:SetHeight(1);
	end
	
	-- BUGFIX: For some reason the distance set by anchors is only updated, if we get the current with of the frame.
	self:GetWidth();
end


-- *** HANDLER FUNCTIONS ***
function RaidIcon:AddFrame (raidIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the target indicator inside the unit frame and vice versa.
	unitFrame.raidIcon = raidIcon;
	raidIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.raidIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	raidIcon.width = width;
	raidIcon.height = height;
	raidIcon.stacking = stackingDirection;	
	
	-- Set the basic functions for the raid icon.
	raidIcon.Update = Update;
	raidIcon.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the threat indicator handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function RaidIcon:OnEvent (event, ...)

	if ( event == "RAID_TARGET_UPDATE" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.raidIcon ) then
					frame.raidIcon:Update();
				end
			end
		end
	end

end