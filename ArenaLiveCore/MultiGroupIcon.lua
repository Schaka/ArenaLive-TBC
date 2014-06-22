--[[ ArenaLive Core Functions: VoiceChat Icon Handler
Created by: Vadrak
Creation Date: 22.06.2013
Last Update: "
This file contains all relevant functions for the multi group button that was added in MoP.
]]--


local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local MultiGroupIcon = ArenaLiveCore:AddHandler("MultiGroupIcon", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
MultiGroupIcon:RegisterEvent("GROUP_ROSTER_UPDATE");
MultiGroupIcon:RegisterEvent("UPDATE_CHAT_COLOR");

-- *** FRAME FUNCTIONS ***
local function Update (self)

	if ( IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) ) then
		self:UpdateColour();
		self:Show();
	else
		self:Hide();
	end

end

local function UpdateColour (self)
	local public = ChatTypeInfo["INSTANCE_CHAT"];
	local private = ChatTypeInfo["PARTY"];
	self.HomePartyIcon:SetVertexColor(private.r, private.g, private.b);
	self.InstancePartyIcon:SetVertexColor(public.r, public.g, public.b);
end

local function OnEnter (self)

	GameTooltip_SetDefaultAnchor(GameTooltip, self);
	self.homePlayers = GetHomePartyInfo(self.homePlayers);

	if ( IsInRaid(LE_PARTY_CATEGORY_HOME) ) then
		GameTooltip:SetText(PLAYER_IN_MULTI_GROUP_RAID_MESSAGE, nil, nil, nil, nil, true);
		GameTooltip:AddLine(format(MEMBER_COUNT_IN_RAID_LIST, #self.homePlayers + 1), 1, 1, 1, true);
	else
		GameTooltip:AddLine(PLAYER_IN_MULTI_GROUP_PARTY_MESSAGE, 1, 1, 1, true);
		local playerList = self.homePlayers[1] or "";
		for i=2, #self.homePlayers do
			playerList = playerList..PLAYER_LIST_DELIMITER..self.homePlayers[i];
		end
		GameTooltip:AddLine(format(MEMBERS_IN_PARTY_LIST, playerList));
	end
	
	GameTooltip:Show();

end

local function OnLeave (self)
	GameTooltip:Hide();
end

local function Reset (self)
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function MultiGroupIcon:AddFrame (multiGroupIcon, HomePartyIcon, InstancePartyIcon, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.multiGroupIcon = multiGroupIcon;
	multiGroupIcon.unitFrame = unitFrame;
	
	unitFrame.handlerList.multiGroupIcon = true;
	
	-- Set references for textures.
	multiGroupIcon.HomePartyIcon = HomePartyIcon;
	multiGroupIcon.InstancePartyIcon = InstancePartyIcon;

	-- Set the basic functions for the castbar.
	multiGroupIcon.Update = Update;
	multiGroupIcon.UpdateColour = UpdateColour;
	multiGroupIcon.OnEnter = OnEnter;
	multiGroupIcon.OnLeave = OnLeave;
	multiGroupIcon.Reset = Reset;
	
	multiGroupIcon:SetScript("OnEnter", multiGroupIcon.OnEnter);
	multiGroupIcon:SetScript("OnLeave", multiGroupIcon.OnLeave);
end

--[[ Function: OnEvent
	 OnEvent function for the ready check handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function MultiGroupIcon:OnEvent (event, ...)
	-- Filter for player as unit, because only player frames will show this info.
	local unit = "player";
	
	if ( event == "GROUP_ROSTER_UPDATE" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.multiGroupIcon ) then
						affectedFrame.multiGroupIcon:Update();
					end
				end
			end
		end
	elseif ( event == "UPDATE_CHAT_COLOR" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.multiGroupIcon ) then
						affectedFrame.multiGroupIcon:UpdateColour();
					end
				end
			end
		end
	end

end