local addonName = ...;
local L = CreateFrame("Frame", "ArenaLiveLoc")
-- General Localisation:
L["FONTSTYLE"] = [[Fonts\FRIZQT__.TTF]];
L["DEAD"] = "Dead";
L["GHOST"] = "Ghost";
L["DISCONNECTED"] = "Disconnected";
L["ARENALIVE_CONFIRM_RELOADUI"] = "Some changed options need a reload of the Interface to take effect correctly. Do wish to reload the Interface now?";

-- Name Text Handler:
L["<AFK>"] = "<AFK>";
L["<DND>"] = "<DND>";

-- CastBar Handler:
L["LOCKOUT!"] = "LOCKOUT! (%s)";

-- CastHistory Handler
L["ERR_COULD_NOT_CREATE_CASTHISTORY_ICON"] = "Couldn't create history icon for the casthistory %s.";

-- Aura Handler
L["ERR_NO_ADDON_NAME_DEFINED"] = "Couldn't set Aura saved variable, because no addon name was given.";

-- FrameMover Handler
L["FRAME_MOVER_TEXT"] = "Drag to Move \n %s \n (x = %d, y = %d)";

-- General Error messages:
L["ERR_ADD_CORE_ALREADY_EXISTS"] = "Couldn't create core, because a core with the name %s already exists!";
L["ERR_DELETE_CORE_DOESNT_EXISTS"] = "Couldn't remove core, because a core with the name %s doesn't exists!";
L["ERR_GET_CORE_DOESNT_EXISTS"] = "Couldn't get core, because a core with the name %s doesn't exists!";

L["ERR_ADD_HANDLER_ALREADY_EXISTS"] = "Couldn't create handler, because a handler with the name %s already exists!";
L["ERR_DELETE_HANDLER_DOESNT_EXISTS"] = "Couldn't remove handler, because a handler with the name %s doesn't exists!";
L["ERR_GET_HANDLER_DOESNT_EXISTS"] = "Couldn't get handler, because a handler with the name %s doesn't exists!";
L["ERR_REGISTER_HANDLER_FOR_CORE_DOESNT_EXISTS"] = "Couldn't register Handler %s for %s core, because a core with the name %s doesn't exists!";

L["ERR_ADD_FRAME_HANDLER_DOESNT_EXISTS"] = "Couldn't add frame %s, because a handler with the name %s doesn't exists!";

L["ERR_ADD_SLASHCMD_MODIFIER_ALREADY_IN_USE"] = "A slash command with the modifier %s already exists!";
L["ERR_SLASHCMD_MODIFIER_DOESNT_EXIST"] = "\"%s\" isn't an available slash command. type /alive info in the chat to get a list of all available commands.";
L["ERR_SLASHCMD_MODIFIER_LIST"] = "List of all available commands:";

L["ERR_ADD_DATABASE_NAME_NOT_GIVEN"] = "Couldn't add database, because no database name was given!";
L["ERR_ADD_DATABASE_ALREADY_EXISTS"] = "Couldn't add database, because a database with the name %s already exists!";
L["ERR_REMOVE_DATABASE_NAME_NOT_GIVEN"] = "Couldn't remove database, because no database name was given!";
L["ERR_REMOVE_DATABASE_DOESNT_EXISTS"] = "Couldn't remove database, because no database named %s exists!";
L["ERR_UPDATE_DATABASE_NAME_NOT_GIVEN"] = "Couldn't update database, because no database name was given!";
L["ERR_UPDATE_DATABASE_DOESNT_EXISTS"] = "Couldn't update database, because no database named %s exists!";
L["ERR_GET_DATABASE_DOESNT_EXISTS"] = "Couldn't get database entry %s, because no database named %s exists!";
L["ERR_GET_DATABASE_NAME_NOT_GIVEN"] = "Couldn't get database entry, because no database named was given!";
L["ERR_SET_DATABASE_DOESNT_EXISTS"] = "Couldn't set database entry, because no database named %s exists!";

L["ERR_SET_LOCALE_ADDON_NOT_GIVEN"] = "Couldn't set localisation entry, because no addon name was given!";
L["ERR_SET_LOCALE_ADDON_DOESNT_EXIST"] = "Couldn't set localisation entry, because no addon named %s is registered!";
L["ERR_GET_LOCALE_ADDON_NOT_GIVEN"] = "Couldn't get localisation entry, because no addon name was given!";
L["ERR_GET_LOCALE_KEY_DOESNT_EXIST"] = "Couldn't get localisation entry, because no localisation key named %s exists!";
L["ERR_GET_LOCALE_ADDON_DOESNT_EXIST"] = "Couldn't get localisation entry, because no addon named %s is registered!";

L["ERR_ADD_UNITFRAME_NOT_GIVEN"] = "Couldn't add unit frame, because no valid frame was given!";
L["ERR_ADD_UNITFRAME_COMBATLOCKDOWN"] = "Couldn't add unit frame due to combat lockdown! Please reload your UI as soon as you're out of combat.";

L["ERR_REMOVE_UNITFRAME_COMBATLOCKDOWN"] = "Couldn't add unit frame due to combat lockdown! Please reload your UI as soon as you're out of combat.";

L["ERR_REMOVE_UNITFRAME_UNITID_NOT_REGISTERED"] = "Cannot remove unit frame's unitID, because it isn't registered for this unitID.";
L["ERR_REMOVE_UNITFRAME_GUID_NOT_REGISTERED"] = "Cannot remove unit frame's GUID, because it isn't registered for this GUID.";

L["ERR_ADD_NAME_ALIAS_NOT_GIVEN"] = "Cannot add name alias, because either no alias or no unit name was given!";

L["ERR_ADD_COOLDOWN_NOT_GIVEN"] = "Cannot add cooldown, because either no cooldown frame or parent frame was given!";



-- *** OPTION MENU ***

-- DropDownMenus
L["DROPDOWN_TITLE_PORTRAIT"] = "Portrait Type:";
L["DROPDOWN_TITLE_ICON_TYPE"] = "Icon Type:";
L["DROPDOWN_TITLE_HEALTH_BAR_COLOUR_MODE"] = "Healthbar Colour:";
L["DROPDOWN_TITLE_NAME_COLOUR_MODE"] = "Name Colour:";
L["DROPDOWN_TITLE_POSITION"] = "Position:";

L["DROPDOWN_OPTION_NONE"] = "None";
L["DROPDOWN_OPTION_PORTRAIT_THREE_D_PORTRAITS"] = "3D Portrait";
L["DROPDOWN_OPTION_PORTRAIT_CLASS_PORTRAITS"] = "Class Icon";
L["DROPDOWN_OPTION_ICON_CLASS"] = "Class";
L["DROPDOWN_OPTION_ICON_RACE"] = "Race";
L["DROPDOWN_OPTION_ICON_PVP_TRINKET"] = "PvP-Trinket";
L["DROPDOWN_OPTION_ICON_RACIAL"] = "Racial";
L["DROPDOWN_OPTION_ICON_SPECIALISATION"] = "Specialisation";
L["DROPDOWN_OPTION_ICON_INTERRUPT_OR_DISPEL"] = "Interrupt/Dispel";
L["DROPDOWN_OPTION_CLASS_COLOUR"] = "Class Colour";
L["DROPDOWN_OPTION_REACTION_COLOUR"] = "Reaction Colour";
L["DROPDOWN_OPTION_SMOOTH_HEALTHBAR"] = "Current Health";
L["DROPDOWN_OPTION_ABOVE"] = "Above";
L["DROPDOWN_OPTION_BELLOW"] = "Below";
L["DROPDOWN_OPTION_LEFT"] = "Left";
L["DROPDOWN_OPTION_RIGHT"] = "Right";

-- Checkbuttons
L["SHOW_COOLDOWN_TEXT"] = "Show cooldown text";
L["SEC_UNTIL_CASTHISTORY_ICON_FADES"] = "Seconds until a cast history icon fades";
L["LOCK_FRAMES"] = "Lock Frames";
L["ENABLE_ABSORB_DISPLAY"] = "Enable absorb display";
L["ENABLE_HEAL_PREDICTION"] = "Enable heal prediction";

-- Sliders
L["CC_INDICATOR_OPTIONS_TITLE"] = "Crowd Control Indicator Priorities:";
L["CC_INDICATOR_OPTIONS_DESCRIPTION"] = "Set the priorities for the different crowd control types, zero deactivates them.";

L["SLIDER_DEFENSIVE_COOLDOWS_TITLE"] = "Defensive Cooldowns:";
L["SLIDER_OFFENSIVE_COOLDOWNS_TITLE"] = "Offensive Cooldowns:";
L["SLIDER_STUNS_TITLE"] = "Stuns:";
L["SLIDER_SILENCE_TITLE"] = "Silence:";
L["SLIDER_CROWD_CONTROL_TITLE"] = "Crowd Control:";
L["SLIDER_ROOTS_TITLE"] = "Roots:";
L["SLIDER_DISARMS_TITLE"] = "Disarms:";
L["SLIDER_USEFULBUFF_TITLE"] = "Useful Buffs:";
L["SLIDER_USEFULDEBUFF_TITLE"] = "Useful Debuffs:";

-- Option Menu Error messages:
L["ERR_OPTIONS_DROPDOWNTYPE_ALREADY_EXISTS"] = "Cannot add dropdown menu type to options, because the defined type name already exists!";
L["ERR_OPTIONS_DROPDOWN_INIT_DROPDOWNTYPE_DOESNT_EXIST"] = "Cannot initialise dropdown menu, because the defined dropdown type %s doesn't exist!";

-- Profile Menu:
L["OPTIONS_PROFILES_PANEL_TITLE"] = "Profiles";
L["OPTIONS_PROFILES_TITLE"] = "Profiles:";
L["OPTIONS_PROFILES_DESCRIPTION"] = "In this menu you can copy your settings from one character to another one.";
L["OPTIONS_PROFILES_ERROR_DATABASE_DOES_NOT_EXIST"] = "Couldn't create profile info for database, because no database names %s exists!";
L["OPTIONS_PROFILES_ERROR_DATABASE_NOT_SAVED_BY_CHARACTER"] = "Couldn't create profile info for database \"%s\", because the database is not able to store profiles!";
L["OPTIONS_PROFILES_CURRENT_PROFILE"] = "Current Profile: ";
L["OPTIONS_PROFILES_COPY_FROM_DROPDOWN_TITLE"] = "Copy From:"