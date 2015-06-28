 --[[ ArenaLive Core Functions: QuestIcon Handler
Created by: Vadrak
Creation Date: 23.06.2013
Last Update: "
This file contains all relevant functions for Quest Mob indicators and their behaviour.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local QuestIcon = ArenaLiveCore:AddHandler("QuestIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
QuestIcon:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	if ( UnitIsQuestBoss(unit) ) then
		self:Show();
		self:SetWidth(self.width);
		self:SetHeight(self.height);
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
	
	-- BUGFIX: For some reason the distance set by anchors is only updated, if we get the current with of the frame.
	self:GetWidth();
	
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function QuestIcon:AddFrame (questIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the quest icon inside the unit frame and vice versa.
	unitFrame.questIcon = questIcon;
	questIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.questIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	questIcon.width = width;
	questIcon.height = height;
	questIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the castbar.
	questIcon.Update = Update;
	questIcon.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the QuestIcon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function QuestIcon:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_CLASSIFICATION_CHANGED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.questIcon ) then
						affectedFrame.questIcon:Update();
					end
				end
			end
		end
	end

end