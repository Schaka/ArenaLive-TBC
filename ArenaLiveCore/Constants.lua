local addonName = "ArenaLiveCore";
local L = getglobal("ArenaLiveLoc")

ArenaLiveCore.defaults = 
	{
		["FrameLock"] = true,
		["Cooldown/ShowText"] = true,
		["CCPriority/defCD"] = 100,
		["CCPriority/stun"] = 90,
		["CCPriority/silence"] = 80,
		["CCPriority/crowdControl"] = 70,
		["CCPriority/root"] = 60,
		["CCPriority/disarm"] = 50,
		["CCPriority/offCD"] = 40,
		["CCPriority/usefulBuffs"] = 30,
		["CCPriority/usefulDebuffs"] = 20,
	};

StaticPopupDialogs["ARENALIVE_CONFIRM_RELOADUI"] = {
	text = L["ARENALIVE_CONFIRM_RELOADUI"],
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) ReloadUI(); end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	preferredIndex = STATICPOPUP_NUMDIALOGS, -- avoid some UI taint.
}