--[[ ArenaLive Core Functions: VoiceChat Icon Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
This file contains all relevant functions for voice chat icon display.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local VoiceChat = ArenaLiveCore:AddHandler("VoiceChat", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
VoiceChat:RegisterEvent("VOICE_START");
VoiceChat:RegisterEvent("VOICE_STOP");
VoiceChat:RegisterEvent("MUTELIST_UPDATE");

-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		return;
	end
	
	local mode;	
	local inInstance, instanceType = IsInInstance();
	
	if ( (instanceType == "pvp") or (instanceType == "arena") ) then
		mode = "Battleground";
	elseif ( IsInRaid() ) then
		mode = "raid";
	else
		mode = "party";
	end
	
	local status = GetVoiceStatus(unit, mode);
	
	if ( status ) then
		self.icon:Show();
		
		if ( GetMuteStatus(unit, mode) ) then
			self.flash:Hide();
			self.muted:Show();
		elseif ( UnitIsTalking(UnitName(unit)) ) then
			self.flash:Show();
			self.muted:Hide();
		else
			self.flash:Hide();
			self.muted:Hide();
		end
	else
		self:Reset();
	end

end

local function Reset (self)
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function VoiceChat:AddFrame (voiceFrame, icon, flash, muted, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.voiceFrame = voiceFrame;
	voiceFrame.unitFrame = unitFrame;
	
	unitFrame.handlerList.voiceFrame = true;
	
	-- Set references for textures.
	voiceFrame.icon = icon;
	voiceFrame.flash = flash;
	voiceFrame.muted = muted;
	
	-- Set the basic functions for the castbar.
	voiceFrame.Update = Update;
	voiceFrame.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the master looter icon handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function VoiceChat:OnEvent (event, ...)
	local unit;
	if ( event == "VOICE_START" or event == "VOICE_STOP" ) then
		unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.voiceFrame ) then
						affectedFrame.voiceFrame:Update();
					end
				end
			end
		end
	elseif ( event == "MUTELIST_UPDATE" ) then
		for frameKey, frame in ipairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then
				if ( frame.handlerList.voiceFrame ) then
					frame.voiceFrame:Update();
				end
			end
		end
	end

end