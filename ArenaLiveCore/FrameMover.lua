--[[ ArenaLive Core Functions: AbsorbBar Handler
Created by: Vadrak
Creation Date: 02.06.2013
Last Update: 06.06.2013
This file contains all relevant functions for health bars and their behaviour.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local FrameMover = ArenaLiveCore:AddHandler("FrameMover", "EventCore");

-- Get the global UnitFrame, ArenaHeader and GroupHeader handlers.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local ArenaHeader = ArenaLiveCore:GetHandler("ArenaHeader");
local PartyHeader = ArenaLiveCore:GetHandler("PartyHeader");

-- Store all frame movers in a table to activate and deactivate them.
local FrameMovers = {}

-- Register all needed events
FrameMover:RegisterEvent("PLAYER_REGEN_ENABLED");
FrameMover:RegisterEvent("PLAYER_LOGOUT");
-- Set up a table to store frame movers that need an update after combat lockdown.
local frameMoverToUpdate = {};

-- *** FRAME FUNCTIONS ***
--[[ Function: Enable
	 Enables the frame mover.
]]--
local function Enable (self, elapsed)
	if ( not InCombatLockdown() ) then
		frameMoverToUpdate[self] = nil;
		self.enabled = true;
		self.unitFrame:SetAttribute("alframelock", nil);
		self:SetScript("OnUpdate", self.OnUpdate);
		self:Show();
	else
		frameMoverToUpdate[self] = "enable";
	end
end

--[[ Function: Disable
	 Disables the frame mover.
]]--
local function Disable(self)
	if ( not InCombatLockdown() ) then
		frameMoverToUpdate[self] = nil;
		self.enabled = nil;
		self.unitFrame:SetAttribute("alframelock", true);
		self:SetScript("OnUpdate", nil);
		self:Hide();
	else
		frameMoverToUpdate[self] = "disable";
	end
end

local function OnUpdate (self, elapsed)

	if ( self.enabled ) then
		self:Update();
	end

end

--[[local function OnShow (self)
	
	self:ClearAllPoints();
	self:SetAllPoints(self.unitFrame);

end]]--

local function OnDragStart (self, button)
	self.unitFrame:StartMoving();
	self.unitFrame:SetClampedToScreen(true);
end

local function OnDragStop (self)
	self.unitFrame:StopMovingOrSizing();
	
	-- Prevent Blizzard's layout cache from saving the frame positions:
	self.unitFrame:SetUserPlaced(false);
	
	-- Save position in the saved variables:
	local point, relativeTo, relativePoint, xOffset, yOffset = self.unitFrame:GetPoint();
	if ( relativeTo ) then
		relativeTo = relativeTo:GetName();
	end
	
	local frameAddonName = self.unitFrame.addonName;
	local keyprefix = self.unitFrame.frameType.."/Position/"
	ArenaLiveCore:SetDBEntry(frameAddonName, keyprefix.."Point", point);
	ArenaLiveCore:SetDBEntry(frameAddonName, keyprefix.."RelativeTo", relativeTo);
	ArenaLiveCore:SetDBEntry(frameAddonName, keyprefix.."RelativePoint", relativePoint);
	ArenaLiveCore:SetDBEntry(frameAddonName, keyprefix.."XOffset", xOffset);
	ArenaLiveCore:SetDBEntry(frameAddonName, keyprefix.."YOffset", yOffset);
end

local function Update (self)

	if ( not self.enabled ) then
		return;
	end
	
	local frameName = self.unitFrame:GetName();
	local left, bottom, width, height = self:GetRect();
	local text = string.format(ArenaLiveCore:GetLocalisation(addonName, "FRAME_MOVER_TEXT"), frameName, left, bottom)
	
	self.text:SetText(text);

end

local function Reset (self)
	self:Disable();
	self.text:SetText();
end

-- *** HANDLER FUNCTIONS ***
function FrameMover:AddFrame (frameMover, fontString, unitFrame)
	
	-- Create a reference for the absorb bar inside the unit frame and vice versa.
	unitFrame.frameMover = frameMover;
	frameMover.unitFrame = unitFrame;
	
	-- Register in Handlerlist
	unitFrame.handlerList.frameMover = true;
	
	-- Register the fontstring that shows the coordinates of the farme.
	frameMover.text = fontString;
	
	frameMover.Enable = Enable;
	frameMover.Disable = Disable;
	frameMover.OnDragStart = OnDragStart;
	frameMover.OnDragStop = OnDragStop;
	frameMover.OnUpdate = OnUpdate;
	frameMover.Update = Update;
	frameMover.Reset = Reset;
	
	-- Set the size of the mover to be the same as the frame, if the frame is larget than the mover.
	frameMover:SetAllPoints(unitFrame);
	
	-- Register for drag
	frameMover:RegisterForDrag("LeftButton");
	
	-- Set Scripts
	frameMover:SetScript("OnDragStart", frameMover.OnDragStart);
	frameMover:SetScript("OnDragStop", frameMover.OnDragStop);
	--frameMover:SetScript("OnShow", frameMover.OnShow);
	
	-- Enable or disable the mover according to saved variables
	local DBKey = "FrameLock"
	local isLocked = ArenaLiveCore:GetDBEntry(addonName, DBKey);	

	-- Add to FrameMover table
	FrameMovers[frameMover] = true;	
	
	if ( isLocked ) then
		frameMover:Disable();
	else
		frameMover:Enable();
	end
	
	-- Set the unit frame's position.
	FrameMover:SetFramePosition(unitFrame);
	
end

function FrameMover:UpdateAll()

	-- Enable or disable all movers according to saved variables
	local DBKey = "FrameLock"
	local isLocked = ArenaLiveCore:GetDBEntry(addonName, DBKey);	
	--[[
	for key, frame in ipairs(UnitFrame.UnitFrameTable) do
		if ( frame.handlerList.frameMover ) then
			if ( isLocked ) then
				frame.frameMover:Disable();
			else
				frame.frameMover:Enable();
			end	
		end
	end

	for header, value in pairs(ArenaHeader.HeaderTable) do
		if ( header.handlerList.frameMover ) then
			if ( isLocked ) then
				header.frameMover:Disable();
			else
				header.frameMover:Enable();
			end	
		end
	end	
	
	for header, value in pairs(PartyHeader.HeaderTable) do
		if ( header.handlerList.frameMover ) then
			if ( isLocked ) then
				header.frameMover:Disable();
			else
				header.frameMover:Enable();
			end	
		end
	end]]--
	
	for frameMover, value in pairs(FrameMovers) do
		if ( isLocked ) then
			frameMover:Disable();
		else
			frameMover:Enable();
		end			
	end
	
end

--[[ Function: SetFramePosition
	 Sets the initial frame position of a unit frame based on saved variables.
	 This normally only needs to be called at the start up, which is done via the AddFrame function.
	 Arguments:
		unitFrame: The unit frame that will be positioned.
]]--
function FrameMover:SetFramePosition(unitFrame)

	local keyprefix = unitFrame.frameType.."/Position/"
	
	-- TEMPORARY: First check if the unit frame position is already stored, because prior to version 0.6beta frame positions were stored via Blizzard's lyout cache.
	local point, relativeTo, relativePoint, xOffset, yOffset;
	
	point = ArenaLiveCore:GetDBEntry(unitFrame.addonName, keyprefix.."Point");
	
	-- If there is no information stored, create the entries now.
	if ( not point ) then
		point, relativeTo, relativePoint, xOffset, yOffset = unitFrame:GetPoint();
		if ( relativeTo ) then
			relativeTo = relativeTo:GetName();
		end
		ArenaLiveCore:SetDBEntry(unitFrame.addonName, keyprefix.."Point", point);
		ArenaLiveCore:SetDBEntry(unitFrame.addonName, keyprefix.."RelativeTo", relativeTo);
		ArenaLiveCore:SetDBEntry(unitFrame.addonName, keyprefix.."RelativePoint", relativePoint);
		ArenaLiveCore:SetDBEntry(unitFrame.addonName, keyprefix.."XOffset", xOffset);
		ArenaLiveCore:SetDBEntry(unitFrame.addonName, keyprefix.."YOffset", yOffset);
	end

	-- Prevent Blizzard's layout cache from saving the frame positions:
	unitFrame:SetUserPlaced(false);
	
	-- Now get the DB entries and set the frame's position.
	point = ArenaLiveCore:GetDBEntry(unitFrame.addonName, keyprefix.."Point");
	relativeTo = ArenaLiveCore:GetDBEntry(unitFrame.addonName, keyprefix.."RelativeTo");
	relativePoint = ArenaLiveCore:GetDBEntry(unitFrame.addonName, keyprefix.."RelativePoint");
	xOffset = ArenaLiveCore:GetDBEntry(unitFrame.addonName, keyprefix.."XOffset");
	yOffset = ArenaLiveCore:GetDBEntry(unitFrame.addonName, keyprefix.."YOffset");
	
	unitFrame:ClearAllPoints();
	unitFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
end

function FrameMover:OnEvent(event, ...)

	if ( event == "PLAYER_REGEN_ENABLED" ) then
		for frame, update in pairs(frameMoverToUpdate) do
			if ( update == "enable" ) then
				frame:Enable();
			elseif ( update == "disable" ) then
				frame:Disable();
			end
		end
	elseif ( event == "PLAYER_LOGOUT" ) then
		-- This helps saving frame positions, when people use scripts to move their frames instead of the drag function.
		for key, frame in pairs(UnitFrame.UnitFrameTable) do
			if ( frame and frame.handlerList.frameMover ) then
				frame.frameMover:OnDragStop();
			end
		end		
	end

end