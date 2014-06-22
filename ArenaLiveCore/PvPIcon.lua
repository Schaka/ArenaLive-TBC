--[[ ArenaLive Core Functions: PvPIcon Handler
Created by: Vadrak
Creation Date: 21.06.2013
Last Update: "
This file contains all relevant functions for PvP Status indicators and their behaviour.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local PvPIcon = ArenaLiveCore:AddHandler("PvPIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
PvPIcon:RegisterEvent("UNIT_FACTION");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	local factionGroup, factionName = UnitFactionGroup(unit);
	if ( UnitIsPVPFreeForAll(unit) ) then
		
		self:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		self:SetWidth(self.width);
		self:SetHeight(self.height);
		self:Show();
		
	elseif ( factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit) ) then
		
		self:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		self:SetWidth(self.width);
		self:SetHeight(self.height);
		self:Show();
	else
		self:Reset();
	end

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
	-- BUGFIX: For some reason the distance set by anchors is only updated, if we get the current with of the frame.
	self:GetWidth();
end


-- *** HANDLER FUNCTIONS ***
function PvPIcon:AddFrame (pvpIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.pvpIcon = pvpIcon;
	pvpIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.pvpIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	pvpIcon.width = width;
	pvpIcon.height = height;
	pvpIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the castbar.
	pvpIcon.Update = Update;
	pvpIcon.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the PvPIcon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function PvPIcon:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_FACTION" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.pvpIcon ) then
						affectedFrame.pvpIcon:Update();
					end
				end
			end
		end
	end

end