--[[ ArenaLive Core Functions: MasterLooter Icon Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
This file contains all relevant functions for group role indicators and their behaviour.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local RoleIcon = ArenaLiveCore:AddHandler("RoleIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
RoleIcon:RegisterEvent("PLAYER_ROLES_ASSIGNED");
RoleIcon:RegisterEvent("GROUP_ROSTER_UPDATE");

-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit);
	
	if ( role == "TANK" or role == "HEALER" or role == "DAMAGER") then
		self:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
		self:Show();
	else
		self:Hide();
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
function RoleIcon:AddFrame (roleIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.roleIcon = roleIcon;
	roleIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.roleIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	roleIcon.width = width;
	roleIcon.height = height;
	roleIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the castbar.
	roleIcon.Update = Update;
	roleIcon.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the master looter icon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function RoleIcon:OnEvent (event, ...)

	if ( event == "PLAYER_ROLES_ASSIGNED" ) then
		local unit = "player";
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.roleIcon ) then
						affectedFrame.roleIcon:Update();
					end
				end
			end
		end
	elseif ( event == "GROUP_ROSTER_UPDATE" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.masterIcon ) then
					frame.masterIcon:Update();
				end
			end
		end
	end

end