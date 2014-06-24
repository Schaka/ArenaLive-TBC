local abilityIDs = { 
-- MISC & Racials ---------------------
		[11196] = 60, -- Recently Bandaged
		[44055] = 15, -- Battlemaster (1750 HP)
		[19305] = 15, -- Starshards
		[2651] = 15, -- Elune's Grace
		[25467] = 24, -- Devouring Plague
		[20600] = 20, -- Perception
		[33697] = 15, -- Blood Fury
		[20594] = 8, -- Stoneform
		[28880] = 15, -- Gift of the Naaru
		[26296] = 10, -- Berserking
		[43716] = 20, -- Call of the Berserker ( Berserker's Call buff )
		[7744] = 5, -- Will of the Forsaken
       
-- Rogue ------------------------------
-- Defensive
        [45182] = 3, -- Cheat Death
        [31224] = 5, -- Cloak of Shadows
        [26669] = 15, -- Evasion
        [11305] = 15, -- Sprint
       
-- Offensive
        [13750] = 15, -- Adrenaline Rush
        [14278] = 7, -- Ghostly Strike dodge buff
        [13877] = 15, -- Blade Flurry
        [8647] = 30, -- Expose Armor
        [26679] = 6, -- Deadly Throw
        [703] = 18, -- Garrote bleed
		[1330] = 3, -- Garrote - Silence
       
-- CC
        [1833] = 4, -- Cheap Shot
        [8643] = 6, -- Kidney Shot
        [1776] = 4, -- Gouge
        [2094] = 10, -- Blind
        [6770] = 10, -- Sap
 
-- Poisons
        [13220] = 15, -- Wound Poison
        [11400] = 10, -- Mind-Numbing Poison III
        [3420] = 12, -- Crippling Poison
        [2835] = 12, -- Deadly Poison
       
-- Druid -------------------------------
-- Defensive
        [22812] = 12, -- Barkskin
        [29166] = 20, -- Innervate
        [16689] = 45, -- Nature's Grasp
        [22842] = 10, -- Frenzied Regeneration
 
-- Healing
        [33763] = 7, -- Lifebloom
        [26980] = 21, -- Regrowth
        [26982] = 12, -- Rejuvenation
        [14253] = 8, -- Abolish Poison
 
-- Offensive
        [26993] = 40, -- Fairie Fire
        [27011] = 40, -- Fairie Fire (Feral)
        [5570] = 12, -- Insect Swarm
        [8921] = 12, -- Moonfire
        [33745] = 15, -- Lacerate
        [9007] = 18, -- Pounce Bleed
       
-- CC
        [33786] = 6, -- Cyclone
        [26989] = 10, -- Roots
        [2637] = 10, -- Hibernate
        [5211] = 5, -- Bash
        [22570] = 5, -- Maim (4p 5s)
        [9005] = 3, -- Pounce stun
       
-- Warrior ------------------------------
-- Offensive
        [12292] = 30, -- Death Wish
        [11597] = 30, -- Sunder Armor
        [18499] = 10, -- Berserker Rage
        [12294] = 10, -- Mortal Strike
        [1715] = 10, -- Hamstring
        [772] = 21, -- Rend
        [20230] = 15, -- Retaliation
        [1719] = 15, -- Recklessness
        [871] = 10, -- Shield Wall
        [12323] = 6, -- Piercing Howl
        [25274] = 3, -- Intercept Stun
        [5530] = 3, -- Mace Stun Effect
       
-- Defensive
        [3411] = 10, -- Intervene
        [23920] = 5, -- Spell Reflection
        [676] = 10, -- Disarm
        [12975] = 20, -- Last Stand
       
-- CC
        [5246] = 8, -- Intimidating Shout
        [12809] = 5, -- Concussion Blow
 
-- Shaman -------------------------------
-- Offensive
        [32182] = 40, -- Heroism
        [2825] = 40, -- Bloodlust
        [8050] = 12, -- Flame Shock
        [8056] = 6, -- Frost Shock
 
-- Defensive
        [30823] = 15, -- Shamanistic Rage
 
-- Priest -------------------------------
-- Offensive
        [10060] = 15, -- Power Infusion
        [25368] = 18, -- Shadow Word: Pain
        [8122] = 8, -- Psychic Scream
        [15487] = 5, -- Silence
        [34917] = 15, -- Vampiric Touch
        [44047] = 2, -- Chastise
       
-- Defensive
        [27607] = 30, -- Power Word: Shield
        [6788] = 13, -- Weakened Soul
        [33206] = 8, -- Pain Suppression
        [6346] = 180, -- Fear Ward
 
-- Healing
        [33076] = 30, -- Prayer of Mending (needs a hack because duration is 10 after first jump)
        [139] = 15, -- Renew
 
-- Paladin -------------------------------
-- Offensive
        [31884] = 20, -- Avenging Wrath
        [853] = 6, -- Hammer of Justice
        [20066] = 6, -- Repentance
        [25771] = 60, -- Forbearance
 
-- Defensive
        [1044] = 14, -- Blessing of Freedom
        [1020] = 12, -- Divine Shield
        [27148] = 30, -- Blessing of Sacrifice
        [10278] = 10, -- Blessing of Protection
        [31842] = 15, -- Divine Illumination
 
-- Mage ----------------------------------
-- Offensive
        [133] = 8, -- Fireball debuff
        [120] = 8, -- Cone of Cold
        [12472] = 20, -- Icy Veins
        [116] = 9, -- Frostbolt debuff
        [2139] = 4, --Counterspell
        [12042] = 15, -- Arcane Power
        [31589] = 15, -- Slow
		[18469] = 4, -- Counterspell - Silenced
		[33043] = 4, -- Dragon's Breath
		[33395] = 8, -- Freeze (Watelemental)
       
-- Defensive
        [45438] = 10, -- Ice Block
        [12051] = 8, -- Evocation
        [66] = 5, -- Invisibilty fade
        [41425] = 30, -- Hypothermia
        [11426] = 60, -- Ice Barriers
 
-- CC
        [118] = 10, -- Poly
        [28272] = 10, -- Poly Pig
        [28271] = 10, -- Poly Turtle
        [27088] = 8, -- Frostnova
		[12494] = 5, -- Frostbite
 
-- Warlock --------------------------------
-- Offensive
        [172] = 18, -- Corruption
        [980] = 24, -- Curse of Agony
        [27243] = 18, -- Seed of Corruption
        [348] = 15, -- Immolate
        [18265] = 30, -- Siphon Life
        [27223] = 3, -- Death Coil
        [24259] = 3, -- Spell Lock
 
-- Defensive
        [18708] = 15, -- Fel Domination
 
-- CC
        [1714] = 6, -- Curse of Tongues
        [5782] = 10, -- Fear
        [5484] = 8, -- Howl of Terror
        [710] = 10, -- Banish
 
-- Hunter ---------------------------------
-- Offensive
        [27065] = 10, -- Aimed Shot    
        [19574] = 18, -- Bestial Wrath
        [38373] = 18, -- The Beast Within
        [27018] = 8, -- Viper Sting
        [1978] = 15, -- Serpent Sting
        [3045] = 15, -- Rapid Fire
        [13813] = 20, -- Explosive Trap
        [13795] = 15, -- Immolation Trap
        [19577] = 3, -- Intimidation
       
-- Defensive
        [19263] = 10, -- Deterrence
 
-- CC
        [14309] = 10, -- Freezing Trap Effect
        [13810] = 30, -- Frost Trap Aura
        [14326] = 10, -- Scare Beast
        [2974] = 10, -- Wing Clip
        [19386] = 12, -- Wyvern Sting
        [19503] = 4, -- Scatter Shot
        [34490] = 3, -- Silencing Shot
        [19229] = 5, -- Improved Wing Clip
        [19410] = 3, -- Improved Concussive Shot
        [5116] = 4, -- Concussive Shot
        [19185] = 4, -- Entrapment
};
BuffLibDebug = 0
BuffLibDB = BuffLibDB or { sync = true}
local function log(msg)
	if BuffLibDebug == 1 then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	elseif BuffLibDebug == 0 then
		return
	end
end -- alias for convenience

local DR_RESET_TIME = 15
local DRLib

local _UnitBuff = UnitBuff
local _UnitDebuff = UnitDebuff

local function firstToUpper(str)
	if (str~=nil) then
		return (str:gsub("^%l", string.upper));
	else
		return nil;
	end
end

local function wipe(t)
	for k,v in pairs(t) do
		t[k]=nil
	end
end

local BuffLib = CreateFrame("Frame", nil, UIParent);
function BuffLib:OnEvent(event, ...) -- functions created in "object:method"-style have an implicit first parameter of "self", which points to object
	self[event](self, ...) -- route event parameters to LoseControl:event methods
end
BuffLib:SetScript("OnEvent", BuffLib.OnEvent)
BuffLib:RegisterEvent("PLAYER_ENTERING_WORLD")
BuffLib:RegisterEvent("PLAYER_LOGIN")

function BuffLib:InitDR(destGUID, spellID, event)
	if type(self.guids[destGUID]) ~= "table" then
		self.guids[destGUID] = { }
	end
	local drCat = DRLib:GetSpellCategory(spellID)
	if drCat then
		local tracked = self.guids[destGUID][drCat]
		--first AURA_APPLIED - initialize DR
		if not self.guids[destGUID][drCat] then
			self.guids[destGUID][drCat] = { reset = 99999999, diminished = 1.0, lastDR = 0 }
		--another AURA_APPLIED - reset DR if run out of time
		elseif tracked and tracked.reset <= GetTime() then -- reset DR because timer ran out
			tracked.diminished = 1.0
			tracked.reset = 99999999
			--log(DR_RESET_TIME.." seconds DR timer ran out, resetting "..drCat)
		--AURA_REMOVE - start timer and DR duration (maybe also on AURA_REFRESH?)
		elseif event == "SPELL_AURA_REMOVED" then
			tracked.reset = GetTime() + DR_RESET_TIME
			--log("start "..DR_RESET_TIME.." seconds DR timer")
		end	
	end
	
end

function BuffLib:NextDR(destGUID, spellID, event)
	local tracked
	local drCat
	if self.guids[destGUID] then
		drCat = DRLib:GetSpellCategory(spellID)
		tracked = self.guids[destGUID][drCat]
		if tracked then
			diminished = tracked.diminished
		end
	end
	if tracked and tracked.lastDR+0.5 <= GetTime() then
		tracked.diminished = DRLib:NextDR(tracked.diminished)
		tracked.lastDR = GetTime()
		--log("next DR: "..GetSpellInfo(spellID).. "  "..drCat)
	end
end

function BuffLib:CreateFrames(destGUID, spellName, spellID)
	-- don't create any more frames than necessary to avoid memory overload
	if self.guids[destGUID] and self.guids[destGUID][spellName] then
		self:UpdateFrames(destGUID, spellName, spellID)
	else
		local diminished = 1.0
		local tracked
		if( self.guids[destGUID] ) then
			local drCat = DRLib:GetSpellCategory(spellID)
			tracked = self.guids[destGUID][drCat]
			if (tracked) then
				diminished = tracked.diminished
				--log(spellName.."  "..self.abilities[spellName]*diminished)
			end
		end
		if type(self.guids[destGUID]) ~= "table" then
			self.guids[destGUID] = { }
		end
		
		--self.guids[destGUID][spellName] = CreateFrame("Frame", spellName .. "_" .. destGUID)
		self.guids[destGUID][spellName] = {}
		-- create information other addons can read using getglobal(spellName_GUIDTarget)
		self.guids[destGUID][spellName].startTime = GetTime()
		self.guids[destGUID][spellName].endTime = self.abilities[spellName]*diminished
		
		log(spellName.."  "..self.abilities[spellName]*diminished.." CreateFrames")
	end
end

function BuffLib:UpdateFrames(destGUID, spellName, spellID)
	if self.guids[destGUID] and self.guids[destGUID][spellName] and self.abilities[spellName] then
		local diminished = 1.0
		local tracked
		if( self.guids[destGUID] ) then
			local drCat = DRLib:GetSpellCategory(spellID)
			tracked = self.guids[destGUID][drCat]
			if (tracked) then
				diminished = tracked.diminished
				--log(spellName.."  "..self.abilities[spellName]*diminished)
			end
		end	
		-- update "library"
		self.guids[destGUID][spellName].startTime = GetTime()
		self.guids[destGUID][spellName].endTime = self.abilities[spellName]*diminished
		
		log(spellName.."  "..self.abilities[spellName]*diminished.." UpdateFrames")
	end
end

function BuffLib:HideFrames(destGUID, spellName, spellID)
	if self.guids[destGUID] and self.guids[destGUID][spellName] and self.abilities[spellName] then
		self.guids[destGUID][spellName].startTime = 0
		self.guids[destGUID][spellName].endTime = 0
		self.guids[destGUID][spellName].timeLeft = 0
	end
end

function BuffLib:PLAYER_LOGIN(...)
	self:CreateOptions()
end

function BuffLib:PLAYER_ENTERING_WORLD(...)
	-- clear frames, just to be sure
	if type(self.guids) == "table" then
		for k,v in pairs(self.guids) do
			for ke,va in pairs(self.abilities) do	
				local frame = getglobal(ke.."_"..k)
				if frame then
					frame = nil
				end
			end
		end
	end
	
	self.guids = {}
	self.abilities = {}
	for k,v in pairs(abilityIDs) do
		self.abilities[GetSpellInfo(k)]=v;
	end
	
	DRLib = LibStub("DRData-1.0")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if BuffLibDB.sync == true then
		self:RegisterEvent("CHAT_MSG_ADDON")
		self:RegisterEvent("UNIT_AURA")
	end
	
end

local logDelay = 0.05

local applyEvents = {
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_SUCCESS",
}

local removeEvents = {
	"SPELL_AURA_REMOVE",
	"SPELL_AURA_DISPEL",
	"SPELL_AURA_STOLEN",
}

function BuffLib:COMBAT_LOG_EVENT_UNFILTERED(...)
	local timestamp, eventType, sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,auraType = select ( 1 , ... );
	
	-- DR can be applied by all spells, therefore outside of self.abilities[name]
	if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_REMOVED" then
		self:InitDR(destGUID, spellID, eventType)
	end
	
	if self.abilities[spellName] and (eventType == "SPELL_AURA_APPLIED") then -- check if spell just used is in list
		-- filter multiple incorrect combatlog events || don't want to trigger spell timer twice if SUCCESS+REFRESH or SUCCESS+APPLIED
		if self.guids[destGUID] and self.guids[destGUID][spellName] and self.guids[destGUID][spellName].lastTime and self.guids[destGUID][spellName].lastTime+logDelay <= GetTime() then
			self:CreateFrames(destGUID, spellName, spellID)
		elseif not self.guids[destGUID] or not self.guids[destGUID][spellName] or not self.guids[destGUID][spellName].lastTime then
			self:CreateFrames(destGUID, spellName, spellID)
		end
	-- have to also take CAST_SUCCESS because it's the only way to get refreshed spells like MS, Harmstring etc	
	elseif self.abilities[spellName] and (eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED_DOSE" or eventType == "SPELL_CAST_SUCCESS") then	
		if self.guids[destGUID] and self.guids[destGUID][spellName] and self.guids[destGUID][spellName].lastTime and self.guids[destGUID][spellName].lastTime+logDelay <= GetTime() then
			self:CreateFrames(destGUID, spellName, spellID)
		elseif not self.guids[destGUID] or not self.guids[destGUID][spellName] or not self.guids[destGUID][spellName].lastTime then
			self:CreateFrames(destGUID, spellName, spellID)
		end
	elseif self.abilities[spellName] and removeEvents[eventType] then
		self:HideFrames(destGUID, spellName, spellID)
	end
	
	-- some spells do not have AURA_REFRESH because they are physical, CAST_SUCCESS works though
	-- could technically catch even more by just using CAST_SUCCESS without spellSchool
	if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or (eventType == "SPELL_CAST_SUCCESS" and spellSchool == "0x1") then
		self:NextDR(destGUID, spellID, eventType)
	end
	
	
	-- hack for Wound Poison
	if spellName == GetSpellInfo(13220) and eventType == "SPELL_DAMAGE" then
		self:CreateFrames(destGUID, spellName, spellID)
	end
	
	-- call UNIT_AURA on any units where the player COULD see buff/debuff durations
	-- UNIT_AURA does not fire automatically when a spell is refreshed :(
	-- the self:UNIT_AURA() sends sync messages
	if eventType == "SPELL_AURA_REFRESH" and BuffLibDB.sync == true then
		if destGUID == UnitGUID("player") then
			self:UNIT_AURA("player")
		end	
	end

	-- timer of last update on this spell, this is to ensure that multiple combatlog events will not overwrite the current timer
	-- for example CAST_SUCCESS and AURA_APPLIED fire at the SAME time (or virtually same time)
	-- only do this for spells which can actually DR - anything else doesn't matter
	if self.abilities[spellName] and DRLib:GetSpellCategory(spellID) then
		if self.guids[destGUID] and self.guids[destGUID][spellName] and eventType ~= "SPELL_AURA_REMOVE" then
			self.guids[destGUID][spellName].lastTime = GetTime() 
			--log("setting lastTime")
		end
	end
	
	if eventType == "SPELL_AURA_REMOVED" then
		self:HideFrames(destGUID, spellName, spellID)
	end
	
end

function BuffLib:CHAT_MSG_ADDON(prefix, message, channel, sender)
	if prefix == "BuffLib" and sender ~= UnitName("player") then
		local guid, name, duration, timeLeft = strsplit(",", message)
		--local EBFrame = getglobal(name.."_"..guid)
		local EBFrame
		if self.guids[guid] then
			EBFrame = self.guids[guid][name]
		end
		if EBFrame ~= nil then
			EBFrame.timeLeft = tonumber(timeLeft)
			EBFrame.duration = tonumber(duration)
			EBFrame.getTime = GetTime()
			--[[delete combatlog data
			EBFrame.startTime = nil
			EBFrame.endTime = nil]]
		else
			--self.guids[guid][name] = CreateFrame("Frame", name.."_"..guid, UIParent)
			if not self.guids[guid] then return end
			self.guids[guid][name] = {}
			self.guids[guid][name].timeLeft = tonumber(timeLeft)
			self.guids[guid][name].duration = tonumber(duration)
			self.guids[guid][name].getTime = GetTime()
		end
		
		--instant buff/debuff timer update for default UnitFrames
		if TargetFrame:IsVisible() and guid == UnitGUID("target") then
			TargetDebuffButton_Update()
		end
		
		local Aura = ArenaLiveCore:GetHandler("Aura")
		if guid == UnitGUID("target") then
			Aura:OnEvent("UNIT_AURA", "target")
		elseif guid == UnitGUID("focus") then	
			Aura:OnEvent("UNIT_AURA", "focus")
		elseif guid == UnitGUID("party1") then	
			Aura:OnEvent("UNIT_AURA", "party1")
		elseif guid == UnitGUID("party2") then	
			Aura:OnEvent("UNIT_AURA", "party2")
		elseif guid == UnitGUID("party3") then	
			Aura:OnEvent("UNIT_AURA", "party4")
		elseif guid == UnitGUID("party4") then	
			Aura:OnEvent("UNIT_AURA", "party4")		
		end
	end
end

function BuffLib:UNIT_AURA(unitID, eventType)
	if unitID == "player" or unitID == "target" or unitID == "focus" then
		for i=1, 40 do
			local name, rank, icon, count, duration, timeLeft = _UnitBuff(unitID, i, castable)		
			if timeLeft ~= nil then -- can see timer, perfect
				self:SendSync(UnitGUID(unitID)..","..name..","..duration..","..timeLeft)
			end

			local name, rank, icon, count, debuffType, duration, timeLeft = _UnitDebuff(unitID, i, castable)
			if timeLeft ~= nil then
				self:SendSync(UnitGUID(unitID)..","..name..","..duration..","..timeLeft)
			end	
		end
	end	
end

function BuffLib:SendSync(message)
	local inInstance, instanceType = IsInInstance()
	if instanceType == "pvp" then
		SendAddonMessage("BuffLib", message, "BATTLEGROUND")
	elseif instanceType == "raid" then
		SendAddonMessage("BuffLib", message, "RAID")
	elseif instanceType == "arena" or instanceType == "party" then
		SendAddonMessage("BuffLib", message, "PARTY")
	elseif instanceType == "none" then
		if UnitGUID("raid1") ~= "" then
			SendAddonMessage("BuffLib", message, "RAID")
		end	
		if UnitGUID("party1") then
			SendAddonMessage("BuffLib", message, "PARTY")
		end
	end
	
end

local SO = LibStub("LibSimpleOptions-1.0")
function BuffLib:CreateOptions()
	local panel = SO.AddOptionsPanel("BuffLib", function() end)
	self.panel = panel
	SO.AddSlashCommand("BuffLib","/bufflib")
	SO.AddSlashCommand("BuffLib","/bl")
	local title, subText = panel:MakeTitleTextAndSubText("Buff Library Addon", "General settings")
	local sync = panel:MakeToggle(
	     'name', 'Synchronize timers',
	     'description', 'Turns off synchronizing timers with your teammates. Could prevent lags.',
	     'default', false,
	     'getFunc', function() return BuffLibDB.sync end,
	     'setFunc', function(value) BuffLibDB.sync = value BuffLib:PLAYER_ENTERING_WORLD() end)
	     
	sync:SetPoint("TOPLEFT",subText,"TOPLEFT",16,-32)
end	

-------- HOOKING FUNCTIONS -------

-- endTime is equal to duration
-- startTime is GetTime() when the spell was found in CombatLog
-- endTime-(GetTime()-startTime) is therefore timeLeft

function UnitBuff(unitID, index, castable)
	local name, rank, icon, count, duration, timeLeft, isMine = _UnitBuff(unitID, index, castable)
	if not name then return name, rank, icon, count, duration, timeLeft, isMine end
	--local EBFrame = getglobal(name.."_"..UnitGUID(unitID))
	local EBFrame
	if BuffLib.guids and BuffLib.guids[UnitGUID(unitID)] then
		EBFrame = BuffLib.guids[UnitGUID(unitID)][name]
	end
	
	
	if timeLeft ~= nil and unitID ~= "player" then -- can see timer, perfect
		if unitID ~= "player" then
			isMine = true
		else
			isMine = false
		end
		--[[if BuffLibDB.sync == true then
			SendAddonMessage("BuffLib", UnitGUID(unitID)..","..name..","..duration..","..timeLeft, "RAID")
			SendAddonMessage("BuffLib", UnitGUID(unitID)..","..name..","..duration..","..timeLeft, "BATTLEGROUND")
		end]]
	elseif timeLeft == nil and EBFrame ~=nil and EBFrame.timeLeft ~= nil and EBFrame.timeLeft-(GetTime()-EBFrame.getTime) > 0 then -- can't see timer but someone in party/raid/bg can
		duration = EBFrame.duration
		timeLeft = EBFrame.timeLeft-(GetTime()-EBFrame.getTime)
		isMine = false
	elseif (timeLeft == nil and EBFrame ~=nil) and (EBFrame.timeLeft == nil or (EBFrame.timeLeft ~= nil and EBFrame.getTime and EBFrame.timeLeft-(GetTime()-EBFrame.getTime) <= 0)) then -- have to load timer from combatlog :(
		duration = EBFrame.endTime
		timeLeft = EBFrame.endTime-(GetTime()-EBFrame.startTime)
		isMine = false		
	end
	if timeLeft and timeLeft <= 0 then
		timeLeft = nil
		duration = nil
		log(name.." resetting timeLeft "..unitID)
	end	
	
	return name, rank, icon, count, duration, timeLeft, isMine
end

function UnitDebuff(unitID, index, castable)
	local name, rank, icon, count, debuffType, duration, timeLeft, isMine = _UnitDebuff(unitID, index, castable)
	if not name then return name, rank, icon, count, debuffType, duration, timeLeft, isMine end
	--local EBFrame = getglobal(name.."_"..UnitGUID(unitID))
	local EBFrame
	if BuffLib.guids and BuffLib.guids[UnitGUID(unitID)] then
		EBFrame = BuffLib.guids[UnitGUID(unitID)][name]
	end
	
	
	if timeLeft ~= nil then
		if unitID ~= "player" then
			isMine = true
		else
			isMine = false
		end
		--[[if BuffLibDB.sync == true then
			SendAddonMessage("BuffLib", UnitGUID(unitID)..","..name..","..duration..","..timeLeft, "RAID")
			SendAddonMessage("BuffLib", UnitGUID(unitID)..","..name..","..duration..","..timeLeft, "BATTLEGROUND")
		end]]
	elseif timeLeft == nil and EBFrame ~=nil and EBFrame.timeLeft ~= nil and EBFrame.timeLeft-(GetTime()-EBFrame.getTime) > 0 then
		duration = EBFrame.duration
		timeLeft = EBFrame.timeLeft-(GetTime()-EBFrame.getTime)
		isMine = false
	elseif (timeLeft == nil and EBFrame ~=nil) and (EBFrame.timeLeft == nil or (EBFrame.timeLeft ~= nil and EBFrame.getTime and EBFrame.timeLeft-(GetTime()-EBFrame.getTime) <= 0)) then
		duration = EBFrame.endTime
		timeLeft = EBFrame.endTime-(GetTime()-EBFrame.startTime)
		isMine = false
	end
	if timeLeft and timeLeft <= 0 then
		timeLeft = nil
		duration = nil
		log(name.." resetting timeLeft "..unitID)
	end	
	
	return name, rank, icon, count, debuffType, duration, timeLeft, isMine
end