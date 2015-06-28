--[[ ArenaLive Core Functions: DRTracker Handler
Created by: Vadrak
Creation Date: 23.06.2013
Last Update: 05.07.2013
This file handles the diminishing return tracking system. It uses combat log instead of the UNIT_AURA event, because the combat log fires for fading auras.
	- Diminishing Returns seem to have a 17 to 18 seconds duration AFTER the spell FADES (depends on the player's latency I guess).
	- The first DR has full duration, the second 50%, the last 25%.
	- A table needs to store the duration of DRs.
	- "COMBAT_LOG_EVENT_UNFILTERED" can track fading buffs/debuffs:
		SPELL_AURA_REMOVED -> Should fire when a buff/debuff has run out or was dispelled etc.
			-> After that 17 Sec duration on the DR-Type.
			-> GUID instead of unitID, because combat log doesn't announce unitIDs.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local DRTracker = ArenaLiveCore:AddHandler("DRTracker", "EventCore");

-- Get the global UnitFrame and Cooldown handlers.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local Cooldown = ArenaLiveCore:GetHandler("Cooldown");

-- Register the handler for all needed events.
DRTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_AURA_APPLIED");
DRTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_AURA_REFRESH");
DRTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_AURA_REMOVED");

-- Constant for the duration of DRs
local DIMINISHING_RETURN_DURATION = 18;



-- *** FRAME FUNCTIONS ***
local function Enable (self)
	self.enabled = true;
	self.unitFrame.handlerList.drTracker = true;
	self:Reset();
end

local function Disable (self)
	self.enabled = nil;
	self.unitFrame.handlerList.drTracker = nil;
	self:Reset();
end

local function Update (self)

	local unit = self.unitFrame.unit;
	
	if ( unit and UnitExists(unit) ) then
		DRTracker:UpdateIcons(self);
	else
		self:Reset();
	end

end

function UpdatePoints(self)
	local point, relativeTo, RelativePoint, xOffset, yOffset = self:GetPoint(); 
	local direction = string.match(RelativePoint, "(LEFT)$"); 
	local iconPoint;
	if ( not direction ) then 
		direction = string.match(RelativePoint, "(RIGHT)$"); 
	end
	
	if ( direction == "LEFT" ) then
		iconPoint = "RIGHT";
		xOffset = -5;
	elseif ( direction == "RIGHT" ) then
		iconPoint = "LEFT";
		xOffset = 5;
	end
	
	for i = 1, self.numIcons do
		local icon = self["icon"..i];
		icon:ClearAllPoints();
		
		if ( i == 1 ) then
			icon:SetPoint(iconPoint, self, iconPoint, 0, 0);
		else
			icon:SetPoint(iconPoint, self["icon"..i-1], direction, xOffset, 0);
		end	
	end
end

local function OnUpdate (self, elapsed)
	
	local drTypeCount = #(self.drStorage);
	
	if ( drTypeCount > 0 ) then
		local theTime = GetTime();
		
		for key, value in ipairs(self.drStorage) do
			if ( not self.drStorage[key]["waitForRemoval"] ) then
				-- The DR timer has been started.
				local expires = self.drStorage[key]["expirationTime"];
				
				if ( theTime >= expires ) then
					-- Diminishing return ran out -> Delete it.
					local drType = self.drStorage[key]["type"]
					self.indexToDRType[drType] = nil;
					table.remove(self.drStorage, key);
					
					-- In order to keep the correct order of DR types, it is important to reduce the indexes by 1 for every DR hat a higher index than the one that ran out.
					for updateType, index in pairs(self.indexToDRType) do
						if ( index > key ) then
							self.indexToDRType[updateType] = index - 1;
						end
					end
					DRTracker:UpdateIcons(self);
				end
			end
		end
	end
end

local function OnHide (self)
	table.wipe(self.drStorage);
	table.wipe(self.indexToDRType);
	
	local numIcons = self.numIcons;
	for i = 1, numIcons do
		local icon = self["icon"..i];
		DRTracker:ResetIcon(icon);
	end
end

local function Reset (self)
	self:Hide();
	table.wipe(self.drStorage);
	table.wipe(self.indexToDRType);
	
	local numIcons = self.numIcons;
	for i = 1, numIcons do
		local icon = self["icon"..i];
		DRTracker:ResetIcon(icon);
	end
end



-- *** HANDLER FUNCTIONS ***
function DRTracker:AddFrame (drTracker, numIcons, iconTemplate, unitFrame)

	-- Create a reference for the target indicator inside the unit frame and vice versa.
	unitFrame.drTracker = drTracker;
	drTracker.unitFrame = unitFrame;
	
	-- Set the basic functions for the dr tracker.
	drTracker.Enable = Enable;
	drTracker.Disable = Disable;
	drTracker.UpdatePoints = UpdatePoints;
	drTracker.Update = Update;
	drTracker.OnUpdate = OnUpdate;
	drTracker.OnHide = OnHide;
	drTracker.Reset = Reset;

	-- Set the number of active icons and 
	drTracker.numIcons = numIcons;	
	
	-- Create the icons.
	for i = 1, numIcons do
		DRTracker:CreateIcon(drTracker, iconTemplate, i);
	end
	
	-- create a dr storage table and a table to store which icon ID is occupied by which type of diminishing return.
	drTracker.drStorage = {};
	drTracker.indexToDRType = {};
	
	-- Enable/Disable the aura frame according to saved variables.
	local DBKey = unitFrame.frameType.."/DRTracker/Enabled";
	local enabled = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
	
	if ( enabled ) then
		drTracker:Enable();
	else
		drTracker:Disable();
	end	
	
	-- Update initial size.
	DRTracker:UpdateSize(drTracker);
	
	-- Set Scripts for the DRTracker.
	drTracker:SetScript("OnUpdate", drTracker.OnUpdate);
	drTracker:SetScript("OnHide", drTracker.OnHide);
end

local newDRInfo = {};
function DRTracker:AddDR (drTracker, spellID, sourceGUID, destGUID)

	local drType = ArenaLiveCore.spellDB["diminishingReturns"][spellID];
	local drTypeIndex = drTracker.indexToDRType[drType];
	drTracker:Show();
	
	if ( drTracker.drStorage[drTypeIndex] ) then
		drTracker.drStorage[drTypeIndex]["spellID"] = spellID;
		
		-- The DR Type is already active. If it is already fully dr'd just update the icon.
		if ( drTracker.drStorage[drTypeIndex]["stacks"] < 3 ) then
			drTracker.drStorage[drTypeIndex]["waitForRemoval"] = true;
			drTracker.drStorage[drTypeIndex]["expirationTime"] = nil;
			drTracker.drStorage[drTypeIndex]["stacks"] = drTracker.drStorage[drTypeIndex]["stacks"] + 1;
			
			-- Update the icon with the new data and reset cooldown, since we must wait until the aura is removed again.
			if ( drTypeIndex <= drTracker.numIcons ) then
				local icon = drTracker["icon"..drTypeIndex];
				DRTracker:UpdateIcon(icon, spellID, drTracker.drStorage[drTypeIndex]["stacks"]);
				icon.cooldown:Reset();
			end
		else
			-- Only update the texture, to indicate that the cast spell was from the same type.
			if ( drTypeIndex <= drTracker.numIcons ) then
				local icon = drTracker["icon"..drTypeIndex];
				DRTracker:UpdateIcon(icon, spellID, drTracker.drStorage[drTypeIndex]["stacks"]);
			end
		end
	else
		-- Set the number for this drType.
		local drIndex = (#drTracker.drStorage or 0 ) + 1;
		
		-- This is a new DR type, add it to the table.
		drTracker.drStorage[drIndex] = {};
		drTracker.drStorage[drIndex]["type"] = drType;
		drTracker.drStorage[drIndex]["spellID"] = spellID;
		drTracker.drStorage[drIndex]["waitForRemoval"] = true;
		drTracker.drStorage[drIndex]["expirationTime"] = nil;
		drTracker.drStorage[drIndex]["stacks"] = 1;

		drTracker.indexToDRType[drType] = drIndex;

		if ( drIndex <= drTracker.numIcons ) then
			DRTracker:UpdateIcon(drTracker["icon"..drIndex], spellID, 1);
		end		
	end

end

function DRTracker:StartDR (drTracker, spellID, sourceGUID, destGUID)

	local drType = ArenaLiveCore.spellDB["diminishingReturns"][spellID];
	local drTypeIndex = drTracker.indexToDRType[drType];

	--[[ Can't start the DR, beacuse there is no index for this DR type.
		 This basically happens, if a diminishing return debuff runs out, after we've reset the tables somehow. ]]--
	if ( not drTypeIndex ) then
		return;
	end
	
	local startTime =  GetTime();
	local expirationTime = startTime + DIMINISHING_RETURN_DURATION;
	
	
	if ( drTracker.drStorage[drTypeIndex] and spellID == drTracker.drStorage[drTypeIndex]["spellID"] ) then
		-- A diminishing return aura has run out. Start the DR timer.
		if ( drTracker.drStorage[drTypeIndex]["stacks"] < 3 or drTracker.drStorage[drTypeIndex]["waitForRemoval"] ) then
			drTracker.drStorage[drTypeIndex]["waitForRemoval"] = nil;
			drTracker.drStorage[drTypeIndex]["expirationTime"] = expirationTime;
			
			if ( drTypeIndex <= drTracker.numIcons ) then
				-- If the DR type uses an icon, then set the Cooldown for it.
				local icon = drTracker["icon"..drTypeIndex];
				icon.cooldown:Set(startTime, DIMINISHING_RETURN_DURATION);
			end
		end
	end
end

function DRTracker:UpdateIcons (drTracker)

	local drCount = #drTracker.drStorage;
	local numIcons = drTracker.numIcons;

	
	if ( drCount > 0 ) then
		for i = 1, numIcons do
			local icon = drTracker["icon"..i];
			
			if ( drTracker.drStorage[i] ) then
				DRTracker:UpdateIcon(icon, drTracker.drStorage[i]["spellID"], drTracker.drStorage[i]["stacks"]);
				
				-- Update the cooldown, if the timer for this frame has been started already.
				if ( not drTracker.drStorage[i]["waitForRemoval"] and drTracker.drStorage[i]["expirationTime"] ) then
					local startTime = drTracker.drStorage[i]["expirationTime"] - DIMINISHING_RETURN_DURATION;
					icon.cooldown:Set(startTime, DIMINISHING_RETURN_DURATION);
				end
			else
				DRTracker:ResetIcon(icon);
			end
		end
	else
		for i = 1, numIcons do
			local icon = drTracker["icon"..i];
			DRTracker:ResetIcon(icon);
		end
	end
	
end

function DRTracker:UpdateSize(drTracker)

	local numIcons = drTracker.numIcons;
	local iconSize = ArenaLiveCore:GetDBEntry(drTracker.unitFrame.addonName, drTracker.unitFrame.frameType.."/DRTracker/IconSize");
	
	local trackerWidth;
	if ( numIcons > 0 ) then
		trackerWidth = (iconSize * numIcons) + ( 5 * ( numIcons - 1 ) );
	else
		trackerWidth = 1;
	end
	
	drTracker:SetWidth(trackerWidth);
	drTracker:SetHeight(iconSize);
	
	for i = 1, numIcons do
		local icon = drTracker["icon"..i];
		local countSize = iconSize / 3;
		icon:SetWidth(iconSize);
		icon:SetHeight(iconSize);
		icon.count:SetWidth(countSize);
		icon.count:SetHeight(countSize);
		Cooldown:UpdateTextSize(icon.cooldown);
	end	
end

function DRTracker:CreateIcon (drTracker, iconTemplate, index)

		local prefix = drTracker:GetName();
		local iconName = prefix.."Icon"..index;
		local icon = CreateFrame("Frame", iconName, drTracker, iconTemplate, index);
		local iconSize = ArenaLiveCore:GetDBEntry(drTracker.unitFrame.addonName, drTracker.unitFrame.frameType.."/DRTracker/IconSize");
		icon:SetWidth(iconSize);
		icon:SetHeight(iconSize);

		local point, relativeTo, RelativePoint, xOffset, yOffset = drTracker:GetPoint(); 

		local direction = string.match(RelativePoint, "(LEFT)$"); 
		local iconPoint;
		
		if ( not direction ) then 
			direction = string.match(RelativePoint, "(RIGHT)$"); 
		end
	
		if ( direction == "LEFT" ) then
			iconPoint = "RIGHT";
			xOffset = -5;
		elseif ( direction == "RIGHT" ) then
			iconPoint = "LEFT";
			xOffset = 5;
		end

		icon:ClearAllPoints();
		
		if ( index == 1 ) then
			icon:SetPoint(iconPoint, drTracker, iconPoint, 0, 0);
		else
			icon:SetPoint(iconPoint, drTracker["icon"..index-1], direction, xOffset, 0);
		end	
		
		drTracker["icon"..index] = icon;
		icon.texture = _G[iconName.."Texture"];
		icon.count = _G[iconName.."Count"];
		
		Cooldown:AddFrame(_G[iconName.."Cooldown"], _G[iconName.."CooldownText"], icon)
end

function DRTracker:UpdateIcon (icon, spellID, stacks)

	local _, _, texture = GetSpellInfo(spellID)
	
	icon:Show();
	icon.isActive = true;
	
	if ( texture ) then
		icon.texture:SetTexture(texture);
	end
	
	if ( stacks >= 3 ) then
		-- Red for full DR
		icon.count:SetTexture(1, 0, 0);
	elseif ( stacks == 2 ) then
		-- Yellow for 1/4 DR
		icon.count:SetTexture(1, 1, 0);
	elseif ( stacks == 1 ) then
		-- Green for 1/2 DR
		icon.count:SetTexture(0, 1, 0);
	end

end

function DRTracker:ResetIcon (icon)
	icon:Hide();
	icon.isActive = nil;
	icon.texture:SetTexture();
	icon.count:SetTexture();
	icon.cooldown:Reset();
end

function DRTracker:OnEvent (event, ...)

	local sourceGUID = select(4, ...);
	local destGUID = select(8, ...);
	local spellID = select(12, ...);

	if ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_AURA_APPLIED" or event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_AURA_REFRESH" ) then
		if ( ArenaLiveCore.spellDB["diminishingReturns"][spellID] and sourceGUID ~= destGUID ) then
			if ( UnitFrame.UnitGUIDTable[destGUID] ) then
				for key, value in pairs(UnitFrame.UnitGUIDTable[destGUID]) do
					if ( value and UnitFrame.UnitFrameTable[key] ) then
						affectedFrame = UnitFrame.UnitFrameTable[key];
							
						if ( affectedFrame.handlerList.drTracker ) then
							DRTracker:AddDR(affectedFrame.drTracker, spellID, sourceGUID, destGUID)
						end
					end
				end
			end
		end
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_AURA_REMOVED" ) then
		if ( ArenaLiveCore.spellDB["diminishingReturns"][spellID] ) then
			if ( UnitFrame.UnitGUIDTable[destGUID] ) then
				for key, value in pairs(UnitFrame.UnitGUIDTable[destGUID]) do
					if ( value and UnitFrame.UnitFrameTable[key] ) then
						affectedFrame = UnitFrame.UnitFrameTable[key];
							
						if ( affectedFrame.handlerList.drTracker ) then
							DRTracker:StartDR(affectedFrame.drTracker, spellID, sourceGUID, destGUID)
						end
					end
				end
			end
		end		
	end

end