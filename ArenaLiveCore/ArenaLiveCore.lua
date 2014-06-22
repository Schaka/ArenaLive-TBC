--[[ ArenaLive Core Functions
Created by: Vadrak
Creation Date: 13.05.2013
Last Update: 02.06.2013
This function set builds the base for the new core of ArenaLive. These functions will take control over any ArenaLive based handlers and addons.
The so called "handlers", which are defined in their respective files, control the way how certain frame types behave for any ArenaLive based
addon. I hope I can reduce the addon's needed performance this way, so that it always will be a fun experience playing with ArenaLive UnitFrames.
]]--

function print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

-- *** GENERAL FUNCTIONS ***
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

ArenaLiveCore.debug = false;

function wipe(table)
	for k,v in pairs(table) do
		k = nil
	end
end

table.wipe = wipe

-- Register Slash-Commands
local slashCommandFunctions = {};
SLASH_ARENALIVECORE1, SLASH_ARENALIVECORE2 = "/alive", "/arenalivecore";
function ArenaLiveCore:RegisterSlashCommand(modifier, description, execFunc)

	if ( slashCommandFunctions[modifier] ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_SLASHCMD_MODIFIER_ALREADY_IN_USE"), modifier), "error");
	else
		slashCommandFunctions[modifier] = {};
		slashCommandFunctions[modifier]["function"] = execFunc;
		slashCommandFunctions[modifier]["description"] = description;
	end

end

function SlashCmdList.ARENALIVECORE(msg, editbox)

	if ( not msg or msg == "" ) then
		InterfaceOptionsFrame_Show();
		InterfaceOptionsFrame_OpenToFrame(ArenaLiveOptions);
	elseif ( msg == "info" ) then
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_SLASHCMD_MODIFIER_LIST")));
		for modifier, cmdTable in pairs(slashCommandFunctions) do
		
			if ( cmdTable["description"] ) then
				print(tostring(modifier)..": "..tostring(cmdTable["description"]));
			end
		
		end
	else
		if ( slashCommandFunctions[msg] and slashCommandFunctions[msg]["function"] ) then
			slashCommandFunctions[msg]["function"]();
		else
			ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_SLASHCMD_MODIFIER_DOESNT_EXIST"), msg), "error");
		end
	end
	
end

--[[ Function: Message 
	 Handles all kinds of messages.
	 Arguments:
		msg: The message to post to the DEFAULT_CHAT_FRAME
		messageType: Can either be "error" for an error message, "debug" for debug message.
					 For every other value or nil it will print a general message to the DEFAULT_CHAT_FRAME.
]]--
function ArenaLiveCore:Message(msg, messageType)

	if ( messageType == "error" ) then
		print("|cFFFF0000ArenaLive Error:|r "..tostring(msg));
	elseif ( messageType == "debug" ) then
		
		if ( ArenaLiveCore.debug ) then
			print("|cFFFF0000ArenaLive Debug:|r "..tostring(msg));
		end
		
	else
		print("|cFFFF0000ArenaLive:|r "..tostring(msg));
	end
	
end

-- Some language clients need other Fonts to show every information correctly (e.g. Russian and Korean).
-- UPDATE: This function is no longer needed as I found out that you can define alternative fonts for different languages.
--[[function ArenaLiveCore:ChangeFonts()
	
	local fontStyle = ArenaLiveCore:GetLocalisation(addonName, "FONTSTYLE");
	if ( fontStyle ~= "Fonts\\FRIZQT__.TTF" ) then
		ArenaLiveFont_Name:SetFont(fontStyle, 12, "OUTLINE");
		ArenaLiveFont_NameSmall:SetFont(fontStyle, 10, "OUTLINE");
		ArenaLiveFont_NameVerySmall:SetFont(fontStyle, 8, "OUTLINE");
		ArenaLiveFont_Level:SetFont(fontStyle, 10, "OUTLINE");
		ArenaLiveFont_StatusBarTextVeryLarge:SetFont(fontStyle, 14, "OUTLINE");
		ArenaLiveFont_StatusBarTextLarge:SetFont(fontStyle, 12, "OUTLINE");
		ArenaLiveFont_StatusBarText:SetFont(fontStyle, 10, "OUTLINE");
		ArenaLiveFont_StatusBarTextSmall:SetFont(fontStyle, 8, "OUTLINE");
		ArenaLiveFont_StatusBarTextVerySmall:SetFont(fontStyle, 6, "OUTLINE");
		ArenaLiveFont_CooldownText:SetFont(fontStyle, 24, "OUTLINE");
	end
end]]--

-- *** COREHANDLER FUNCTIONS ***
--[[ Cores directly influence the behaviour of ArenaLiveCore and are able to set up handlers with additional functions to interact with those cores.
	 Most of my standard cores attach all their functions directly to the ArenaLiveCore frame and don't add themselves to this core list. But if
	 a core needs to attach some basic functions to handlers that register for it (e.g. EventCore), it is needed to register it via the functions below
	 and create a function named "CoreName.SetupHandler" which sets up the handlers.
	 ]]--
-- I set up an extra table for our core references, because then they can't interfere with the base functions.
ArenaLiveCore.cores = {};

--[[ Function: AddCore
	 Adds a new core to ArenaLiveCore.
	 Arguments:
		name: The name the core should take
	 Returns:
		The table that will "contain" the core.
]]--
function ArenaLiveCore:AddCore(name)

	-- Create the new core handler or display an error message, if a core handler with that name already exists.
	if ( not ArenaLiveCore.cores[name] ) then
		ArenaLiveCore.cores[name] = {};
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_CORE_ALREADY_EXISTS"), name), "error");
	end
	
	return ArenaLiveCore.cores[name];
	
end

--[[ Function: RemoveCore
	 Removes a set core functions form the addon's core.
	 Arguments:
		name: Name of the core that should be removed/diabled
]]--
function ArenaLiveCore:RemoveCore(name)

	-- Create the new core handler or display an error message, if a core handler with that name already exists.
	if ( ArenaLiveCore.cores[name] ) then
		ArenaLiveCore.cores[name] = nil;
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_DELETE_CORE_DOESNT_EXISTS"), name), "error");
	end
	
end

--[[ Function: GetCore
	 Returns the table for the specified core, if it exists.
	 Arguments:
		name: Name of the core that should
	 Returns:
		the table that contains the specified core.
		
]]--
function ArenaLiveCore:GetCore(name)

	-- Return core handler or display an error message, if a core handler with that name doesn't exist.
	if ( ArenaLiveCore.cores[name] ) then
		return ArenaLiveCore.cores[name];
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_GET_CORE_DOESNT_EXISTS"), name), "error");
	end
	
end



-- *** HANDLER FUNCTIONS ***
-- I set up an extra table for our handler references, because then they can't interfere with the base functions.
ArenaLiveCore.handlers = {};

--[[ Function: AddHandler
	 Adds a new handler to ArenaLiveCore.
	 Arguments:
		name: The name the handler should take
		...: A list of cores the assigned handler wants to register for.
		This will be mostly the case for the event and localisation handlers.
	 Returns:
		The table that will "contain" the handler.
]]--

function ArenaLiveCore:AddHandler(name, ...)
	
	local coreString;
	local numCores = select('#', ...) or 0;
	
	-- Create the new handler or display an error message, if a handler with that name already exists.
	if ( not self.handlers[name] ) then
		self.handlers[name] = {};
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_HANDLER_ALREADY_EXISTS"), name), "error");
	end
	
	if ( numCores > 0 ) then
		for i = 1, numCores do
			coreString = select(i, ...);
			
			if ( ArenaLiveCore.cores[coreString] ) then
				if ( ArenaLiveCore.cores[coreString].SetupHandler ) then
					ArenaLiveCore.cores[coreString]:SetupHandler(self.handlers[name]);
				end
			else
				ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_REGISTER_HANDLER_FOR_CORE_DOESNT_EXISTS"), name, coreString, coreString), "error");
			end
		end
	end
	
	return self.handlers[name];
end

--[[ Function: RemoveHandler
	 Removes a Handler form the core.
	 Arguments:
		name: Name of the handler that should be removed/diabled
]]--
function ArenaLiveCore:RemoveHandler(name)
	if ( self.handlers[name] ) then
		self.handlers[name] = nil;
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_DELETE_HANDLER_DOESNT_EXISTS"), name), "error");
	end
end

--[[ Function: RemoveAllHandlers 
	 This function removes all handlers from the core.
]]--
function ArenaLiveCore:RemoveAllHandlers()
	table.wipe(ArenaLiveCore.handlers);
end

--[[ Function: GetHandler
	 This function removes all handlers from the core.
	 Arguments:
		handlerName: String - Name of the handler that should be returned.
	 Returns:
		handler: The required handler.
	 
]]--
function ArenaLiveCore:GetHandler(handlerName)
	local handler;
	
	if ( ArenaLiveCore.handlers[handlerName] ) then
		return ArenaLiveCore.handlers[handlerName];
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_GET_HANDLER_DOESNT_EXISTS"), handlerName), "error");
	end
end



-- *** FRAME FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a frame to contain all ArenaLiveCore specific functions. I.e. it attaches some base functions to it, that can be used
	 to register it for handlers etc.
	 Arguments:
		frame: The frame that needs to be registered.
		handlerName: The name of an already registered handler.
		...: A list of arguments that the handler needs to register the frame.
]]--
function ArenaLiveCore:AddFrame(frame, handlerName, ...)
	local frameName = tostring(frame:GetName());
	if ( self.handlers[handlerName] ) then
		self.handlers[handlerName]:AddFrame(frame, ...);
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_ADD_FRAME_HANDLER_DOESNT_EXISTS"), frameName, handlerName), "error");
	end
end