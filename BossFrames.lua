local addonName = "ArenaLiveUnitFrames";

local function InitialiseBossFrame(self)
	local prefix = self:GetName();
	local frameType = "BossFrames";
	local onRightClick = "focus";
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local levelText = _G[prefix.."LevelText"];
	local icon1 = _G[prefix.."Icon1"];
	local icon2 = _G[prefix.."Icon2"];
	local icon3 = _G[prefix.."Icon3"];
	local ccIndicator = _G[prefix.."PortraitOverlay"];	
	local id = self:GetID();
	
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false, false);
	ArenaLiveCore:AddFrame(_G[prefix.."TargetIndicator"], "TargetIndicator", self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(ccIndicator, "CCIndicator", _G[prefix.."PortraitOverlayIcon"], _G[prefix.."PortraitOverlayCooldown"], _G[prefix.."PortraitOverlayCooldownText"], self);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame(_G[prefix.."HealthBarText"], "StatusBarText", "HealthBarText", "DEAD_OR_GHOST", nil, true, self);
	ArenaLiveCore:AddFrame(_G[prefix.."PowerBarText"], "StatusBarText", "PowerBarText", nil, true, nil, self);
	ArenaLiveCore:AddFrame(_G[prefix.."AbsorbBar"], "AbsorbBar", _G[prefix.."AbsorbBarOverlay"], 32, _G[prefix.."AbsorbBarFullHPIndicator"], self);
	ArenaLiveCore:AddFrame(_G[prefix.."HealPredictionBar"], "HealPredictionBar", self);
	ArenaLiveCore:AddFrame(_G[prefix.."CastBar"], "CastBar", _G[prefix.."CastBarBorder"], _G[prefix.."CastBarBorderShieldGlow"], _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], _G[prefix.."CastBarAnimationGroup"], _G[prefix.."CastBarAnimationGroupFadeOutAnimation"], true, true, self);
	ArenaLiveCore:AddFrame(_G[prefix.."CastHistory"], "CastHistory", "ArenaLive_CastHistoryIconTemplate", self);
	self:SetAttribute("alframelock", true);
end

function ALUF_BossFrames:UpdateFramePoints()

	local frameSpacing = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/FrameSpacing");
	local growUpwards = ArenaLiveCore:GetDBEntry(self.addonName, self.frameType.."/GrowUpwards");
	local point, relativeTo, relativePoint, yOffset, _;
	local headerHeight, headerWidth;
	headerHeight = frameSpacing * 4;
		
	if ( growUpwards ) then
		point = "BOTTOM"
		relativePoint = "TOP"
	else
		point = "TOP"
		relativePoint = "BOTTOM"
		frameSpacing = -frameSpacing;
	end
		
	for i = 1, 5 do
		local frame = _G["ALUF_BossFrame"..i];
		local _, _, _, xOffset = frame:GetPoint();
		frame:ClearAllPoints();
			
		if ( i == 1 ) then
			headerWidth = frame:GetWidth();
			headerHeight = headerHeight + ( frame:GetHeight() * 5 );
			relativeTo = self;
			frame:SetPoint(point, relativeTo, point, xOffset, 0);
		else
			relativeTo = _G["ALUF_BossFrame"..i-1];
			frame:SetPoint(point, relativeTo, relativePoint, xOffset, frameSpacing);
		end
	end

	self:SetSize(headerWidth, headerHeight);
end

local function OnEvent(self, event, ...)

	if ( event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" ) then
		for i = 1, 5 do
			if ( UnitExists("boss"..i) ) then
				local frame = _G["ALUF_BossFrame"..i];
				frame:Update();
			end
		end	
	end

end

local function OnShow (frameMover)

	for i = 1, 5 do
		local frame = _G["ALUF_BossFrame"..i]
		frame:SetAttribute("alframelock", nil);
	end	
end

local function OnHide (frameMover)

	for i = 1, 5 do
		local frame = _G["ALUF_BossFrame"..i]
		frame:SetAttribute("alframelock", true);
	end	

end

function ALUF_BossFrames:Initialise()
	local prefix = self:GetName();
	local scale = ArenaLiveCore:GetDBEntry(addonName, "BossFrames/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
	
	self.handlerList = {};
	self.addonName = addonName;
	self.frameType = "BossFrames";
	
	for i = 1, 5 do
		local frame = _G["ALUF_BossFrame"..i]
		InitialiseBossFrame(frame);
	end
	
	ALUF_BossFrames:UpdateFramePoints(self);
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
	
	ALUF_BossFrames.frameMover:SetScript("OnShow", OnShow);
	ALUF_BossFrames.frameMover:SetScript("OnHide", OnHide);
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT");
	self:SetScript("OnEvent", OnEvent);
end

function ALUF_BossFrames:Enable()

	-- Set BossFrames
	for i = 1, 5 do
		local frame = _G["ALUF_BossFrame"..i];
		frame:SetUnit("boss"..i);
	end	

end

function ALUF_BossFrames:Disable()
	-- Reset BossFrames
	for i = 1, 5 do
		local frame = _G["ALUF_BossFrame"..i];
		frame:ResetUnit();
	end	
	
end

function ALUF_BossFrames:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		ALUF_BossFrames:Enable();
	else
		ALUF_BossFrames:Disable();
	end
end

local castBarEnabled;
local castBarPosition;
local castHistoryEnabled;
local function UpdateFrameAttachements(self)

	-- Reset all points
	self.castBar:ClearAllPoints();
	self.castHistory:ClearAllPoints();
	
	-- Set new castbar position
	if ( castBarPosition == "LEFT" ) then
		self.castBar:SetPoint("TOPRIGHT", self, "TOPLEFT", -25, -14)
	elseif ( castBarPosition == "RIGHT" ) then
		self.castBar:SetPoint("TOPLEFT", self, "TOPRIGHT", 25, -14)
	end	
	
	-- Set new casthistory direction
	if ( castBarPosition == "LEFT" ) then
		self.castHistory:SetPoint("TOPRIGHT", self.castBar.border, "BOTTOMRIGHT", 0, -2);
	elseif ( castBarPosition == "RIGHT" ) then
		self.castHistory:SetPoint("BOTTOMRIGHT", self.castBar.border, "TOPRIGHT", 0, 2);
	end	
	
	-- Set new cast history moving direction
	if ( castBarPosition == "LEFT" ) then
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "BossFrames/CastHistory/Direction", "LEFT");
	elseif ( castBarPosition == "RIGHT" ) then
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "BossFrames/CastHistory/Direction", "RIGHT");
	end

end

function ALUF_BossFrames:UpdateAttachements()

	castBarEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "BossFrames/CastBar/Enabled");
	castBarPosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "BossFrames/CastBar/Position");
	castHistoryEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "BossFrames/CastHistory/Position");

	for i = 1 , 5 do
		local frame = _G["ALUF_BossFrame"..i];
		UpdateFrameAttachements(frame);
	end
end