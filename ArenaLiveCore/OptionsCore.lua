--[[ ArenaLive Core: Options Core
Created by: Vadrak
Creation Date: 23.06.2013
Last Update: "
This Core stores a function set of relevant functions to create an option menu for a arena live based addon. In contrast to most other handlers, this one is a completely seperate frame named "ArenaLiveOptions".
]]--


-- Local version is said to be faster.
local ArenaLiveOptions = ArenaLiveOptions;

-- Create a table to store all possible Dropdown menu types.
local dropDownMenuTypes = {
		["Portrait"] = {
			["title"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_TITLE_PORTRAIT"),
			[1] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_PORTRAIT_THREE_D_PORTRAITS"),
				["value"] = "threeD",
			},
			[2] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_PORTRAIT_CLASS_PORTRAITS"),
				["value"] = "class",
			},
		},
		["IconType"] = {
			["title"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_TITLE_ICON_TYPE"),
			[1] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_CLASS"),
				["value"] = "class",		
			},
			[2] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_RACE"),
				["value"] = "race",	
			},
			[3] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_PVP_TRINKET"),
				["value"] = "trinket",		
			},
			[4] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_RACIAL"),
				["value"] = "racial",			
			},
			[5] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_SPECIALISATION"),
				["value"] = "specialisation",			
			},
			[6] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_INTERRUPT_OR_DISPEL"),
				["value"] = "interruptOrDispel",			
			},
			[7] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_REACTION_COLOUR"),
				["value"] = "reaction",		
			},
		},
		["HealthBarColourMode"] = {
			["title"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_TITLE_HEALTH_BAR_COLOUR_MODE"),
			[1] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_NONE"),
				["value"] = "none",	
				
			},
			[2] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ICON_CLASS"),
				["value"] = "class",	
				
			},
			[3] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_REACTION_COLOUR"),
				["value"] = "reaction",	
				
			},
			[3] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_SMOOTH_HEALTHBAR"),
				["value"] = "smooth",	
				
			},
		},
		["NameColourMode"] = {
			["title"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_TITLE_NAME_COLOUR_MODE"),
			[1] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_NONE"),
				["value"] = "none",	
				
			},
			[2] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_CLASS_COLOUR"),
				["value"] = "class",	
				
			},
			[3] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_REACTION_COLOUR"),
				["value"] = "reaction",	
				
			},
		},
		["Position"] = {
			["title"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_TITLE_POSITION"),
			[1] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_ABOVE"),
				["value"] = "ABOVE",	
				
			},
			[2] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_BELLOW"),
				["value"] = "BELOW",	
			},
			[3] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_LEFT"),
				["value"] = "LEFT",	
				
			},
			[4] = {
				["text"] = ArenaLiveCore:GetLocalisation("ArenaLiveCore", "DROPDOWN_OPTION_RIGHT"),
				["value"] = "RIGHT",	
			},
		},
};



-- *** GENERAL FUNCTIONS ***
function ArenaLiveOptions:Initialise()
	ArenaLiveCore:Message("initialise options", "debug");
	-- Create a panel in Blizzard's addon panel
	self.name = "ArenaLive [Core]";
	InterfaceOptions_AddCategory(self);
	
	self:InitialiseCheckButton(ArenaLiveOptions_CoreLockFrames, "ArenaLiveCore", "FrameLock", "LOCK_FRAMES", function() local FrameMover = ArenaLiveCore:GetHandler("FrameMover"); FrameMover:UpdateAll() end);
	self:InitialiseCheckButton(ArenaLiveOptions_CoreShowCooldownText, "ArenaLiveCore", "Cooldown/ShowText", "SHOW_COOLDOWN_TEXT", function() local Cooldown = ArenaLiveCore:GetHandler("Cooldown"); Cooldown:UpdateAll() end);
		
	ArenaLiveOptions_CoreCCIndicatorOptionsTitle:SetText(ArenaLiveCore:GetLocalisation("ArenaLiveCore", "CC_INDICATOR_OPTIONS_TITLE"));
	ArenaLiveOptions_CoreCCIndicatorOptionsDescription:SetText(ArenaLiveCore:GetLocalisation("ArenaLiveCore", "CC_INDICATOR_OPTIONS_DESCRIPTION"));
	
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_DefCDSlider, "ArenaLiveCore", "CCPriority/defCD", "SLIDER_DEFENSIVE_COOLDOWS_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_OffCDSlider, "ArenaLiveCore", "CCPriority/offCD", "SLIDER_OFFENSIVE_COOLDOWNS_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_UsefulBuffSlider, "ArenaLiveCore", "CCPriority/usefulBuffs", "SLIDER_USEFULBUFF_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_UsefulDebuffSlider, "ArenaLiveCore", "CCPriority/usefulDebuffs", "SLIDER_USEFULDEBUFF_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_StunSlider, "ArenaLiveCore", "CCPriority/stun", "SLIDER_STUNS_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_SilenceSlider, "ArenaLiveCore", "CCPriority/silence", "SLIDER_SILENCE_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_CrowdControlSlider, "ArenaLiveCore", "CCPriority/crowdControl", "SLIDER_CROWD_CONTROL_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_RootSlider, "ArenaLiveCore", "CCPriority/root", "SLIDER_ROOTS_TITLE");
	self:InitialiseSlider(ArenaLiveOptions_CoreCCIndicatorOptions_DisarmSlider, "ArenaLiveCore", "CCPriority/disarm", "SLIDER_DISARMS_TITLE");
	
end

function ArenaLiveOptions:AddDropDownMenuType(name, dropDownTable)
	if ( not dropDownMenuTypes[name] ) then
		dropDownMenuTypes[name] = dropDownTable;
	else	
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_OPTIONS_DROPDOWNTYPE_ALREADY_EXISTS"), name), "error");
	end
end

-- *** TEMPLATE FUNCTIONS ***
-- CHECKBUTTONS
local function CheckButtonOnClick(self)

	if ( self.affectedVariable ) then
		local newValue = self:GetChecked();
	
		ArenaLiveCore:SetDBEntry(self.addOnName, self.affectedVariable, newValue);
	end
	
	if (self.func) then
		self.func();
	end

end

-- NOTE: localisationString is just a temporary fix and will be the norm in a future update of the core.
function ArenaLiveOptions:InitialiseCheckButton(checkButton, addonName, affectedVariable, titleLocalisationKey, execFunc, localisationString)
	local prefix = checkButton:GetName();
	local title = _G[prefix.."Text"];
	
	-- Set title
	if ( titleLocalisationKey ) then
		title:SetText(ArenaLiveCore:GetLocalisation(addonName, titleLocalisationKey));
	elseif ( localisationString ) then
		title:SetText(localisationString);
	end
	-- Set pointers
	checkButton.addOnName = addonName;
	checkButton.affectedVariable = affectedVariable;
	checkButton.func = execFunc;
	
	if ( affectedVariable ) then
		local initValue = ArenaLiveCore:GetDBEntry(addonName, affectedVariable);
		
		checkButton:SetChecked(initValue);
	end
	
	checkButton:SetScript("OnClick", CheckButtonOnClick);

end

-- EDITBOXES
local function EditBoxOnEditFocusLost(self)

	local newValue = self:GetText();
	
	if ( self.affectedVariable ) then
		ArenaLiveCore:SetDBEntry(self.addOnName, self.affectedVariable, newValue);
	end
	
	if (self.func) then
		self.func();
	end

end

-- NOTE: localisationString is just a temporary fix and will be the norm in a future update of the core.
function ArenaLiveOptions:InitialiseEditBox(editBox, addonName, affectedVariable, titleLocalisationKey, execFunc, localisationString)
	local prefix = editBox:GetName();
	local title = _G[prefix.."Title"];
	
	-- Set title
	if ( titleLocalisationKey ) then
		title:SetText(ArenaLiveCore:GetLocalisation(addonName, titleLocalisationKey));
	elseif ( localisationString ) then
		title:SetText(localisationString);
	end
	
	-- Set pointers
	editBox.addOnName = addonName;
	editBox.affectedVariable = affectedVariable;
	editBox.func = execFunc;
	
	if ( affectedVariable ) then
		local initValue = ArenaLiveCore:GetDBEntry(addonName, affectedVariable);
		if ( initValue ) then
			editBox:SetText(initValue);
		end
	end

	-- Reset the EditBox's cursor position, so that the text is shown correctly.
	editBox:SetCursorPosition(0);
	
	editBox:SetScript("OnEditFocusLost", EditBoxOnEditFocusLost);

end

-- SLIDERS
local function SliderOnValueChanged(self)
	
	local prefix = self:GetName();
	local currText = _G[prefix.."Current"];
	
	local newValue = math.floor(self:GetValue());

	-- Slider bugfix for 5.4
	if ( newValue ~= self:GetValue() ) then
		self:SetValue(newValue);
		return;
	end
	
	currText:SetText(newValue);
	
	if ( self.affectedVariable ) then
		ArenaLiveCore:SetDBEntry(self.addOnName, self.affectedVariable, newValue);
	end
	
	if (self.func) then
		self.func();
	end

end

-- NOTE: localisationString is just a temporary fix and will be the norm in a future update of the core.
function ArenaLiveOptions:InitialiseSlider (slider, addonName, affectedVariable, titleLocalisationKey, execFunc, localisationString)
	
	local prefix = slider:GetName();
	local minText = _G[prefix.."Min"];
	local currText = _G[prefix.."Current"];
	local maxText = _G[prefix.."Max"];
	local title = _G[prefix.."Title"];
	
	-- Set title
	if ( titleLocalisationKey ) then
		title:SetText(ArenaLiveCore:GetLocalisation(addonName, titleLocalisationKey));
	elseif ( localisationString ) then
		title:SetText(localisationString);
	end
	
	-- Set references
	slider.addOnName = addonName;
	slider.affectedVariable = affectedVariable;
	slider.func = execFunc;
	
	-- Set min and max text strings
	local minValue, maxValue = slider:GetMinMaxValues();
	minText:SetText(minValue);
	maxText:SetText(maxValue);
	
	-- Set current Value if needed.
	if ( affectedVariable ) then
		local initValue = ArenaLiveCore:GetDBEntry(addonName, affectedVariable);
		
		if ( initValue ) then
			currText:SetText(initValue);
			slider:SetValue(initValue);
		end
	end
	
	slider:SetScript("OnValueChanged", SliderOnValueChanged);

end

-- DROPDOWN MENUS
local function dropDownUpdate (self, title, dropdown)
	self = this
	-- Update Dropdown text to new value.
	UIDropDownMenu_SetText(title, dropdown);
	
	if ( dropdown.affectedVariable ) then
		ArenaLiveCore:SetDBEntry(dropdown.addonName, dropdown.affectedVariable, self.value);
	end
	
	if ( dropdown.func ) then
		dropdown.func();
	end
end

local info = UIDropDownMenu_CreateInfo();
local function dropDownInitFunc (self)
	local dropDownType = self.type;
	local currSelectedValue;
	local index = 1;
	
	if ( self.affectedVariable ) then
		currSelectedValue = ArenaLiveCore:GetDBEntry(self.addonName, self.affectedVariable);
	end	
	
	-- Set up the dropdown menu.
	while dropDownMenuTypes[dropDownType][index] do
		if ( not self.ignoreEntries or not self.ignoreEntries[index] ) then
			info.text = dropDownMenuTypes[dropDownType][index]["text"];
			info.value = dropDownMenuTypes[dropDownType][index]["value"];
			info.func = function() dropDownUpdate(nil, info.text, self) end;
			info.isTitle = dropDownMenuTypes[dropDownType][index]["isTitle"];
			info.disabled = dropDownMenuTypes[dropDownType][index]["disabled"];
			info.arg1 = info.text;
			info.arg2 = self; -- will be dropdown in dropDownUpdate(self, dropdown, arg2);
			
			-- Set current value, if this one is it.
			if ( currSelectedValue and currSelectedValue == info.value ) then
				UIDropDownMenu_SetText(info.text, self);
				info.checked = true;
			else
				info.checked = nil;
			end
			
			UIDropDownMenu_AddButton(info);
		end
			index = index + 1;
	end

end
-- NOTE: overrideTitleString is just a temporary fix and will be the norm in a future update of the core.
function ArenaLiveOptions:InitialiseDropDownMenu (dropDown, dropDownType, addonName, affectedVariable, execFunc, ignoreEntries, overrideTitleKey, overrideTitleString)
	
	if ( not dropDownMenuTypes[dropDownType] ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_OPTIONS_DROPDOWN_INIT_DROPDOWNTYPE_DOESNT_EXIST"), dropDownType), "error");
		return;
	end
	
	local prefix = dropDown:GetName();
	local title = _G[prefix.."Title"];

	-- Set title
	if ( overrideTitleString ) then
		title:SetText(overrideTitleString);
	elseif ( overrideTitleKey ) then
		title:SetText(ArenaLiveCore:GetLocalisation(addonName, overrideTitleKey));
	else
		title:SetText(dropDownMenuTypes[dropDownType]["title"]);
	end
	
	-- Set references
	dropDown.addonName = addonName;
	dropDown.type = dropDownType;
	dropDown.affectedVariable = affectedVariable;
	dropDown.func = execFunc;
	dropDown.ignoreEntries = ignoreEntries;
	-- Initialise the dropdown using blizzard's standard functionset.
	UIDropDownMenu_Initialize(dropDown, function()
		dropDownInitFunc(dropDown)
	end);

end

-- BUTTONS
local function ButtonOnClick(self, button, down)

	if ( self.func ) then
		self.func();
	end

end

-- NOTE: localisationString is just a temporary fix and will be the norm in a future update of the core.
function ArenaLiveOptions:InitialiseButton (button, addonName, titleLocalisationKey, execFunc, localisationString)
	
	-- Set Text:
	local prefix = button:GetName();
	local buttonText = _G[prefix.."Text"];
	
	-- Set Text
	if ( localisationString ) then
		button:SetText(localisationString);
	else
		button:SetText(ArenaLiveCore:GetLocalisation(addonName, titleLocalisationKey));
	end
	

	-- Get new text width to set the size of the button correctly:
	if ( buttonText ) then
		local width = buttonText:GetWidth() + 20;
		button:SetWidth(width);
	end
	
	-- Set addonName and affected variable:
	button.func = execFunc;
	
	button:SetScript("OnClick", ButtonOnClick);
end