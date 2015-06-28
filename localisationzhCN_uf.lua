--[[ Simplified Chinese localisation done by curse user "ziscloud". Thanks a lot! ]]--

local addonName = "ArenaLiveUnitFrames";
local L = {};

if not (GetLocale() == "zhCN") then return end


-- GENERAL OPTIONS:
L["OPTIONS_TITLE"] = "ArenaLive [UnitFrames] 选项:";
L["ONLY_SHOW_CASTABLE_BUFFS"] = "只显示可施放Buff";
L["ONLY_SHOW_DISPELLABLE_DEBUFFS"] = "只显示可驱散的Debuff";
L["ONLY_SHOW_OWN_DEBUFFS"] = "只显示我施放的Debuff";
L["HIDE_BLIZZARD_CASTBAR"] = "掩藏暴雪自带施法条";
L["SLASH_CMD_DESCRIPTION"] = "打开选项菜单";
L["UNIT_FRAMES_BORDER_COLOUR"] = "框体边框颜色：";

-- OPTION PANEL NAMES:
L["OPTION_PANEL_NAME"] = "ArenaLive [UnitFrames]";
L["OPTION_PANEL_PLAYERFRAME_NAME"] = "玩家框体";
L["OPTION_PANEL_TARGETFRAME_NAME"] = "目标框体";
L["OPTION_PANEL_TARGETOFTARGETFRAME_NAME"] = "目标的目标框体";
L["OPTION_PANEL_FOCUSRAME_NAME"] = "焦点框体";
L["OPTION_PANEL_TARGETOFFOCUSFRAME_NAME"] = "焦点的目标框体";
L["OPTION_PANEL_PETFRAME_NAME"] = "宠物框体";
L["OPTION_PANEL_ARENAENEMYFRAEMS_NAME"] = "竞技场敌对框体";
L["OPTION_PANEL_PARTYFRAMES_NAME"] = "团队框体";

-- PLAYER FRAME OPTIONS:
L["OPTIONS_PLAYERFRAME_TITLE"] = "玩家框体选项：";
L["OPTIONS_TARGETFRAME_TITLE"] = "目标框体选项：";
L["OPTIONS_TARGETOFTARGETFRAME_TITLE"] = "目标的目标框体选项：";
L["OPTIONS_TARGETOFFOCUSFRAME_TITLE"] = "焦点的目标框体选项：";
L["OPTIONS_FOCUSFRAME_TITLE"] = "焦点框体选项：";
L["OPTIONS_PETFRAME_TITLE"] = "宠物框体选项：";
L["OPTIONS_ARENAENEMYFRAMES_TITLE"] = "竞技场敌对框体选项：";
L["OPTIONS_PARTYFRAMES_TITLE"] = "团队框体：";

-- PARTY FRAME OPTIONS
L["PARTY_TARGET_POSITION"] = "团队框体位置：";
L["PARTY_PETFRAME_POSITION"] = "宠物框体选项：";
L["PARTY_SHOW_IN_RAID"] = "在团队副本中显示";
L["PARTY_SHOW_IN_ARENA"] = "在竞技场中显示";
L["PARTY_SHOW_TARGETS"] = "显示团队目标框体";
L["PARTY_SHOW_PETFRAME"] = "显示宠物框体";
L["PARTY_SHOW_PLAYER"] = "显示玩家框体";

-- ARENA FRAME OPTIONS:

-- UNITFRAME OPTIONS:
L["ENABLE_FRAME"] = "启用框体";

L["FRAME_SCALE_PERCENT"] = "框体缩放比例(%)";
L["SPACE_BETWEEN_FRAMES"] = "框体之间的距离";
L["REVERSE_FILL_STATUSBARS"] = "反转状态条填充";

L["SHOWN_TEXT_IN_HEALTHBAR"] = "显示生命值：";
L["SHOWN_TEXT_IN_POWERBAR"] = "显示能量值：";

L["OPTIONS_CASTBAR_TITLE"] = "施法条：";
L["SHOW_CASTBAR"] = "显示施法条";
L["SHOW_CASTHISTORY"] = "显示施放记录";
L["CASTHISTORY_ICON_SIZE"] = "图标大小";
L["MAX_SHOWN_CASTHISTORY_ICONS"] = "显示施放历史图标";

L["OPTIONS_AURAFRAME_TITLE"] = "光环：";
L["SHOW_AURAFRAME"] = "显示Buffs和Debuffs";
L["RTL_AURAS"] = "从右到左排列光环";
L["MAX_SHOWN_BUFFS"] = "Buff的最大显示数量";
L["MAX_SHOWN_DEBUFFS"] = "Debuff的最大数量";
L["NORMAL_AURA_ICON_SIZE"] = "正常光环尺寸";
L["LARGE_AURA_ICON_SIZE"] = "放大光环尺寸";



L["GROW_UPWARDS"] = "向上增长";

L["OPTIONS_DRTRACKER_TITLE"] = "递减监视：";
L["SHOW_DRTRACKER"] = "显示递减监视";
L["SHOW_DRTRACKER_ICONSIZE"] = "递减图标大小";
L["DRTRACKER_ICON_SIZE"] = "图标大小";

L["RESET_FRAME_POSITION"] = "重置位置";

ArenaLiveCore:AddAddonLocalisation (addonName, L);