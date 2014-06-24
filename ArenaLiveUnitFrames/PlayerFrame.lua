local addonName = "ArenaLiveUnitFrames";


function ALUF_PlayerFrame:Initialise()
		
	local prefix = self:GetName();
	local frameType = "PlayerFrame";
	local onRightClick = "togglemenu";
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local levelText = _G[prefix.."LevelText"];
	local icon1 = _G[prefix.."Icon1"];
	local icon2 = _G[prefix.."Icon2"];
	local ccIndicator = _G[prefix.."PortraitOverlay"];
	local scale = ArenaLiveCore:GetDBEntry(addonName, "PlayerFrame/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
		
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame (_G[prefix.."HealthBarText"], "StatusBarText", "HealthBarText", "DEAD_OR_GHOST", nil, true, self)
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame (_G[prefix.."PowerBarText"], "StatusBarText", "PowerBarText", nil, true, nil, self)
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(levelText, "LevelText", nil, "(%s)", self);
	ArenaLiveCore:AddFrame(icon1, "Icon", _G[prefix.."Icon1Texture"], _G[prefix.."Icon1Cooldown"], _G[prefix.."Icon1CooldownText"], self);
	ArenaLiveCore:AddFrame(icon2, "Icon", _G[prefix.."Icon2Texture"], _G[prefix.."Icon2Cooldown"], _G[prefix.."Icon2CooldownText"], self);
	ArenaLiveCore:AddFrame(ccIndicator, "CCIndicator", _G[prefix.."PortraitOverlayIcon"], _G[prefix.."PortraitOverlayCooldown"], _G[prefix.."PortraitOverlayCooldownText"], self);
	ArenaLiveCore:AddFrame(_G[prefix.."CastBar"], "CastBar", _G[prefix.."CastBarBorder"], _G[prefix.."CastBarBorderShieldGlow"], _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], _G[prefix.."CastBarAnimationGroup"], _G[prefix.."CastBarAnimationGroupFadeOutAnimation"], true, true, self);
	ArenaLiveCore:AddFrame (_G[prefix.."AuraFrame"], "Aura", _G[prefix.."AuraFrameBuffFrame"], _G[prefix.."AuraFrameDebuffFrame"], "ArenaLive_BuffTemplate", "ArenaLive_DebuffTemplate", self);
	ArenaLiveCore:AddFrame(_G[prefix.."PVPIcon"], "PvPIcon", 24, 24, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."LeaderIcon"], "LeaderIcon", 16, 16, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."MasterLooterIcon"], "MasterLooterIcon", 16, 16, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."StatusIcon"], "StatusIcon", 18, 18, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."ReadyCheck"], "ReadyCheck", self);
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
end

function ALUF_PlayerFrame:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		if ( not self.unit ) then
			self:SetUnit("player");
		end
	else
		self:ResetUnit();
	end

end

function ALUF_PlayerFrame:OnEvent(event, ...)
	local unit = ...;
	if ( event == "PLAYER_SPECIALIZATION_CHANGED" and unit == "player" and IsAddOnLoaded(addonName) ) then
		ALUF_PlayerFrame:UpdateAttachements();
	end
end

local ownAltPowerBars = false;
function ALUF_PlayerFrame:UpdateAttachements()
	
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/Enabled");
	local castBarEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/CastBar/Enabled");
	local castBarPosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/CastBar/Position");
	local auraFrameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/AuraFrame/Enabled");
	local auraFramePosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/AuraFrame/Position");
	local altPowerBar;
	local altPowerBaryOffset = 0;
	
	local _, class = UnitClass("player");	
	if ( class == "SHAMAN" ) then
		altPowerBar = true;
	end

	if ( not ownAltPowerBars and enabled ) then
		ALUF_PlayerFrame:GetAltPowerBars();
	end
	
	if ( altPowerBar ) then
		if ( class == "PALADIN" ) then
			altPowerBaryOffset = -37; -- HolyPower is pretty large
		else
			altPowerBaryOffset = -27;
		end
	end
	-- Reset all points
	self.castBar:ClearAllPoints();
	self.auraFrame:ClearAllPoints();
	
	-- Set new castbar position
	if ( castBarPosition == auraFramePosition ) then
		if ( castBarPosition == "BELOW" ) then
			self.castBar:SetPoint("TOPLEFT", self.auraFrame, "BOTTOMLEFT", 21, -3)
		elseif ( castBarPosition == "ABOVE" ) then
			self.castBar:SetPoint("BOTTOMLEFT", self.auraFrame, "TOPLEFT", 21, 3)
		end
	else
		if ( castBarPosition == "BELOW" ) then
			self.castBar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -10, altPowerBaryOffset-3)
		elseif ( castBarPosition == "ABOVE" ) then
			self.castBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -10, 3)
		end	
	end

	-- Set new auraframe position
	if ( auraFramePosition == "BELOW" ) then
		self.auraFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 33, altPowerBaryOffset+3);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/AuraFrame/GrowUpwards", false);
	elseif ( auraFramePosition == "ABOVE" ) then
		self.auraFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 33, 2);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "PlayerFrame/AuraFrame/GrowUpwards", true);
	end	
	
end

local function UpdateTotemFramePosition()
	local _, class = UnitClass("player");
	if ( class == "DRUID" ) then
		-- Resto Druid Mushroom Display
		TotemFrame:ClearAllPoints();
		TotemFrame:SetPoint("TOPRIGHT", ALUF_PlayerFrame, "BOTTOMRIGHT", 25, 15 );
	end
end

function ALUF_PlayerFrame:GetAltPowerBars()
	
	-- Use the Blizzard AltPowerBars and attach them to our PlayerFrame.
	local _, class = UnitClass("player");	
	if ( class == "SHAMAN" ) then
		TotemFrame:SetParent(ALUF_PlayerFrame);
		TotemFrame:ClearAllPoints();
		TotemFrame:SetPoint("TOP", ALUF_PlayerFrame, "BOTTOM", 0, 9 );
	end
	
	ownAltPowerBars = true;

end

ALUF_PlayerFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
ALUF_PlayerFrame:SetScript("OnEvent", ALUF_PlayerFrame.OnEvent);