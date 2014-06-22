--[[ ArenaLive Core: Event Core
Created by: Vadrak
Creation Date: 13.05.2013
Last Update: 23.06.2013
This handler sets the main frame (ArenaLiveCore) up to register for all events the other handlers need, so that they are only called once.
It then will send the event information to all other handlers that have registered for these specific events. Then again the handlers will filter the event information to
only reach out to those frames, that need the event's arguments (e.g. filtered by unitID or GUID etc.).
]]--
local addonName = "ArenaLiveCore";
	
-- These events must always be registered.
local lockedEvents = {
	["ADDON_LOADED"] = true,
	["PLAYER_LOGOUT"] = true,
};

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Register the two locked events that always need to be registered.
ArenaLiveCore:RegisterEvent("ADDON_LOADED");
ArenaLiveCore:RegisterEvent("PLAYER_LOGOUT");

-- Create a table to store information about event throttling
local eventThrottleTable = {
		["GROUP_ROSTER_UPDATE"] = 
			{
				["throttleExpires"] = 0;
				["throttleInterval"] = 0.1
			},
};
-- Create a new core.
local EventCore = ArenaLiveCore:AddCore("EventCore");
local registeredHandlers = {};

--[[ Function: OnEvent
	 This handles the OnEvent script. Apart from ADDON_LOADED, which tells us when ArenaLiveCore has been loaded and
	 COMBAT_LOG_EVENT_UNITFILTERED which we try to filter a bit, every event is simply passed to the registered handlers
	 without filtering.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
function ArenaLiveCore:OnEvent(event, ...)
	
	local arg1 = ...;
	
	-- In order to reduce needed performance for the addon, events can be throttled, so that they get registered only once for a defined time interval.
	--[[if ( eventThrottleTable[event] ) then
		local theTime = GetTime();
		
		if ( theTime >= eventThrottleTable[event]["throttleExpires"] ) then
			eventThrottleTable[event]["throttleExpires"] = theTime + eventThrottleTable[event]["throttleInterval"];
		else
			return;
		end
	end]]--
	
	if ( event == "UNIT_AURA" and arg1 == "target" ) then
		for i = 1, 40 do
			local name, rank, icon, count, duration, expires = UnitDebuff("target", i);
			if ( name ) then
				ArenaLiveCore:Message("Aura-SpellID: (= "..name..")", "debug");
			else
			end
		end
	end
	
	if ( event == "ADDON_LOADED" and arg1 == addonName ) then
		if ( ArenaLive_SavedVariables ) then
			ArenaLiveCore.db = ArenaLive_SavedVariables;
		end
		
		if ( not ArenaLiveCore:DatabaseExists("ArenaLiveCore") ) then
			ArenaLiveCore:AddDatabase("ArenaLiveCore", ArenaLiveCore.defaults, false);
		end
			
		-- Initialise Options panel
		ArenaLiveOptions:Initialise();
			
		-- Update fonts, if needed (e.g. for russian or korean client)
		-- OUT OF DATE: I switched to alternateTo und alternateAlphabetID in Fonts.xml
		-- ArenaLiveCore:ChangeFonts();
	elseif ( event == "PLAYER_LOGOUT" ) then
		ArenaLive_SavedVariables = ArenaLiveCore.db;
	end
	
	if ( event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT" ) then
		local event2 = select(2, ...);
		event = event.."_"..event2;
	end
	
	if ( registeredHandlers[event] ) then
		local test = string.find(event ,"COMBAT_LOG_EVENT_UNFILTERED");
		if ( test ) then
			--ArenaLiveCore:Message(event, "debug");
		end
		for key, handler in ipairs(registeredHandlers[event]) do
			handler:OnEvent(event, ...);
		end
	end
end



-- *** HANDLER FUNCTIONS ***
--[[ Function: Enable
	 Function to enable the EventCore.
]]--
function EventCore:Enable()
	ArenaLiveCore:SetScript("OnEvent", ArenaLiveCore.OnEvent);
end

--[[ Function: Enable
	 Function to disable the EventCore.
]]--
function EventCore:Disable()
	ArenaLiveCore:SetScript("OnEvent", nil);
end

--[[ Function: RegisterEvent
	 Handler function to add events, will be attached via SetupHandler function.
	 Arguments:
		handler: The handler that is set up.

]]--
local function RegisterEvent (self, event)
	
	--[[ Check if it is a combat log event, because for combat log events we use the pattern "COMBATLOG_EVENT-COMBATLOG_SPECIFIC_EVENT"
		 which isn't a real event type.]]--
	local isCombatLog = string.match(event, "COMBAT_LOG_EVENT_UNFILTERED") or string.match(event, "COMBAT_LOG_EVENT") or false;
	 

	-- Register the main frame for this event if needed.
	if ( ( not isCombatLog and not ArenaLiveCore:IsEventRegistered(event) ) or ( isCombatLog and not ArenaLiveCore:IsEventRegistered(isCombatLog) )  ) then
		if ( isCombatLog ) then
			ArenaLiveCore:RegisterEvent(isCombatLog);
		else
			ArenaLiveCore:RegisterEvent(event);
		end
	end
	
	if ( not registeredHandlers[event] ) then
		-- The event wasn't registered until now, so we register it.
		registeredHandlers[event] = {};
		
		-- Insert the handler into the table.
		table.insert(registeredHandlers[event], self);
	else
		table.insert(registeredHandlers[event], self);
	end

end

--[[ Function: UnregisterEvent
	  Handler function to remove events, will be attached via SetupHandler function.
	 Arguments:
		handler: The handler that is set up.

]]--
local function UnregisterEvent (self, event)
	
	if ( not registeredHandlers[event] ) then
		return;
	end

	--[[ Check if it is a combat log event, because for combat log events we use the pattern "COMBATLOG_EVENT-COMBATLOG_SPECIFIC_EVENT"
		 which isn't a real event type.]]--
	local isCombatLog = string.match(event, "COMBAT_LOG_EVENT_UNFILTERED") or string.match(event, "COMBAT_LOG_EVENT") or false;
	
	for key, handler in ipairs(registeredHandlers[event]) do
	
		if ( self == handler ) then
			table.remove(registeredHandlers[event], key)
		end
	
	end
	
	local entriesLeft = #registeredHandlers[event];
	
	if ( entriesLeft == 0  and not lockedEvents[event] ) then
		-- No handler uses this event anymore, so we can unregister it.
		if ( isCombatLog ) then
			ArenaLiveCore:UnregisterEvent(isCombatLog);
		else
			ArenaLiveCore:UnregisterEvent(event);
		end
	end
end

--[[ Function: SetupHandler
	 This function attaches the needed functions to add or remove events to the assigned handler.
	 Arguments:
		handler: The handler that is set up.

]]--
function EventCore:SetupHandler(handler)

	handler.RegisterEvent = RegisterEvent;
	handler.UnregisterEvent = UnregisterEvent;

end


-- Enable the event core initially
EventCore:Enable()