local abilityIDs = {
	-- none, these can ONLY be broken by trinket
	[33786] = "none", -- Cyclone 
	[710] = "none", -- Banish
	-- physicalStun all stuns which don't break on damage
    [1833] = "physicalStun", -- Cheap Shot
    [8643] = "physicalStun", -- Kidney Shot
	[5211] = "physicalStun", -- Bash
	[25274] = "physicalStun", -- Intercept Stun
	[9005] = "physicalStun", -- Pounce stun
	[5530] = "physicalStun", -- Mace Stun Effect
	[34510] = "physicalStun", -- Deep Thunder/Storm Herald stun
	[19410] = "physicalStun", -- Improved Concussive Shot
	[12809] = "physicalStun", -- Concussion Blow	
	[19577] = "physicalStun", -- Intimidation
	[20549] = "physicalStun", -- War Stomp
	-- all physical effects which ONLY break on damage
    [1776] = "physicalPolyZerker", -- Gouge
    [2094] = "physicalPoly", -- Blind
    [6770] = "physicalPolyZerkerOverride", -- Sap
	[19503] = "physicalPoly", -- Scatter Shot
	-- all effects which can only be broken by Blessing of Freedom, Blessing of Protection or Escape Artist
	[19229] = "physicalRoot", -- Improved Wing Clip
	[23694] = "physicalRoot", -- Hamstring Proc
	-- all physical effects which can be broken by tremor
	[5246] = "physicalFearTremor", -- Intimidating Shout || this will need a hack later on, because the target of the spell breaks on 1 damage
	-- all physical effects which only break from DIRECT damage
	[22570] = "physicalPolyPeriodic", -- Maim (4p 5s)
	-- all magic effects which only break from DIRECT damage
    [33043] = "magicPolyPeriodic", -- Dragon's Breath
	-- all magic effects which break on damage
	[118] = "magicPoly", -- Poly
	[28272] = "magicPoly", -- Poly Pig
	[28271] = "magicPoly", -- Poly Turtle
	[14309] = "magicPoly", -- Freezing Trap Effect 
	[20066] = "magicPoly", -- Repentance
	-- all effects which can be dispelled but also break after ~1500 damage taken
    [26989] = "magicRootsOverride", -- Entangling Roots
	[33395] = "magicRoots", -- Freeze (Watelemental)
	[122] = "magicRoots", -- Frost nova
	[12494] = "magicRoots", -- Frostbite
	-- all magic effects that break on damage but also break on tremor
    [2637] = "magicPolyTremor", -- Hibernate
	-- all magic effects that break on damage, tremor and can be interrupt (channeling)
	[10912] = "magicPolyTremorInterrupt", -- Mind Control
	-- all poison effects that break on damage but also break on tremor / stoneform
	[19386] = "poisonPolyTremor", -- Wyvern Sting
	-- all magic effects which can be dispelled, break on tremor and on ~1500 damage
	[8122] = "magicFearTremor", -- Psychic Scream
	[5484] = "magicFearTremor", -- Howl of Terror
	[14326] = "magicFearTremor", -- Scare Beast
	[6215] = "magicFearTremorOverride", -- Fear
    -- all effects which can ONLY be dispelled
    [853] = "magic", -- Hammer of Justice
	[27223] = "magic", -- Death Coil
    [19185] = "magic", -- Entrapment	
}

local categories = {
	["none"] = {
		-- these effects CANNOT be removed by anything other than trinket
		["override"] = 1, 
	},
	-- CS/KS
	["physicalStun"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[1953] = 1, -- Blink
		[34471] = 1, -- The Beast Within
	},
	-- Blind etc
	["physicalPoly"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[34471] = 1, -- The Beast Within
		["damage"] = 1, -- any form of damage breaks this
		["periodicDamage"] = 1, -- any form of periodic damage breaks this
	},
	-- Sap/Gouge
	["physicalPolyZerker"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[18499] = 1, -- Berserker Rage
		["damage"] = 1, -- any form of damage breaks this
		["periodicDamage"] = 1, -- any form of periodic damage breaks this
	},
	["physicalPolyZerkerOverride"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[18499] = 1, -- Berserker Rage
		["damage"] = 1, -- any form of damage breaks this
		["periodicDamage"] = 1, -- any form of periodic damage breaks this
		["override"] = 1,
	},
	-- Hamstring proc etc
	["physicalRoot"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[20589] = 1, -- Escape Artist
		[1044] = 1, -- Blessing of Freedom
		[1953] = 1, -- Blink
		[31642] = 1, -- Blazing Speed
		[11305] = 1, -- Sprint
		[34471] = 1, -- The Beast Within
		["shapeshift"] = 1,
	},
	-- Intimidating Shout
	["physicalFearTremor"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		[18499] = 1, -- Berserker Rage
		[12292] = 1, -- Death Wish
		["tremor"] = 1, -- broken by tremor
		["bigDamage"] = 1, -- broken by ~1500 damage
	},
	-- Maim
	["physicalPolyPeriodic"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[18499] = 1, -- Berserker Rage
		["damage"] = 1,
	},
	-- Dragon's Breath
	["magicPolyPeriodic"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1,
		["dispel"] = 1,
	},
	-- Poly/Repentance etc
	["magicPoly"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
		["shapeshift"] = 1,
		["override"] = 1,
	},
	-- Entangling Roots/Frost Nova
	["magicRoots"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[20589] = 1, -- Escape Artist
		[1044] = 1, -- Blessing of Freedom
		[1953] = 1, -- Blink
		[31642] = 1, -- Blazing Speed
		[11305] = 1, -- Sprint
		[31224] = 1, -- Cloak of Shadows
		[34471] = 1, -- The Beast Within
		["dispel"] = 1,
		["bigDamage"] = 1, -- broken by ~1500 damage
		["shapeshift"] = 1,
	},
	["magicRootsOverride"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[20589] = 1, -- Escape Artist
		[1044] = 1, -- Blessing of Freedom
		[1953] = 1, -- Blink
		[31642] = 1, -- Blazing Speed
		[11305] = 1, -- Sprint
		[31224] = 1, -- Cloak of Shadows
		[34471] = 1, -- The Beast Within
		["dispel"] = 1,
		["bigDamage"] = 1, -- broken by ~1500 damage
		["shapeshift"] = 1,
		["override"] = 1,
	},
	-- Hibernate
	["magicPolyTremor"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
		["tremor"] = 1,
		["override"] = 1,
	},
	-- Mind Control
	["magicPolyTremorInterrupt"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
		["tremor"] = 1,
		["interrupt"] = 1,
	},
	-- Wyvern Sting
	["poisonPolyTremor"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		[20594] = 1, -- Stoneform
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
		["tremor"] = 1,
	},
	-- Fear/Psychic Scream etc
	["magicFearTremor"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		[18499] = 1, -- Berserker Rage
		[12292] = 1, -- Death Wish
		["bigDamage"] = 1,
		["dispel"] = 1,
		["tremor"] = 1,
	},
	["magicFearTremorOverride"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		[18499] = 1, -- Berserker Rage
		[12292] = 1, -- Death Wish
		["bigDamage"] = 1,
		["dispel"] = 1,
		["tremor"] = 1,
		["override"] = 1,
	},
	-- Death Coil, HoJ etc
	["magic"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[34471] = 1, -- The Beast Within
		["dispel"] = 1, 
	},
}

local function map_length(t)
    local c = 0
    for k,v in pairs(t) do
         c = c+1
    end
    return c
end
-- time before the CC naturally ends that trinket will still be tracked
local timeOutBuffer = 0.5
-- how much damage needs to be taken during root/fear before we can assume it wasn't trinketed
local bigDamageValue = 800

local damageEvents = {
	["SWING_DAMAGE"] = 1,
	["SPELL_DAMAGE"] = 1,
	["RANGE_DAMAGE"] = 1,
	["SPELL_DRAIN"] = 1,
	["SPELL_LEECH"] = 1,
}

local periodicDamageEvents = {
	["SPELL_PERIODIC_DAMAGE"] = 1,
	["SPELL_PERIODIC_DRAIN"] = 1,
	["SPELL_PERIODIC_LEECH"] = 1,
}

-- don't include leech here, it doesn't break Fear/Roots in TBC
local bigDamageEvents = {
	["SWING_DAMAGE"] = 1,
	["SPELL_DAMAGE"] = 1,
	["RANGE_DAMAGE"] = 1,
	["SPELL_DRAIN"] = 1,
	["SPELL_PERIODIC_DAMAGE"] = 1,
	["SPELL_PERIODIC_DRAIN"] = 1,
}

local logEvents = {
	["SWING_DAMAGE"] = 1,
	["SPELL_DAMAGE"] = 1,
	["RANGE_DAMAGE"] = 1,
	["SPELL_PERIODIC_DAMAGE"] = 1,
	["SPELL_DISPEL"] = 1,
	["SPELL_INTERRUPT"] = 1,
	["SPELL_DRAIN"] = 1,
	["SPELL_LEECH"] = 1,
	["SPELL_PERIODIC_DRAIN"] = 1,
	["SPELL_PERIODIC_LEECH"] = 1,
	["SPELL_CAST_SUCCESS"] = 1,
}
local RealmNames = {
	["EU Arena-tournament.com 2.4.3"] = 1,
	["TBC-Tournament"] = 1,
	["TBC Tournament"] = 1,
}
local immunityIDs = {
	[1020] = 1, -- Divine Shield
	[45438] = 1, -- Ice Block
	[7744] = 1, -- Will of the Forsaken
	[20594] = 1, -- Stoneform
	[20589] = 1, -- Escape Artist
	[1044] = 1, -- Blessing of Freedom
	[10278] = 1, -- Blessing of Protection
	[18499] = 1, -- Berserker Rage
	[1953] = 1, -- Blink
	[31642] = 1, -- Blazing Speed
	[11305] = 1, -- Sprint
	[31224] = 1, -- Cloak of Shadows
	[34471] = 1, -- The Beast Within
	[12292] = 1, -- Death Wish
}

local shapeshiftIDs = {
	[783] = 1, -- Travel form
	[768] = 1, -- Cat form
	[9634] = 1, -- Dire bear form
	[24858] = 1, -- Moonkin form
}

local overrideIDs = {
	[33786] = 1, -- Cyclone 
	[710] = 1, -- Banish
	[6770] = 1, -- Sap
	[118] = 1, -- Poly
	[28272] = 1, -- Poly Pig
	[28271] = 1, -- Poly Turtle
	[14309] = 1, -- Freezing Trap Effect 
	[26989] = 1, -- Entangling Roots
	[2637] = 1, -- Hibernate
	[6215] = 1, -- Fear
}
-- units from which timers should be taken
local unitIDs = {
	["target"] = 1,
	["targettarget"] = 1,
	["focus"] = 1,
	["focustarget"] = 1,
	["party1target"] = 1,
	["party2target"] = 1,
	["party3target"] = 1,
	["party4target"] = 1,
	["pettarget"] = 1,
	["party1"] = 1,
	["party2"] = 1,
	["party3"] = 1,
	["party4"] = 1,
}

TrinketTrackerDB = TrinketTrackerDB or { ["debug"] = true }

local function log(msg)
	if TrinketTrackerDB.debug == true then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	elseif TrinketTrackerDebug == false then
		return
	end
end -- alias for convenience

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

local TrinketTracker = CreateFrame("Frame", nil, UIParent);
function TrinketTracker:OnEvent(event, ...) -- functions created in "object:method"-style have an implicit first parameter of "self", which points to object
	self[event](self, ...) -- route event parameters to LoseControl:event methods
end
TrinketTracker:SetScript("OnEvent", TrinketTracker.OnEvent)
TrinketTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
TrinketTracker:RegisterEvent("PLAYER_LOGIN")

function TrinketTracker:StartTimer(destGUID, spellName, timeLeft, duration)
	-- don't create any more frames than necessary to avoid memory overload
	if self.guids[destGUID] and self.guids[destGUID][spellName] then
		self:UpdateTimer(destGUID, spellName, timeLeft, duration)
	else
		if type(self.guids[destGUID]) ~= "table" then
			self.guids[destGUID] = { }
		end
		
		--self.guids[destGUID][spellName] = CreateFrame("Frame", spellName .. "_" .. destGUID)
		self.guids[destGUID][spellName] = {}
		-- use ACTUAL GetTime() at which the spell started, regardless of when this function is called
		self.guids[destGUID][spellName].startTime = GetTime()-(duration-timeLeft)
		self.guids[destGUID][spellName].timeLeft = timeLeft
		
		--log("Found timer for spell: "..spellName.." with time left: "..timeLeft)
	end
end

function TrinketTracker:UpdateTimer(destGUID, spellName, timeLeft, duration)
	if self.guids[destGUID] and self.guids[destGUID][spellName] and self.abilities[spellName] then
	
		-- update "library"
		--if self.guids[destGUID][spellName].startTime <
		self.guids[destGUID][spellName].startTime = GetTime()-(duration-timeLeft)
		self.guids[destGUID][spellName].timeLeft = timeLeft
		
		--log("Found timer for spell: "..spellName.." with time left: "..timeLeft)
	end
end

function TrinketTracker:PLAYER_LOGIN(...)
	self:CreateOptions()
	self.cdFrames = { }
	self.trinketFrames = { }
	self.tremor = false
end

local SO = LibStub("LibSimpleOptions-1.0")
function TrinketTracker:CreateOptions()
	local panel = SO.AddOptionsPanel("TrinketTracker", function() end)
	self.panel = panel
	SO.AddSlashCommand("TrinketTracker","/TrinketTracker")
	SO.AddSlashCommand("TrinketTracker","/tt")
	local title, subText = panel:MakeTitleTextAndSubText("Trinket Tracker Addon", "General settings")
	local sync = panel:MakeToggle(
	     'name', 'Debug',
	     'description', 'Turns debugging info in your chat on/off',
	     'default', true,
	     'getFunc', function() return TrinketTrackerDB.debug end,
	     'setFunc', function(value) TrinketTrackerDB.debug = value end)
	     
	sync:SetPoint("TOPLEFT",subText,"TOPLEFT",16,-32)
end	

function TrinketTracker:PLAYER_TARGET_CHANGED(...)
	self:UNIT_AURA("target")
end

function TrinketTracker:PLAYER_FOCUS_CHANGED(...)
	self:UNIT_AURA("focus")
end

function TrinketTracker:PLAYER_ENTERING_WORLD(...)
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
	self.override = {}
	self.tremor = false
	
	for k,v in pairs(abilityIDs) do
		self.abilities[GetSpellInfo(k)]=v;
	end
	
	for k,v in pairs(overrideIDs) do
		self.override[GetSpellInfo(k)]=v;
	end
	
	for i=1,5 do
		if self.cdFrames[i] then
			self.cdFrames[i]:SetCooldown(GetTime(), 0)
		end
	end
	
	for k,v in pairs(self.trinketFrames) do
		v:SetCooldown(GetTime(), 0)
		v:Hide()
	end
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("CHAT_MSG_ADDON")
	
end

function TrinketTracker:UpdateTremor(...)
	local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags = select(1, ...)
	if eventType == "SPELL_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SWING_DAMAGE" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = select(1, ...)
		self.tremor = false
		self.tremorTime = 0
		self:SetScript("OnUpdate", nil)
	elseif eventType == "SPELL_CAST_SUCCESS" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool = select(1, ...)
		self.tremor = true
		local milliseconds = tonumber(strsub(tostring(GetTime()), -3))/1000
		self.tremorTime = GetTime()
	end	
end

function TrinketTracker:CHAT_MSG_ADDON(prefix, message, channel, sender)
	if prefix == "BuffLib" and sender ~= UnitName("player") and not RealmNames[GetRealmName()] then
		local guid, name, duration, timeLeft = strsplit(",", message)
		if guid == UnitGUID("target") then
			self:UNIT_AURA("target")
		elseif guid == UnitGUID("focus") then	
			self:UNIT_AURA("focus")
		elseif guid == UnitGUID("party1") then	
			self:UNIT_AURA("party1")
		elseif guid == UnitGUID("party2") then	
			self:UNIT_AURA("party2")
		elseif guid == UnitGUID("party3") then	
			self:UNIT_AURA("party3")
		elseif guid == UnitGUID("party4") then		
			self:UNIT_AURA("party4")			
		end
	elseif prefix == "GladdyTrinketUsed" and sender ~= UnitName("player") then
		self:TrinketUsed(message, nil, nil)
	end	
end

function TrinketTracker:UNIT_AURA(unitID, ...)
	if unitIDs[unitID] then
		for i=1, 40 do
			local name, rank, icon, count, debuffType, duration, timeLeft = UnitDebuff(unitID, i)
			if timeLeft ~= nil and timeLeft > 0 and self.abilities[name] then
				self:StartTimer(UnitGUID(unitID), name, timeLeft, duration)
			end
		end
	end
end

function TrinketTracker:CheckTrinket(category, destGUID, destName, spellTimer, spellName)
	if not category then return end
	local damage, periodicDamage, bigDamage, iceblock, wotf, bubble, escapeartist,
	stoneform, freedom, protection, dispel, tremor, zerker, sprint, blink, blazspeed,
	cloak, bm, deathwish, interrupt, shapeshift, override
	
	--[[if category["none"] then
		self:TrinketUsed(destGUID, destName, spellName)
		return
	end]]	
	if category["damage"] then
		damage = self:CheckDamage(destGUID, spellTimer)
		if damage == true then
			log(spellName.." on "..destName.." broke on damage")
		end
	end
	if category["periodicDamage"] then
		periodicDamage = self:CheckPeriodicDamage(destGUID, spellTimer)
		if periodicDamage  == true then
			log(spellName.." on "..destName.. "broke on periodic damage")
		end
	end
	if category["tremor"] then
		tremor = self:CheckTremor(destGUID, spellTimer)
		if tremor  == true then
			log(spellName.." on "..destName.. "broke on tremor")
		end
	end
	if category[45438] then
		iceblock = self:CheckImmunity(destGUID, spellTimer, 45438)
		if iceblock == true then
			log(spellName.." on "..destName.." broke with ice block")
		end
	end
	if category[7744] then
		wotf = self:CheckImmunity(destGUID, spellTimer, 7744)
		if wotf == true then
			log(spellName.." on "..destName.." broke with will")
		end
	end
	if category[1020] then
		bubble = self:CheckImmunity(destGUID, spellTimer, 1020)
		if bubble == true then
			log(spellName.." on "..destName.." broke with bubble")
		end
	end
	if category[20594] then
		stoneform = self:CheckImmunity(destGUID, spellTimer, 20594)
		if stoneform == true then
			log(spellName.." on "..destName.." broke with stoneform")
		end	
	end
	if category[20589] then
		escapeartist = self:CheckImmunity(destGUID, spellTimer, 20589)
		if escapeartist == true then
			log(spellName.." on "..destName.." broke with escape artist")
		end	
	end
	if category[1044] then
		freedom = self:CheckImmunity(destGUID, spellTimer, 1044)
		if freedom == true then
			log(spellName.." on "..destName.." broke with freedom")
		end	
	end
	if category[10278] then
		protection = self:CheckImmunity(destGUID, spellTimer, 10278)
		if protection == true then
			log(spellName.." on "..destName.." broke with protection")
		end	
	end
	if category[18499] then
		zerker = self:CheckImmunity(destGUID, spellTimer, 18499)
		if zerker == true then
			log(spellName.." on "..destName.." broke with zerker rage")
		end	
	end
	if category[1953] then
		blink = self:CheckImmunity(destGUID, spellTimer, 1953)
		if blink == true then
			log(spellName.." on "..destName.." broke with blink")
		end	
	end
	if category[31642] then
		blazspeed = self:CheckImmunity(destGUID, spellTimer, 31642)
		if blazspeed == true then
			log(spellName.." on "..destName.." broke with blazing speed")
		end	
	end
	if category[11305] then
		sprint = self:CheckImmunity(destGUID, spellTimer, 11305)
		if sprint == true then
			log(spellName.." on "..destName.." broke with imp sprint")
		end	
	end
	if category[31224] then
		cloak = self:CheckImmunity(destGUID, spellTimer, 31224)
		if sprint == true then
			log(spellName.." on "..destName.." broke with cloak")
		end	
	end
	if category[34471] then
		bm = self:CheckImmunity(destGUID, spellTimer, 34471)
		if bm == true then
			log(spellName.." on "..destName.." broke with bm")
		end	
	end
	if category[12292] then
		deathwish = self:CheckImmunity(destGUID, spellTimer, 12292)
		if deathwish == true then
			log(spellName.." on "..destName.." broke with death wish")
		end	
	end
	if category["dispel"] then
		dispel = self:CheckDispel(destGUID, spellTimer, spellName)
		if dispel == true then
			log(spellName.." on "..destName.." was dispelled")
		end
	end
	if category["bigDamage"] then
		bigDamage = self:CheckBigDamage(destGUID, spellTimer)
		if bigDamage == true then
			log(spellName.." on "..destName.." broke on big damage")
		end
	end
	if category["interrupt"] then
		interrupt = self:CheckInterrupt(destGUID, spellTimer, spellName)
		if interrupt == true then
			log(spellName.." on "..destName.." broke on interrupt")
		end
	end	
	if category["shapeshift"] then
		shapeshift = self:CheckShapeShift(destGUID, spellTimer)
		if shapeshift == true then
			log(spellName.." on "..destName.." broke on shapeshift")
		end	
	end
	if category["override"] then
		override = self:CheckOverride(destGUID, spellTimer, spellName)
		if override == true then
			log(spellName.." on "..destName.." broke on being overwriten")
		end	
	end
	
	return damage, periodicDamage, bigDamage, iceblock, wotf, bubble, escapeartist,
	stoneform, freedom, protection, dispel, tremor, zerker, sprint, blink, blazspeed,
	cloak, bm, deathwish, interrupt, shapeshift, override
end

function TrinketTracker:HasTrinket(categoryType, destGUID, destName, spellName, ...)
	--takes all parameters
	local damage, periodicDamage, bigDamage, iceblock, wotf, bubble, escapeartist,
	stoneform, freedom, protection, dispel, tremor, zerker, sprint, blink, blazspeed,
	cloak, bm, deathwish, interrupt, shapeshift, override = select(1, ...)
	if categoryType == "physicalStun" then
		if not iceblock and not bubble and not protection and not blink and not bm then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "none" then
		if not override then
			self:TrinketUsed(destGUID, destName, spellName)
		end	
	elseif categoryType == "physicalPoly" then
		if not damage and not periodicDamage and not iceblock and not bubble and not protection then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "physicalPolyZerker" then
		if not damage and not periodicDamage and not iceblock and not bubble and not protection and not zerker and not bm then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "physicalPolyZerkerOverride" then
		if not damage and not periodicDamage and not iceblock and not bubble and not protection and not zerker and not bm and not override then
			self:TrinketUsed(destGUID, destName, spellName)
		end			
	elseif categoryType == "physicalRoot" then
		if not iceblock and not bubble and not protection and not freedom and not escapeartist and not sprint and not blazspeed and not blink and not bm and not shapeshift then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "physicalFearTremor" then -- Intimidating Shout needs a hack later because 2 spellIDs with one breaking on every damage, the other on bigDamage
		if not damage and not periodicDamage and not iceblock and not bubble and not protection and not tremor and not wotf and not zerker and not deathwish then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "physicalPolyPeriodic" then
		if not damage and not iceblock and not bubble and not protection and not zerker then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "magicPolyPeriodic" then -- Dragon's Breath
		if not damage and not iceblock and not bubble and not dispel then
			self:TrinketUsed(destGUID, destName, spellName)
		end	
	elseif categoryType == "magicPoly" then
		if not damage and not periodicDamage and not iceblock and not bubble and not dispel and not shapeshift and not override then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "magicRoots" then
		if not bigDamage and not iceblock and not bubble and not freedom and not escapeartist and not dispel and not sprint and not blazspeed and not blink and not bm and not cloak and not shapeshift then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "magicRootsOverride" then
		if not bigDamage and not iceblock and not bubble and not freedom and not escapeartist and not dispel and not sprint and not blazspeed and not blink and not bm and not cloak and not shapeshift and not override then
			self:TrinketUsed(destGUID, destName, spellName)
		end	
	elseif categoryType == "magicPolyTremor" then -- Hibernate
		if not damage and not periodicDamage and not iceblock and not bubble and not dispel and not tremor and not override then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "magicPolyTremorInterrupt" then -- Mind Control
		if not damage and not periodicDamage and not iceblock and not bubble and not dispel and not tremor and not interrupt and not wotf then
			self:TrinketUsed(destGUID, destName, spellName)
		end	
	elseif categoryType == "poisonPolyTremor" then
		if not damage and not periodicDamage and not iceblock and not bubble and not wotf and not dispel and not tremor and not stoneform then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "magicFearTremor" then
		if not bigDamage and not iceblock and not bubble and not dispel and not wotf and not tremor and not zerker and not deathwish then
			self:TrinketUsed(destGUID, destName, spellName)
		end
	elseif categoryType == "magicFearTremorOverride" then
		if not bigDamage and not iceblock and not bubble and not dispel and not wotf and not tremor and not zerker and not deathwish and not override then
			self:TrinketUsed(destGUID, destName, spellName)
		end	
	elseif categoryType == "magic" then
		if not iceblock and not bubble and not dispel then
			self:TrinketUsed(destGUID, destName, spellName)
		end	
	end
end

function TrinketTracker:TrinketUsed(destGUID, destName, spellName)
	if getglobal("GladdyFrame") and destName then
		for i=1,5 do
			local button = getglobal("GladdyButtonFrame"..i)
			if button and button.guid == destGUID then
				if self.cdFrames[i] == nil then
					self.cdFrames[i] = CreateFrame("Cooldown", "TrinketTimer"..i, button)
					self.cdFrames[i]:SetWidth(40)
					self.cdFrames[i]:SetHeight(40)
					self.cdFrames[i]:SetPoint("LEFT", button, "RIGHT")
					self.cdFrames[i]:SetCooldown(GetTime(), 120)
				else
					self.cdFrames[i]:SetCooldown(GetTime(), 120)
				end
			end	
		end
	--[[else
		if not self.trinketFrames[destName] then
			local frame 
			if map_length(self.trinketFrames) == 0 then
				frame = CreateFrame("Cooldown", "PvPTrinket_1", UIParent)
				frame.font=frame:CreateFontString("TrinketFont_1")
				frame:SetPoint("CENTER", 300, 50)
			else
				frame = CreateFrame("Cooldown", "PvPTrinket_"..map_length(self.trinketFrames)+1, UIParent)
				frame.font=frame:CreateFontString("TrinketFont_"..map_length(self.trinketFrames)+1)
				if (map_length(self.trinketFrames))%3 == 0 then
					frame:SetPoint("TOPLEFT", "PvPTrinket_"..map_length(self.trinketFrames)-2, "BOTTOMLEFT")
				else
					frame:SetPoint("TOPLEFT", "TrinketFont_"..map_length(self.trinketFrames), "TOPRIGHT")
				end
			end
			frame:SetHeight(30)
			frame:SetWidth(30)
			frame.texture = frame:CreateTexture("TrinketTexture", "BACKGROUND")
			frame.texture:SetTexture("Interface\\Icons\\inv_jewelry_trinketpvp_01")
			frame.texture:SetAllPoints(frame)
			frame.font:SetFontObject("GameFontNormal", 15)
			frame.font:SetText(destName)
			frame.font:SetPoint("TOPLEFT", frame, "TOPRIGHT")
			frame:SetCooldown(GetTime(), 120)
			self.trinketFrames[destName] = frame
		else
			self.trinketFrames[destName]:SetCooldown(GetTime(), 120)
		end]]	
	end
	--log("Trinket Used: "..destName.." for "..spellName)
	local Icon = ArenaLiveCore:GetHandler("Icon");
	--sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellNum,spellName = ...;
	SendAddonMessage("GladdyTrinketUsed", destGUID)
	Icon:OnEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_CAST_SUCCESS", time(), "SPELL_CAST_SUCCESS", destGUID, destName, nil, destGUID, destName, nil, 42292, "PvPTrinket")
	
end

function TrinketTracker:Test()
	for i=1,15 do
		TrinketTracker:TrinketUsed("someID", "name"..i)
	end
end

function TrinketTracker:CheckDispel(destGUID, spellTimer, searchName)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,extraSpellID,extraSpellName,extraSchool,auraType = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if eventType == "SPELL_DISPEL" and extraSpellName == searchName then			
				return true
			end
		end
	end
	return false
end

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function TrinketTracker:CheckTremor(destGUID, spellTimer)
	if self.tremor == true then
		local timeToTick = round(GetTime()-self.tremorTime, 0)%3
		if timeToTick == 0 then
			return true
		end
	end
	return false
end

-- needs more work, CC on sourceGUID can also cause interruption, needs list of interrupt spells and then search for SPELL_CAST_SUCCESS with destGUID
function TrinketTracker:CheckInterrupt(destGUID, spellTimer, searchName)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,extraSpellID,extraSpellName,extraSchoo = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if eventType == "SPELL_INTERRUPT" and extraSpellName == searchName then			
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckImmunity(destGUID, spellTimer, searchID)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if eventType == "SPELL_CAST_SUCCESS" and spellID == searchID then	
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckDamage(destGUID, spellTimer)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if damageEvents[eventType] then
				--log(timestamp.."  "..eventType.."  "..sourceGUID.."  "..sourceName.."  "..sourceFlags.."  "..destGUID.."  "..destName)
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckPeriodicDamage(destGUID, spellTimer)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if periodicDamageEvents[eventType] then
				--log(timestamp.."  "..eventType.."  "..sourceGUID.."  "..sourceName.."  "..sourceFlags.."  "..destGUID.."  "..destName)
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckBigDamage(destGUID, spellTimer)
	local damageduringCC = 0
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if bigDamageEvents[eventType] then
				if eventType == "SWING_DAMAGE" then
					damageduringCC = damageduringCC + arg1
				else
					damageduringCC = damageduringCC + arg4
				end
				if damageduringCC >= bigDamageValue then
					return true
				end
				-- small timeframe - if taken damage immediately before CC broke, assume it broke on damage
				if timestamp > GetTime()-0.15 and timestamp <= GetTime() then
					return true
				end
			end
		end
	end
	return false
end

function TrinketTracker:CheckShapeShift(destGUID, spellTimer)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if (eventType == "SPELL_CAST_SUCCESS" or eventType =="SPELL_AURA_REMOVED") and shapeshiftIDs[spellID] then	
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckOverride(searchGUID, spellTimer, searchName)
	for k,v in pairs(self.guids) do
		for i=0, 10 do
			local spellTable = v[i]
			if spellTable and k ~= searchGUID then
			-- not supposed to look in its own events || searchID = guid from which spell was just removed
			-- now search OTHER combatlog tables for SPELL_AURA_APPLIED immediately before searchGUID event was found
			local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
			spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
			-- buffer in case damage event is timestamped slightly after AURA_REMOVE
			--log(timestamp.."  "..eventType.."  "..destGUID.."  "..GetTime())
			if timestamp >= GetTime()-0.1 and timestamp <= GetTime()+0.1 then
				if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") and self.override[spellName] and spellName == searchName then	
					return true
				end
			end
			end
		end
	end
	return false
end

function TrinketTracker:CombatLogCache(guidTable, guid, ...)
	if ... == nil then log("empty event") return end
	if not guidTable then
		self.guids[guid] = {}
		guidTable = self.guids[guid]
	end
	
	if not guidTable.eventCount then
		guidTable.eventCount = 0
	else
		guidTable.eventCount = guidTable.eventCount + 1
	end
	local index = mod(guidTable.eventCount, 10)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19 = select(1, ...)
	guidTable[index] = {  
		[0] = arg1, [1] =arg2, [2] =arg3, [3] =arg4, [4] =arg5, [5] =arg6, [6] =arg7, [7] =arg8, [8] =arg9, [9] =arg10, [10] =arg11, [11] =arg12,
		[12] =arg13, [13] =arg14, [14] =arg15, [15] =arg16, [16] =arg17, [17] =arg18, [18] =arg19, 
	}
end

function TrinketTracker:TableToArgs(spellTable)
	return spellTable[0], spellTable[1], spellTable[2], spellTable[3], spellTable[4],
	spellTable[5], spellTable[6], spellTable[7], spellTable[8], spellTable[9], spellTable[10],
	spellTable[11], spellTable[12], spellTable[13],	spellTable[14], spellTable[15], spellTable[16],
	spellTable[17], spellTable[18]
end

--could take this out eventually, I think
function TrinketTracker:CombatLogEventToTable(...)
	local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags = select(1, ...)
	--overwrite timestamp -> need to check what happened between the time a timer was saved NOW, so events need a proper timestamp
	timestamp = GetTime()
	if eventType == "SWING_DAMAGE" then
		local _,_,_,_,_,_,_,_,amount,school,resisted,blocked,absorbed,glancing,crushing = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags, amount,school,resisted,blocked,absorbed,glancing,crushing
	elseif eventType == "SPELL_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing
	elseif eventType == "SPELL_DISPEL" or eventType == "SPELL_INTERRUPT" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,extraSpellID,extraSpellName,extraSchool,auraType = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,extraSpellID, extraSpellName, extraSchool, auraType
	elseif eventType == "SPELL_DRAIN" or eventType == "SPELL_LEECH" or eventType == "SPELL_PERIODIC_DRAIN" or eventType == "SPELL_PERIODIC_LEECH" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,amount,powerType,extraAmount = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,amount,powerType,extraAmount
	elseif eventType == "SPELL_CAST_SUCCESS" or "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool
	else
		-- only track combatlog events that actually matter
		log("shit event")
		return nil
	end
end

function TrinketTracker:COMBAT_LOG_EVENT_UNFILTERED(...)
	local timestamp, eventType, sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,auraType = select ( 1 , ... );
	--log(eventType.."  "..spellName)
	if eventType == "SPELL_AURA_REMOVED" and self.abilities[spellName] and self.guids[destGUID] and self.guids[destGUID][spellName] then
		local spellTimer = self.guids[destGUID][spellName]
		local category = categories[self.abilities[spellName]]
		if GetTime()+timeOutBuffer < spellTimer.startTime+spellTimer.timeLeft then -- if expected spell duration-0.1 was not reached when SPELL_AURA_REMOVED was fired do
			self:HasTrinket(self.abilities[spellName], destGUID, destName, spellName, self:CheckTrinket(category, destGUID, destName, spellTimer, spellName))
		end
	end
	
	-- "hack" for tremor
	if (eventType == "SPELL_CAST_SUCCESS" and spellID == 8143) or destName == GetSpellInfo(8143) then
		self:UpdateTremor(...)
	end
	
	-- fake event to prevent from having to cache a lot of SPELL_AURA_REMOVED
	-- REFRESH sometimes fires REMOVED whereas APPLIED sometimes fires after removed (multiple, inconsistent events -_- )
	if eventType == "SPELL_AURA_REMOVED" and shapeshiftIDs[spellID] then
		eventType = "SPELL_CAST_SUCCESS"
	end
	
	-- fake event for cases in which a spell gets removed for being casted on another target (see overrideIDs)
	if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") and self.override[spellName] then
		eventType = "SPELL_CAST_SUCCESS"
		
	end
	
	-- save last 11 combatlog events 
	if self.guids and logEvents[eventType] then
		if eventType == "SPELL_CAST_SUCCESS" and (not immunityIDs[spellID] and not shapeshiftIDs[spellID] and not self.override[spellName]) then return end
		-- sometimes SPELL_CAST_SUCCESS only has a sourceGUID, no destGUID. Unlike SPELL_AURA_APPLIED it's also fired before SPELL_AURA_REMOVE
		if eventType == "SPELL_CAST_SUCCESS" then
			-- some spells can only be casted on yourself (bubble, shapeshift) others can be casted by someone else (blessing of prot)
			if destGUID == nil or destName == nil then --destGUID should never be nil but 0x00000000000000
				self:CombatLogCache(self.guids[sourceGUID], sourceGUID, self:CombatLogEventToTable(...))
			else
				self:CombatLogCache(self.guids[destGUID], destGUID, self:CombatLogEventToTable(...))
			end
		else
			self:CombatLogCache(self.guids[destGUID], destGUID, self:CombatLogEventToTable(...))
		end
		
	end
end

-- hack for servers with serverside trinket support
if RealmNames[GetRealmName()] then
	TrinketTracker:UnregisterAllEvents()
	TrinketTracker:RegisterEvent("CHAT_MSG_ADDON")
end	