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
local FrameHider = ArenaLiveCore:AddHandler("FrameHider", "EventCore");

FrameHider:RegisterEvent("PLAYER_REGEN_ENABLED");

-- Set up a table to store all frames that will be hidden.
local hiddenFrames = {};

-- Local variable to set, when a frame was inserted/removed in combat lockdown.
local combatLockDownUpdate = false;

-- *** HANDLER FUNCTIONS ***
function FrameHider:AddFrame (frame)
	
	if ( not frame ) then
		return;
	end
	
	hiddenFrames[frame] = true;
end

function FrameHider:RemoveFrame (frame)

	if ( not frame ) then
		return;
	end

	hiddenFrames[frame] = "show";
end

local needReloadUI = false;
function FrameHider:Refresh()
	if ( not InCombatLockdown() ) then
		combatLockDownUpdate = nil;
		for frame, value in pairs(hiddenFrames) do
			local frameName = frame:GetName();
			if ( value == "show" ) then
				local onLoad = frame:GetScript("OnLoad");
				
				if ( frameName ~= "PlayerFrame" and onLoad ) then
					frame.Show = nil;
					onLoad(frame);
				else
					frame:Show();
				end
				
				hiddenFrames[frame] = nil;
				
				if ( frameName ~= "CastingBarFrame" ) then
					needReloadUI = true;
				end
			else
				if ( frameName ~= "PlayerFrame" ) then
					-- Unregistering all events for player frame would cause taint, so it is an exception from the rule.
					frame:UnregisterAllEvents();
					frame.Show = function() end
				end	
				frame:Hide();
			end
		end
	else
		combatLockDownUpdate = true;
	end
	
	if ( needReloadUI ) then
		needReloadUI = false;
		StaticPopup_Show("ARENALIVE_CONFIRM_RELOADUI");
	end
end

function FrameHider:CheckHiddenStatus(frame)
	return hiddenFrames[frame];
end

function FrameHider:OnEvent(event, ...)
	
	if ( event == "PLAYER_REGEN_ENABLED" and combatLockDownUpdate ) then
		FrameHider:Refresh()
	end
	
end