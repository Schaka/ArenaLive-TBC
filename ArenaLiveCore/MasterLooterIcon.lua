--[[ ArenaLive Core Functions: MasterLooter Icon Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
This file contains all relevant functions for group master looter indicators and their behaviour.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local MasterLooterIcon = ArenaLiveCore:AddHandler("MasterLooterIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
MasterLooterIcon:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");

-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end

	local lootMethod, lootMaster = GetLootMethod();
	local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
	local unitNumber = tonumber(string.match(unit, "^[a-z]+([0-9]+)$")) or -1;
	
	if ( not lootMaster ) then
		lootMaster = -2;
	end
	
	if ( ( lootMaster == 0 and unit == "player" and UnitGUID("party1") ) or ( (unitType == "party" or unitType == "raid") and unitNumber == lootMaster )  ) then
		self:SetWidth(self.width);
		self:SetHeight(self.height);
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
function MasterLooterIcon:AddFrame (masterIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.masterIcon = masterIcon;
	masterIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.masterIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	masterIcon.width = width;
	masterIcon.height = height;
	masterIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the castbar.
	masterIcon.Update = Update;
	masterIcon.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the master looter icon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
function MasterLooterIcon:OnEvent (event, ...)

	if ( event == "PARTY_LOOT_METHOD_CHANGED" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.masterIcon ) then
					frame.masterIcon:Update();
				end
			end
		end
	end

end