local addonName = "ArenaLiveUnitFrames";
local Aura = ArenaLiveCore:GetHandler("Aura");
local DRTracker = ArenaLiveCore:GetHandler("DRTracker");
local HealthBar = ArenaLiveCore:GetHandler("HealthBar");
local PowerBar = ArenaLiveCore:GetHandler("PowerBar");
local CastBar = ArenaLiveCore:GetHandler("CastBar");
local FrameHider = ArenaLiveCore:GetHandler("FrameHider");
local NameText = ArenaLiveCore:GetHandler("NameText");
local Portrait = ArenaLiveCore:GetHandler("Portrait");
local Icon = ArenaLiveCore:GetHandler("Icon");
local StatusBarText = ArenaLiveCore:GetHandler("StatusBarText");
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");
local ProfileMenu = ArenaLiveCore:GetHandler("ProfileMenu");

local UnitFrames =
{
	["ALUF_PlayerFrame"] = true,
	["ALUF_PetFrame"] = true,
	["ALUF_TargetFrame"] = true,
	["ALUF_TargetofTargetFrame"] = true,
	["ALUF_FocusFrame"] = true,
	["ALUF_TargetofFocusFrame"] = true,
	["ALUF_PartyFrame1"] = true,
	["ALUF_PartyFrame1PetFrame"] = true,
	["ALUF_PartyFrame1TargetFrame"] = true,
	["ALUF_PartyFrame2"] = true,
	["ALUF_PartyFrame2PetFrame"] = true,
	["ALUF_PartyFrame2TargetFrame"] = true,
	["ALUF_PartyFrame3"] = true,
	["ALUF_PartyFrame3PetFrame"] = true,
	["ALUF_PartyFrame3TargetFrame"] = true,
	["ALUF_PartyFrame4"] = true,
	["ALUF_PartyFrame4PetFrame"] = true,
	["ALUF_PartyFrame4TargetFrame"] = true,
	["ALUF_PartyPlayerFrame"] = false,
	["ALUF_PartyPlayerFramePetFrame"] = false,
	["ALUF_PartyPlayerFrameTargetFrame"] = false,
	["ALUF_ArenaEnemyFrame1"] = true,
	["ALUF_ArenaEnemyFrame2"] = true,
	["ALUF_ArenaEnemyFrame3"] = true,
	["ALUF_ArenaEnemyFrame4"] = true,
	["ALUF_ArenaEnemyFrame5"] = true,
}

local function PlayerFrameOptions_Initialise()
	
	-- Register Options panel
	ALUF_PlayerFrame_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_PLAYERFRAME_NAME");
	ALUF_PlayerFrame_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_PlayerFrame_Options);
	
	ALUF_PlayerFrame_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PLAYERFRAME_TITLE"));
	ALUF_PlayerFrame_OptionsCastBarTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_CASTBAR_TITLE"));
	ALUF_PlayerFrame_OptionsAuraTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_AURAFRAME_TITLE"));
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PlayerFrame_OptionsIsEnabled, addonName, "PlayerFrame/Enabled", "ENABLE_FRAME", function() ALUF_PlayerFrame:Toggle(); local enabled = ArenaLiveCore:GetDBEntry(addonName, "PlayerFrame/Enabled"); if ( enabled ) then  FrameHider:AddFrame(PlayerFrame); else FrameHider:RemoveFrame(PlayerFrame); end FrameHider:Refresh();  end);
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PlayerFrame_OptionsShowCastBar, addonName,  "PlayerFrame/CastBar/Enabled", "SHOW_CASTBAR", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "PlayerFrame/CastBar/Enabled"); if ( enabled ) then ALUF_PlayerFrameCastBar:Enable(); else ALUF_PlayerFrameCastBar:Disable(); end ALUF_PlayerFrame:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PlayerFrame_OptionsShowAuras, addonName, "PlayerFrame/AuraFrame/Enabled", "SHOW_AURAFRAME", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "PlayerFrame/AuraFrame/Enabled"); if ( enabled ) then ALUF_PlayerFrameAuraFrame:Enable(); else ALUF_PlayerFrameAuraFrame:Disable(); end ALUF_PlayerFrame:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PlayerFrame_OptionsRTLAuras, addonName, "PlayerFrame/AuraFrame/RTL", "RTL_AURAS", function() ALUF_PlayerFrameAuraFrame:Update(); end);
	
	ArenaLiveOptions:InitialiseEditBox(ALUF_PlayerFrame_OptionsHealthBarText, addonName, "PlayerFrame/HealthBar/Text", "SHOWN_TEXT_IN_HEALTHBAR", function() ALUF_PlayerFrameHealthBarText:Update(); end);
	ArenaLiveOptions:InitialiseEditBox(ALUF_PlayerFrame_OptionsPowerBarText, addonName, "PlayerFrame/PowerBar/Text", "SHOWN_TEXT_IN_POWERBAR", function() ALUF_PlayerFramePowerBarText:Update(); end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_PlayerFrame_OptionsFrameScale, addonName, "PlayerFrame/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "PlayerFrame/Scale"); scale = scale / 100; ALUF_PlayerFrame:SetScale(scale); ALUF_PlayerFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PlayerFrame_OptionsNormalAuraIconSize, addonName, "PlayerFrame/AuraFrame/NormalIconSize", "NORMAL_AURA_ICON_SIZE", function() ALUF_PlayerFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PlayerFrame_OptionsLargeAuraIconSize, addonName, "PlayerFrame/AuraFrame/PlayerIconSize", "LARGE_AURA_ICON_SIZE", function() ALUF_PlayerFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PlayerFrame_OptionsMaxShownBuffs, addonName, "PlayerFrame/AuraFrame/MaxShownBuffs", "MAX_SHOWN_BUFFS", function() ALUF_PlayerFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PlayerFrame_OptionsMaxShownDebuffs, addonName, "PlayerFrame/AuraFrame/MaxShownDebuffs", "MAX_SHOWN_DEBUFFS", function() ALUF_PlayerFrameAuraFrame:Update();  end);
	
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsPortraitType, "Portrait", addonName, "PlayerFrame/Portrait/Type", function() ALUF_PlayerFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsIcon1, "IconType", addonName, "PlayerFrame/Icon1/Type", function() ALUF_PlayerFrameIcon1:Update(); end, {[7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsIcon2, "IconType", addonName, "PlayerFrame/Icon2/Type", function() ALUF_PlayerFrameIcon2:Update(); end, {[7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsHealthBarColour, "HealthBarColourMode", addonName, "PlayerFrame/HealthBar/ColourMode", function() ALUF_PlayerFrameHealthBar:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsNameColour, "NameColourMode", addonName, "PlayerFrame/NameText/ColourMode", function() ALUF_PlayerFrameName:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsCastBarPosition, "Position", addonName, "PlayerFrame/CastBar/Position", function() ALUF_PlayerFrame:UpdateAttachements() end, {[3] = true, [4] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PlayerFrame_OptionsAuraPosition, "Position", addonName, "PlayerFrame/AuraFrame/Position", function() ALUF_PlayerFrame:UpdateAttachements() end, {[3] = true, [4] = true,});

end

local function PetFrameOptions_Initialise()
	
	-- Register Options panel
	ALUF_PetFrame_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_PETFRAME_NAME");
	ALUF_PetFrame_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_PetFrame_Options);
	
	ALUF_PetFrame_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PETFRAME_TITLE"));
	ALUF_PetFrame_OptionsAuraTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_AURAFRAME_TITLE"));
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PetFrame_OptionsIsEnabled, addonName, "PetFrame/Enabled", "ENABLE_FRAME", function() ALUF_PetFrame:Toggle(); local enabled = ArenaLiveCore:GetDBEntry(addonName, "PetFrame/Enabled"); if ( enabled ) then  FrameHider:AddFrame(PetFrame); else FrameHider:RemoveFrame(PetFrame); end FrameHider:Refresh();  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PetFrame_OptionsReverseFillStatusBars, addonName, "PetFrame/StatusBars/ReverseFill", "REVERSE_FILL_STATUSBARS", function() HealthBar:SetReverseFill(ALUF_PetFrame); PowerBar:SetReverseFill(ALUF_PetFrame); CastBar:SetReverseFill(ALUF_PetFrame); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PetFrame_OptionsShowAuras, addonName, "PetFrame/AuraFrame/Enabled", "SHOW_AURAFRAME", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "PetFrame/AuraFrame/Enabled"); if ( enabled ) then ALUF_PetFrameAuraFrame:Enable(); else ALUF_PetFrameAuraFrame:Disable(); end end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PetFrame_OptionsRTLAuras, addonName, "PetFrame/AuraFrame/RTL", "RTL_AURAS", function() ALUF_PetFrameAuraFrame:Update(); end);
	
	ArenaLiveOptions:InitialiseEditBox(ALUF_PetFrame_OptionsHealthBarText, addonName, "PetFrame/HealthBar/Text", "SHOWN_TEXT_IN_HEALTHBAR", function() ALUF_PetFrameHealthBarText:Update(); end);
	ArenaLiveOptions:InitialiseEditBox(ALUF_PetFrame_OptionsPowerBarText, addonName, "PetFrame/PowerBar/Text", "SHOWN_TEXT_IN_POWERBAR", function() ALUF_PetFramePowerBarText:Update(); end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_PetFrame_OptionsFrameScale, addonName, "PetFrame/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "PetFrame/Scale"); scale = scale / 100; ALUF_PetFrame:SetScale(scale); ALUF_PetFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PetFrame_OptionsNormalAuraIconSize, addonName, "PetFrame/AuraFrame/NormalIconSize", "NORMAL_AURA_ICON_SIZE", function() ALUF_PetFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PetFrame_OptionsLargeAuraIconSize, addonName, "PetFrame/AuraFrame/PlayerIconSize", "LARGE_AURA_ICON_SIZE", function() ALUF_PetFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PetFrame_OptionsMaxShownBuffs, addonName, "PetFrame/AuraFrame/MaxShownBuffs", "MAX_SHOWN_BUFFS", function() ALUF_PetFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PetFrame_OptionsMaxShownDebuffs, addonName, "PetFrame/AuraFrame/MaxShownDebuffs", "MAX_SHOWN_DEBUFFS", function() ALUF_PetFrameAuraFrame:Update();  end);
	
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PetFrame_OptionsHealthBarColour, "HealthBarColourMode", addonName, "PetFrame/HealthBar/ColourMode", function() ALUF_PetFrameHealthBar:SetColour()  end, {[2] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PetFrame_OptionsAuraPosition, "Position", addonName, "PetFrame/AuraFrame/Position", function() ALUF_PetFrame:UpdateAttachements() end, {[3] = true, [4] = true,});

end

local function TargetFrameOptions_Initialise()
	
	-- Register Options panel
	ALUF_TargetFrame_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_TARGETFRAME_NAME");
	ALUF_TargetFrame_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_TargetFrame_Options);
	
	ALUF_TargetFrame_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_TARGETFRAME_TITLE"));
	ALUF_TargetFrame_OptionsCastBarTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_CASTBAR_TITLE"));
	ALUF_TargetFrame_OptionsAuraTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_AURAFRAME_TITLE"));
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetFrame_OptionsIsEnabled, addonName, "TargetFrame/Enabled", "ENABLE_FRAME", function() ALUF_TargetFrame:Toggle(); local enabled = ArenaLiveCore:GetDBEntry(addonName, "TargetFrame/Enabled"); if ( enabled ) then  FrameHider:AddFrame(TargetFrame); else FrameHider:RemoveFrame(TargetFrame); end FrameHider:Refresh();  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetFrame_OptionsShowCastBar, addonName,  "TargetFrame/CastBar/Enabled", "SHOW_CASTBAR", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "TargetFrame/CastBar/Enabled"); if ( enabled ) then ALUF_TargetFrameCastBar:Enable(); else ALUF_TargetFrameCastBar:Disable(); end ALUF_TargetFrame:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetFrame_OptionsShowAuras, addonName, "TargetFrame/AuraFrame/Enabled", "SHOW_AURAFRAME", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "TargetFrame/AuraFrame/Enabled"); if ( enabled ) then ALUF_TargetFrameAuraFrame:Enable(); else ALUF_TargetFrameAuraFrame:Disable(); end ALUF_TargetFrame:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetFrame_OptionsRTLAuras, addonName, "TargetFrame/AuraFrame/RTL", "RTL_AURAS", function() ALUF_TargetFrameAuraFrame:Update(); end);
	
	ArenaLiveOptions:InitialiseEditBox(ALUF_TargetFrame_OptionsHealthBarText, addonName, "TargetFrame/HealthBar/Text", "SHOWN_TEXT_IN_HEALTHBAR", function() ALUF_TargetFrameHealthBarText:Update(); end);
	ArenaLiveOptions:InitialiseEditBox(ALUF_TargetFrame_OptionsPowerBarText, addonName, "TargetFrame/PowerBar/Text", "SHOWN_TEXT_IN_POWERBAR", function() ALUF_TargetFramePowerBarText:Update(); end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetFrame_OptionsFrameScale, addonName, "TargetFrame/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "TargetFrame/Scale"); scale = scale / 100; ALUF_TargetFrame:SetScale(scale); ALUF_TargetFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetFrame_OptionsNormalAuraIconSize, addonName, "TargetFrame/AuraFrame/NormalIconSize", "NORMAL_AURA_ICON_SIZE", function() ALUF_TargetFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetFrame_OptionsLargeAuraIconSize, addonName, "TargetFrame/AuraFrame/PlayerIconSize", "LARGE_AURA_ICON_SIZE", function() ALUF_TargetFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetFrame_OptionsMaxShownBuffs, addonName, "TargetFrame/AuraFrame/MaxShownBuffs", "MAX_SHOWN_BUFFS", function() ALUF_TargetFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetFrame_OptionsMaxShownDebuffs, addonName, "TargetFrame/AuraFrame/MaxShownDebuffs", "MAX_SHOWN_DEBUFFS", function() ALUF_TargetFrameAuraFrame:Update();  end);
	
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsPortraitType, "Portrait", addonName, "TargetFrame/Portrait/Type", function() ALUF_TargetFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsIcon1, "IconType", addonName, "TargetFrame/Icon1/Type", function() ALUF_TargetFrameIcon1:Update(); end, {[7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsIcon2, "IconType", addonName, "TargetFrame/Icon2/Type", function() ALUF_TargetFrameIcon2:Update(); end, {[7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsHealthBarColour, "HealthBarColourMode", addonName, "TargetFrame/HealthBar/ColourMode", function() ALUF_TargetFrameHealthBar:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsNameColour, "NameColourMode", addonName, "TargetFrame/NameText/ColourMode", function() ALUF_TargetFrameName:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsCastBarPosition, "Position", addonName, "TargetFrame/CastBar/Position", function() ALUF_TargetFrame:UpdateAttachements() end, {[3] = true, [4] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetFrame_OptionsAuraPosition, "Position", addonName, "TargetFrame/AuraFrame/Position", function() ALUF_TargetFrame:UpdateAttachements() end, {[3] = true, [4] = true,});

end

local function TargetOfTargetFrameOptions_Initialise()
	
	-- Register Options panel
	ALUF_TargetOfTargetFrame_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_TARGETOFTARGETFRAME_NAME");
	ALUF_TargetOfTargetFrame_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_TargetOfTargetFrame_Options);
	
	ALUF_TargetOfTargetFrame_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_TARGETOFTARGETFRAME_TITLE"));

	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetOfTargetFrame_OptionsIsEnabled, addonName, "TargetOfTargetFrame/Enabled", "ENABLE_FRAME", function() ALUF_TargetofTargetFrame:Toggle() end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetOfTargetFrame_OptionsReverseFillStatusBars, addonName, "TargetOfTargetFrame/StatusBars/ReverseFill", "REVERSE_FILL_STATUSBARS", function() HealthBar:SetReverseFill(ALUF_TargetofTargetFrame); PowerBar:SetReverseFill(ALUF_TargetofTargetFrame); CastBar:SetReverseFill(ALUF_TargetofTargetFrame); end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetOfTargetFrame_OptionsFrameScale, addonName, "TargetOfTargetFrame/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "TargetOfTargetFrame/Scale"); scale = scale / 100; ALUF_TargetofTargetFrame:SetScale(scale); ALUF_TargetofTargetFramePortrait:Update(); end);

	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetOfTargetFrame_OptionsPortraitType, "Portrait", addonName, "TargetOfTargetFrame/Portrait/Type", function() ALUF_TargetofTargetFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetOfTargetFrame_OptionsHealthBarColour, "HealthBarColourMode", addonName, "TargetOfTargetFrame/HealthBar/ColourMode", function() ALUF_TargetofTargetFrameHealthBar:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetOfTargetFrame_OptionsNameColour, "NameColourMode", addonName, "TargetOfTargetFrame/NameText/ColourMode", function() ALUF_TargetofTargetFrameName:SetColour()  end);

	ArenaLiveOptions:InitialiseButton(ALUF_TargetOfTargetFrame_OptionsResetPositionButton, addonName, "RESET_FRAME_POSITION", function() ALUF_TargetofTargetFrame:ResetPosition() end);
end

local function FocusFrameOptions_Initialise()
	
	-- Register Options panel
	ALUF_FocusFrame_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_FOCUSRAME_NAME");
	ALUF_FocusFrame_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_FocusFrame_Options);
	
	ALUF_FocusFrame_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_FOCUSFRAME_TITLE"));
	ALUF_FocusFrame_OptionsCastBarTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_CASTBAR_TITLE"));
	ALUF_FocusFrame_OptionsAuraTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_AURAFRAME_TITLE"));
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_FocusFrame_OptionsIsEnabled, addonName, "FocusFrame/Enabled", "ENABLE_FRAME", function() ALUF_FocusFrame:Toggle(); local enabled = ArenaLiveCore:GetDBEntry(addonName, "FocusFrame/Enabled"); if ( enabled ) then  FrameHider:AddFrame(FocusFrame); else FrameHider:RemoveFrame(FocusFrame); end FrameHider:Refresh();  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_FocusFrame_OptionsShowCastBar, addonName,  "FocusFrame/CastBar/Enabled", "SHOW_CASTBAR", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "FocusFrame/CastBar/Enabled"); if ( enabled ) then ALUF_FocusFrameCastBar:Enable(); else ALUF_FocusFrameCastBar:Disable(); end ALUF_FocusFrame:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_FocusFrame_OptionsShowAuras, addonName, "FocusFrame/AuraFrame/Enabled", "SHOW_AURAFRAME", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "FocusFrame/AuraFrame/Enabled"); if ( enabled ) then ALUF_FocusFrameAuraFrame:Enable(); else ALUF_FocusFrameAuraFrame:Disable(); end ALUF_FocusFrame:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_FocusFrame_OptionsRTLAuras, addonName, "FocusFrame/AuraFrame/RTL", "RTL_AURAS", function() ALUF_FocusFrameAuraFrame:Update(); end);
	
	ArenaLiveOptions:InitialiseEditBox(ALUF_FocusFrame_OptionsHealthBarText, addonName, "FocusFrame/HealthBar/Text", "SHOWN_TEXT_IN_HEALTHBAR", function() ALUF_FocusFrameHealthBarText:Update(); end);
	ArenaLiveOptions:InitialiseEditBox(ALUF_FocusFrame_OptionsPowerBarText, addonName, "FocusFrame/PowerBar/Text", "SHOWN_TEXT_IN_POWERBAR", function() ALUF_FocusFramePowerBarText:Update(); end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_FocusFrame_OptionsFrameScale, addonName, "FocusFrame/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "FocusFrame/Scale"); scale = scale / 100; ALUF_FocusFrame:SetScale(scale); ALUF_FocusFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseSlider(ALUF_FocusFrame_OptionsNormalAuraIconSize, addonName, "FocusFrame/AuraFrame/NormalIconSize", "NORMAL_AURA_ICON_SIZE", function() ALUF_FocusFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_FocusFrame_OptionsLargeAuraIconSize, addonName, "FocusFrame/AuraFrame/PlayerIconSize", "LARGE_AURA_ICON_SIZE", function() ALUF_FocusFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_FocusFrame_OptionsMaxShownBuffs, addonName, "FocusFrame/AuraFrame/MaxShownBuffs", "MAX_SHOWN_BUFFS", function() ALUF_FocusFrameAuraFrame:Update();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_FocusFrame_OptionsMaxShownDebuffs, addonName, "FocusFrame/AuraFrame/MaxShownDebuffs", "MAX_SHOWN_DEBUFFS", function() ALUF_FocusFrameAuraFrame:Update();  end);
	
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsPortraitType, "Portrait", addonName, "FocusFrame/Portrait/Type", function() ALUF_FocusFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsIcon1, "IconType", addonName, "FocusFrame/Icon1/Type", function()  ALUF_FocusFrameIcon1:Update(); end, {[7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsIcon2, "IconType", addonName, "FocusFrame/Icon2/Type", function()  ALUF_FocusFrameIcon2:Update(); end, {[7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsHealthBarColour, "HealthBarColourMode", addonName, "FocusFrame/HealthBar/ColourMode", function() ALUF_FocusFrameHealthBar:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsNameColour, "NameColourMode", addonName, "FocusFrame/NameText/ColourMode", function() ALUF_FocusFrameName:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsCastBarPosition, "Position", addonName, "FocusFrame/CastBar/Position", function() ALUF_FocusFrame:UpdateAttachements() end, {[3] = true, [4] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_FocusFrame_OptionsAuraPosition, "Position", addonName, "FocusFrame/AuraFrame/Position", function() ALUF_FocusFrame:UpdateAttachements() end, {[3] = true, [4] = true,});

end

local function TargetOfFocusFrameOptions_Initialise()
	
	-- Register Options panel
	ALUF_TargetOfFocusFrame_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_TARGETOFFOCUSFRAME_NAME");
	ALUF_TargetOfFocusFrame_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_TargetOfFocusFrame_Options);
	
	ALUF_TargetOfFocusFrame_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_TARGETOFFOCUSFRAME_TITLE"));

	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetOfFocusFrame_OptionsIsEnabled, addonName, "TargetOfFocusFrame/Enabled", "ENABLE_FRAME", function() ALUF_TargetofFocusFrame:Toggle() end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_TargetOfFocusFrame_OptionsReverseFillStatusBars, addonName, "TargetOfFocusFrame/StatusBars/ReverseFill", "REVERSE_FILL_STATUSBARS", function() HealthBar:SetReverseFill(ALUF_TargetofFocusFrame); PowerBar:SetReverseFill(ALUF_TargetofFocusFrame); CastBar:SetReverseFill(ALUF_TargetofFocusFrame); end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_TargetOfFocusFrame_OptionsFrameScale, addonName, "TargetOfFocusFrame/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "TargetOfFocusFrame/Scale"); scale = scale / 100; ALUF_TargetofFocusFrame:SetScale(scale); ALUF_TargetofFocusFramePortrait:Update(); end);

	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetOfFocusFrame_OptionsPortraitType, "Portrait", addonName, "TargetOfFocusFrame/Portrait/Type", function() ALUF_TargetofFocusFramePortrait:Update(); end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetOfFocusFrame_OptionsHealthBarColour, "HealthBarColourMode", addonName, "TargetOfFocusFrame/HealthBar/ColourMode", function() ALUF_TargetofFocusFrameHealthBar:SetColour()  end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_TargetOfFocusFrame_OptionsNameColour, "NameColourMode", addonName, "TargetOfFocusFrame/NameText/ColourMode", function() ALUF_TargetofFocusFrameName:SetColour()  end);

	ArenaLiveOptions:InitialiseButton(ALUF_TargetOfFocusFrame_OptionsResetPositionButton, addonName, "RESET_FRAME_POSITION", function() ALUF_TargetofFocusFrame:ResetPosition() end);
end

local function ArenaEnemyFramesOptions_Initialise()

	-- Register Options panel
	ALUF_ArenaEnemyFrames_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_ARENAENEMYFRAEMS_NAME");
	ALUF_ArenaEnemyFrames_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_ArenaEnemyFrames_Options);
	
	ALUF_ArenaEnemyFrames_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_ARENAENEMYFRAMES_TITLE"));
	ALUF_ArenaEnemyFrames_OptionsCastBarTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_CASTBAR_TITLE"));
	ALUF_ArenaEnemyFrames_OptionsDrTrackerTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_DRTRACKER_TITLE"));
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_ArenaEnemyFrames_OptionsIsEnabled, addonName, "ArenaFrames/Enabled", "ENABLE_FRAME", function() ALUF_ArenaEnemyFrames:Toggle();  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_ArenaEnemyFrames_OptionsReverseFillStatusBars, addonName, "ArenaFrames/StatusBars/ReverseFill", "REVERSE_FILL_STATUSBARS", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; HealthBar:SetReverseFill(frame); PowerBar:SetReverseFill(frame); CastBar:SetReverseFill(frame); end end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_ArenaEnemyFrames_OptionsGrowUpwards, addonName, "ArenaFrames/GrowUpwards", "GROW_UPWARDS", function() ALUF_ArenaEnemyFrames:UpdateFramePoints();  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_ArenaEnemyFrames_OptionsShowCastBar, addonName,  "ArenaFrames/CastBar/Enabled", "SHOW_CASTBAR", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "ArenaFrames/CastBar/Enabled"); for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; if ( enabled ) then frame.castBar:Enable(); else frame.castBar:Disable(); end end ALUF_ArenaEnemyFrames:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_ArenaEnemyFrames_OptionsShowDrTracker, addonName, "ArenaFrames/DRTracker/Enabled", "SHOW_DRTRACKER", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "ArenaFrames/DRTracker/Enabled"); for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; if ( enabled ) then frame.drTracker:Enable(); else frame.drTracker:Disable(); end end ALUF_ArenaEnemyFrames:UpdateAttachements(); end);	
	ArenaLiveOptions:InitialiseEditBox(ALUF_ArenaEnemyFrames_OptionsHealthBarText, addonName, "ArenaFrames/HealthBar/Text", "SHOWN_TEXT_IN_HEALTHBAR", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; frame.healthBarText:Update(); end end);
	ArenaLiveOptions:InitialiseEditBox(ALUF_ArenaEnemyFrames_OptionsPowerBarText, addonName, "ArenaFrames/PowerBar/Text", "SHOWN_TEXT_IN_POWERBAR", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; frame.powerBarText:Update(); end end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_ArenaEnemyFrames_OptionsFrameScale, addonName, "ArenaFrames/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "ArenaFrames/Scale"); scale = scale / 100; ALUF_ArenaEnemyFrames:SetScale(scale); for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; frame.portrait:Update(); end end);
	ArenaLiveOptions:InitialiseSlider(ALUF_ArenaEnemyFrames_OptionsFrameSpacing, addonName, "ArenaFrames/FrameSpacing", "SPACE_BETWEEN_FRAMES", function() ALUF_ArenaEnemyFrames:UpdateFramePoints();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_ArenaEnemyFrames_OptionsDrTrackerIconSize, addonName, "ArenaFrames/DRTracker/IconSize", "SHOW_DRTRACKER_ICONSIZE", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; DRTracker:UpdateSize(frame.drTracker); end end);

	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsPortraitType, "Portrait", addonName, "ArenaFrames/Portrait/Type", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; frame.portrait:Update(); end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsIcon1, "IconType", addonName, "ArenaFrames/Icon1/Type", function() for i = 1, 5 do ALUF_ArenaEnemyFrames["arenaFrame"..i]["icon1"]:Update(); end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsIcon2, "IconType", addonName, "ArenaFrames/Icon2/Type", function() for i = 1, 5 do ALUF_ArenaEnemyFrames["arenaFrame"..i]["icon2"]:Update(); end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsHealthBarColour, "HealthBarColourMode", addonName, "ArenaFrames/HealthBar/ColourMode", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; frame.healthBar:SetColour() end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsNameColour, "NameColourMode", addonName, "ArenaFrames/NameText/ColourMode", function() for i = 1, 5 do local frame = ALUF_ArenaEnemyFrames["arenaFrame"..i]; frame.nameText:SetColour(); end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsCastBarPosition, "Position", addonName, "ArenaFrames/CastBar/Position", function() ALUF_ArenaEnemyFrames:UpdateAttachements() end, {[1] = true, [2] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_ArenaEnemyFrames_OptionsDrTrackerPosition, "Position", addonName, "ArenaFrames/DRTracker/Position", function() ALUF_ArenaEnemyFrames:UpdateAttachements() end, {[1] = true, [2] = true,});

end

local function PartyFramesOptions_Initialise()

	-- Register Options panel
	ALUF_PartyFrames_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_PARTYFRAMES_NAME");
	ALUF_PartyFrames_Options.parent = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
	InterfaceOptions_AddCategory(ALUF_PartyFrames_Options);

	ALUF_PartyFrames_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_PARTYFRAMES_TITLE"));
	ALUF_PartyFrames_OptionsCastBarTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_CASTBAR_TITLE"));
	ALUF_PartyFrames_OptionsAuraTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_AURAFRAME_TITLE"));
	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsIsEnabled, addonName, "PartyFrames/Enabled", "ENABLE_FRAME", function() ALUF_PartyFrames:Toggle(); local enabled = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/Enabled"); if ( not enabled ) then StaticPopup_Show("ARENALIVE_CONFIRM_RELOADUI"); end end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsGrowUpwards, addonName, "PartyFrames/GrowUpwards", "GROW_UPWARDS", function() ALUF_PartyFrames:UpdateFramePoints();  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsShowInRaid, addonName, "PartyFrames/ShowInRaid", "PARTY_SHOW_IN_RAID", function() local showInRaid = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/ShowInRaid"); ALUF_PartyFrames:SetAttribute("showRaid", showInRaid);  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsShowInArena, addonName, "PartyFrames/ShowInArena", "PARTY_SHOW_IN_ARENA", function() local showInArena = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/ShowInArena"); ALUF_PartyFrames:SetAttribute("showArena", showInArena);  end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsShowCastBar, addonName,  "PartyFrames/CastBar/Enabled", "SHOW_CASTBAR", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/CastBar/Enabled"); local frame = ALUF_PartyFrames["partyPlayerFrame"]; if ( enabled ) then frame.castBar:Enable(); else frame.castBar:Disable(); end for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; if ( enabled ) then frame.castBar:Enable(); else frame.castBar:Disable(); end end ALUF_PartyFrames:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsShowAuras, addonName, "PartyFrames/AuraFrame/Enabled", "SHOW_AURAFRAME", function() local enabled = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/AuraFrame/Enabled"); local frame = ALUF_PartyFrames["partyPlayerFrame"]; if ( enabled ) then frame.auraFrame:Enable(); else frame.auraFrame:Disable(); end for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; if ( enabled ) then frame.auraFrame:Enable(); else frame.auraFrame:Disable(); end end end);	
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsShowTarget, addonName, "PartyFrames/TargetFrame/Enabled", "PARTY_SHOW_TARGETS", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; ALUF_PartyFrames:ToggleTargetFrame(frame, "target"); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; ALUF_PartyFrames:ToggleTargetFrame(frame, "party"..i.."target"); end ALUF_PartyFrames:UpdateAttachements(); end);
	ArenaLiveOptions:InitialiseCheckButton(ALUF_PartyFrames_OptionsShowPetFrame, addonName, "PartyFrames/PetFrame/Enabled", "PARTY_SHOW_PETFRAME", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; ALUF_PartyFrames:TogglePetFrame(frame, "pet"); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; ALUF_PartyFrames:TogglePetFrame(frame, "partypet"..i); end end);	
	
	ArenaLiveOptions:InitialiseEditBox(ALUF_PartyFrames_OptionsHealthBarText, addonName, "PartyFrames/HealthBar/Text", "SHOWN_TEXT_IN_HEALTHBAR", function()  local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.healthBarText:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.healthBarText:Update(); end end);
	ArenaLiveOptions:InitialiseEditBox(ALUF_PartyFrames_OptionsPowerBarText, addonName, "PartyFrames/PowerBar/Text", "SHOWN_TEXT_IN_POWERBAR", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.powerBarText:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.powerBarText:Update(); end end);
	
	ArenaLiveOptions:InitialiseSlider(ALUF_PartyFrames_OptionsFrameScale, addonName, "PartyFrames/Scale", "FRAME_SCALE_PERCENT", function() local scale = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/Scale"); scale = scale / 100; ALUF_PartyFrames:SetScale(scale); local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.portrait:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.portrait:Update(); end end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PartyFrames_OptionsFrameSpacing, addonName, "PartyFrames/FrameSpacing", "SPACE_BETWEEN_FRAMES", function() ALUF_PartyFrames:UpdateFramePoints();  end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PartyFrames_OptionsNormalAuraIconSize, addonName, "PartyFrames/AuraFrame/NormalIconSize", "NORMAL_AURA_ICON_SIZE", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.auraFrame:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.auraFrame:Update(); end end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PartyFrames_OptionsLargeAuraIconSize, addonName, "PartyFrames/AuraFrame/PlayerIconSize", "LARGE_AURA_ICON_SIZE", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.auraFrame:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.auraFrame:Update(); end end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PartyFrames_OptionsMaxShownBuffs, addonName, "PartyFrames/AuraFrame/MaxShownBuffs", "MAX_SHOWN_BUFFS", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.auraFrame:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.auraFrame:Update(); end end);
	ArenaLiveOptions:InitialiseSlider(ALUF_PartyFrames_OptionsMaxShownDebuffs, addonName, "PartyFrames/AuraFrame/MaxShownDebuffs", "MAX_SHOWN_DEBUFFS", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.auraFrame:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.auraFrame:Update(); end end);
	
	
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsPortraitType, "Portrait", addonName, "PartyFrames/Portrait/Type", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.portrait:Update(); for i = 1, 4 do frame = ALUF_PartyFrames["partyFrame"..i]; frame.portrait:Update(); end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsIcon1, "IconType", addonName, "PartyFrames/Icon1/Type", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.icon1:Update(); for i = 1, 4 do ALUF_PartyFrames["partyFrame"..i]["icon1"]:Update(); end end, {[5] = true, [7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsIcon2, "IconType", addonName, "PartyFrames/Icon2/Type", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.icon2:Update(); for i = 1, 4 do ALUF_PartyFrames["partyFrame"..i]["icon2"]:Update(); end end, {[5] = true, [7] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsHealthBarColour, "HealthBarColourMode", addonName, "PartyFrames/HealthBar/ColourMode", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.healthBar:SetColour();  for i = 1, 4 do local frame = ALUF_PartyFrames["partyFrame"..i]; frame.healthBar:SetColour() end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsNameColour, "NameColourMode", addonName, "PartyFrames/NameText/ColourMode", function() local frame = ALUF_PartyFrames["partyPlayerFrame"]; frame.nameText:SetColour();  for i = 1, 4 do local frame = ALUF_PartyFrames["partyFrame"..i]; frame.nameText:SetColour(); end end);
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsCastBarPosition, "Position", addonName, "PartyFrames/CastBar/Position", function() ALUF_PartyFrames:UpdateAttachements() end, {[1] = true, [2] = true,});
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsTargetPosition, "Position", addonName, "PartyFrames/TargetFrame/Position", function() ALUF_PartyFrames:UpdateAttachements() end, {[1] = true, [2] = true,}, "PARTY_TARGET_POSITION");
	ArenaLiveOptions:InitialiseDropDownMenu(ALUF_PartyFrames_OptionsPetFramePosition, "Position", addonName, "PartyFrames/PetFrame/Position", function() ALUF_PartyFrames:UpdateAttachements() end, {[1] = true, [2] = true,}, "PARTY_PETFRAME_POSITION");
end

local function ColourPickerButton_Update(restore)
	local newR, newG, newB, newA;
	
	if ( restore ) then
		newR, newG, newB, newA = unpack(restore);
	else
		newR, newG, newB, newA = ColorPickerFrame:GetColorRGB();
		newA = OpacitySliderFrame:GetValue();
	end

	ArenaLiveCore:SetDBEntry(addonName, "UnitFrames/Border/red", newR);
	ArenaLiveCore:SetDBEntry(addonName, "UnitFrames/Border/green", newG);
	ArenaLiveCore:SetDBEntry(addonName, "UnitFrames/Border/blue", newB);
	ArenaLiveCore:SetDBEntry(addonName, "UnitFrames/Border/alpha", newA);
	
	ALUF_Options:UpdateBorderColours();
end

local function ColourPickerButton_OnClick()

	local red = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/red") or 1;
	local green = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/green") or 1;
	local blue = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/blue") or 1;
	
	ColorPickerFrame.previousValues = {red, green, blue, alpha};
	ColorPickerFrame:SetColorRGB(red, green, blue);
	ColorPickerFrame.func = ColourPickerButton_Update;
	ColorPickerFrame.opacityFunc = ColourPickerButton_Update;
	ColorPickerFrame.cancelFunc = ColourPickerButton_Update;
	
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
	

end

function ALUF_Options:UpdateBorderColours()

	local red = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/red") or 1;
	local green = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/green") or 1;
	local blue = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/blue") or 1;
	local alpha = ArenaLiveCore:GetDBEntry(addonName, "UnitFrames/Border/alpha") or 1;

	-- Update Options Texture:
	ALUF_OptionsBorderColourPickerPickedColour:SetVertexColor(red, green, blue, alpha);
	
	-- Now update all frames:
	for frameName, value in pairs(UnitFrames) do
		local border = _G[frameName.."Border"];
		local castBarBorder = _G[frameName.."CastBarBorder"];
		if ( value ) then
			if ( border ) then
				border:SetVertexColor(red, green, blue, alpha);
			end
			if ( castBarBorder ) then
				castBarBorder:SetVertexColor(red, green, blue, alpha);
			end
		end
	end

end

function ALUF_Options:InitialiseColourPicker()
	-- Set title text:
	ALUF_OptionsBorderColourTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "UNIT_FRAMES_BORDER_COLOUR"));
	
	-- On Click Event:
	ALUF_OptionsBorderColourPicker:SetScript("OnClick", ColourPickerButton_OnClick);
end

function ALUF_Options:Initialise()

-- Set Option panel Title.
ALUF_OptionsTitle:SetText(ArenaLiveCore:GetLocalisation(addonName, "OPTIONS_TITLE"));

ALUF_Options.name = ArenaLiveCore:GetLocalisation(addonName, "OPTION_PANEL_NAME");
InterfaceOptions_AddCategory(ALUF_Options);

ArenaLiveOptions:InitialiseCheckButton(ALUF_OptionsOnlyShowCastableBuffs, addonName, "Auras/OnlyShowCastableBuffs", "ONLY_SHOW_CASTABLE_BUFFS", function() for key, frame in ipairs(UnitFrame.UnitFrameTable) do if ( frame.auraFrame ) then frame.auraFrame:Update(); end end end);
ArenaLiveOptions:InitialiseCheckButton(ALUF_OptionsOnlyShowDispellableDebuffs, addonName, "Auras/OnlyShowDispellableDebuffs", "ONLY_SHOW_DISPELLABLE_DEBUFFS", function() for key, frame in ipairs(UnitFrame.UnitFrameTable) do if ( frame.auraFrame ) then frame.auraFrame:Update(); end end end);
ArenaLiveOptions:InitialiseCheckButton(ALUF_OptionsOnlyShowPlayerDebuffs, addonName, "Auras/ShowOwnDebuffsOnly", "ONLY_SHOW_OWN_DEBUFFS", function() for key, frame in ipairs(UnitFrame.UnitFrameTable) do if ( frame.auraFrame ) then frame.auraFrame:Update(); end end end);
ArenaLiveOptions:InitialiseCheckButton(ALUF_OptionsHideBlizzCastBar, addonName, "HideBlizzardCastBar", "HIDE_BLIZZARD_CASTBAR", function() local hideBar = ALUF_OptionsHideBlizzCastBar:GetChecked(); if ( hideBar ) then FrameHider:AddFrame(CastingBarFrame); else FrameHider:RemoveFrame(CastingBarFrame); end FrameHider:Refresh();  end);
ALUF_Options:InitialiseColourPicker();

	PlayerFrameOptions_Initialise();
	PetFrameOptions_Initialise();
	TargetFrameOptions_Initialise();
	TargetOfTargetFrameOptions_Initialise();
	FocusFrameOptions_Initialise();
	TargetOfFocusFrameOptions_Initialise();
	ArenaEnemyFramesOptions_Initialise();
	PartyFramesOptions_Initialise();
	--BossFramesOptions_Initialise();
	
	-- Add Profile Menu:
	ProfileMenu:AddFrame(ALUF_ProfileMenu, ALUF_Options.name, addonName, ALUF_ProfileMenuCopyFromProfile, ALUF_ProfileMenuTitle, ALUF_ProfileMenuProfileDescription, ALUF_ProfileMenuCurrentProfile);
end

