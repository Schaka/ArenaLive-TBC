--[[ ArenaLive Core Functions: Aura Handler
Created by: Vadrak
Creation Date: 16.06.2013
Last Update: "
This file stores the basic functions for the aura display and the aura header for player buffs.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local Aura = ArenaLiveCore:AddHandler("Aura", "EventCore");

-- Get the global UnitFrame and Cooldown handlers.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local Cooldown = ArenaLiveCore:GetHandler("Cooldown");

-- Register the handler for all needed events.
Aura:RegisterEvent("UNIT_AURA");

-- Set two constants for the maximal amount of buffs and debuffs
local NUM_MAX_BUFFS = 40;
local NUM_MAX_DEBUFFS = 40;

-- Set up a table containing all units that are controled by the player to seperate normal from large icons.
local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};

-- Constants for x and y offset.
local AURA_X_OFFSET = 3;
local AURA_Y_OFFSET = 3;

-- *** FRAME FUNCTIONS ***
local function Enable (self)
	self.enabled = true;
	self.unitFrame.handlerList.auraFrame = true;
	self:Show();
end

local function Disable (self)
	self.enabled = nil;
	self.unitFrame.handlerList.auraFrame = nil;
	self:Hide();
end

-- Outside the function to reduce garbage
local largeBuffList = {};
local largeDebuffList = {};
local colour = {};
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit or not self.enabled ) then
		return;
	end
	
	if ( not self:IsShown() ) then
		self:Show();
	end
	
	local prefix = self.buffFrame:GetName();
	local maxRowWidth = self:GetWidth();
	local frame, frameName;	
	local name, rank, icon, count, dispelType, duration, expires, isMine;
	
	local maxShownBuffs = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/AuraFrame/MaxShownBuffs");
	local maxShownDebuffs = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/AuraFrame/MaxShownDebuffs");
	local onlyShowRaidBuffs = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, "Auras/OnlyShowCastableBuffs");
	local onlyShowDispellableDebuffs = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, "Auras/OnlyShowDispellableDebuffs");
	local tournamentStyle = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, "Auras/TournamentFilter"); -- DO NOT USE THIS FOR NORMAL UNITFRAMES
	
	local playerIsUnit = UnitIsUnit("player", unit);
	local canAssist = UnitCanAssist("player", unit);
	
	local filter;
	if ( onlyShowRaidBuffs and canAssist ) then
		filter = "RAID";
	end	
	
	-- Handle Buff display
	local numBuffs = 0;
	local frameID = 1;
	local auraID = 1;
	
	while frameID <= NUM_MAX_BUFFS do
		
		frameName = prefix.."Icon"..frameID;
		frame = _G[frameName];
		
		-- Retrieve buff info for the unit
		name, rank, icon, count, duration, expires, isMine = UnitBuff(unit, auraID, filter);
		if ( frameID <= maxShownBuffs and icon ) then
			
			-- Check if the buff is filtered or not.
			if ( Aura:ShouldShowBuff(self, unit, auraID, filter) ) then
				if ( not frame ) then
					-- Not enough buff icons exist so create a new one.
					frame = Aura:CreateIcon(self, frameID, "BUFF");
				end
				
				-- Set tooltip relevant info.
				frame.unit = unit;
				frame:SetID(auraID);
				frame.filter = filter;
				
				-- Set buff texture.
				frame.icon:SetTexture(icon);
				
				-- Set the display of buff stacks, if necessary.
				if ( count and count > 1 ) then
					if ( frame.count ) then
						frame.count:SetText(count);
						frame.count:Show();
					end
				else
					if ( frame.count ) then
						frame.count:Hide();
					end
				end
				
				-- Set the cooldown duration
				if ( duration and duration > 0 ) then
					if ( frame.cooldown ) then
						local startTime = duration - expires;
						frame.cooldown:Set(GetTime() - startTime, duration);
					end
				else
					if ( frame.cooldown ) then
						frame.cooldown:Reset();
					end
				end
				
				if ( not playerIsUnit and isStealable ) then
					if ( frame.stealable ) then
						frame.stealable:Show();
					end
				else
					if ( frame.stealable ) then
						frame.stealable:Hide();
					end
				end
				
				-- Set the buff to be big if the buff is cast by the player or his pet
				if isMine then
					largeBuffList[auraID] = true;
				else
					largeBuffList[auraID] = false;
				end
				
				numBuffs = numBuffs + 1;
				frameID = frameID + 1;
			end
		else
			-- Hide all unnecessary frames and break the loop, if there are no frames left.
			if ( frame ) then
				frame:Hide();
				frameID = frameID + 1;
			else
				break;
			end
			
			
		end
		
		auraID = auraID + 1;
	end
	
	-- Reset the filters for debuff handling.
	if ( onlyShowDispellableDebuffs and canAssist ) then
		filter = "RAID";
	else
		filter = nil;
	end		
		
	-- Reset frame and aura IDs and then retrieve debuff info for the unit.
	local numDebuffs = 0;
	frameID = 1;
	auraID = 1;		
	local prefix = self.debuffFrame:GetName();
	
	while frameID <= NUM_MAX_DEBUFFS do
		frameName = prefix.."Icon"..frameID;
		frame = _G[frameName];
		
		name, rank, icon, count, dispelType, duration, expires, isMine = UnitDebuff(unit, auraID, filter);
		
		if ( frameID <= maxShownDebuffs and icon ) then
			
			-- Check if the debuff is filtered or not.
			if ( Aura:ShouldShowDebuff(self, unit, auraID, filter) ) then
				if ( not frame ) then
					-- Not enough debuff icons exist so create a new one.
					frame = Aura:CreateIcon(self, frameID, "DEBUFF");
				end
			
				-- Set tooltip relevant info.
				frame.unit = unit;
				frame:SetID(auraID);
				frame.filter = filter;
			
				-- Set debuff texture.
				frame.icon:SetTexture(icon);
			
				-- Set the display of buff stacks, if necessary.
				if ( count > 1 ) then
					if ( frame.count ) then
						frame.count:SetText(count);
						frame.count:Show();
					end
				else
					if ( frame.count ) then
						frame.count:Hide();
					end
				end
				
				-- Set the cooldown duration
				if ( duration and duration > 0 ) then
					if ( frame.cooldown ) then
						local startTime = duration - expires;
						frame.cooldown:Set(GetTime()-startTime, duration);
					end
				else
					if ( frame.cooldown ) then
						frame.cooldown:Reset();
					end
				end

				if ( dispelType ) then
					colour = DebuffTypeColor[dispelType];
				else
					colour = DebuffTypeColor["none"];
				end

				-- Set border colour for the debuff, if necessary.
				if ( frame.border) then
					frame.border:SetVertexColor(colour.r, colour.g, colour.b);
				end
				
				-- Set the debuff to be big if the buff is cast by the player or his pet
				if isMine then
					largeDebuffList[auraID] = true;
				else
					largeDebuffList[auraID] = false;
				end
				
				numDebuffs = numDebuffs + 1;
				frameID = frameID + 1;
			end
		else
			-- Hide all unnecessary frames and break the loop, if there are no frames left.
			if ( frame ) then
				frame:Hide();
				frameID = frameID + 1;
			else
				break;
			end			
			
		end
		
		auraID = auraID + 1;
	end
	
	local buffFrameheight, debuffFrameheight;
	
	-- Update buff positions, the functions returns the height of the frame.
	buffFrameheight = Aura:UpdateAuraPositions(self, "BUFF", numBuffs, maxRowWidth)
	-- Update debuff positions, the functions returns the height of the frame.
	debuffFrameheight = Aura:UpdateAuraPositions(self, "DEBUFF", numDebuffs, maxRowWidth)
	-- Last but not least, update the aura frame's size.
	Aura:UpdateAuraFrameSize(self, numBuffs, numDebuffs, buffFrameheight, debuffFrameheight)
end

local function Reset(self)
	self:Hide();
end

-- *** HANDLER FUNCTIONS ***
function Aura:AddFrame (auraFrame, buffFrame, debuffFrame, buffTemplate, debuffTemplate, unitFrame)
	
	-- Create a reference for the aura frame inside the unit frame and vice versa.
	unitFrame.auraFrame = auraFrame;
	auraFrame.unitFrame = unitFrame;
	
	-- Set references to buff and debuff child frames.
	auraFrame.buffFrame = buffFrame;
	auraFrame.debuffFrame = debuffFrame;
	
	-- Set names for buff and debuff templates.
	auraFrame.buffTemplate = buffTemplate;
	auraFrame.debuffTemplate = debuffTemplate;
	
	-- Set the basic functions for the indicator.
	auraFrame.Enable = Enable;
	auraFrame.Disable = Disable;
	auraFrame.Update = Update;
	auraFrame.Reset = Reset;

	-- Enable/Disable the aura frame according to saved variables.
	local DBKey = unitFrame.frameType.."/AuraFrame/Enabled";
	local enabled = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
	
	if ( enabled ) then
		auraFrame:Enable();
	else
		auraFrame:Disable();
	end	
end

function Aura:CreateIcon (auraFrame, index, iconType)
	local frame;
	local frameName; 
	
	if ( iconType == "DEBUFF" ) then -- Debuff
		frameName = auraFrame.debuffFrame:GetName();
		frameName = frameName.."Icon"..index;
		frame = CreateFrame("Button", frameName, auraFrame.debuffFrame, auraFrame.debuffTemplate)
		auraFrame.debuffFrame["icon"..index] = frame;
		frame.icon = _G[frameName.."Icon"];
		frame.count = _G[frameName.."Count"];
		frame.cooldown = _G[frameName.."Cooldown"];
		frame.border = _G[frameName.."Border"];
	elseif ( iconType == "BUFF" ) then -- Buff
		frameName = auraFrame.buffFrame:GetName();
		frameName = frameName.."Icon"..index;
		frame = CreateFrame("Button", frameName, auraFrame.buffFrame, auraFrame.buffTemplate)
		auraFrame.buffFrame["icon"..index] = frame;
		frame.icon = _G[frameName.."Icon"];
		frame.count = _G[frameName.."Count"];
		frame.cooldown = _G[frameName.."Cooldown"];
		frame.stealable = _G[frameName.."Stealable"];
	end
	
	-- Register the cooldown;
	Cooldown:AddFrame(frame.cooldown, nil, frame);
	
	return frame;
end

function Aura:ShouldShowBuff (auraFrame, unit, index, filter)

	local tournamentStyle = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, "Auras/TournamentFilter")

	if ( tournamentStyle ) then
		local _, _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, index, filter);
		
		if ( ArenaLiveCore.spellDB["ShownBuffs"][spellId] ) then
			return true;
		else
			return nil;
		end
	else
		return true;
	end

end

function Aura:ShouldShowDebuff (auraFrame, unit, index, filter)
	local ownDebuffsOnly = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, "Auras/ShowOwnDebuffsOnly");
	
	if ( ( not ownDebuffsOnly ) or ( not UnitCanAttack("player", unit) ) ) then
		return true;
	else
		
		local _, _, _, _, _, _, _, unitCaster, _, _, spellID, _, _, isCastByPlayer = UnitDebuff(unit, index, filter);
		
		local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, "ENEMY_TARGET");
		
		if ( hasCustom ) then
			return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );
		else
			return not isCastByPlayer or unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle";
		end
	end

end

-- TODO: Switch to max auras per row instead of max row width?
function Aura:UpdateAuraPositions(auraFrame, auraType, numAuras, maxRowWidth)

	local iconSpacing = AURA_X_OFFSET;
	local normalIconSize = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, auraFrame.unitFrame.frameType.."/AuraFrame/NormalIconSize");
	local largeIconSize = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, auraFrame.unitFrame.frameType.."/AuraFrame/PlayerIconSize");
	local frame, relativeTo, size;
	local rowWidth = 0;
	local newRowYOffset = 0;
	local totalFrameHeight = 0;
	local rowLargestIconSize = 0;
	local auraTypeFrame;
	
	if ( auraType == "BUFF" ) then
		auraTypeFrame = auraFrame.buffFrame;
	elseif ( auraType == "DEBUFF" ) then
		auraTypeFrame = auraFrame.debuffFrame;
	end
	
	for i = 1, numAuras do
		frame = auraTypeFrame["icon"..i];
		
		-- Set the size for the current icon, depending on a list of large buffs and debuffs.
		if ( ( auraType == "BUFF" and largeBuffList[i] ) or ( auraType == "DEBUFF" and largeDebuffList[i] ) ) then
			size = largeIconSize;
		else
			size = normalIconSize;
		end
		
		-- Set the row size that will be returned by this function according to the current icon's size.
		if ( i == 1 ) then
			rowWidth = size;
			rowLargestIconSize = size;
		else
			rowWidth = rowWidth + size + AURA_X_OFFSET;
		end
		
		-- Create a new row, if the current row width would be larger than the aura frame width. The totalFrameHeight is now set to the frame height + the largest Icon of the preceding row to get the yOffset we need.
		if ( rowWidth > maxRowWidth ) then
			
			newRowYOffset = newRowYOffset + AURA_Y_OFFSET + rowLargestIconSize;
			rowWidth = size;
			rowLargestIconSize = 0;
			
			Aura:UpdateIcon(auraFrame, auraType, i, i, size, newRowYOffset)
			-- if the last icon creates a new row, we add his size to the newRowYOffset to get the overall height of the auraFrame.
			if ( i == numAuras ) then
				totalFrameHeight = newRowYOffset + size;
			end
		else
			
			Aura:UpdateIcon(auraFrame, auraType, i, i-1, size, newRowYOffset);
			
			-- The last Icon creates no new row, so we add the largestIconSize to newRowYOffset to get the total height.
			if ( i == numAuras ) then
				totalFrameHeight = newRowYOffset + rowLargestIconSize;
			end
		end
		
		-- Check if the icon is larger than the current largest icon.
		if ( rowLargestIconSize < size ) then
			rowLargestIconSize = size;
		end
	end
	
	return totalFrameHeight;

end

function Aura:UpdateIcon (auraFrame, auraType, index, relativeIndex, size, yOffset)

	local point, relativeTo, relativePoint;
	local growUpwards = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, auraFrame.unitFrame.frameType.."/AuraFrame/GrowUpwards");
	local rtlAuras = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, auraFrame.unitFrame.frameType.."/AuraFrame/RTL");
	local frame;
	local auraTypeFrame;
	local xOffset = AURA_X_OFFSET;
	
	if ( auraType == "BUFF" ) then
		auraTypeFrame = auraFrame.buffFrame
	elseif ( auraType == "DEBUFF" ) then
		auraTypeFrame = auraFrame.debuffFrame
	end

	frame = auraTypeFrame["icon"..index];
	
	if ( not frame ) then
		return;
	end
	
	-- Set point and relative point according to the grow upwards setting.
	if ( growUpwards ) then
		point = "BOTTOM";
		relativePoint = "BOTTOM";
	else
		point = "TOP";
		relativePoint = "TOP"
		
		-- Because we grow downwards, yOffset must be a negative value.
		yOffset = -yOffset;
	end
	
	-- Set point according to right to left (rtl) setting.
	if ( rtlAuras ) then
		point = point.."RIGHT";
		relativePoint = relativePoint.."LEFT";
		xOffset = -AURA_X_OFFSET
	else
		point = point.."LEFT";
		relativePoint = relativePoint.."RIGHT"
	end
	
	if ( index == 1 ) then
	
		relativePoint = point;
		xOffset = 0;
		yOffset = 0;
		relativeTo = frame:GetParent();
		
	elseif ( relativeIndex ~= index - 1 ) then
		--[[ The relativeIndex isn't the icon before, this means that a new row begins. Set relativePoint = point,
			 because otherwise the icon would be attached to the wrong side of the auraType frame.
			 Also reset the xOffset, since we're at the beginning of a row. ]]--
		relativePoint = point;
		relativeTo = frame:GetParent();
		xOffset = 0;
	else
		-- Set the relative Frame (the preceding buff) and reset yOffset, because positioning is relative to the preceding frame. 
		relativeTo = auraTypeFrame["icon"..relativeIndex];
		yOffset = 0;
	end
	
	-- Set up the frame. The Aura is finally done!
	frame:SetWidth(size);
	frame:SetHeight(size);
	
	if (frame.stealable) then
		frame.stealable:SetWidth(size+5, size+5);
		frame.stealable:SetHeight(size+5, size+5);
	end
	
	-- Now set the new anchor and show the icon.
	frame:ClearAllPoints();
	frame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
	frame:Show();

end

function Aura:UpdateAuraFrameSize (auraFrame, numBuffs, numDebuffs, buffFrameheight, debuffFrameheight)

	local point, relativeTo, relativePoint, totalHeight;
	local growUpwards = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, auraFrame.unitFrame.frameType.."/AuraFrame/GrowUpwards");
	local tournamentStyle = ArenaLiveCore:GetDBEntry(auraFrame.unitFrame.addonName, "Auras/TournamentFilter");
	local yOffset;
	local unit = auraFrame.unitFrame.unit;
	local width = auraFrame:GetWidth();

	if ( growUpwards ) then
		point = "BOTTOMLEFT";
		relativePoint = "TOPLEFT"
		yOffset = AURA_Y_OFFSET;
	else
		point = "TOPLEFT";
		relativePoint = "BOTTOMLEFT";
		yOffset = -AURA_Y_OFFSET;
	end		
	
	if ( numBuffs == 0 ) then
		buffFrameheight = 1;
		yOffset = 0;
	end	
	
	if ( numDebuffs == 0 ) then
		debuffFrameheight = 1;
		yOffset = 0;
	end	

	auraFrame.buffFrame:ClearAllPoints();
	auraFrame.debuffFrame:ClearAllPoints();
	
	-- Unit is friendly, so buffs come first. Also show buffs first, if we are in a Spectator/Tournament environment.
	if ( ( UnitIsFriend("player", unit) ) or ( tournamentStyle ) ) then	
		auraFrame.buffFrame:SetPoint(point, auraFrame, point, 0, 0);
		auraFrame.debuffFrame:SetPoint(point, auraFrame.buffFrame, relativePoint, 0, yOffset);
	else
		auraFrame.debuffFrame:SetPoint(point, auraFrame, point, 0, 0);
		auraFrame.buffFrame:SetPoint(point, auraFrame.debuffFrame, relativePoint, 0, yOffset);	
	end
	
	totalHeight = buffFrameheight + debuffFrameheight + AURA_Y_OFFSET;
	
	if ( totalHeight == 0 ) then
		totalHeight = 1;
	end
	
	auraFrame.buffFrame:SetWidth(width);
	auraFrame.buffFrame:SetHeight(buffFrameheight);
	auraFrame.debuffFrame:SetWidth(width);
	auraFrame.debuffFrame:SetHeight(debuffFrameheight);
	auraFrame:SetWidth(width, totalHeight);	
	auraFrame:SetHeight(totalHeight);
	
end

function Aura:OnEvent (event, ...)
	if ( ... == "player" ) then
		local msg;
		for i = 1, NUM_MAX_DEBUFFS do
			local name, _, _, _, _, _, _, _, _, _, spellID = UnitDebuff("player", i);
			if ( name ) then
				msg = name..": "..tostring(spellID);
				ArenaLiveCore:Message(msg, "debug");
			else
				break;
			end
		end
	end
	
	if ( event == "UNIT_AURA" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];

					if ( affectedFrame.handlerList.auraFrame ) then
						affectedFrame.auraFrame:Update();
					end
				end
			end
		end
	end
end