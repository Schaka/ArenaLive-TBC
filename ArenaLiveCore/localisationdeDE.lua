--[[ German localisation done by myself and "Syncrow". Thanks a lot! ]]--

local addonName = "ArenaLiveCore"
local L = getglobal("ArenaLiveLoc")

if not (GetLocale() == "deDE") then return end

-- General Localisation:
L["FONTSTYLE"] = [[Fonts\FRIZQT__.TTF]];
L["DEAD"] = "tot";
L["GHOST"] = "Geist";
L["DISCONNECTED"] = "Nicht verbunden";
L["ARENALIVE_CONFIRM_RELOADUI"] = "Die Benutzeroberfläche muss neu geladen werden, damit alle Änderungen in Kraft treten können. Möchtest du die Oberfläche jetzt neu laden?";

-- Name Text Handler:
L["<AFK>"] = "<AFK>";
L["<DND>"] = "<DND>";

-- CastBar Handler:
L["LOCKOUT!"] = "UNTERBROCHEN! (%s)";

-- CastHistory Handler
L["ERR_COULD_NOT_CREATE_CASTHISTORY_ICON"] = "Konnte keinen Icon für die Zauber-Historie %s erstellen.";

-- Aura Handler
L["ERR_NO_ADDON_NAME_DEFINED"] = "Konnte Aura SavedVariable nicht speichern, da kein Addonname angegeben wurde.";

-- FrameMover Handler
L["FRAME_MOVER_TEXT"] = [=[Linke Maustaste gedrückt halten und ziehen zum verschieben
 %s 
 (x = %d, y = %d)]=];

-- General Error messages:
L["ERR_ADD_CORE_ALREADY_EXISTS"] = "Konnte Kern nicht erstellen, da es bereits einen Kern mit nem Namen %s gibt!";
L["ERR_DELETE_CORE_DOESNT_EXISTS"] = "Konnte Kern nicht nicht entfernen, da kein Kern mit dem Namen %s existiert!";
L["ERR_GET_CORE_DOESNT_EXISTS"] = "Konnte Kern nicht aufrufen, da kein Kern mit dem Namen %s existiert!";

L["ERR_ADD_HANDLER_ALREADY_EXISTS"] = "Kann den Handler nicht erstellen, da es bereits ein Handler namens %s existiert!";
L["ERR_DELETE_HANDLER_DOESNT_EXISTS"] = "Konnte Handler nicht nicht entfernen, da kein Handler mit dem Namen %s existiert!";
L["ERR_GET_HANDLER_DOESNT_EXISTS"] = "Konnte Handler nicht aufrufen, da kein Handler mit dem Namen %s existiert!";
L["ERR_REGISTER_HANDLER_FOR_CORE_DOESNT_EXISTS"] = "Konnte Handler %s für den Kern %s nicht registrieren, da kein Kern mit dem Namen %s existiert!";

L["ERR_ADD_FRAME_HANDLER_DOESNT_EXISTS"] = "Konnte den Frame %s nicht hinzufügen, da kein Handler namens %s existiert!";

L["ERR_ADD_SLASHCMD_MODIFIER_ALREADY_IN_USE"] = "Es existiert bereits ein Slash-Command mit dem Modifier %s!";
L["ERR_SLASHCMD_MODIFIER_DOESNT_EXIST"] = "\"%s\" ist kein verfügbares Kommando. Tippe \"/alive info\" in den Chat ein, um eine Liste aller verfügbaren Kommandos zu erhalten.";
L["ERR_SLASHCMD_MODIFIER_LIST"] = "Liste aller verfügbaren Befehle:";

L["ERR_ADD_DATABASE_NAME_NOT_GIVEN"] = "Konnte Datenbank nicht hinzufügen, da kein Datenbankname angegeben wurde!";
L["ERR_ADD_DATABASE_ALREADY_EXISTS"] = "Konnte Datenbank nicht hinzufügen, da es bereits eine Datenbank mit dem Namen %s gibt!";
L["ERR_REMOVE_DATABASE_NAME_NOT_GIVEN"] = "Konnte Datenbank nicht entfernen, da kein Datenbankname angegeben wurde!";
L["ERR_REMOVE_DATABASE_DOESNT_EXISTS"] = "Konnte Datenbank nicht entfernen, da keine Datenbank %s existiert!";
L["ERR_UPDATE_DATABASE_NAME_NOT_GIVEN"] = "Konnte Datenbank nicht updaten, weil kein Datenbankname angegeben wurde!";
L["ERR_UPDATE_DATABASE_DOESNT_EXISTS"] = "Konnte Datenbank nicht updaten, da keine Datenbank namens %s existiert!";
L["ERR_GET_DATABASE_DOESNT_EXISTS"] = "Konnte Datenbankeintrag %s nicht aufrufen, da kein Datenbankeintrag mit dem Namen %s existiert!";
L["ERR_GET_DATABASE_NAME_NOT_GIVEN"] = "Konnte den Datenbankeintrag nicht abrufen, da kein Datenbankname angegeben wurde!";
L["ERR_SET_DATABASE_DOESNT_EXISTS"] = "Konnte Datenbankeintrag nicht setzen, da keine Datenbank %s existiert!";

L["ERR_SET_LOCALE_ADDON_NOT_GIVEN"] = "Konnte Lokalisierungseintrag nicht setzen, da kein Addonname angegeben wurde!";
L["ERR_SET_LOCALE_ADDON_DOESNT_EXIST"] = "Konnte Lokalisierungseintrag nicht setzen,d a kein Addon %s registriert ist!";
L["ERR_GET_LOCALE_ADDON_NOT_GIVEN"] = "Konnte Lokalisierungseintrag nicht aufrufen, da kein Addon angegeben wurde!";
L["ERR_GET_LOCALE_KEY_DOESNT_EXIST"] = "Konnte Lokalisierungseintrag nicht aufrufen, da kein Eintrag %s existiert!";
L["ERR_GET_LOCALE_ADDON_DOESNT_EXIST"] = "Konnte Lokalisierungseintrag nicht aufrufen, da kein Addon mit dem Namen %s registriert ist!";

L["ERR_ADD_UNITFRAME_NOT_GIVEN"] = "Konnte den Unitframe nicht hinzufügen, da kein gültiger Frame angegeben wurde!";
L["ERR_ADD_UNITFRAME_COMBATLOCKDOWN"] = "Kann den Unitframe aufgrund der Interfacesperrung im Kampf nicht hinzufügen! Bitte lade das Interface neu, sobald du nicht mehr im Kampf bist.";

L["ERR_REMOVE_UNITFRAME_COMBATLOCKDOWN"] = "Konnte  Unitframe aufgund des Combat Lockdown nicht hinzufügen! Bitte lade dein UI neu, sobald du nicht mehr im Kampf bist.";

L["ERR_REMOVE_UNITFRAME_UNITID_NOT_REGISTERED"] = "Kann die UnitID des Unitframe nicht entfernen, da er nicht für diese unitID registriert ist.";
L["ERR_REMOVE_UNITFRAME_GUID_NOT_REGISTERED"] = "Kann die GUID des Unitframes nicht entfernen, da er für diese GUID nicht registriert ist.";

L["ERR_ADD_NAME_ALIAS_NOT_GIVEN"] = "Kann Namensalias nicht hinzufügen, da entweder kein Alias oder kein zugehöriger Name angegeben wurde!";

L["ERR_ADD_COOLDOWN_NOT_GIVEN"] = "Kann den Cooldownframe nicht hinzufügen, weil entweder kein Cooldown- oder Elternframe gegeben ist.";



-- *** OPTION MENU ***

-- DropDownMenus
L["DROPDOWN_TITLE_PORTRAIT"] = "Portraitart:";
L["DROPDOWN_TITLE_ICON_TYPE"] = "Iconart:";
L["DROPDOWN_TITLE_HEALTH_BAR_COLOUR_MODE"] = "Lebensbalkenfarbe:";
L["DROPDOWN_TITLE_NAME_COLOUR_MODE"] = "Namensfarbe:";
L["DROPDOWN_TITLE_POSITION"] = "Position:";

L["DROPDOWN_OPTION_NONE"] = "Keine";
L["DROPDOWN_OPTION_PORTRAIT_THREE_D_PORTRAITS"] = "3D Portrait";
L["DROPDOWN_OPTION_PORTRAIT_CLASS_PORTRAITS"] = "Klassenbild";
L["DROPDOWN_OPTION_ICON_CLASS"] = "Klasse";
L["DROPDOWN_OPTION_ICON_RACE"] = "Rasse";
L["DROPDOWN_OPTION_ICON_PVP_TRINKET"] = "PvP-Schmuckstück";
L["DROPDOWN_OPTION_ICON_RACIAL"] = "Rassenfähigkeit";
L["DROPDOWN_OPTION_ICON_SPECIALISATION"] = "Spezialisierung";
L["DROPDOWN_OPTION_ICON_INTERRUPT_OR_DISPEL"] = "Unterbrechungs-/Reinigungszauber";
L["DROPDOWN_OPTION_CLASS_COLOUR"] = "Klassenfarbe";
L["DROPDOWN_OPTION_REACTION_COLOUR"] = "Reaktionsfarbe";
L["DROPDOWN_OPTION_SMOOTH_HEALTHBAR"] = "Momentanes Leben";
L["DROPDOWN_OPTION_ABOVE"] = "Darüber";
L["DROPDOWN_OPTION_BELLOW"] = "Darunter";
L["DROPDOWN_OPTION_LEFT"] = "Links";
L["DROPDOWN_OPTION_RIGHT"] = "Rechts";

-- Checkbuttons
L["SHOW_COOLDOWN_TEXT"] = "Zeige Abklingzeitentext";
L["SEC_UNTIL_CASTHISTORY_ICON_FADES"] = "Sekunden, bis ein Icon der Zauberhistorie verblasst";
L["LOCK_FRAMES"] = "Frames sperren";
L["ENABLE_ABSORB_DISPLAY"] = "Aktiviere Schildanzeige";
L["ENABLE_HEAL_PREDICTION"] = "Momentan gewirkte Heilung anzeigen";

-- Sliders
L["CC_INDICATOR_OPTIONS_TITLE"] = "Prioritäten der Kontrollverlustanzeige:";
L["CC_INDICATOR_OPTIONS_DESCRIPTION"] = "Hier kannst du die Prioritäten für die verschiedenen Arten von Crowd Control setzen. Wähle den Wert 0, um sie zu deaktivieren.";

L["SLIDER_DEFENSIVE_COOLDOWS_TITLE"] = "Defensive Fähigkeiten:";
L["SLIDER_OFFENSIVE_COOLDOWNS_TITLE"] = "Offensive Fähigkeiten:";
L["SLIDER_STUNS_TITLE"] = "Betäubungseffekte:";
L["SLIDER_SILENCE_TITLE"] = "Stilleeffekte:";
L["SLIDER_CROWD_CONTROL_TITLE"] = "Kontrollverlust:";
L["SLIDER_ROOTS_TITLE"] = "Unbeweglichkeitseffekte:";
L["SLIDER_DISARMS_TITLE"] = "Entwaffnungen:";
L["SLIDER_USEFULBUFF_TITLE"] = "Nützliche Stärkungszauber:";
L["SLIDER_USEFULDEBUFF_TITLE"] = "Nützliche Schwächungszauber:";

-- Option Menu Error messages:
L["ERR_OPTIONS_DROPDOWNTYPE_ALREADY_EXISTS"] = "Konnte Dropdownmenü nicht zu den Optionen hinzufügen, da der angegebene Typname bereits existiert!";
L["ERR_OPTIONS_DROPDOWN_INIT_DROPDOWNTYPE_DOESNT_EXIST"] = "Konnte Dropdownmenü nicht initialisieren, da kein Dropdownmenütyp %s existiert!";

-- Profile Menu:
L["OPTIONS_PROFILES_PANEL_TITLE"] = "Profile";
L["OPTIONS_PROFILES_TITLE"] = "Profile:";
L["OPTIONS_PROFILES_DESCRIPTION"] = "In diesem Menü kannst du die Einstellungen eines Charakters auf einen Anderen kopieren.";
L["OPTIONS_PROFILES_ERROR_DATABASE_DOES_NOT_EXIST"] = "Das Informationsprofil für die Datenbank konnte nicht erstellt werden, da keine Datenbank namens %s vorhanden ist!";
L["OPTIONS_PROFILES_ERROR_DATABASE_NOT_SAVED_BY_CHARACTER"] = "Das Informationsprofil für die Datenbank \"%s\" konnte nicht erstellt werden, da diese Datenbank nicht in der Lage ist Profile zu speichern!";
L["OPTIONS_PROFILES_CURRENT_PROFILE"] = "Derzeitiges Profil: ";
L["OPTIONS_PROFILES_COPY_FROM_DROPDOWN_TITLE"] = "Kopiere Eintrag von:";