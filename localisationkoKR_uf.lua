--[[Korean localisation done by curse user "jungwan2". Thanks a lot!
First Korean localisation was done by curse user "kennetshin", but couldn't be used due to the changes of the addon's core. Nevertheless you also have my thanks for your effort!]]--

local addonName = "ArenaLiveUnitFrames";
local L = {};

if not (GetLocale() == "koKR") then return end

-- GENERAL OPTIONS:
L["OPTIONS_TITLE"] = "ArenaLive [UnitFrames] 설정:";
L["ONLY_SHOW_CASTABLE_BUFFS"] = "오직 아군에 시전가능한 버프만 보여줍니다";
L["ONLY_SHOW_DISPELLABLE_DEBUFFS"] = "오직 아군에 해제가능한 디버프만 보여줍니다.";
L["ONLY_SHOW_OWN_DEBUFFS"] = "오직 적대적타켓에 적용된 자신의 디버프만 보여줍니다";
L["HIDE_BLIZZARD_CASTBAR"] = "블리자드 기본 시전바를 숨김";
L["SLASH_CMD_DESCRIPTION"] = "ArenaLive [UnitFrames]을 위한 설정 메뉴를 열기";

-- OTHER OPTIONS:


-- OPTION PANEL NAMES:
L["OPTION_PANEL_NAME"] = "ArenaLive [UnitFrames]";
L["OPTION_PANEL_PLAYERFRAME_NAME"] = "플레이어 프레임";
L["OPTION_PANEL_TARGETFRAME_NAME"] = "대상 프레임";
L["OPTION_PANEL_TARGETOFTARGETFRAME_NAME"] = "대상의 대상 프레임";
L["OPTION_PANEL_FOCUSRAME_NAME"] = "주시 프레임";
L["OPTION_PANEL_TARGETOFFOCUSFRAME_NAME"] = "타겟의 주시 프레임";
L["OPTION_PANEL_PETFRAME_NAME"] = "펫 프레임";
L["OPTION_PANEL_ARENAENEMYFRAEMS_NAME"] = "투기장 적 프레임";
L["OPTION_PANEL_PARTYFRAMES_NAME"] = "파티 프레임";

-- PLAYER FRAME OPTIONS:
L["OPTIONS_PLAYERFRAME_TITLE"] = "ArenaLive [UnitFrames] 플레이어 프레임 설정:";
L["OPTIONS_TARGETFRAME_TITLE"] = "ArenaLive [UnitFrames] 대상 프레임 설정:";
L["OPTIONS_TARGETOFTARGETFRAME_TITLE"] = "ArenaLive [UnitFrames] 대상의 대상 프레임 설정:";
L["OPTIONS_TARGETOFFOCUSFRAME_TITLE"] = "ArenaLive [UnitFrames] 대상의 주시 프레임 설정:";
L["OPTIONS_FOCUSFRAME_TITLE"] = "ArenaLive [UnitFrames] 주시 프레임 설정:";
L["OPTIONS_PETFRAME_TITLE"] = "ArenaLive [UnitFrames] 펫 프레임 설정:";
L["OPTIONS_ARENAENEMYFRAMES_TITLE"] = "ArenaLive [UnitFrames] 투기장 적 프레임 설정:";
L["OPTIONS_PARTYFRAMES_TITLE"] = "ArenaLive [UnitFrames] 파티 프레임:";

-- PARTY FRAME OPTIONS
L["PARTY_TARGET_POSITION"] = "파티 대상 위치:";
L["PARTY_PETFRAME_POSITION"] = "펫 프레임 위치:";
L["PARTY_SHOW_IN_RAID"] = "레이드에서 보이기";
L["PARTY_SHOW_IN_ARENA"] = "아레나에서 보이기";
L["PARTY_SHOW_TARGETS"] = "파티 타겟들 보이기";
L["PARTY_SHOW_PETFRAME"] = "펫 프레임 보이기";
L["PARTY_SHOW_PLAYER"] = "플레이어 보이기";

-- ARENA FRAME OPTIONS

-- UNITFRAME OPTIONS:
L["ENABLE_FRAME"] = "프레임 사용";

L["FRAME_SCALE_PERCENT"] = "프레임 크기 (%)";
L["SPACE_BETWEEN_FRAMES"] = "프레임간의 간격";
L["REVERSE_FILL_STATUSBARS"] = "상태바 반대로 채우기";

L["SHOWN_TEXT_IN_HEALTHBAR"] = "체력바에 텍스트 표시:";
L["SHOWN_TEXT_IN_POWERBAR"] = "기력바에 텍스트 표시:";

L["OPTIONS_CASTBAR_TITLE"] = "시전바:";
L["SHOW_CASTBAR"] = "시전바 보이기";
L["SHOW_CASTHISTORY"] = "시전 히스토리 보이기";
L["CASTHISTORY_ICON_SIZE"] = "아이콘 크기";
L["MAX_SHOWN_CASTHISTORY_ICONS"] = "시전 히스토리 아이콘 보이기";

L["OPTIONS_AURAFRAME_TITLE"] = "오라:";
L["SHOW_AURAFRAME"] = "버프와 디버프 보이기";
L["RTL_AURAS"] = "오른쪽에서 왼쪽으로 오라 확장";
L["MAX_SHOWN_BUFFS"] = "최대 버프 표시";
L["MAX_SHOWN_DEBUFFS"] = "최대 디버프 표시";
L["NORMAL_AURA_ICON_SIZE"] = "오라 보통 크기";
L["LARGE_AURA_ICON_SIZE"] = "오라 큰 크기";

L["SHOW_DRTRACKER"] = "DR Tracker 보이기";
L["DRTRACKER_ICON_SIZE"] = "DR Tracker 아이콘 크기";

L["GROW_UPWARDS"] = "위로 확장";
L["SPACE_BETWEEN_FRAMES"] = "프레임간의 간격";

L["OPTIONS_DRTRACKER_TITLE"] = "DR Tracker 애드온 지원:";
L["SHOW_DRTRACKER"] = "DR Tracker 보이기";
L["SHOW_DRTRACKER_ICONSIZE"] = "DR Tracker 아이콘 크기";

ArenaLiveCore:AddAddonLocalisation (addonName, L);