--[[ ArenaLive Core Functions: HealthBar Handler
Created by: Vadrak
Creation Date: 13.06.2013
Last Update: "
This file stores the basic functions for the casthistory.
Unlike in the first version of the cast history I completely detached the history from the castbar. This way it is much more flexible, reliable and much less
vulnerable to errors.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local CastHistory = ArenaLiveCore:AddHandler("CastHistory", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
CastHistory:RegisterEvent("UNIT_SPELLCAST_START");
CastHistory:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
CastHistory:RegisterEvent("UNIT_SPELLCAST_STOP");
CastHistory:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
CastHistory:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
CastHistory:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
CastHistory:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_DAMAGE");
CastHistory:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_HEAL");
CastHistory:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_CAST_SUCCESS");
CastHistory:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_INTERRUPT");

-- Create a table that stores all cast histories. This way it is easier to update the icon duration for all of them.
local castHistories = {};

-- x and y offset modifiers for anchoring the cast history icons after they are animated.
local DEFAULT_X_MOD = 3;
local DEFAULT_Y_MOD = 3;
local ICON_DURATION = 7;

-- *** FRAME FUNCTIONS ***
local function Enable (self)
	self.enabled = true;
	self.unitFrame.handlerList.castHistory = true;
	self:SetScript("OnUpdate", self.OnUpdate);
	self:Show();
end

local function Disable (self)
	self.enabled = nil;
	self.unitFrame.handlerList.castHistory = nil;
	self:SetScript("OnUpdate", nil);
	self:Hide();
end

local function Update (self)	
	if ( not self.enabled ) then
		return;
	end

	self:Reset();
end

local function OnUpdate(self, elapsed)

	if ( not self.enabled ) then
		return;
	end

	if ( self.numIcons > 0 ) then
		self.elapsed = self.elapsed + elapsed;
		
		-- Throttle the OnUpdate function for the cast history.
		if ( self.elapsed > 0.5 ) then
			self.elapsed = 0;
			
			for i = 1, self.numIcons do
				local icon = self["icon"..i];
				
				if ( icon and icon.active and icon.expires and icon.expires <= GetTime() ) then
					icon.fadeOutAnimation:Play();
					icon.fading = true;
				end
			end
		end
	end

end

local function Rotate (self, event, spellID, lineID)

	if ( not self.enabled ) then
		return;
	end

	local name, rank, texture, powerCost, isFunnel, powerType, castingTime, minRange, maxRange = GetSpellInfo(spellID);
	local maxIcons = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/CastHistory/MaxShownIcons");
	local iconFound;
	local icon;
	local unit = self.unitFrame.unit
	local dontMove = true;
	local direction = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/CastHistory/Direction");
	local size = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/CastHistory/IconSize");

	-- This is the first spell the cast history gets. We need to create an icon now.
	if ( self.numIcons == 0 ) then
		CastHistory:CreateIcon(self);
	end
	
	--[[ It is possible that there is no visible frame on the initial position due to the fadeout of failed casts.
	If this is the case, we don't need to move anything, because we already have enough space to show the new icon. ]]--
	for i = 1, self.numIcons do
		icon = self["icon"..i];
		
		if ( icon.timesMoved == 0 and icon.active ) then
			dontMove = nil;
			break;
		end	
	end
	
	icon = nil;
	
	for i = 1, self.numIcons do
		icon = self["icon"..i];
		
		if ( not icon.active ) then
			-- This is an icon we can use for the new spell, just check if we've found one already.
			if ( not iconFound ) then
				
				icon.spellID = spellID;
				
				-- PvP-Trinekt spell has a different icon than the trinkets. So I replace it here with the according one.
				if ( spellID == ArenaLiveCore.spellDB["trinket"] ) then
					local _, faction = UnitFactionGroup(unit);
					
					if ( faction == "Alliance" ) then
						texture = ("Interface\\ICONS\\INV_Jewelry_TrinketPVP_01");
					else
						texture = ("Interface\\ICONS\\INV_Jewelry_TrinketPVP_02");
					end
				end
					
				icon.texture:SetTexture(texture);
				icon:SetAlpha(0);
					
				-- Update icon Size etc.
				CastHistory:UpdateIcon(icon, size, direction);
					
				if ( event == "UNIT_SPELLCAST_START" ) then
					icon.casting = true;
					icon.lineID = lineID;
					self.castingIcon = icon;
					icon.castingAnimation:Play();
				elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
					icon.casting = nil;
					icon.channeling = true;
					self.channelIcon = icon;
					icon.castingAnimation:Play();
				elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
					icon.fadeInAnimation:Play();
				end

				icon.active = true;
				iconFound = true;
				icon:Show();
				--[[ Mark the icon in our castbar as the newest icon. This way it is possible to alter its appearance via combat log functions,
					 because these always fire after the UNIT_SPELLCAST events. ]]--
				self.newestIcon = icon;
			end
		else
			
			-- Already active icon. So this one might has to be moved.
			if (not dontMove ) then

				icon.timesMoved = icon.timesMoved + 1;

				if ( icon.moveAnimation:IsPlaying() ) then
					-- If the icon is already moving we just add the default offset to the current transitionway
					local xOffset, yOffset = icon.translationAnimation:GetOffset();
					
					if ( direction == "LEFT" ) then
						xOffset = xOffset - size;
					elseif ( direction == "RIGHT" ) then
						xOffset = xOffset + size;
					elseif ( direction == "UP" ) then
						yOffset = yOffset + size;
					elseif ( direction == "DOWN" ) then
						yOffset = yOffset - size;
					end
					
					icon.translationAnimation:SetOffset(xOffset, yOffset);
				else
					icon.moveAnimation:Play();
				end
				
				if (not icon.fading and icon.timesMoved >= maxIcons ) then
					icon.fadeOutAnimation:Play();
				end
			
			end			
		
		end
	end
	
	-- Create a new icon, if no inactive icon was found.
	if ( not iconFound ) then
		icon = CastHistory:CreateIcon(self);
		
		icon.spellID = spellID;
				
		-- PvP-Trinekt spell has a different icon than the trinkets. So I replace it here with the according one.
		if ( spellID == ArenaLiveCore.spellDB["trinket"] ) then
			local _, faction = UnitFactionGroup(unit);
					
			if ( faction == "Alliance" ) then
				texture = ("Interface\\ICONS\\INV_Jewelry_TrinketPVP_01");
			else
				texture = ("Interface\\ICONS\\INV_Jewelry_TrinketPVP_02");
			end
		end	
		
		icon.texture:SetTexture(texture);
		icon:SetAlpha(0);
					
		-- Update icon Size etc.
		CastHistory:UpdateIcon(icon, size, direction);
					
		if ( event == "UNIT_SPELLCAST_START" ) then
			icon.casting = true;
			icon.lineID = lineID;
			self.castingIcon = icon;
			icon.castingAnimation:Play();
		elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
			icon.channeling = true;
			self.channelIcon = icon;
			icon.castingAnimation:Play();
		elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
			icon.fadeInAnimation:Play();
		end
		
		icon.active = true;
		iconFound = true;
		icon:Show();
		
		--[[ Mark the icon in our castbar as the newest icon. This way it is possible to alter its appearance via combat log functions,
			 because these always fire after the UNIT_SPELLCAST events. ]]--
		self.newestIcon = icon;
	end
	
end

local function Reset (self)
	if ( self.numIcons > 0 ) then
		for i = 1, self.numIcons do
			local icon = self["icon"..i];
			CastHistory:ResetIcon(icon)
		end
	end

end



-- *** ANIMATION SCRIPT FUNCTIONS ***
local function FadeInOnFinished(animation, requested)
	local icon = animation:GetParent();
	
	icon:SetAlpha(1);
	icon.expires = GetTime() + ICON_DURATION;	

end

local function FadeOutOnFinished(animation, requested)
	local icon = animation:GetParent();
	local castHistory = icon:GetParent();
	
	icon:Hide();
	icon:SetAlpha(0);
		
	if ( icon.active ) then
		CastHistory:ResetIcon(icon);
	end	

end

local function MoveOnFinished(animation, requested)
	local icon = animation:GetParent();
	local castHistory = icon:GetParent();
	local size = ArenaLiveCore:GetDBEntry(castHistory.unitFrame.addonName, castHistory.unitFrame.frameType.."/CastHistory/IconSize");
	local direction = ArenaLiveCore:GetDBEntry(castHistory.unitFrame.addonName, castHistory.unitFrame.frameType.."/CastHistory/Direction");
	
	-- Reset animation's xOffset to default
	local point, relativeTo, relativePoint, xOffset, yOffset = icon:GetPoint();

	if ( direction == "LEFT" ) then
		xOffset = (-size - DEFAULT_X_MOD) * icon.timesMoved ;
		yOffset = 0;
		icon.translationAnimation:SetOffset(-size, 0);
	elseif ( direction == "RIGHT" ) then
		xOffset = ( size + DEFAULT_X_MOD ) * icon.timesMoved ;
		yOffset = 0;
		icon.translationAnimation:SetOffset(size, 0);
	elseif ( direction == "UP" ) then
		yOffset = (size + DEFAULT_Y_MOD) * icon.timesMoved;
		xOffset = 0;
		icon.translationAnimation:SetOffset(0, size);
	elseif ( direction == "DOWN" ) then
		yOffset = (-size - DEFAULT_Y_MOD) * icon.timesMoved;
		xOffset = 0;
		icon.translationAnimation:SetOffset(0, -size);
	end	

	icon:ClearAllPoints();
	icon:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);	

end

local function CastingOnFinished(animation, requested)
	local icon = animation:GetParent();
	local castHistory = icon:GetParent();
	
	if ( not icon.abandoned ) then
		
		icon.fadeInAnimation:Play();
	else
		CastHistory:ResetIcon(icon);
	end	

end



-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a statusbar to be the healthbar of a unit frame.
	 Arguments:
		castHistory: The frame that will be registered as casthistory.
		iconTemplate: Name of a frame template for the casthistory's icons.
		unitFrame: the unit frame the casthistory belongs to.
]]--
function CastHistory:AddFrame (castHistory, iconTemplate, unitFrame)

	-- Create a reference for the casthistory inside the unit frame and vice versa.
	unitFrame.castHistory = castHistory;
	castHistory.unitFrame = unitFrame;
	
	-- Set basic values for the casthistory.
	castHistory.numIcons = 0;
	castHistory.elapsed = 0;
	castHistory.iconTemplate = iconTemplate;

	-- Set basic functions for the casthistory.
	castHistory.OnUpdate = OnUpdate;
	castHistory.Update = Update;
	castHistory.Rotate = Rotate;
	castHistory.Reset = Reset;
	castHistory.Enable = Enable;
	castHistory.Disable = Disable;
	
	castHistory:SetScript("OnUpdate", castHistory.OnUpdate);

	-- Enable/Disable the casthistory according to saved variables.
	local DBKey = unitFrame.frameType.."/CastHistory/Enabled";
	local enabled = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
	
	if ( enabled ) then
		castHistory:Enable();
	else
		castHistory:Disable();
	end	

	castHistories[castHistory] = true;
end

function CastHistory:SetIconDuration()
	ICON_DURATION = tonumber(ArenaLiveCore:GetDBEntry(addonName, "CastHistory/IconDuration"));
end

function CastHistory:CreateIcon(castHistory)

	local size = ArenaLiveCore:GetDBEntry(castHistory.unitFrame.addonName, castHistory.unitFrame.frameType.."/CastHistory/IconSize");
	local direction = ArenaLiveCore:GetDBEntry(castHistory.unitFrame.addonName, castHistory.unitFrame.frameType.."/CastHistory/Direction");
	local numIcons = castHistory.numIcons + 1;
	local iconTemplate = castHistory.iconTemplate;
	local prefix = castHistory:GetName();
	local iconName = prefix.."Icon"..numIcons;
	local iconReference = "icon"..numIcons;
	
	local icon = CreateFrame("Button", iconName, castHistory, iconTemplate);
	
	
	if ( icon ) then
		castHistory[iconReference] = icon;
		
		icon.texture = _G[iconName.."Texture"];
		icon.border = _G[iconName.."Border"];
		icon.lockOutTexture = _G[iconName.."LockOutTexture"];
		icon.castingAnimation = _G[iconName.."Casting"];
		icon.moveAnimation = _G[iconName.."Move"];
		icon.translationAnimation = _G[iconName.."MoveTranslation"];
		icon.fadeInAnimation = _G[iconName.."FadeIn"];
		icon.fadeOutAnimation = _G[iconName.."FadeOut"];
		
		-- Set the anchor of icon according to the move direction.
		CastHistory:UpdateIcon(icon, size, direction)
		
		icon.timesMoved = 0;
		
		castHistory.numIcons = numIcons;
		
		-- Set scripts for the animations.
		icon.fadeInAnimation:SetScript("OnFinished", FadeInOnFinished);
		icon.fadeOutAnimation:SetScript("OnFinished", FadeOutOnFinished);
		icon.castingAnimation:SetScript("OnFinished", CastingOnFinished);
		icon.moveAnimation:SetScript("OnFinished", MoveOnFinished);
		
		return castHistory[iconReference];
	else
		ArenaLiveCore:Message(string.format(ArenaLiveCore:GetLocalisation(addonName, "ERR_COULD_NOT_CREATE_CASTHISTORY_ICON"), prefix), "error");
	end

end

function CastHistory:UpdateIcon(icon, size, direction)
		
		icon:ClearAllPoints();
		
		if ( direction == "LEFT" ) then
			icon:SetPoint("RIGHT");
			icon.translationAnimation:SetOffset(-size, 0);
		elseif ( direction == "RIGHT" ) then
			icon:SetPoint("LEFT");
			icon.translationAnimation:SetOffset(size, 0);
		elseif ( direction == "UP" ) then
			icon:SetPoint("BOTTOM");
			icon.translationAnimation:SetOffset(0, size);
		elseif ( direction == "DOWN" ) then
			icon:SetPoint("TOP");
			icon.translationAnimation:SetOffset(0, -size);
		end
		
		icon:SetSize(size, size);
		icon.border:SetSize(size+1, size+1);		
end

function CastHistory:ResetIcon (icon)
	
	icon:Hide();
	icon.texture:SetTexture();
	icon.border:SetVertexColor(1, 1, 1, 1);
	icon.border:Hide();
	icon.lockOutTexture:Hide();
	
	-- Stop all animations that are running.
	icon.moveAnimation:Stop();
	icon.fadeInAnimation:Stop();
	icon.fadeOutAnimation:Stop();
	icon.castingAnimation:Stop();
	
	-- Reset the offset for the translation animation.
	icon.translationAnimation:SetOffset(0, 0);
	
	-- Clear all points and set the alpha to 1.
	icon:SetAlpha(1);
	icon:ClearAllPoints();
	
	-- Reset all control variables to their initial state.
	icon.active = nil;
	icon.timesMoved = 0;
	icon.expires = nil;
	icon.fading = nil;
	icon.abandoned = nil;
	icon.casting = nil;
	icon.lineID = nil;
	icon.channeling = nil;
	icon.spellID = nil;

end

function CastHistory:StartCast(castHistory, event, ...)
		local lineID = select(4, ...);
		local spellID = select(5, ...);
		castHistory.casting = true;
		castHistory.lineID = lineID;
		castHistory:Rotate(event, spellID, lineID);

end

function CastHistory:StopCast(castHistory, ...)
	local lineID = select(4, ...);
	local spellID = select(5, ...);
	local name = GetSpellInfo(spellID);
	
	castHistory.casting = nil;
	castHistory.lineID = nil;
	
	local icon = castHistory.castingIcon;

	if ( icon and lineID == icon.lineID ) then
		-- Reset the history icon that was registered for this casted spell.
		icon.casting = nil;
		icon.lineID = nil;
		icon.abandoned = true;
		icon.castingAnimation:Finish();
		castHistory.stoppedIcon = castHistory.castingIcon;
		castHistory.castingIcon = nil;
	end

end

function CastHistory:StartChannel(castHistory, event, ...)
	local spellID = select(5, ...);	
	castHistory.channeling = true;
	castHistory:Rotate(event, spellID, nil);
end

function CastHistory:StopChannel(castHistory, ...)

		castHistory.channeling = nil;
		local icon = castHistory.channelIcon;
		
		if ( icon ) then
			icon.channeling = nil;
			icon.abandoned = nil;
			icon.castingAnimation:Finish();
			icon.stoppedIcon = castHistory.channelIcon;
			icon.channelIcon = nil;
		end

end

function CastHistory:SuccessfulCast (castHistory, event, ...)
	local icon = castHistory.castingIcon;
	local lineID = select(4, ...);
	local spellID = select(5, ...);		
	local name = GetSpellInfo(spellID);
	if ( not castHistory.casting and not castHistory.channeling and not ArenaLiveCore.spellDB["filteredSpells"][spellID] ) then
		-- This one is an instant cast spell. "UNIT_SPELLCAST_SUCCEEDED" also fires for every tick of a channeled spell, so we checked channeling also.
		castHistory:Rotate(event, spellID, lineID);
	elseif ( castHistory.casting and lineID == castHistory.lineID ) then
		castHistory.isCasting = nil;
		castHistory.lineID = nil;
		
		if ( icon and icon.casting ) then
			icon.casting = nil;
			icon.lineID = nil;
			icon.abandoned = nil;
			icon.castingAnimation:Finish();
			castHistory.castingIcon = nil;
		end
	end
end

function CastHistory:SetIconBorderColour(castHistory, ...)

		local spellID = select(12, ...);
		local destGUID = select(8, ...);
		local icon = castHistory.newestIcon;
		local _, class;
		
		if ( icon and not icon.casting and not icon.channeling and icon.spellID and icon.spellID == spellID ) then

			if ( destGUID ~= "0x0000000000000000" and destGUID ~= "" and destGUID ) then
				_, class = GetPlayerInfoByGUID(destGUID)
			end			
		
			if ( class ) then
				icon.border:Show();
				icon.border:SetVertexColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, 1);

			else
				icon.border:Hide();
			end
			
			castHistory.newestIcon = nil;
		end

end

function CastHistory:LockOutCast(castHistory, ...)

	local extraSpellID = select(15, ...);
		
	icon = castHistory.stoppedIcon;
	
	if ( icon and icon.abandoned and icon.spellID and extraSpellID == icon.spellID ) then
		icon.abandoned = nil;
		icon.border:Show();
		icon.border:SetVertexColor(1, 0, 0, 1);
		icon.lockOutTexture:Show();
		castHistory.stoppedIcon = nil;		
	end

end

function CastHistory:OnEvent (event, ...)

	local affectedFrame;
	
	if ( event == "UNIT_SPELLCAST_START" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:StartCast(affectedFrame.castHistory, event, ...)
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_STOP" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:StopCast(affectedFrame.castHistory, ...);
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:SuccessfulCast(affectedFrame.castHistory, event, ...)
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:StartChannel(affectedFrame.castHistory, event, ...)
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then
		local unit = ...;
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:StopChannel(affectedFrame.castHistory, ...)
					end
				end
			end
		end
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_DAMAGE" or event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_HEAL" or event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_CAST_SUCCESS" ) then
		local sourceGUID = select(4, ...);
		if ( UnitFrame.UnitGUIDTable[sourceGUID] ) then
			for key, value in pairs(UnitFrame.UnitGUIDTable[sourceGUID]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
						
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:SetIconBorderColour(affectedFrame.castHistory, ...)
					end
				end
			end
		end
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_INTERRUPT" )then
		local destGUID = select(8, ...);
		if ( UnitFrame.UnitGUIDTable[destGUID] ) then
			for key, value in pairs(UnitFrame.UnitGUIDTable[destGUID]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
						
					if ( affectedFrame.handlerList.castHistory ) then
						CastHistory:LockOutCast(affectedFrame.castHistory, ...)
					end
				end
			end
		end
	end
end