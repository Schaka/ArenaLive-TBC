--[[ ArenaLive Core Functions: Crowd Control Indicator Handler
Created by: Vadrak
Creation Date: 11.06.2013
Last Update: "
This file contains all relevant functions for CC Indicators and their behaviour.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local CCIndicator = ArenaLiveCore:AddHandler("CCIndicator", "EventCore");

-- Get the global UnitFrame and Cooldown handlers.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local Cooldown = ArenaLiveCore:GetHandler("Cooldown");

-- Register the handler for all needed events.
CCIndicator:RegisterEvent("UNIT_AURA");

-- Set variables for the number of maximal queried buffs and debuffs.
local MAX_BUFFS = 40;
local MAX_DEBUFFS = 40;

-- Create a table to store the currently highest aura for every unitID.
local ccByUnitID = {};

-- localized spellname table
local locSpells = {};
for k,v in pairs(ArenaLiveCore.spellDB["portraitOverlay"]) do
	local name = GetSpellInfo(k)
	if name then
		locSpells[name] = v
	end
end

-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	local startTime, duration;
	
	CCIndicator:QueryAuras(unit);
	
	if ( ccByUnitID[unit] and ccByUnitID[unit]["spellName"] ) then
		self.active = true;
		self.texture:SetTexture(ccByUnitID[unit]["texture"]);
		if ccByUnitID[unit]["duration"] then
			startTime = ccByUnitID[unit]["duration"] - ccByUnitID[unit]["expires"];
			duration = ccByUnitID[unit]["duration"];
			self.cooldown:Set(GetTime() - startTime, duration);
		end
	elseif ( ( not ccByUnitID[unit] or not ccByUnitID[unit]["spellName"] ) and self.active == true )then
		self.active = nil;
		self:Reset();
	end

end

local function Reset (self)
	self.texture:SetTexture();
	self.cooldown:Reset();
end
-- *** HANDLER FUNCTIONS ***
function CCIndicator:AddFrame (ccIndicator, texture, cooldown, cooldownText, unitFrame)
	
	-- Create a reference for the ccIndicator inside the unit frame and vice versa.
	unitFrame.ccIndicator = ccIndicator;
	ccIndicator.unitFrame = unitFrame;
	
	-- Register the ccIndcator in the unit frame's handler list.
	unitFrame.handlerList.ccIndicator = true;
	
	-- Set some base variables for the indicator.
	ccIndicator.texture = texture;

	-- Set the cooldown of the indicator.
	Cooldown:AddFrame(cooldown, cooldownText, ccIndicator);
	
	-- Set the basic functions for the indicator.
	ccIndicator.Update = Update;
	ccIndicator.Reset = Reset;

end

function CCIndicator:QueryAuras (unit)

	-- Only query auras if we have a unit frame that shows this unit.
	if ( UnitFrame.UnitIDTable[unit] ) then
		local priority, spellName, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID
		local matchSpellID, matchAura, matchType, matchDuration, matchExpires, matchTexture, matchPriority;
		
		-- Check Buffs first.
		for i=1, MAX_BUFFS do
			spellName, rank, icon, count, duration, expires = UnitBuff(unit, i);
			
			if ( icon ) then					
				
				if ( locSpells[spellName] ) then
					-- Get the priority of the spell.
					local dbKey =  "CCPriority/"..locSpells[spellName];
					priority = ArenaLiveCore:GetDBEntry(addonName, dbKey);					
					
					if ( priority > 0 and ( not matchSpellID or ( (matchPriority < priority ) or ( matchPriority == priority and matchExpires < expires ) ) ) ) then
						-- We've found the first matching spell or there was already a matching spell with higher priority / later expiration time.
						matchSpellID = spellName;
						matchAura = i;
						matchType = "buff";
						matchDuration = duration;
						matchExpires = expires;
						matchTexture = icon;
						matchPriority = priority;
					end
				end
			else
				-- No buffs are left, so we can stop here.
				break;
			end
			
		end
		
		-- Then ceck Debuffs
		for i=1, MAX_DEBUFFS do
			spellName, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitDebuff(unit, i);
			
			if ( icon ) then
						
				if ( locSpells[spellName] ) then
					-- Get the priority of the spell.
					local dbKey =  "CCPriority/"..locSpells[spellName];
					priority = ArenaLiveCore:GetDBEntry(addonName, dbKey);							
					
					if ( priority > 0 and ( not matchSpellID or ( (matchPriority < priority ) or ( matchPriority == priority and matchExpires < expires ) ) ) ) then
						-- We've found the first matching spell or there was already a matching spell with higher priority / later expiration time.
						matchSpellID = spellName;
						matchAura = i;
						matchType = "buff";
						matchDuration = duration;
						matchExpires = expires;
						matchTexture = icon;
						matchPriority = priority;
					end
				end
			else
				-- No debuffs are left, so we can stop here.
				break;
			end
		end
		
		if ( matchSpellID ) then
			-- Create a table for this unit, if no table exists.
			if ( not ccByUnitID[unit] ) then
				ccByUnitID[unit] = {};
			end
			
			ccByUnitID[unit]["spellName"] = matchSpellID;
			ccByUnitID[unit]["aura"] = matchAura;
			ccByUnitID[unit]["type"] = matchType;
			ccByUnitID[unit]["duration"] = matchDuration;
			ccByUnitID[unit]["expires"] = matchExpires;
			ccByUnitID[unit]["texture"] = matchTexture;
			ccByUnitID[unit]["priority"] = matchPriority;
				
		else
			if ( ccByUnitID[unit] and ccByUnitID[unit]["spellName"] ) then
				-- Reset the current entry for this unit, because it has run out.
				ccByUnitID[unit]["spellName"] = nil;
				ccByUnitID[unit]["aura"] = nil;
				ccByUnitID[unit]["type"] = nil;
				ccByUnitID[unit]["duration"] = nil;
				ccByUnitID[unit]["texture"] = nil;
				ccByUnitID[unit]["expires"] = nil;
				ccByUnitID[unit]["priority"] = nil;
				
			end
		end
	end
end

function CCIndicator:OnEvent (event, ...)
	
	if ( event == "UNIT_AURA" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
							
					if ( affectedFrame.ccIndicator ) then
						affectedFrame.ccIndicator:Update();
					end
				end
			end
		end
	end

end