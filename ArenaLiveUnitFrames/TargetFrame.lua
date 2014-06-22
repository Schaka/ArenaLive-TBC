local addonName = "ArenaLiveUnitFrames";
function ALUF_TargetFrame:Initialise()

	local prefix = self:GetName();
	local frameType = "TargetFrame";
	local onRightClick = "togglemenu";
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local levelText = _G[prefix.."LevelText"];
	local icon1 = _G[prefix.."Icon1"];
	local icon2 = _G[prefix.."Icon2"];
	local ccIndicator = _G[prefix.."PortraitOverlay"];
	local scale = ArenaLiveCore:GetDBEntry(addonName, "TargetFrame/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
		
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false);
	ArenaLiveCore:AddFrame (_G[prefix.."Flash"], "ThreatIndicator", self);
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
	ArenaLiveCore:AddFrame(_G[prefix.."StatusIcon"], "StatusIcon", 18, 18, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."RaidIcon"], "RaidIcon", 24, 24, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."QuestIcon"], "QuestIcon", 32, 32, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."PetBattleIcon"], "PetBattleIcon", 32, 32, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."AbsorbBar"], "AbsorbBar", _G[prefix.."AbsorbBarOverlay"], 32, _G[prefix.."AbsorbBarFullHPIndicator"], self);
	ArenaLiveCore:AddFrame(_G[prefix.."HealPredictionBar"], "HealPredictionBar", self);
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
	ArenaLiveCore:AddFrame(_G[prefix.."ComboPointFrame"], "ComboPoints", _G[prefix.."ComboPointFrameComboPoint1"], _G[prefix.."ComboPointFrameComboPoint2"], _G[prefix.."ComboPointFrameComboPoint3"], _G[prefix.."ComboPointFrameComboPoint4"], _G[prefix.."ComboPointFrameComboPoint5"], self)
	self:SetUnit("target");
end

function ALUF_TargetFrame:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		self:Hide()
		if ( not self.unit ) then
			self:SetUnit("target");
		end
	else
		self:ResetUnit();
	end

end

function ALUF_TargetFrame:UpdateAttachements()
	
	local castBarEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "TargetFrame/CastBar/Enabled");
	local castBarPosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "TargetFrame/CastBar/Position");
	local auraFrameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "TargetFrame/AuraFrame/Enabled");
	local auraFramePosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "TargetFrame/AuraFrame/Position");


	-- Reset all points
	self.castBar:ClearAllPoints();
	self.auraFrame:ClearAllPoints();
	
	-- Set new castbar position
	if ( castBarPosition == auraFramePosition ) then
		if ( castBarPosition == "BELOW" ) then
			self.castBar:SetPoint("TOPRIGHT", self.auraFrame, "BOTTOMRIGHT", -21, -3)
		elseif ( castBarPosition == "ABOVE" ) then
			self.castBar:SetPoint("BOTTOMRIGHT", self.auraFrame, "TOPRIGHT", -21, 3)
		end
	else
		if ( castBarPosition == "BELOW" ) then
			self.castBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 10, -3)
		elseif ( castBarPosition == "ABOVE" ) then
			self.castBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 10, 3)
		end	
	end
	
	-- Set new auraframe position
	if ( auraFramePosition == "BELOW" ) then
		self.auraFrame:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -33, 3);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "TargetFrame/AuraFrame/GrowUpwards", false);
	elseif ( auraFramePosition == "ABOVE" ) then
		self.auraFrame:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -33, 2);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "TargetFrame/AuraFrame/GrowUpwards", true);
	end	
	
end