--[[ Simplified Chinese localisation done by curse user "ziscloud". Thanks a lot! ]]--

local addonName, L = ...;

if not (GetLocale() == "zhCN") then return end

-- General Localisation:
L["FONTSTYLE"] = [[Fonts\ARKai_T.ttf]];
L["DEAD"] = "死亡";
L["GHOST"] = "灵魂";
L["DISCONNECTED"] = "离线";
L["ARENALIVE_CONFIRM_RELOADUI"] = "有一些配置需要重载界面才能生效。是否现在重载界面？";

-- Name Text Handler:
L["<AFK>"] = "<离开>";
L["<DND>"] = "<请勿打扰>";

-- CastBar Handler:
L["LOCKOUT!"] = "锁定！ (%s)";

-- CastHistory Handler
L["ERR_COULD_NOT_CREATE_CASTHISTORY_ICON"] = "无法为施放记录 %s 创建图标.";

-- Aura Handler
L["ERR_NO_ADDON_NAME_DEFINED"] = "无法设置光环的已保存变量，请指定插件名称！";

-- FrameMover Handler
L["FRAME_MOVER_TEXT"] = [=[拖动 
 %s 
 (x = %d, y = %d)]=];

-- General Error messages:
L["ERR_ADD_CORE_ALREADY_EXISTS"] = "无法创建核心模块，因为名为 %s 的核心模块以及存在！";
L["ERR_DELETE_CORE_DOESNT_EXISTS"] = "无法移除核心模块，因为名为 %s 的核心模块不存在！";
L["ERR_GET_CORE_DOESNT_EXISTS"] = "无法获取核心模块，因为名为 %s 的核心模块不存在！";

L["ERR_ADD_HANDLER_ALREADY_EXISTS"] = "无法创建handler，因为名为 %s 的handler已经存在！";
L["ERR_DELETE_HANDLER_DOESNT_EXISTS"] = "无法移除handler，因为名为 %s 的handler不存在！";
L["ERR_GET_HANDLER_DOESNT_EXISTS"] = "无法获取handler，因为名为 %s 的handler不存在！";
L["ERR_REGISTER_HANDLER_FOR_CORE_DOESNT_EXISTS"] = "无法注册名为 %s 的Handler到名为 %s 的核心模块， 因为名为 %s 的核心模块不存在！";

L["ERR_ADD_FRAME_HANDLER_DOESNT_EXISTS"] = "无法添加名为 %s 的框体，因为名为 %s 的框体Handler不存在！";

L["ERR_ADD_SLASHCMD_MODIFIER_ALREADY_IN_USE"] = "命令行指令 %s 已经存在！";
L["ERR_SLASHCMD_MODIFIER_DOESNT_EXIST"] = "\"%s\" 不是一个可用的命令行指令。在聊天框中输入 /alive 来查看所有可用的命令行指令。";
L["ERR_SLASHCMD_MODIFIER_LIST"] = "查看所有可用的命令行指令：";

L["ERR_ADD_DATABASE_NAME_NOT_GIVEN"] = "无法添加数据库，请指定一个数据库名！";
L["ERR_ADD_DATABASE_ALREADY_EXISTS"] = "无法添加数据库，因为名为 %s 的数据库已经存在！";
L["ERR_REMOVE_DATABASE_NAME_NOT_GIVEN"] = "无法删除数据库，请指定数据库名！";
L["ERR_REMOVE_DATABASE_DOESNT_EXISTS"] = "无法删除数据库，因为名为 %s 的数据库不存在！";
L["ERR_UPDATE_DATABASE_NAME_NOT_GIVEN"] = "无法更新数据库，请指定一个数据库名！";
L["ERR_UPDATE_DATABASE_DOESNT_EXISTS"] = "无法更新数据库，因为名为 %s 的数据库不存在！";
L["ERR_GET_DATABASE_DOESNT_EXISTS"] = "无法获取名为 %s 的数据库记录，因为名为 %s 的数据库不存在！";
L["ERR_GET_DATABASE_NAME_NOT_GIVEN"] = "无法获取数据库记录，请指定一个数据库名！";
L["ERR_SET_DATABASE_DOESNT_EXISTS"] = "无法设置数据库记录，因为名为 %s 的数据库不存在！";

L["ERR_SET_LOCALE_ADDON_NOT_GIVEN"] = "无法设置本地化记录，请指定插件名称！";
L["ERR_SET_LOCALE_ADDON_DOESNT_EXIST"] = "无法设置本地化记录，因为名为 %s 的插件并没有注册！";
L["ERR_GET_LOCALE_ADDON_NOT_GIVEN"] = "无法获取本地化记录，请指定插件名称！";
L["ERR_GET_LOCALE_KEY_DOESNT_EXIST"] = "无法获取本地化记录，因为名为 %s 的本地化key不存在！";
L["ERR_GET_LOCALE_ADDON_DOESNT_EXIST"] = "无法获取本地化记录，因为名为 %s 的插件并没有注册！";

L["ERR_ADD_UNITFRAME_NOT_GIVEN"] = "无法添加单位框体，请指定正确的框体！";
L["ERR_ADD_UNITFRAME_COMBATLOCKDOWN"] = "因为战斗锁定，无法添加单位框体！一旦离开战斗，请尽快重载界面。";

L["ERR_REMOVE_UNITFRAME_COMBATLOCKDOWN"] = "因为战斗锁定，无法移除单位框体！一旦离开战斗，请尽快重载界面。";

L["ERR_REMOVE_UNITFRAME_UNITID_NOT_REGISTERED"] = "无法移除单位框体的unitID，因为框体并没有以这个unitID进行注册！";
L["ERR_REMOVE_UNITFRAME_GUID_NOT_REGISTERED"] = "无法移除单位框体的GUID，因为框体并没有以这个GUID进行注册！";

L["ERR_ADD_NAME_ALIAS_NOT_GIVEN"] = "无法添加别名，请指定别名或者单位名字！";

L["ERR_ADD_COOLDOWN_NOT_GIVEN"] = "无法添加冷却，请选择冷却框体或者父框体！";



-- *** OPTION MENU ***

-- DropDownMenus
L["DROPDOWN_TITLE_PORTRAIT"] = "头像类型：";
L["DROPDOWN_TITLE_ICON_TYPE"] = "图标类型：";
L["DROPDOWN_TITLE_HEALTH_BAR_COLOUR_MODE"] = "生命条颜色：";
L["DROPDOWN_TITLE_NAME_COLOUR_MODE"] = "姓名颜色：";
L["DROPDOWN_TITLE_POSITION"] = "位置：";

L["DROPDOWN_OPTION_NONE"] = "空";
L["DROPDOWN_OPTION_PORTRAIT_THREE_D_PORTRAITS"] = "3D 头像";
L["DROPDOWN_OPTION_PORTRAIT_CLASS_PORTRAITS"] = "职业图标";
L["DROPDOWN_OPTION_ICON_CLASS"] = "职业";
L["DROPDOWN_OPTION_ICON_RACE"] = "种族";
L["DROPDOWN_OPTION_ICON_PVP_TRINKET"] = "徽章";
L["DROPDOWN_OPTION_ICON_RACIAL"] = "种族";
L["DROPDOWN_OPTION_ICON_SPECIALISATION"] = "专精";
L["DROPDOWN_OPTION_ICON_INTERRUPT_OR_DISPEL"] = "打断/驱散";
L["DROPDOWN_OPTION_CLASS_COLOUR"] = "职业颜色";
L["DROPDOWN_OPTION_REACTION_COLOUR"] = "动态颜色";
L["DROPDOWN_OPTION_SMOOTH_HEALTHBAR"] = "当前血量";
L["DROPDOWN_OPTION_ABOVE"] = "上方";
L["DROPDOWN_OPTION_BELLOW"] = "下方";
L["DROPDOWN_OPTION_LEFT"] = "左";
L["DROPDOWN_OPTION_RIGHT"] = "右";

-- Checkbuttons
L["SHOW_COOLDOWN_TEXT"] = "显示冷却文字";
L["SEC_UNTIL_CASTHISTORY_ICON_FADES"] = "施放记录图标显示时间";
L["LOCK_FRAMES"] = "锁定框体";
L["ENABLE_ABSORB_DISPLAY"] = "显示吸收量";
L["ENABLE_HEAL_PREDICTION"] = "启用预计治疗量";

-- Sliders
L["CC_INDICATOR_OPTIONS_TITLE"] = "控制指示器优先级：";
L["CC_INDICATOR_OPTIONS_DESCRIPTION"] = "设置控制类型的优先级，设置为0将禁用对应的类型。";

L["SLIDER_DEFENSIVE_COOLDOWS_TITLE"] = "防御冷却：";
L["SLIDER_OFFENSIVE_COOLDOWNS_TITLE"] = "进攻冷却：";
L["SLIDER_STUNS_TITLE"] = "晕眩：";
L["SLIDER_SILENCE_TITLE"] = "沉默：";
L["SLIDER_CROWD_CONTROL_TITLE"] = "控制：";
L["SLIDER_ROOTS_TITLE"] = "定身：";
L["SLIDER_DISARMS_TITLE"] = "缴械：";
L["SLIDER_USEFULBUFF_TITLE"] = "有用的Buff:";
L["SLIDER_USEFULDEBUFF_TITLE"] = "有用的Debuff:";

-- Option Menu Error messages:
L["ERR_OPTIONS_DROPDOWNTYPE_ALREADY_EXISTS"] = "无法在选项中添加下拉菜单类型，因为这个菜单类型以及存在！";
L["ERR_OPTIONS_DROPDOWN_INIT_DROPDOWNTYPE_DOESNT_EXIST"] = "无法初始化下拉菜单，因为名为 %s 的下拉菜单类型不存在！";

-- Profile Menu:
L["OPTIONS_PROFILES_PANEL_TITLE"] = "配置存档";
L["OPTIONS_PROFILES_TITLE"] = "配置存档:";
L["OPTIONS_PROFILES_DESCRIPTION"] = "你可以复制所有设置从一个角色到另外一个角色。";
L["OPTIONS_PROFILES_ERROR_DATABASE_DOES_NOT_EXIST"] = "无法创建配置存档到数据库，因为名为 %s 的数据库不存在！";
L["OPTIONS_PROFILES_ERROR_DATABASE_NOT_SAVED_BY_CHARACTER"] = "无法创建配置存档到名为 %s 的数据库，因为当前数据库不允许存储配置存档！";
L["OPTIONS_PROFILES_CURRENT_PROFILE"] = "当前配置存档： ";
L["OPTIONS_PROFILES_COPY_FROM_DROPDOWN_TITLE"] = "从这里复制：";