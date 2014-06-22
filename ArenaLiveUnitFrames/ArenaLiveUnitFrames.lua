local addonName = "ArenaLiveUnitFrames";
local FrameHider = ArenaLiveCore:GetHandler("FrameHider");

ArenaLiveUnitFrames.DEFAULTS = {

	["Version"] = "0.7beta6",

	["UnitFrames/Border/red"] = 1,
	["UnitFrames/Border/green"] = 1,
	["UnitFrames/Border/blue"] = 1,
	
	["PlayerFrame/Enabled"] = true,
	["PlayerFrame/Scale"] = 100,
	["PlayerFrame/Portrait/Type"] = "threeD",
	["PlayerFrame/Icon1/Type"] = "class",
	["PlayerFrame/Icon2/Type"] = "specialisation",
	["PlayerFrame/StatusBars/ReverseFill"] = false,
	["PlayerFrame/HealthBar/ColourMode"] = "class",
	["PlayerFrame/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PlayerFrame/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PlayerFrame/NameText/ColourMode"] = "reaction",
	["PlayerFrame/AuraFrame/Enabled"] = true,
	["PlayerFrame/AuraFrame/PlayerIconSize"] = 25,
	["PlayerFrame/AuraFrame/NormalIconSize"] = 21,
	["PlayerFrame/AuraFrame/GrowUpwards"] = false,
	["PlayerFrame/AuraFrame/MaxShownBuffs"] = 32,
	["PlayerFrame/AuraFrame/MaxShownDebuffs"] = 32,
	["PlayerFrame/AuraFrame/Position"] = "BELOW",
	["PlayerFrame/CastBar/Enabled"] = true,
	["PlayerFrame/CastBar/Position"] = "BELOW",
	["PlayerFrame/CastHistory/Enabled"] = true,
	["PlayerFrame/CastHistory/IconSize"] = 21,
	["PlayerFrame/CastHistory/Direction"] = "RIGHT",
	["PlayerFrame/CastHistory/MaxShownIcons"] = 6,
	["PlayerFrame/Position/Point"] = "TOPLEFT",
	["PlayerFrame/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["PlayerFrame/Position/RelativePoint"] = "TOPLEFT",
	["PlayerFrame/Position/XOffset"] = 19,
	["PlayerFrame/Position/YOffset"] = -4,
	
	["PetFrame/Enabled"] = true,
	["PetFrame/Scale"] = 100,
	["PetFrame/Portrait/Type"] = "threeD",
	["PetFrame/StatusBars/ReverseFill"] = false,
	["PetFrame/HealthBar/ColourMode"] = "none",
	["PetFrame/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PetFrame/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PetFrame/AuraFrame/Enabled"] = true,
	["PetFrame/AuraFrame/PlayerIconSize"] = 25,
	["PetFrame/AuraFrame/NormalIconSize"] = 21,
	["PetFrame/AuraFrame/GrowUpwards"] = false,
	["PetFrame/AuraFrame/MaxShownBuffs"] = 32,
	["PetFrame/AuraFrame/MaxShownDebuffs"] = 32,
	["PetFrame/AuraFrame/Position"] = "BELOW",
	["PetFrame/Position/Point"] = "TOPLEFT",
	["PetFrame/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["PetFrame/Position/RelativePoint"] = "TOPLEFT",
	["PetFrame/Position/XOffset"] = 19,
	["PetFrame/Position/YOffset"] = -138,
	
	["TargetFrame/Enabled"] = true,
	["TargetFrame/Scale"] = 100,
	["TargetFrame/Portrait/Type"] = "threeD",
	["TargetFrame/Icon1/Type"] = "class",
	["TargetFrame/Icon2/Type"] = "specialisation",
	["TargetFrame/StatusBars/ReverseFill"] = false,
	["TargetFrame/HealthBar/ColourMode"] = "class",
	["TargetFrame/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["TargetFrame/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["TargetFrame/NameText/ColourMode"] = "reaction",
	["TargetFrame/AuraFrame/Enabled"] = true,
	["TargetFrame/AuraFrame/PlayerIconSize"] = 25,
	["TargetFrame/AuraFrame/NormalIconSize"] = 21,
	["TargetFrame/AuraFrame/GrowUpwards"] = false,
	["TargetFrame/AuraFrame/MaxShownBuffs"] = 32,
	["TargetFrame/AuraFrame/MaxShownDebuffs"] = 32,
	["TargetFrame/AuraFrame/Position"] = "BELOW",
	["TargetFrame/CastBar/Enabled"] = true,
	["TargetFrame/CastBar/Position"] = "BELOW",
	["TargetFrame/CastHistory/Enabled"] = true,
	["TargetFrame/CastHistory/IconSize"] = 21,
	["TargetFrame/CastHistory/Direction"] = "LEFT",
	["TargetFrame/CastHistory/MaxShownIcons"] = 6,
	["TargetFrame/Position/Point"] = "TOPLEFT",
	["TargetFrame/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["TargetFrame/Position/RelativePoint"] = "TOPLEFT",
	["TargetFrame/Position/XOffset"] = 250,
	["TargetFrame/Position/YOffset"] = -4,
	
	["FocusFrame/Enabled"] = true,
	["FocusFrame/Scale"] = 100,
	["FocusFrame/Portrait/Type"] = "threeD",
	["FocusFrame/Icon1/Type"] = "class",
	["FocusFrame/Icon2/Type"] = "specialisation",
	["FocusFrame/StatusBars/ReverseFill"] = false,
	["FocusFrame/HealthBar/ColourMode"] = "class",
	["FocusFrame/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["FocusFrame/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["FocusFrame/NameText/ColourMode"] = "reaction",
	["FocusFrame/AuraFrame/Enabled"] = true,
	["FocusFrame/AuraFrame/PlayerIconSize"] = 25,
	["FocusFrame/AuraFrame/NormalIconSize"] = 21,
	["FocusFrame/AuraFrame/GrowUpwards"] = false,
	["FocusFrame/AuraFrame/MaxShownBuffs"] = 32,
	["FocusFrame/AuraFrame/MaxShownDebuffs"] = 32,
	["FocusFrame/AuraFrame/Position"] = "BELOW",
	["FocusFrame/CastBar/Enabled"] = true,
	["FocusFrame/CastBar/Position"] = "BELOW",
	["FocusFrame/CastHistory/Enabled"] = true,
	["FocusFrame/CastHistory/IconSize"] = 21,
	["FocusFrame/CastHistory/Direction"] = "LEFT",
	["FocusFrame/CastHistory/MaxShownIcons"] = 6,
	["FocusFrame/Position/Point"] = "TOPLEFT",
	["FocusFrame/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["FocusFrame/Position/RelativePoint"] = "TOPLEFT",
	["FocusFrame/Position/XOffset"] = 250,
	["FocusFrame/Position/YOffset"] = -138,
	
	["TargetOfTargetFrame/Enabled"] = true,
	["TargetOfTargetFrame/Scale"] = 100,
	["TargetOfTargetFrame/Portrait/Type"] = "class",
	["TargetOfTargetFrame/StatusBars/ReverseFill"] = false,
	["TargetOfTargetFrame/HealthBar/ColourMode"] = "class",
	["TargetOfTargetFrame/NameText/ColourMode"] = "reaction",
	["TargetOfTargetFrame/Position/Point"] = "BOTTOMLEFT",
	["TargetOfTargetFrame/Position/RelativeTo"] = "ALUF_TargetFrame",
	["TargetOfTargetFrame/Position/RelativePoint"] = "BOTTOMRIGHT",
	["TargetOfTargetFrame/Position/XOffset"] = 3,
	["TargetOfTargetFrame/Position/YOffset"] = 7,
	
	["TargetOfFocusFrame/Enabled"] = true,
	["TargetOfFocusFrame/Scale"] = 100,
	["TargetOfFocusFrame/Portrait/Type"] = "class",
	["TargetOfFocusFrame/StatusBars/ReverseFill"] = false,
	["TargetOfFocusFrame/HealthBar/ColourMode"] = "class",
	["TargetOfFocusFrame/NameText/ColourMode"] = "reaction",
	["TargetOfFocusFrame/Position/Point"] = "BOTTOMLEFT",
	["TargetOfFocusFrame/Position/RelativeTo"] = "ALUF_FocusFrame",
	["TargetOfFocusFrame/Position/RelativePoint"] = "BOTTOMRIGHT",
	["TargetOfFocusFrame/Position/XOffset"] = 3,
	["TargetOfFocusFrame/Position/YOffset"] = 7,
	
	["ArenaFrames/Enabled"] = true,
	["ArenaFrames/Scale"] = 100,
	["ArenaFrames/GrowUpwards"] = false,
	["ArenaFrames/FrameSpacing"] = 10,
	["ArenaFrames/Portrait/Type"] = "class",
	["ArenaFrames/Icon1/Type"] = "trinket",
	["ArenaFrames/Icon2/Type"] = "interruptOrDispel",
	["ArenaFrames/Icon3/Type"] = "specialisation",
	["ArenaFrames/StatusBars/ReverseFill"] = false,
	["ArenaFrames/HealthBar/ColourMode"] = "class",
	["ArenaFrames/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["ArenaFrames/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["ArenaFrames/NameText/ColourMode"] = "reaction",
	["ArenaFrames/CastBar/Enabled"] = true,
	["ArenaFrames/CastBar/Position"] = "LEFT",
	["ArenaFrames/CastHistory/Enabled"] = true,
	["ArenaFrames/CastHistory/IconSize"] = 21,
	["ArenaFrames/CastHistory/Direction"] = "RIGHT",
	["ArenaFrames/CastHistory/MaxShownIcons"] = 3,
	["ArenaFrames/DRTracker/Enabled"] = true,
	["ArenaFrames/DRTracker/Position"] = "RIGHT",
	["ArenaFrames/DRTracker/IconSize"] = 32,
	["ArenaFrames/Position/Point"] = "TOPRIGHT",
	["ArenaFrames/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["ArenaFrames/Position/RelativePoint"] = "TOPRIGHT",
	["ArenaFrames/Position/XOffset"] = -200,
	["ArenaFrames/Position/YOffset"] = -100,
	
	["PartyFrames/Enabled"] = true,
	["PartyFrames/ShowPlayer"] = true,
	["PartyFrames/ShowInArena"] = true,
	["PartyFrames/ShowInRaid"] = true,
	["PartyFrames/Scale"] = 100,
	["PartyFrames/FrameSpacing"] = 48,
	["PartyFrames/Portrait/Type"] = "threeD",
	["PartyFrames/Icon1/Type"] = "class",
	["PartyFrames/Icon2/Type"] = "trinket",
	["PartyFrames/StatusBars/ReverseFill"] = false,
	["PartyFrames/HealthBar/ColourMode"] = "class",
	["PartyFrames/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PartyFrames/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PartyFrames/NameText/ColourMode"] = "reaction",
	["PartyFrames/AuraFrame/Enabled"] = true,
	["PartyFrames/AuraFrame/PlayerIconSize"] = 25,
	["PartyFrames/AuraFrame/NormalIconSize"] = 21,
	["PartyFrames/AuraFrame/GrowUpwards"] = false,
	["PartyFrames/AuraFrame/MaxShownBuffs"] = 6,
	["PartyFrames/AuraFrame/MaxShownDebuffs"] = 6,
	["PartyFrames/AuraFrame/Position"] = "BELOW",
	["PartyFrames/CastBar/Enabled"] = true,
	["PartyFrames/CastBar/Position"] = "RIGHT",
	["PartyFrames/CastHistory/Enabled"] = true,
	["PartyFrames/CastHistory/IconSize"] = 21,
	["PartyFrames/CastHistory/Direction"] = "RIGHT",
	["PartyFrames/CastHistory/MaxShownIcons"] = 3,
	["PartyFrames/TargetFrame/Enabled"] = true,
	["PartyFrames/TargetFrame/Position"] = "RIGHT",
	["PartyFrames/PetFrame/Enabled"] = true,
	["PartyFrames/PetFrame/Position"] = "LEFT",
	["PartyFrames/Position/Point"] = "CENTER",
	["PartyFrames/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["PartyFrames/Position/RelativePoint"] = "CENTER",
	["PartyFrames/Position/XOffset"] = 0,
	["PartyFrames/Position/YOffset"] = 0,
	
	["PartyTargetFrame/Enabled"] = true,
	["PartyTargetFrame/Scale"] = 100,
	["PartyTargetFrame/Portrait/Type"] = "class",
	["PartyTargetFrame/StatusBars/ReverseFill"] = false,
	["PartyTargetFrame/HealthBar/ColourMode"] = "class",
	["PartyTargetFrame/NameText/ColourMode"] = "none",

	["PartyPetFrame/Enabled"] = true,
	["PartyPetFrame/Scale"] = 100,
	["PartyPetFrame/Portrait/Type"] = "threeD",
	["PartyPetFrame/StatusBars/ReverseFill"] = false,
	["PartyPetFrame/HealthBar/ColourMode"] = "none",
	["PartyPetFrame/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["PartyPetFrame/NameText/ColourMode"] = "none",
	
	["BossFrames/Enabled"] = true,
	["BossFrames/Scale"] = 100,
	["BossFrames/GrowUpwards"] = false,
	["BossFrames/FrameSpacing"] = 10,
	["BossFrames/Portrait/Type"] = "threeD",
	["BossFrames/StatusBars/ReverseFill"] = false,
	["BossFrames/HealthBar/ColourMode"] = "none",
	["BossFrames/HealthBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["BossFrames/PowerBar/Text"] = "%CURR_SHORT% / %MAX_SHORT% (%PERCENT_SHORT%%)",
	["BossFrames/NameText/ColourMode"] = "reaction",
	["BossFrames/CastBar/Enabled"] = true,
	["BossFrames/CastBar/Position"] = "LEFT",
	["BossFrames/CastHistory/Enabled"] = true,
	["BossFrames/CastHistory/IconSize"] = 21,
	["BossFrames/CastHistory/Direction"] = "RIGHT",
	["BossFrames/CastHistory/MaxShownIcons"] = 3,
	["BossFrames/Position/Point"] = "TOPRIGHT",
	["BossFrames/Position/RelativeTo"] = "ArenaLiveUnitFrames",
	["BossFrames/Position/RelativePoint"] = "TOPRIGHT",
	["BossFrames/Position/XOffset"] = -200,
	["BossFrames/Position/YOffset"] = -100,	
	
};

local framesToHide = {
		["ALUF_PlayerFrame"] =
		{
		[1] = "PlayerFrame",
		},
		["ALUF_TargetFrame"] =
		{
			[1] = "TargetFrame",
			[2] = "ComboFrame",
		},
		["ALUF_FocusFrame"] =
		{
			[1] = "FocusFrame",
		},
		["ALUF_PetFrame"] =
		{
			[1] = "PetFrame",
		},
		["ALUF_PartyFrames"] =
		{
			[1] = "PartyMemberFrame1",
			[2] = "PartyMemberFrame2",
			[3] = "PartyMemberFrame3",
			[4] = "PartyMemberFrame4",
		},
		--[[["ALUF_BossFrames"] =
		{
			[1] = "Boss1TargetFrame",
			[2] = "Boss2TargetFrame",
			[3] = "Boss3TargetFrame",
			[4] = "Boss4TargetFrame",
			[5] = "Boss5TargetFrame",
		},]]--
};

function ArenaLiveUnitFrames:OnEvent(event, ...)
	local arg1 = ...;
	if ( event == "ADDON_LOADED" and arg1 == addonName ) then
		if ( not ArenaLiveCore:DatabaseExists(addonName) ) then
			ArenaLiveCore:AddDatabase(addonName, ArenaLiveUnitFrames.DEFAULTS, true);
		else
			local version = ArenaLiveCore:GetDBEntry(addonName, "Version");
			
			-- Fill database with new entries for this version:
			--[[if ( not version or version < ArenaLiveUnitFrames.DEFAULTS.Version ) then
				if ( ArenaLiveUnitFrames.DEFAULTS.Version == 0.8 ) then
					ArenaLiveCore:SetDBEntry(addonName, "Version", 0.8);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Enabled", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Enabled"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Scale", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Scale"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/GrowUpwards", ArenaLiveUnitFrames.DEFAULTS["BossFrames/GrowUpwards"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/FrameSpacing", ArenaLiveUnitFrames.DEFAULTS["BossFrames/FrameSpacing"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Portrait/Type", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Portrait/Type"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/StatusBars/ReverseFill", ArenaLiveUnitFrames.DEFAULTS["BossFrames/StatusBars/ReverseFill"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/HealthBar/ColourMode", ArenaLiveUnitFrames.DEFAULTS["BossFrames/HealthBar/ColourMode"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/HealthBar/Text", ArenaLiveUnitFrames.DEFAULTS["BossFrames/HealthBar/Text"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/PowerBar/Text", ArenaLiveUnitFrames.DEFAULTS["BossFrames/PowerBar/Text"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/NameText/ColourMode", ArenaLiveUnitFrames.DEFAULTS["BossFrames/NameText/ColourMode"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/CastBar/Enabled", ArenaLiveUnitFrames.DEFAULTS["BossFrames/CastBar/Enabled"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/CastBar/Position", ArenaLiveUnitFrames.DEFAULTS["BossFrames/CastBar/Position"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/CastHistory/Enabled", ArenaLiveUnitFrames.DEFAULTS["BossFrames/CastHistory/Enabled"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/CastHistory/IconSize", ArenaLiveUnitFrames.DEFAULTS["BossFrames/CastHistory/IconSize"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/CastHistory/Direction", ArenaLiveUnitFrames.DEFAULTS["BossFrames/CastHistory/Direction"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/CastHistory/MaxShownIcons", ArenaLiveUnitFrames.DEFAULTS["BossFrames/CastHistory/MaxShownIcons"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Position/Point", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Position/Point"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Position/RelativeTo", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Position/RelativeTo"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Position/RelativePoint", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Position/RelativePoint"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Position/XOffset", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Position/XOffset"]);
					ArenaLiveCore:SetDBEntry(addonName, "BossFrames/Position/YOffset", ArenaLiveUnitFrames.DEFAULTS["BossFrames/Position/YOffset"]);
				end
			end]]--
		end
		
		ALUF_Options:Initialise();
		
		-- Initialise PlayerFrame (toggled as soon as "PLAYER_LOGIN" fires. Otherwise it would bug the player frame)
		ALUF_PlayerFrame:Initialise();
		
		-- Initialise PetFrame
		ALUF_PetFrame:Initialise();
		ALUF_PetFrame:UpdateAttachements();
		ALUF_PetFrame:Toggle();
		
		-- Initialise TargetFarme
		ALUF_TargetFrame:Initialise();
		ALUF_TargetFrame:UpdateAttachements();
		ALUF_TargetFrame:Toggle();
		
		-- Initialise TargetOfTargetFrame
		ALUF_TargetofTargetFrame:Initialise();
		ALUF_TargetofTargetFrame:Toggle();
		
		-- Initialise FocusFrame
		ALUF_FocusFrame:Initialise();
		ALUF_FocusFrame:UpdateAttachements();
		ALUF_FocusFrame:Toggle();
		
		-- Initialise TargetOfFocusFrame
		ALUF_TargetofFocusFrame:Initialise();
		ALUF_TargetofFocusFrame:Toggle();
		
		-- Initialise ArenaEnemyFrames
		ALUF_ArenaEnemyFrames:Initialise();
		ALUF_ArenaEnemyFrames:UpdateAttachements();
		ALUF_ArenaEnemyFrames:Toggle();

		-- Initialise PartyFrames
		ALUF_PartyFrames:Initialise();
		ALUF_PartyFrames:UpdateAttachements();
		ALUF_PartyFrames:Toggle();
		
		-- Initialise BossFrames
		--ALUF_BossFrames:Initialise();
		--ALUF_BossFrames:UpdateAttachements();
		--ALUF_BossFrames:Toggle();
		
		-- SHow/Hide Castbar
		local hideBar = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "HideBlizzardCastBar");
		if ( hideBar ) then 
			FrameHider:AddFrame(CastingBarFrame); 
		else
			FrameHider:RemoveFrame(CastingBarFrame); 
		end
		
		-- Show/Hide Blizzard's UnitFrames
		for alufFrameName, blizzFrames in pairs(framesToHide) do
			local alufFrame = _G[alufFrameName];
			local frameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", alufFrame.frameType.."/Enabled");
			if ( frameEnabled ) then
				for key, blizzFrameName in ipairs(framesToHide[alufFrameName]) do
					local blizzFrame = _G[blizzFrameName];
					if ( blizzFrame ) then
						FrameHider:AddFrame(blizzFrame);
					end
				end
			end
		end
		FrameHider:Refresh();
		
		-- Update Border Colours:
		ALUF_Options:UpdateBorderColours();
		
		-- Register Slash command:
		ArenaLiveCore:RegisterSlashCommand("aluf", ArenaLiveCore:GetLocalisation(addonName, "SLASH_CMD_DESCRIPTION"), function() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(ALUF_Options); end)
	elseif ( event == "PLAYER_LOGIN" ) then
		ALUF_PlayerFrame:Toggle();
		ALUF_PlayerFrame:UpdateAttachements();
	end
end

ArenaLiveUnitFrames:RegisterEvent("ADDON_LOADED");
ArenaLiveUnitFrames:RegisterEvent("PLAYER_LOGIN");
ArenaLiveUnitFrames:SetScript("OnEvent", ArenaLiveUnitFrames.OnEvent);