local addonName = "ArenaLiveUnitFrames"
local L = {};

-- GENERAL OPTIONS:
L["OPTIONS_TITLE"] = "ArenaLive [UnitFrames] Options:";
L["ONLY_SHOW_CASTABLE_BUFFS"] = "Only show castable buffs on allies";
L["ONLY_SHOW_DISPELLABLE_DEBUFFS"] = "Only show dispellable debuffs on allies";
L["ONLY_SHOW_OWN_DEBUFFS"] = "Only show my own debuffs on enemies";
L["HIDE_BLIZZARD_CASTBAR"] = "Hide Blizzard's player castbar";
L["SLASH_CMD_DESCRIPTION"] = "Opens the option menu for ArenaLive [UnitFrames]";
L["UNIT_FRAMES_BORDER_COLOUR"] = "Unit Frame Border Colour:";

-- OPTION PANEL NAMES:
L["OPTION_PANEL_NAME"] = "ArenaLive [UnitFrames]";
L["OPTION_PANEL_PLAYERFRAME_NAME"] = "Player Frame";
L["OPTION_PANEL_TARGETFRAME_NAME"] = "Target Frame";
L["OPTION_PANEL_TARGETOFTARGETFRAME_NAME"] = "Target of Target Frame";
L["OPTION_PANEL_FOCUSRAME_NAME"] = "Focus Frame";
L["OPTION_PANEL_TARGETOFFOCUSFRAME_NAME"] = "Target of Focus Frame";
L["OPTION_PANEL_PETFRAME_NAME"] = "Pet Frame";
L["OPTION_PANEL_ARENAENEMYFRAEMS_NAME"] = "Arena Enemy Frames";
L["OPTION_PANEL_PARTYFRAMES_NAME"] = "Party Frames";
L["OPTION_PANEL_BOSSFRAMES_NAME"] = "Boss Frames";

-- PLAYER FRAME OPTIONS:
L["OPTIONS_PLAYERFRAME_TITLE"] = "ArenaLive [UnitFrames] Player Frame Options:";
L["OPTIONS_TARGETFRAME_TITLE"] = "ArenaLive [UnitFrames] Target Frame Options:";
L["OPTIONS_TARGETOFTARGETFRAME_TITLE"] = "ArenaLive [UnitFrames] Target of Target Frame Options:";
L["OPTIONS_TARGETOFFOCUSFRAME_TITLE"] = "ArenaLive [UnitFrames] Target of Focus Frame Options:";
L["OPTIONS_FOCUSFRAME_TITLE"] = "ArenaLive [UnitFrames] Focus Frame Options:";
L["OPTIONS_PETFRAME_TITLE"] = "ArenaLive [UnitFrames] Pet Frame Options:";
L["OPTIONS_ARENAENEMYFRAMES_TITLE"] = "ArenaLive [UnitFrames] Arena Enemy Frames Options:";
L["OPTIONS_PARTYFRAMES_TITLE"] = "ArenaLive [UnitFrames] Party Frames:";
L["OPTIONS_BOSSFRAMES_TITLE"] = "ArenaLive [UnitFrames] Boss Frames:";

-- PARTY FRAME OPTIONS
L["PARTY_TARGET_POSITION"] = "Party Target Position:";
L["PARTY_PETFRAME_POSITION"] = "Pet Frame Position:";
L["PARTY_SHOW_IN_RAID"] = "Show in Raid";
L["PARTY_SHOW_IN_ARENA"] = "Show in Arena";
L["PARTY_SHOW_TARGETS"] = "Show Party Targets";
L["PARTY_SHOW_PETFRAME"] = "Show Pet Frame";
L["PARTY_SHOW_PLAYER"] = "Show Player";

-- ARENA FRAME OPTIONS:

-- BOSS FRAME OPTIONS:

-- UNITFRAME OPTIONS:
L["ENABLE_FRAME"] = "Enable frame";

L["FRAME_SCALE_PERCENT"] = "Frame scale (%)";
L["SPACE_BETWEEN_FRAMES"] = "Space between frames";
L["REVERSE_FILL_STATUSBARS"] = "Reverse fill statusbars";

L["SHOWN_TEXT_IN_HEALTHBAR"] = "Shown text in healthbar:";
L["SHOWN_TEXT_IN_POWERBAR"] = "Shown text in powerbar:";

L["OPTIONS_CASTBAR_TITLE"] = "Castbar:";
L["SHOW_CASTBAR"] = "Show castbar";
L["SHOW_CASTHISTORY"] = "Show cast history";
L["CASTHISTORY_ICON_SIZE"] = "Icon Size";
L["MAX_SHOWN_CASTHISTORY_ICONS"] = "Shown cast history Icons";

L["OPTIONS_AURAFRAME_TITLE"] = "Auras:";
L["SHOW_AURAFRAME"] = "Show Buffs and Debuffs";
L["RTL_AURAS"] = "Grow Auras from right to left";
L["MAX_SHOWN_BUFFS"] = "Max Shown Buffs";
L["MAX_SHOWN_DEBUFFS"] = "Max Shown Debuffs";
L["NORMAL_AURA_ICON_SIZE"] = "Normal Aura Size";
L["LARGE_AURA_ICON_SIZE"] = "Large Aura Size";

L["SHOW_DRTRACKER"] = "Show Diminishing Returns";
L["DRTRACKER_ICON_SIZE"] = "Icon Size";

L["GROW_UPWARDS"] = "Grow upwards";
L["SPACE_BETWEEN_FRAMES"] = "Space between frames";

L["OPTIONS_DRTRACKER_TITLE"] = "Diminishing Return Tracker:";
L["SHOW_DRTRACKER"] = "Show DR Tracker";
L["SHOW_DRTRACKER_ICONSIZE"] = "DR Icon Size";

L["RESET_FRAME_POSITION"] = "Reset Position";

ArenaLiveCore:AddAddonLocalisation (addonName, L);