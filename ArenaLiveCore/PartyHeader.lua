--[[ ArenaLive Core Functions: PartyHeader Handler
Created by: Vadrak
Creation Date: 04.07.2013
Last Update: "
These functions are used to set up every group header for party frames.
It will store all ArenaLive based group headers that show party target units in a table.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local PartyHeader = ArenaLiveCore:AddHandler("PartyHeader", "EventCore");
PartyHeader:RegisterEvent("PLAYER_REGEN_ENABLED");
PartyHeader:RegisterEvent("GROUP_ROSTER_UPDATE");
PartyHeader:RegisterEvent("UNIT_NAME_UPDATE");
PartyHeader:RegisterEvent("PLAYER_ENTERING_WORLD");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Set up the header storage table.
PartyHeader.HeaderTable = {};

-- Set up a table for frames that need a update after CombatLockDown fades.
local headerToUpdate = {};


-- *** FRAME FUNCTIONS ***
-- self, name, value
local onAttributeChangedSnippet = [[
 if ( name ~= "inarena" and name ~= "state-ingroup" and name ~= "alframelock" and name ~= "state-existingunits" and name ~= "showplayer" and name ~= "showarena" and name ~= "showraid" ) then
  return
 end

 local show;
 
 if (not self:GetAttribute("alframelock") ) then
  self:Show();
  
  local playerFrame = self:GetFrameRef("PartyPlayerFrame");
  if ( self:GetAttribute("showplayer") ) then
   playerFrame:Show();
  else
   playerFrame:Hide();
  end
  
  for i = 1, 4 do
   local frameRef = "PartyFrame"..i;
   local frame = self:GetFrameRef(frameRef);
   frame:Show();
  end
  return;

 else
  if ( self:GetAttribute("state-ingroup") == "party" or ( self:GetAttribute("inarena") and self:GetAttribute("showarena") ) or ( self:GetAttribute("state-ingroup") == "raid" and self:GetAttribute("showraid") ) ) then
   show = true;
  else
   show = nil;
  end
 end
 
 if ( show ) then 
  local existingunits = self:GetAttribute("state-existingunits");
  self:Show();
  
  local playerFrame = self:GetFrameRef("PartyPlayerFrame");
  if ( self:GetAttribute("showplayer") ) then
   playerFrame:Show();
  else
   playerFrame:Hide();
  end
  
  for i = 1, 4 do
   local frameRef = "PartyFrame"..i;
   local frame = self:GetFrameRef(frameRef);
   
   if ( i <= existingunits ) then
    frame:Show();
   else
    frame:Hide();
   end
  end
 else
  self:Hide();
 end 

]];

local existingUnitsSnippet = [[ [target=party4, exists] 4; [target=party3, exists] 3; [target=party2, exists] 2; [target=party1, exists] 1; 0  ]];
local groupTypeSnippet = [[ [group:raid] raid; [group:party] party; nil ]];
local function Enable (self)
	if ( not InCombatLockdown() ) then
		self.SetToggle = nil;
		
		local showInRaid = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/ShowInRaid");
		local showInArena = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/ShowInArena");
		
		RegisterStateDriver(self, "existingunits", existingUnitsSnippet);
		RegisterStateDriver(self, "ingroup", groupTypeSnippet);
		self:SetScript("OnAttributeChanged", self.OnAttributeChanged);
		--self:WrapScript(self, "OnAttributeChanged", onAttributeChangedSnippet);
		self:SetAttribute("showraid", showInRaid);
		self:SetAttribute("showarena", showInArena);
		self:UpdateShowPlayer(self);
	else
		self.SetToggle = "enable";
		headerToUpdate[self] = true;
	end
end

local function Disable (self)

	if ( not InCombatLockdown() ) then
		self.SetToggle = nil;

		UnregisterStateDriver(self, "unitsexist");
		UnregisterStateDriver(self, "ingroup");
		self:SetScript("OnAttributeChanged", nil);
		self:UnwrapScript(self, "OnAttributeChanged");
		self:Hide();
	else
		self.SetToggle = "disable";
		headerToUpdate[self] = true;
	end
	
end

local function UpdateFramePoints(self)
	
	if ( not InCombatLockdown() ) then
		self.SetNewPoints = nil;
		
		local frameSpacing = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/FrameSpacing");
		local growUpwards = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/GrowUpwards");
		local showPlayer = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/ShowPlayer");
		local point, relativeTo, relativePoint, yOffset, _;
		local headerHeight, headerWidth;
		
		if ( growUpwards ) then
			point = "BOTTOM"
			relativePoint = "TOP"
		else
			point = "TOP"
			relativePoint = "BOTTOM"
			frameSpacing = -frameSpacing;
		end

		if ( showPlayer ) then
			
			headerHeight = math.abs(frameSpacing) * 4;
			local playerFrame = self["partyPlayerFrame"];
			local _, _, _, xOffset = playerFrame:GetPoint();
			playerFrame:ClearAllPoints();
			playerFrame:SetPoint(point, self, point, xOffset, 0);
		else
			headerHeight = math.abs(frameSpacing) * 3;
		end
		
		for i = 1, 4 do
			local frameRef = "partyFrame"..i;
			local frame = self[frameRef];	
			local _, _, _, xOffset = frame:GetPoint();
			
			frame:ClearAllPoints();
			
			if ( i == 1 ) then
				headerWidth = frame:GetWidth();
				headerHeight = headerHeight + ( frame:GetHeight() * 5 );
				if ( showPlayer ) then
					relativeTo = self["partyPlayerFrame"];
					frame:SetPoint(point, relativeTo, relativePoint, 0, frameSpacing);
				else
					relativeTo = self;
					frame:SetPoint(point, relativeTo, point, xOffset, 0);
				end
				
			else
				relativeTo = self["partyFrame"..i-1];
				frame:SetPoint(point, relativeTo, relativePoint, xOffset, frameSpacing);
			end

		end
		
		self:SetWidth(headerWidth);
		self:SetHeight(headerHeight);
	else
		self.SetNewPoints = true;
		headerToUpdate[self] = true;
	end
end

local function UpdateInArena(self)
	
	if ( not InCombatLockdown() ) then
		self.SetNewInArena = nil;
		local _, instanceType = IsInInstance();
		
		if ( instanceType == "arena" ) then
			self:SetAttribute("inarena", true);
		else
			self:SetAttribute("inarena", nil);
		end
	else
		self.SetNewInArena = true;
		headerToUpdate[self] = true;
	end

end

local function UpdateShowPlayer(self)
	
	if ( not InCombatLockdown() ) then
		self.SetShowPlayer = nil;
		
		local showPlayer = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/ShowPlayer");
		self:SetAttribute("showplayer", showPlayer);

	else
		self.SetShowPlayer = true;
		headerToUpdate[self] = true;
	end

end

local function Update(self)
	
	local playerFrame = self["partyPlayerFrame"];
	if ( self:GetAttribute("showplayer") ) then
		if ( not playerFrame.guid ) then
			playerFrame:SetUnitGUID(playerFrame.unit);
		end
		playerFrame:Update();	
	end
	
	for i = 1, 4 do
		local frameRef = "partyFrame"..i;
		local frame = self[frameRef];
		
		if ( frame.unit and UnitExists(frame.unit) ) then
			frame:SetUnitGUID(frame.unit);
			frame:Update();
		end
	end
end

local function OnAttributeChanged(self, name, value)

	if ( name ~= "inarena" and name ~= "numopponents" and name ~= "alframelock" and name ~= "state-numexistingunits" ) then
		return;
	end
	
	local playerFrame = self["partyPlayerFrame"];
	if ( self:GetAttribute("showPlayer") ) then
		if ( not playerFrame.guid ) then
			playerFrame:SetUnitGUID(playerFrame.unit);
		end		
		playerFrame:Update();
	end
	
	for i = 1, 4 do
		local frameRef = "partyFrame"..i;
		local frame = self[frameRef];
		
		if ( frame and frame:IsVisible() ) then
			frame:SetUnitGUID(frame.unit);
			frame:Update();
		end
	end
	
end

-- *** HANDLER FUNCTIONS ***
function PartyHeader:AddFrame (header, addon, frameType, partyFrame1, partyFrame2, partyFrame3, partyFrame4, partyPlayerFrame)

	if ( not InCombatLockdown() ) then
		--SecureHandler_OnLoad(self)
		
		header.addonName = addon;
		header.frameType = frameType;
		
		-- Create a handlerlist.
		header.handlerList = {};
		
		-- Set global references:
		header.partyFrame1 = partyFrame1;
		header.partyFrame2 = partyFrame2;
		header.partyFrame3 = partyFrame3;
		header.partyFrame4 = partyFrame4;
		header.partyPlayerFrame = partyPlayerFrame;
		
		--[[ Set frame references for all 5 party frames in the restricted environment:
		header:SetFrameRef("PartyFrame1", partyFrame1);
		header:SetFrameRef("PartyFrame2", partyFrame2);
		header:SetFrameRef("PartyFrame3", partyFrame3);
		header:SetFrameRef("PartyFrame4", partyFrame4);
		header:SetFrameRef("PartyPlayerFrame", partyPlayerFrame);]]
		
		-- Set basic functions
		header.Enable = Enable;
		header.Disable = Disable;
		header.Update = Update;
		header.UpdateInArena = UpdateInArena;
		header.UpdateShowPlayer = UpdateShowPlayer;
		header.UpdateFramePoints = UpdateFramePoints;
		header.OnAttributeChanged = OnAttributeChanged;
		
		-- Set Frame points according to saved variables.
		header:UpdateFramePoints();

		PartyHeader.HeaderTable[header] = true;
	else
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_ARENAHEDER_COMBATLOCKDOWN"), "error");
	end

end
--[[
function PartyHeader:UNIT_NAME_UPDATE(header, unitNumber, unit)
	
	if ( unit == "player" ) then
		local playerFrame = header["partyPlayerFrame"];
		if ( header:GetAttribute("showplayer") ) then
			if ( not playerFrame.guid ) then
				playerFrame:SetUnitGUID(playerFrame.unit);
			end
			playerFrame:Update();
		end		
	elseif ( unitNumber > 0 ) then
		local frameRef = "partyFrame"..unitNumber;
		local frame = header[frameRef];
		
		if ( frame ) then
			if ( frame.unit ) then
				frame:SetUnitGUID(frame.unit);
			end
			frame:Update();
		end
	end

end
]]--
function PartyHeader:OnEvent(event, ...)

	if ( event == "PLAYER_REGEN_ENABLED" ) then
	
		for header, value in pairs(headerToUpdate) do
			
			if ( header and value ) then
				
				if ( header.SetToggle == "enable" ) then
					header:Enable();
				elseif ( header.SetToggle == "disable" ) then
					header:Disable();
				end
				
				if ( header.SetShowPlayer ) then
					UpdateShowPlayer(self);
				end
				
				if ( header.SetNewInArena ) then
					header:UpdateInArena();
				end
				
				if ( header.SetNewPoints ) then
					header:UpdateFramePoints()
				end
			end
			
			headerToUpdate[header] = nil;
		end
		
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		for header, value in pairs(PartyHeader.HeaderTable) do
		
			if ( header and value ) then
				header:UpdateInArena();
				header:Update();
			end
		end
	elseif ( event == "GROUP_ROSTER_UPDATE" ) then
		for header, value in pairs(PartyHeader.HeaderTable) do
		
			if ( header and value ) then
				header:Update();
			end
		end
	--[[elseif ( event == "UNIT_NAME_UPDATE" ) then
		local unit = ...;
		local unitNumber = tonumber(string.match(unit, "^[a-z]+([0-9]+)$")) or 0;
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		
		if ( unitType == "player" or unitType == "party" ) then
			for header, value in pairs(PartyHeader.HeaderTable) do
			
				if ( header and value ) then
					 PartyHeader:UNIT_NAME_UPDATE(header, unitNumber, ...)
				end
			end
		end]]--
	end

end