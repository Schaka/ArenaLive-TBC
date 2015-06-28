local addonName = "ArenaLiveUnitFrames";

local function InitialiseArenaFrame(self)
	local prefix = self:GetName();
	local frameType = "ArenaFrames";
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
	
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false, true);
	ArenaLiveCore:AddFrame(_G[prefix.."TargetIndicator"], "TargetIndicator", self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(icon1, "Icon", _G[prefix.."Icon1Texture"], _G[prefix.."Icon1Cooldown"], _G[prefix.."Icon1CooldownText"], self);
	ArenaLiveCore:AddFrame(icon2, "Icon", _G[prefix.."Icon2Texture"], _G[prefix.."Icon2Cooldown"], _G[prefix.."Icon2CooldownText"], self);
	ArenaLiveCore:AddFrame(icon3, "Icon", _G[prefix.."Icon3Texture"], _G[prefix.."Icon3Cooldown"], _G[prefix.."Icon3CooldownText"], self);
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(ccIndicator, "CCIndicator", _G[prefix.."PortraitOverlayIcon"], _G[prefix.."PortraitOverlayCooldown"], _G[prefix.."PortraitOverlayCooldownText"], self);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame(_G[prefix.."HealthBarText"], "StatusBarText", "HealthBarText", "DEAD_OR_GHOST", nil, true, self);
	ArenaLiveCore:AddFrame(_G[prefix.."PowerBarText"], "StatusBarText", "PowerBarText", nil, true, nil, self);
	ArenaLiveCore:AddFrame(_G[prefix.."CastBar"], "CastBar", _G[prefix.."CastBarBorder"], _G[prefix.."CastBarBorderShieldGlow"], _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], true, true, self);
	ArenaLiveCore:AddFrame (_G[prefix.."DrTracker"], "DRTracker", 3, "ArenaLive_DrTrackerIconTemplate", self)

end

function ALUF_ArenaEnemyFrames:Initialise()
	local prefix = self:GetName();
	local scale = ArenaLiveCore:GetDBEntry(addonName, "ArenaFrames/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
	
	for i = 1, 5 do
		local frame = _G["ALUF_ArenaEnemyFrame"..i]
		InitialiseArenaFrame(frame);
	end
	
	ArenaLiveCore:AddFrame(self, "ArenaHeader", addonName, "ArenaFrames", _G["ALUF_ArenaEnemyFrame1"], _G["ALUF_ArenaEnemyFrame2"], _G["ALUF_ArenaEnemyFrame3"], _G["ALUF_ArenaEnemyFrame4"], _G["ALUF_ArenaEnemyFrame5"])
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);

end

function ALUF_ArenaEnemyFrames:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		ALUF_ArenaEnemyFrames:Enable();
	else
		ALUF_ArenaEnemyFrames:Disable();
	end

	-- Set/Reset ArenaEnemyFrames
	for i = 1, 5 do
		local frame = self["arenaFrame"..i];
		if ( enabled ) then
			if ( not self.unit ) then
				frame:SetUnit("arena"..i);
			end
		else
			frame:ResetUnit();
		end
	end	
end

local castBarEnabled;
local castBarPosition;
local drTrackerEnabled;
local drTrackerPosition;
local function UpdateFrameAttachements(self)

	-- Reset all points
	self.castBar:ClearAllPoints();
	self.drTracker:ClearAllPoints();
	
	-- Set new castbar position
	if ( castBarPosition == drTrackerPosition and drTrackerEnabled ) then
		if ( castBarPosition == "LEFT" ) then
			self.castBar:SetPoint("TOPRIGHT", self.drTracker, "TOPLEFT", -2, 10)
		elseif ( castBarPosition == "RIGHT" ) then
			self.castBar:SetPoint("TOPLEFT", self.drTracker, "TOPRIGHT", 2, 10)
		end
	else
		if ( castBarPosition == "LEFT" ) then
			self.castBar:SetPoint("TOPRIGHT", self, "TOPLEFT", -25, -14)
		elseif ( castBarPosition == "RIGHT" ) then
			self.castBar:SetPoint("TOPLEFT", self, "TOPRIGHT", 25, -14)
		end	
	end
	
	-- Set new dr tracker position
	if ( drTrackerPosition == "LEFT" ) then
		self.drTracker:SetPoint("RIGHT", self, "LEFT", -5, 0);
	elseif ( drTrackerPosition == "RIGHT" ) then
		self.drTracker:SetPoint("LEFT", self, "RIGHT", 5, 0);
	end	
	self.drTracker:UpdatePoints();

end

function ALUF_ArenaEnemyFrames:UpdateAttachements()

	castBarEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "ArenaFrames/CastBar/Enabled");
	castBarPosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "ArenaFrames/CastBar/Position");
	drTrackerEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "ArenaFrames/DRTracker/Enabled");
	drTrackerPosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "ArenaFrames/DRTracker/Position");

	for i = 1 , 5 do
		local frame = self["arenaFrame"..i];
		UpdateFrameAttachements(frame);
	end
end