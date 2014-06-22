--[[ ArenaLive Core Functions: ArenaHeader Handler
Created by: Vadrak
Creation Date: 04.07.2013
Last Update: "
These functions are used to set up every group header for arena frames.
It will store all ArenaLive based group headers that show arena target units in a table.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local ArenaHeader = ArenaLiveCore:AddHandler("ArenaHeader", "EventCore");
ArenaHeader:RegisterEvent("PLAYER_REGEN_ENABLED");
ArenaHeader:RegisterEvent("PLAYER_ENTERING_WORLD");
ArenaHeader:RegisterEvent("ARENA_OPPONENT_UPDATE");
ArenaHeader:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Set up the header storage table.
ArenaHeader.HeaderTable = {};

-- Set up a table for frames that need a update after CombatLockDown fades.
local headerToUpdate = {};


-- *** FRAME FUNCTIONS ***
-- self, name, value
local onAttributeChangedSnippet = [[
 if ( name ~= "inarena" and name ~= "numopponents" and name ~= "alframelock" and name ~= "state-unitsexist" ) then
  return;
 end

 local numOpponents = self:GetAttribute("numopponents");
  
 if ( not self:GetAttribute("inarena") and numOpponents > 0 ) then
  self:SetAttribute("numopponents", 0);
 end
 
 if (not self:GetAttribute("alframelock") ) then
  self:Show();
    for i=1, 5 do
	 local frameRef = "ArenaFrame"..i;
	 local frame = self:GetFrameRef(frameRef);
	 UnregisterUnitWatch(frame);
	 if ( not frame:IsShown() ) then
	 frame:Show();
	 end
    end
 elseif ( self:GetAttribute("inarena") ) then
   for i=1, 5 do
	local frameRef = "ArenaFrame"..i;
	local frame = self:GetFrameRef(frameRef);
	UnregisterUnitWatch(frame);
	if ( i <= numOpponents ) then
	 frame:Show();
	else
	 frame:Hide();
    end
   end
   self:Show();
 elseif ( self:GetAttribute("state-unitsexist") ) then 
  self:Show();
  for i = 1, 5 do
   local frameRef = "ArenaFrame"..i;
   local frame = self:GetFrameRef(frameRef);
   RegisterUnitWatch(frame);
  end
 else
  for i = 1, 5 do
   local frameRef = "ArenaFrame"..i;
   local frame = self:GetFrameRef(frameRef);
   UnregisterUnitWatch(frame);
  end
  self:Hide();
 end 

]];

local unitsExistSnippet = [[ [target=arena1, exists, nodead] true; [target=arena2, exists, nodead] true; [target=arena3, exists, nodead] true; [target=arena4, exists, nodead] true; [target=arena5, exists, nodead] true; nil  ]];

local function Enable (self)
	if ( not InCombatLockdown() ) then
		self.SetToggle = nil;
		
		RegisterStateDriver(self, "unitsexist", unitsExistSnippet);
		self:SetScript("OnAttributeChanged", self.OnAttributeChanged);
		--self:WrapScript(self, "OnAttributeChanged", onAttributeChangedSnippet);
	else
		self.SetToggle = "enable";
		headerToUpdate[self] = true;
	end
end

local function Disable (self)

	if ( not InCombatLockdown() ) then
		self.SetToggle = nil;

		UnregisterStateDriver(self, "unitsexist");
		self:SetScript("OnAttributeChanged", nil);
		self:UnwrapScript(self, "OnAttributeChanged");
	else
		self.SetToggle = "disable";
		headerToUpdate[self] = true;
	end
	
end

local function LockFrame(self, frame)
	
	if ( frame.handlerList.healthBar ) then
		frame.healthBar.lockValues = true;
		frame.healthBar.lockColour = true;
		frame.healthBar:SetStatusBarColor(0.5, 0.5, 0.5);
	end
	
	if ( frame.handlerList.powerBar ) then
		frame.powerBar.lockValues = true;
		frame.powerBar.lockColour = true;
		frame.powerBar:SetStatusBarColor(0.5, 0.5, 0.5);
	end

end

local function UnlockFrame(self, frame)

	if ( frame.handlerList.healthBar ) then
		frame.healthBar.lockValues = nil;
		frame.healthBar.lockColour = nil;
		frame.healthBar:Update();
	end
	
	if ( frame.handlerList.powerBar ) then
		frame.powerBar.lockValues = nil;
		frame.powerBar.lockColour = nil;
		frame.powerBar:Update();
	end

end

local function UpdateFramePoints(self)
	
	if ( not InCombatLockdown() ) then
		self.SetNewPoints = nil;
		local frameSpacing = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/FrameSpacing");
		local growUpwards = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/GrowUpwards");
		local point, relativeTo, relativePoint, yOffset, _;
		local headerHeight, headerWidth;
		headerHeight = frameSpacing * 4;
		if ( growUpwards ) then
			point = "BOTTOM"
			relativePoint = "TOP"
		else
			point = "TOP"
			relativePoint = "BOTTOM"
			frameSpacing = -frameSpacing;
		end
		
		for i = 1, 5 do
			local frameRef = "arenaFrame"..i;
			local frame = self[frameRef];	
			local _, _, _, xOffset = frame:GetPoint();
			frame:ClearAllPoints();
			
			if ( i == 1 ) then
				headerWidth = frame:GetWidth();
				headerHeight = headerHeight + ( frame:GetHeight() * 5 );
				relativeTo = self;
				frame:SetPoint(point, relativeTo, point, xOffset, 0);
			else
				relativeTo = self["arenaFrame"..i-1];
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
		local currentValue = self:GetAttribute("inarena");
		
		if ( instanceType == "arena" ) then
			if ( not currentValue ) then
				self:SetAttribute("inarena", true);
			end
		else
			if ( currentValue ) then
				self:SetAttribute("inarena", nil);
			end
		end
	else
		self.SetNewInArena = true;
		headerToUpdate[self] = true;
	end

end

local function UpdateNumOpponents(self)
	
	if ( not InCombatLockdown() ) then
		self.SetNewNumOpponents = nil;
		local _, instanceType = IsInInstance();
		
		if ( instanceType ~= "arena" ) then
			return;
		end
		
		local numOpponents = GetNumArenaOpponentSpecs() or 0;
		if ( numOpponents == 0 ) then
			numOpponents = GetNumArenaOpponents() or 0;
		end
				
		self:SetAttribute("numopponents", numOpponents);
	else
		self.SetNewNumOpponents = true;
		headerToUpdate[self] = true;
	end

end

local function Update(self)
	self:UpdateInArena();
	self:UpdateNumOpponents();
end

local function OnAttributeChanged(self, name, value)

	if ( name ~= "inarena" and name ~= "numopponents" and name ~= "alframelock" and name ~= "state-numexistingunits" ) then
		return;
	end
	
	local numOpponents = self:GetAttribute("numopponents");
	local inarena = self:GetAttribute("inarena");
	if ( value and (name == "numopponents" or name == "inarena") and numOpponents > 0 ) then
		for i = 1, value do
			local frameRef = "arenaFrame"..i;
			local frame = self[frameRef];			
			
			-- If there are no opponents, then we're probably in the preparation room, so lock frames to make sure health and power bar are set to 100% and grey.
			if ( GetNumArenaOpponents() == 0 ) then
				self:LockFrame(frame);
				if ( frame.healthBar ) then
					frame.healthBar:Reset();
				end
				if ( frame.powerBar ) then
					frame.powerBar:Reset();
				end
			end
		end
	end	
	
	for i = 1, 5 do
		local frameRef = "arenaFrame"..i;
		local frame = self[frameRef];
		
		if ( frame and frame:IsVisible() ) then
			frame:Update();
		end
	end

end

-- *** HANDLER FUNCTIONS ***
function ArenaHeader:AddFrame (header, addon, frameType, arenaFrame1, arenaFrame2, arenaFrame3, arenaFrame4, arenaFrame5)

	if ( not InCombatLockdown() ) then
		--SecureHandler_OnLoad(self)
		
		header.addonName = addon;
		header.frameType = frameType;
		
		-- Create a handlerlist.
		header.handlerList = {};
		
		-- Set global references:
		header.arenaFrame1 = arenaFrame1;
		header.arenaFrame2 = arenaFrame2;
		header.arenaFrame3 = arenaFrame3;
		header.arenaFrame4 = arenaFrame4;
		header.arenaFrame5 = arenaFrame5;
		
		--[[ Set frame references for all 5 arenaframes in the restricted environment:
		header:SetFrameRef("ArenaFrame1", arenaFrame1);
		header:SetFrameRef("ArenaFrame2", arenaFrame2);
		header:SetFrameRef("ArenaFrame3", arenaFrame3);
		header:SetFrameRef("ArenaFrame4", arenaFrame4);
		header:SetFrameRef("ArenaFrame5", arenaFrame5);]]
		
		-- Set initial value for numOpponent attribute.
		header:SetAttribute("numopponents", 0);
		
		-- Set basic functions
		header.Enable = Enable;
		header.Disable = Disable;
		header.LockFrame = LockFrame;
		header.UnlockFrame = UnlockFrame;
		header.Update = Update;
		header.UpdateInArena = UpdateInArena;
		header.UpdateNumOpponents = UpdateNumOpponents;
		header.UpdateFramePoints = UpdateFramePoints;
		header.OnAttributeChanged = OnAttributeChanged;
		
		-- Set Frame points according to saved variables.
		header:UpdateFramePoints();

		-- Enable/Disable Header according to saved variables
		local enabled = ArenaLiveCore:GetDBEntry(addon, header.frameType.."/Enabled");
		
		if ( enabled ) then
			header:Enable();
		else
			header:Disable();
		end
		
		ArenaHeader.HeaderTable[header] = true;
	else
		ArenaLiveCore:Message(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_ARENAHEDER_COMBATLOCKDOWN"), "error");
	end

end

function ArenaHeader:ARENA_OPPONENT_UPDATE(header, unit, state)

	-- Make sure that all enemies are shown.
	if ( header:GetAttribute("numopponents") < GetNumArenaOpponents() ) then
		header:UpdateNumOpponents();
	end

	local unitNumber = tonumber(string.match(unit, "^[a-z]+([0-9]+)$")) or 0;
	local frame;
	
	if ( unitNumber > 0 ) then
		frame = header["arenaFrame"..unitNumber];
	end
	
	if ( not frame ) then
		return;
	end

	--[[ INFORMATION ON ARENA_OPPONENT_UPDATE:
		 seen = An enemy gets visible
		 unseen = An enemy gets invisible to the player or releases his/her Ghost.
		 destroyed = An enemy leaves the Arena.
		 cleared = This fires, after you leave the Arena.
	]]--	
	if ( state == "seen" and UnitGUID(unit) ) then -- Blizzard uses "UnitGUID" instead of UnitExists in case it's a remote udpate. I, however, experienced problems with empty frames, so I'll stick with UnitExists instead.
		header:UnlockFrame(frame);
		frame:SetUnitGUID(frame.unit);
		frame:Update();
	elseif ( state == "destroyed" ) then
		header:UnlockFrame(frame);
		frame:Update();
	elseif ( state == "cleared" ) then
		header:UnlockFrame(frame);
		frame:ResetUnitGUID();
		frame:Reset();
	elseif ( state == "unseen" ) then
		header:LockFrame(frame);
	end
end

function ArenaHeader:OnEvent(event, ...)

	if ( event == "PLAYER_REGEN_ENABLED" ) then
	
		for header, value in pairs(headerToUpdate) do
			
			if ( header and value ) then
				
				if ( header.SetToggle == "enable" ) then
					header:Enable();
				elseif ( header.SetToggle == "disable" ) then
					header:Disable();
				end
				
				if ( header.SetNewInArena ) then
					header:UpdateInArena();
				end
				
				if ( header.SetNewNumOpponents ) then
					header:UpdateNumOpponents();
				end
				
				if ( header.SetNewPoints ) then
					header:UpdateFramePoints()
				end
			end
			
			headerToUpdate[header] = nil;
		end
		
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		for header, value in pairs(ArenaHeader.HeaderTable) do
		
			if ( header and value ) then
				header:Update();
			end
		end
	elseif ( event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" ) then
		for header, value in pairs(ArenaHeader.HeaderTable) do
		
			if ( header and value ) then
				header:UpdateNumOpponents();
			end
		end
	elseif ( event == "ARENA_OPPONENT_UPDATE" ) then
		for header, value in pairs(ArenaHeader.HeaderTable) do
		
			if ( header and value ) then
				 ArenaHeader:ARENA_OPPONENT_UPDATE(header, ...)
			end
		end		
	end

end

