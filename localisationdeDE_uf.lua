--[[ German localisation done by myself and "Syncrow". Thanks a lot! ]]--

local addonName = "ArenaLiveUnitFrames"
local L = {};

if not (GetLocale() == "deDE") then return end

-- GENERAL OPTIONS:
L["OPTIONS_TITLE"] = "ArenaLive [UnitFrames] Optionen:";
L["ONLY_SHOW_CASTABLE_BUFFS"] = "Zeige nur wirkbare Stärkungszauber bei verbündeten Zielen";
L["ONLY_SHOW_DISPELLABLE_DEBUFFS"] = "Zeige nur reinigbare Schwächungszauber bei verbündeten Zielen";
L["ONLY_SHOW_OWN_DEBUFFS"] = "Zeige nur meine eigenen Schwächungszauber bei gegnerischen Zielen";
L["HIDE_BLIZZARD_CASTBAR"] = "Verstecke Blizzards Spieler-Zauberleiste";
L["SLASH_CMD_DESCRIPTION"] = "Öffnet das Optionsmenü für ArenaLive [UnitFrames]";
L["UNIT_FRAMES_BORDER_COLOUR"] = "Rahmenfarbe der Unitframes:";

-- OPTION PANEL NAMES:
L["OPTION_PANEL_NAME"] = "ArenaLive [UnitFrames]";
L["OPTION_PANEL_PLAYERFRAME_NAME"] = "Spieler";
L["OPTION_PANEL_TARGETFRAME_NAME"] = "Ziel";
L["OPTION_PANEL_TARGETOFTARGETFRAME_NAME"] = "Ziel des Ziels";
L["OPTION_PANEL_FOCUSRAME_NAME"] = "Fokus";
L["OPTION_PANEL_TARGETOFFOCUSFRAME_NAME"] = "Ziel des Focus'";
L["OPTION_PANEL_PETFRAME_NAME"] = "Begleiter";
L["OPTION_PANEL_ARENAENEMYFRAEMS_NAME"] = "Arenagegner";
L["OPTION_PANEL_PARTYFRAMES_NAME"] = "Gruppe";

-- PLAYER FRAME OPTIONS:
L["OPTIONS_PLAYERFRAME_TITLE"] = "ArenaLive [UnitFrames] Spieler Frame Optionen:";
L["OPTIONS_TARGETFRAME_TITLE"] = "ArenaLive [UnitFrames] Ziel Frame Optionen:";
L["OPTIONS_TARGETOFTARGETFRAME_TITLE"] = "ArenaLive [UnitFrames] Ziel des Ziels Optionen:";
L["OPTIONS_TARGETOFFOCUSFRAME_TITLE"] = "ArenaLive [UnitFrames] Ziel des Fokus' Optionen:";
L["OPTIONS_FOCUSFRAME_TITLE"] = "ArenaLive [UnitFrames] Fokus Optionen:";
L["OPTIONS_PETFRAME_TITLE"] = "ArenaLive [UnitFrames] Begleiter Optionen:";
L["OPTIONS_ARENAENEMYFRAMES_TITLE"] = "ArenaLive [UnitFrames] Arenagegner Optionen:";
L["OPTIONS_PARTYFRAMES_TITLE"] = "ArenaLive [UnitFrames] Gruppen Optionen:"

-- PARTY FRAME OPTIONS
L["PARTY_TARGET_POSITION"] = "Gruppenzielposition:";
L["PARTY_PETFRAME_POSITION"] = "Begleiterframeposition:";
L["PARTY_SHOW_IN_RAID"] = "Im Raid anzeigen";
L["PARTY_SHOW_IN_ARENA"] = "In Arena anzeigen";
L["PARTY_SHOW_TARGETS"] = "Zeige Gruppenziele";
L["PARTY_SHOW_PETFRAME"] = "Zeige Begleiter";
L["PARTY_SHOW_PLAYER"] = "Zeige Spieler";

-- ARENA FRAME OPTIONS:

-- UNITFRAME OPTIONS:
L["ENABLE_FRAME"] = "Frame aktivieren";

L["FRAME_SCALE_PERCENT"] = "Frameskalierung (%)";
L["SPACE_BETWEEN_FRAMES"] = "Abstand zwischen Frames";
L["REVERSE_FILL_STATUSBARS"] = "Füllrichtung der Statusleisten umkehren";
L["SHOWN_TEXT_IN_HEALTHBAR"] = "Gezeigter Text im Lebensbalken:";
L["SHOWN_TEXT_IN_POWERBAR"] = "Gezeigter Text im Energiebalken:"
L["OPTIONS_CASTBAR_TITLE"] = "Zauberleiste:";
L["SHOW_CASTBAR"] = "Zauberleiste anzeigen";
L["SHOW_CASTHISTORY"] = "Zauberhistorie anzeigen";
L["CASTHISTORY_ICON_SIZE"] = "Icongröße";
L["MAX_SHOWN_CASTHISTORY_ICONS"] = "Anzahl angezeigter Zauberhistorienicons";

L["OPTIONS_AURAFRAME_TITLE"] = "Auren:";
L["SHOW_AURAFRAME"] = "Stärkungs- und Schwächungszauber anzeigen";
L["RTL_AURAS"] = "Auren von rechts nach links auflisten";
L["MAX_SHOWN_BUFFS"] = "Max gezeigte Stärkungszauber";
L["MAX_SHOWN_DEBUFFS"] = "Max gezeigte Schwächungszauber";
L["NORMAL_AURA_ICON_SIZE"] = "Normale Aurengröße";
L["LARGE_AURA_ICON_SIZE"] = "Große Aurengröße";

L["SHOW_DRTRACKER"] = "Zeige Diminishing Returns";
L["DRTRACKER_ICON_SIZE"] = "Icongröße";

L["GROW_UPWARDS"] = "Nach oben wachsen";
L["SPACE_BETWEEN_FRAMES"] = "Platz zwischen Frames";

L["OPTIONS_DRTRACKER_TITLE"] = "Diminishing Return Anzeige:";
L["SHOW_DRTRACKER"] = "Zeige DR Anzeige";
L["SHOW_DRTRACKER_ICONSIZE"] = "DR Icongröße";

L["RESET_FRAME_POSITION"] = "Position wiederherstellen";

ArenaLiveCore:AddAddonLocalisation (addonName, L);

