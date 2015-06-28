 --[[ ArenaLive Core Functions: PetBattleIcon Handler
Created by: Vadrak
Creation Date: 23.06.2013
Last Update: "
This file contains all relevant functions for Pet battle pet indicators and their behaviour.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local PetBattleIcon = ArenaLiveCore:AddHandler("PetBattleIcon");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	if ( UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) ) then
		local petType = UnitBattlePetType(unit);
		self:SetTexture("Interface\\TargetingFrame\\PetBadge-"..PET_TYPE_SUFFIX[petType]);
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
	
	-- BUGFIX: For some reason the distance set by anchors is only updated, if we get the current with of the frame.
	self:GetWidth();
	
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function PetBattleIcon:AddFrame (petBattleIcon, width, height, stackingDirection, unitFrame)

	-- Create a reference for the quest icon inside the unit frame and vice versa.
	unitFrame.petBattleIcon = petBattleIcon;
	petBattleIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.petBattleIcon = true;
	
	-- Set base variables for the icon's size and how stacked icons are anchored.
	petBattleIcon.width = width;
	petBattleIcon.height = height;
	petBattleIcon.stacking = stackingDirection;
	
	-- Set the basic functions for the castbar.
	petBattleIcon.Update = Update;
	petBattleIcon.Reset = Reset;

end