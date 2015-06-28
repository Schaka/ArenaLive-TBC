--[[ ArenaLive Core Functions: Leader Icon Handler
Created by: Vadrak
Creation Date: 21.06.2013
Last Update: "
This file contains all relevant functions for group leader indicators and their behaviour.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local LeaderIcon = ArenaLiveCore:AddHandler("LeaderIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
LeaderIcon:RegisterEvent("PARTY_LEADER_CHANGED");
LeaderIcon:RegisterEvent("GROUP_ROSTER_UPDATE");

local function UnitIsGroupLeader(unit)
	for i=1, 40 do
		if UnitGUID(unit) == UnitGUID("raid"..i) then
			local name, rank, subgroup, level, class, fileName, 
			zone, online, isDead, role, isML = GetRaidRosterInfo(i)
			if rank == 2 then
				return true
			else
				return false
			end			
		end
	end
end

-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end

	if ( UnitIsGroupLeader(unit) ) then
		
		self:SetWidth(self.width);
		self:SetHeight(self.height);

		self:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon");
		self:SetTexCoord(0, 1, 0, 1);
		
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
function LeaderIcon:AddFrame (leaderIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.leaderIcon = leaderIcon;
	leaderIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.leaderIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	leaderIcon.width = width;
	leaderIcon.height = height;
	leaderIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the castbar.
	leaderIcon.Update = Update;
	leaderIcon.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the leader icon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
function LeaderIcon:OnEvent (event, ...)

	if ( event == "PARTY_LEADER_CHANGED" or "GROUP_ROSTER_UPDATE" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.leaderIcon ) then
					frame.leaderIcon:Update();
				end
			end
		end
	end

end