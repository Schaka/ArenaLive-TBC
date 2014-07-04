--[[ ArenaLive Core Functions: Castbar Handler
Created by: Vadrak
Creation Date: 11.06.2013
Last Update: "
This file contains all relevant functions for CC Indicators and their behaviour.
]]--

-- TODO: Make colour for shield changable.

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local CastBar = ArenaLiveCore:AddHandler("CastBar", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
CastBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_INTERRUPT");
CastBar:RegisterEvent("PLAYER_ENTERING_WORLD");
CastBar:RegisterEvent("UNIT_SPELLCAST_START");
CastBar:RegisterEvent("UNIT_SPELLCAST_DELAYED");
CastBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
CastBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
CastBar:RegisterEvent("UNIT_SPELLCAST_FAILED");
CastBar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
CastBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
CastBar:RegisterEvent("UNIT_SPELLCAST_STOP");
CastBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
CastBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
CastBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");


-- *** FRAME FUNCTIONS ***
function Enable (self)
	self:SetScript("OnUpdate", self.OnUpdate);	
	self.unitFrame.handlerList.castBar = true;
	self.enabled = true;
	self:Update();
end

function Disable (self)
	self:SetScript("OnUpdate", nil);		
	self.unitFrame.handlerList.castBar = nil;
	self.enabled = nil;
	self:Hide();
end

function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit or not self.enabled ) then
		return;
	end
	
	local nameChannel  = UnitChannelInfo(unit);
	local nameSpell  = UnitCastingInfo(unit);

	if ( nameChannel ) then
		CastBar:StartChannel(self, unit);
	elseif ( nameSpell ) then
		CastBar:StartCast(self, unit);
	else
		self:FinishSpell(false, false)
		--self:Hide()
	end	
end

function OnUpdate (self, elapsed)

		if ( self.casting ) then
			self.value = self.value + elapsed;
			
			if ( self.value >= self.maxValue ) then
				self:SetValue(self.maxValue);
				self:FinishSpell(false, true);
				return;
			end
			
			self:SetValue(self.value);
			
		elseif ( self.channeling ) then
			self.value = self.value - elapsed;
			
			if ( self.value <= 0 ) then
				self:FinishSpell(true, false);
				return;
			end
			
			self:SetValue(self.value);
		end

end

function OnShow (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit or not self.enabled  ) then
		self:Hide();
		return;
	end

	if ( self.casting ) then
		local _, _, _, _, startTime = UnitCastingInfo(unit);
		if ( startTime ) then
			self.value = (GetTime() - (startTime / 1000));
		end
	else
		local _, _, _, _, _, endTime = UnitChannelInfo(unit);
		if ( endTime ) then
			self.value = ((endTime / 1000) - GetTime());
		end
	end

end

function FinishSpell (self, wasChannel, wasSuccessful) 

	if ( wasSuccessful or wasChannel ) then
		self.casting = nil;
		self.lineID = nil;
		self.channeling = nil;
		self:SetStatusBarColor(0.0, 1.0, 0.0);
		UIFrameFadeOut(self, 0.3, 1, 0)
		self.fadeInfo.finishedFunc = function() self:Hide() end
		--self:Hide()
	else
		self.casting = nil;
		self.lineID = nil;
		self:SetStatusBarColor(1.0, 0.0, 0.0);
		--self.fadeOutAnimation:SetStartDelay(0.5);
		self:Hide()
	end
	
	self:SetValue(self.maxValue);
	--self.animationGroup:Play();
	
end

-- *** HANDLER FUNCTIONS ***
function CastBar:AddFrame (castBar, castBarBorder, castBarBorderShield, castBarIcon, castBarText, castBarAnimationGroup, castBarFadeOutAnimation, showTradeSkills, showShield, unitFrame)

	-- Create a reference for the castbar inside the unit frame and vice versa.
	unitFrame.castBar = castBar;
	castBar.unitFrame = unitFrame;
	
	-- Set some base variables for the castbar.
	castBar.border = castBarBorder;
	castBar.borderShield = castBarBorderShield;
	castBar.icon = castBarIcon;
	castBar.text = castBarText;
	castBar.animationGroup = castBarAnimationGroup;
	castBar.fadeOutAnimation = castBarFadeOutAnimation;
	castBar.showTradeSkills = showTradeSkills;
	castBar.showShield = showShield;
	castBar.value = 0;
	castBar.maxValue = 0;
	castBar.minValue = 0;
	
	-- Set the basic functions for the castbar.
	castBar.Update = Update;
	castBar.OnUpdate = OnUpdate;
	castBar.OnShow = OnShow;
	castBar.FinishSpell = FinishSpell;
	castBar.Enable = Enable;
	castBar.Disable = Disable;
	
	-- Set reverse fill
	--CastBar:SetReverseFill(unitFrame);
	
	-- Set OnShow script, since this one must always be active.
	castBar:SetScript("OnShow", self.OnShow);
	
	-- Enable/Disable the castbar according to saved variables.
	local DBKey = unitFrame.frameType.."/CastBar/Enabled";
	local enabled = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
	
	if ( enabled ) then
		castBar:Enable();
	else
		castBar:Disable();
	end
end

function CastBar:SetReverseFill(unitFrame)
	if ( unitFrame.castBar ) then
		local DBKey = unitFrame.frameType.."/StatusBars/ReverseFill";
		local reverseFill = ArenaLiveCore:GetDBEntry(unitFrame.addonName, DBKey);
		unitFrame.castBar:SetReverseFill(reverseFill);
	end
end


function CastBar:ShowShieldBorder(castBar)

	if ( castBar ) then
		if ( castBar.border ) then
			--castBar.border:Hide();
		end
		
		if ( castBar.showShield and castBar.borderShield ) then
			castBar.borderShield:Show();
		end
		
		castBar:SetStatusBarColor(0.0, 0.49, 1.0);
	end
end

function CastBar:HideShieldBorder(castBar)
	
	if ( castBar ) then
		if ( castBar.border ) then
			--castBar.border:Show();
		end
		
		if ( castBar.borderShield ) then
			castBar.borderShield:Hide();
		end

		castBar:SetStatusBarColor(1.0, 0.7, 0.0);		
	end
end

function CastBar:StartCast (castBar, ...)
	
	local unit = select(1, ...);

	if ( not unit or not castBar.enabled ) then
		castBar:Hide();
		return;
	end
	
	local spellID = select(5, ...);
	local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(unit);
	
	if (not name or (not castBar.showTradeSkills and isTradeSkill ) ) then
		castBar:Hide();
		return;
	end
	
	castBar:SetStatusBarColor(1.0, 0.7, 0.0);
	
	castBar.value = (GetTime() - (startTime / 1000));
	castBar.maxValue = (endTime - startTime) / 1000;
	castBar:SetMinMaxValues(0, castBar.maxValue);
	castBar:SetValue(castBar.value);	
	
	if ( castBar.text ) then
		castBar.text:SetText(text);
	end
	
	if ( castBar.icon ) then
		castBar.icon:SetTexture(texture);
	end	
	
	castBar:SetAlpha(1.0);
	castBar.casting = 1;
	
	if ( spellID ) then
		castBar.spellID = spellID;
	else
		castBar.spellName = name;
	end
	
	castBar.lineID = lineID;
	castBar.channeling = nil;

	
	if ( castBar.borderShield ) then
		if ( castBar.showShield and notInterruptible ) then
			castBar.borderShield:Show();
			castBar:SetStatusBarColor(0.0, 0.49, 1.0);
		else
			castBar.borderShield:Hide();
			castBar:SetStatusBarColor(1.0, 0.7, 0.0);
		end
	end
	castBar:Show();

end

function CastBar:DelayedCast (castBar, ...)
	local unit = select(1, ...);
	
	if ( castBar:IsShown() ) then
	
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(unit);

		if ( not name or (not castBar.showTradeSkills and isTradeSkill)) then
				castBar:Hide();
				return;
		end
		
		castBar.value = (GetTime() - (startTime / 1000));
		castBar.maxValue = (endTime - startTime) / 1000;
		castBar:SetMinMaxValues(0, castBar.maxValue);	

		if ( not castBar.casting ) then
			castBar:SetStatusBarColor(1.0, 0.7, 0.0);

			castBar.casting = 1;
			castBar.channeling = nil;
		end
		
	end

end

function CastBar:LockOutCast (castBar, ...)
	
	local guid = castBar.unitFrame.guid;
	
	if (not guid ) then
		return;
	end
	
	local destGUID = select(8, ...);
	local spellSchool = select(17, ...);

	if ( destGUID == guid ) then
		castBar.text:SetText(string.format(ArenaLiveCore:GetLocalisation(addonName, "LOCKOUT!"), GetSchoolString(spellSchool)));
		castBar:FinishSpell(false, false);
	end

end

function CastBar:FailedOrInterruptedCast (castBar, event, ...)
	local spellName = select(2, ...);
	local spellID = select(5, ...);
	
	if ( castBar:IsShown() and ( castBar.casting and select(4, ...) == castBar.lineID ) ) then
	
		if ( castBar.text ) then
			if ( event == "UNIT_SPELLCAST_FAILED" ) then
				castBar.text:SetText(FAILED);
				castBar:SetStatusBarColor(1.0, 0.0, 0.0);
			else
				castBar.text:SetText(INTERRUPTED);
				castBar:SetStatusBarColor(1.0, 0.0, 0.0);
			end
		end
		
		UIFrameFadeOut(castBar, 0.5, 1, 0)
		castBar.fadeInfo.finishedFunc = function() castBar:Hide() end
		--castBar:FinishSpell(false, false);
	end

end

function CastBar:SuccessfulCast (castBar, ...)

	if ( castBar:IsShown() and ( castBar.casting and select(4, ...) == castBar.lineID ) ) then
		castBar:FinishSpell(false, true);
	end
end

function CastBar:StartChannel (castBar, ...)

	local unit = select(1, ...);

	if ( not unit or not castBar.enabled ) then
		castBar:Hide();
		return;
	end

	local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit);

	if ( not name or (not castBar.showTradeSkills and isTradeSkill)) then
		return;
	end	

	castBar:SetStatusBarColor(0.0, 1.0, 0.0);
	castBar.value = ((endTime / 1000) - GetTime());
	castBar.maxValue = (endTime - startTime) / 1000;
	castBar:SetMinMaxValues(0, castBar.maxValue);
	castBar:SetValue(castBar.value);
	
	if ( castBar.text ) then
		castBar.text:SetText(name);
	end	

	if ( castBar.icon ) then
		castBar.icon:SetTexture(texture);
	end
	
	castBar:SetAlpha(1.0);
	castBar.casting = nil;
	castBar.channeling = 1;
	
	local spellID = select(5, ...);
	if ( spellID ) then
		castBar.spellID = spellID;
	else
		castBar.spellName = name;
	end
	
	if ( castBar.borderShield ) then
		if ( castBar.showShield and notInterruptible ) then
			castBar.borderShield:Show();
			castBar:SetStatusBarColor(0.0, 0.49, 1.0);
		else
			castBar.borderShield:Hide();
			castBar:SetStatusBarColor(1.0, 0.7, 0.0);
		end
	end

	castBar:Show();
end

function CastBar:UpdateChannel (castBar, ...)
	local unit = select(1, ...);
	
	if ( not unit ) then
		return;
	end
	
	if ( castBar:IsShown() ) then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit);
		
		if ( not name or (not castBar.showTradeSkills and isTradeSkill)) then
			castBar:Hide();
			return;
		end
		
		castBar.value = ((endTime / 1000) - GetTime());
		castBar.maxValue = (endTime - startTime) / 1000;
		castBar:SetMinMaxValues(0, castBar.maxValue);
		castBar:SetValue(castBar.value);
	end

end

function CastBar:StopCastOrChannel (castBar, event, ...)

	if ( not castBar:IsVisible() ) then
		castBar:Hide();
	end

	if ( ( castBar.casting and event == "UNIT_SPELLCAST_STOP" and select(4, ...) == castBar.lineID ) or ( castBar.channeling and event == "UNIT_SPELLCAST_CHANNEL_STOP" ) ) then

		if ( event == "UNIT_SPELLCAST_CHANNEL_STOP" ) then
			castBar:FinishSpell(true, false)
		else
			--castBar:FinishSpell(false, false)
			UIFrameFadeOut(castBar, 0.3, 1, 0)
			castBar.fadeInfo.finishedFunc = function() castBar:Hide() end
		end
	
	end

end

local affectedFrame;
function CastBar:OnEvent(event, ...)
	
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		-- We need to update all frames in this case.
		for key, frame in pairs(UnitFrame.UnitFrameTable) do
			if ( frame ) then	
				if ( frame.handlerList.castBar ) then
					frame.castBar:Update();
				end
			end
		end
		return;
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_INTERRUPT" ) then
		local destGUID = select(8, ...);
		if ( UnitFrame.UnitGUIDTable[destGUID] ) then
			for key, value in pairs(UnitFrame.UnitGUIDTable[destGUID]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:LockOutCast(affectedFrame.castBar, ...)
					end
				end
			end
		end
		return;
	end
	
	local unit = ...;

	if ( event == "UNIT_SPELLCAST_START" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:StartCast(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_FAILED" ) or ( event == "UNIT_SPELLCAST_INTERRUPTED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:FailedOrInterruptedCast(affectedFrame.castBar, event, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:DelayedCast(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:SuccessfulCast(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:StartChannel(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:UpdateChannel(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_STOP" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:StopCastOrChannel(affectedFrame.castBar, event, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_INTERRUPTIBLE" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:HideShieldBorder(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	elseif ( event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.castBar ) then
						CastBar:ShowShieldBorder(affectedFrame.castBar, ...)	
					end
				end
			end
		end
	end


end