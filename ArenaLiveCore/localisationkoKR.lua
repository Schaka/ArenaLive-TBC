--[[ ArenaLive [Core]: Korean Localisation File
Created by: Vadrak
Creation Date: 6.07.2013
Last Update: 27.07.2013
Korean localisation done by curse user "jungwan2". Thanks a lot!
First Korean localisation was done by curse user "kennetshin", but couldn't be used due to the changes in the addon's core. Nevertheless you also have my thanks for your effort!
]]--

local _, L = ...;

if ( GetLocale() == "koKR" ) then
L["FONTSTYLE"] = [[Fonts\2002B.TTF]];
L["DEAD"] = "죽음";
L["GHOST"] = "유령";
L["DISCONNECTED"] = "접속종료";
L["ARENALIVE_CONFIRM_RELOADUI"] = "일부 변경 옵션이 제대로 적용하려면 인터페이스의 로드가 필요합니다. 지금 인터페이스를 다시 로드하시겠습니까?";

-- Name Text Handler:
L["<AFK>"] = "<자리비움>";
L["<DND>"] = "<다른용무중>";

-- CastBar Handler:
L["LOCKOUT!"] = "잠금! (%s)";

-- CastHistory Handler
L["ERR_COULD_NOT_CREATE_CASTHISTORY_ICON"] = "시전 히스토리 %s 에 대한 히스토리 아이콘을 만들 수 없습니다.";

-- Aura Handler
L["ERR_NO_ADDON_NAME_DEFINED"] = "애드온 이름을 지정하지 않았기 때문에 오라 변수 저장 설정을 할 수 없습니다.";

-- FrameMover Handler
L["FRAME_MOVER_TEXT"] = "드래그로 이동 \n %s \n (x = %d, y = %d)";

-- General Error messages:
L["ERR_ADD_CORE_ALREADY_EXISTS"] = "%s 라는 코어가 이미 존재하기 때문에, 코어를 만들 수 없습니다!";
L["ERR_DELETE_CORE_DOESNT_EXISTS"] = "%s 라는 코어가 존재하지 않기 때문에, 코어를 제거 할 수 없습니다!";
L["ERR_GET_CORE_DOESNT_EXISTS"] = "%s 라는 코어가 존재하지 않기 때문에, 코어를 확인할 수 없습니다!";

L["ERR_ADD_HANDLER_ALREADY_EXISTS"] = "%s 라는 핸들러가 이미 존재하기 때문에, 핸들러를 만들 수 없습니다!";
L["ERR_DELETE_HANDLER_DOESNT_EXISTS"] = "%s 라는 핸들러가 존재하지 않기 때문에, 핸들러를 제거 할 수 없습니다!";
L["ERR_GET_HANDLER_DOESNT_EXISTS"] = "%s 라는 핸들러가 존재하지 않기 때문에, 핸들러를 확인할 수 없습니다!";

L["ERR_ADD_FRAME_HANDLER_DOESNT_EXISTS"] = "%s 라는 핸들러가 존재하지 않기 때문에, 프레임 %s을(를) 추가 할 수 없습니다!";

L["ERR_ADD_SLASHCMD_MODIFIER_ALREADY_IN_USE"] = "변경자 %s 인 슬래시 명령이 이미 존재합니다!";
L["ERR_SLASHCMD_MODIFIER_DOESNT_EXIST"] = "\"%s\"은 가능한 슬래시 명령이 아닙니다. 채팅창에서 /alive info를 타이핑하여 모든 가능한 명령의 목록을 확인하십시오.";
L["ERR_SLASHCMD_MODIFIER_LIST"] = "사용할 수 있는 모든 명령어 목록:";

L["ERR_ADD_DATABASE_NAME_NOT_GIVEN"] = "데이터베이스 이름이 제공되지 않았기 때문에, 데이터베이스를 추가 할 수 없습니다!";
L["ERR_ADD_DATABASE_ALREADY_EXISTS"] = "%s 라는 데이터베이스가 이미 존재하기 때문에, 데이터베이스를 추가 할 수 없습니다!";
L["ERR_REMOVE_DATABASE_NAME_NOT_GIVEN"] = "데이터베이스 이름이 제공되지 않았기 때문에, 데이터베이스를 제거 할 수 없습니다!";
L["ERR_REMOVE_DATABASE_DOESNT_EXISTS"] = "%S 라는 데이터베이스가 존재하지 않기 때문에, 데이터베이스를 제거 할 수 없습니다!";
L["ERR_UPDATE_DATABASE_NAME_NOT_GIVEN"] = "데이터베이스 이름이 제공되지 않았기 때문에, 데이터베이스를 갱신할 수 없습니다!";
L["ERR_UPDATE_DATABASE_DOESNT_EXISTS"] = "%S 라는 데이터베이스가 존재하지 않기 때문에, 데이터베이스를 갱신할 수 없습니다!";
L["ERR_GET_DATABASE_DOESNT_EXISTS"] = "%S 라는 데이터베이스가 존재하지 않기 때문에, 데이터베이스 항목 %S을(를) 받을 수 없습니다!";
L["ERR_GET_DATABASE_NAME_NOT_GIVEN"] = "데이터베이스 이름이 주어지지 않았기 때문에, 데이터베이스 항목을 확인할 수 없습니다!";
L["ERR_SET_DATABASE_DOESNT_EXISTS"] = "% 라는 데이터베이스가 존재하지 않기 때문에, 데이터베이스 항목을 설정할 수 없습니다!";

L["ERR_SET_LOCALE_ADDON_NOT_GIVEN"] = "애드온 이름을 지정하지 않았기 때문에, 지역화 항목을 설정할 수 없습니다!";
L["ERR_SET_LOCALE_ADDON_DOESNT_EXIST"] = "애드온 이름 % s이(가) 등록되지 않았기 때문에, 지역화 항목을 설정할 수 없습니다!";
L["ERR_GET_LOCALE_ADDON_NOT_GIVEN"] = "애드온 이름을 지정하지 않았기 때문에, 지역화 항목을 확인할 수 없습니다!";
L["ERR_GET_LOCALE_KEY_DOESNT_EXIST"] = "지역화 키 %s의 존재하지 않기 때문에, 지역화 항목을 확인할 수 없습니다!";
L["ERR_GET_LOCALE_ADDON_DOESNT_EXIST"] = "애드온 이름 %s이(가) 등록되지 않았기 때문에, 지역화 항목을 확인할 수 없습니다!";

L["ERR_ADD_UNITFRAME_NOT_GIVEN"] = "유효한 프레임을 지정하지 않았기 때문에, 유닛 프레임을 추가 할 수 없습니다!";
L["ERR_ADD_UNITFRAME_COMBATLOCKDOWN"] = "전투 시에는 유닛 프레임을 추가 할 수 없도록 잠겨있습니다! 전투가 종료되면 UI를 다시 로드하십시오.";

L["ERR_REMOVE_UNITFRAME_COMBATLOCKDOWN"] = "전투 시에는 유닛 프레임을 삭제 할 수 없도록 잠겨있습니다! 전투가 종료되면 UI를 다시 로드하십시오.";

L["ERR_REMOVE_UNITFRAME_UNITID_NOT_REGISTERED"] = "이 unitID에 등록되어 있지 않기 때문에, 유닛 프레임의 unitID를 제거 할 수 없습니다.";
L["ERR_REMOVE_UNITFRAME_GUID_NOT_REGISTERED"] = "이 GUID에 등록되어 있지 않기 때문에, 유닛 프레임의 GUID를 제거 할 수 없습니다.";

L["ERR_ADD_NAME_ALIAS_NOT_GIVEN"] = "별칭 또는 유닛 이름 중 하나를 지정하지 않았기 때문에, 이름 별칭을 추가 할 수 없습니다!";

L["ERR_ADD_COOLDOWN_NOT_GIVEN"] = "재사용 대기 시간 프레임 또는 상위 프레임 중 하나가 주어지지 않았기 때문에, 재사용 대기 시간을 추가 할 수 없습니다!";



-- *** OPTION MENU ***

-- DropDownMenus
L["DROPDOWN_TITLE_PORTRAIT"] = "초상화 종류:";
L["DROPDOWN_TITLE_ICON_TYPE"] = "아이콘 종류:";
L["DROPDOWN_TITLE_HEALTH_BAR_COLOUR_MODE"] = "체력바 색상:";
L["DROPDOWN_TITLE_NAME_COLOUR_MODE"] = "이름 색상:";
L["DROPDOWN_TITLE_POSITION"] = "위치:";

L["DROPDOWN_OPTION_NONE"] = "None";
L["DROPDOWN_OPTION_PORTRAIT_THREE_D_PORTRAITS"] = "3D 초상화";
L["DROPDOWN_OPTION_PORTRAIT_CLASS_PORTRAITS"] = "직업 아이콘";
L["DROPDOWN_OPTION_ICON_CLASS"] = "직업";
L["DROPDOWN_OPTION_ICON_RACE"] = "종족";
L["DROPDOWN_OPTION_ICON_PVP_TRINKET"] = "PvP-급장";
L["DROPDOWN_OPTION_ICON_RACIAL"] = "종족특성";
L["DROPDOWN_OPTION_ICON_SPECIALISATION"] = "전문화";
L["DROPDOWN_OPTION_ICON_INTERRUPT_OR_DISPEL"] = "방해/해제";
L["DROPDOWN_OPTION_CLASS_COLOUR"] = "직업 색상";
L["DROPDOWN_OPTION_REACTION_COLOUR"] = "반응 색상";
L["DROPDOWN_OPTION_SMOOTH_HEALTHBAR"] = "현재 체력";
L["DROPDOWN_OPTION_ABOVE"] = "위";
L["DROPDOWN_OPTION_BELLOW"] = "아래";
L["DROPDOWN_OPTION_LEFT"] = "왼쪽";
L["DROPDOWN_OPTION_RIGHT"] = "오른쪽";



-- Checkbuttons
L["SHOW_COOLDOWN_TEXT"] = "재사용 대기시간 텍스트 보이기";
L["SEC_UNTIL_CASTHISTORY_ICON_FADES"] = "시전 히스토리 아이콘의 사라지기 까지의 시간(초)";
L["LOCK_FRAMES"] = "프레임 잠금";
L["ENABLE_ABSORB_DISPLAY"] = "흡수 표시 켜기";
L["ENABLE_HEAL_PREDICTION"] = "예상 치유량 켜기";

-- Sliders
L["CC_INDICATOR_OPTIONS_TITLE"] = "군중 제어(CC) 표시 우선 순위:";
L["CC_INDICATOR_OPTIONS_DESCRIPTION"] = "다른 군중 제어(CC) 유형에 대한 우선 순위 설정을 0으로 비활성화합니다.";

L["SLIDER_DEFENSIVE_COOLDOWS_TITLE"] = "방어 재사용 대기 시간:";
L["SLIDER_OFFENSIVE_COOLDOWNS_TITLE"] = "공격 재사용 대기 시간:";
L["SLIDER_STUNS_TITLE"] = "스턴:";
L["SLIDER_SILENCE_TITLE"] = "침묵:";
L["SLIDER_CROWD_CONTROL_TITLE"] = "군중 제어(CC):";
L["SLIDER_ROOTS_TITLE"] = "뿌리:";
L["SLIDER_DISARMS_TITLE"] = "무장해제:";
L["SLIDER_USEFULBUFF_TITLE"] = "유용한 버프:";
L["SLIDER_USEFULDEBUFF_TITLE"] = "유용한 디버프:";

-- Option Menu Error messages:
L["ERR_OPTIONS_DROPDOWNTYPE_ALREADY_EXISTS"] = "정의된 유형의 이름이 이미 존재하기 때문에, 옵션에 드롭 다운 메뉴 형식을 추가 할 수 없습니다!";
L["ERR_OPTIONS_DROPDOWN_INIT_DROPDOWNTYPE_DOESNT_EXIST"] = "정의된 드롭 다운 유형 %s은(는) 존재하지 않기 때문에, 드롭 다운 메뉴를 초기화 할 수 없습니다!";
end