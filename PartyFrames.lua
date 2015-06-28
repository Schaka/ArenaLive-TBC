local addonName = "ArenaLiveUnitFrames";

local function PartyFrameOnUpdate(self, elapsed)

	if ( self.unit and UnitExists(self.unit) ) then
		if ( UnitInRange(self.unit) ) then
			self:SetAlpha(1);
		else
			self:SetAlpha(0.8);
		end
	end

	
end

local function PartyTargetOnUpdate(self, elapsed)
	if ( self.unit ) then
		local guid = UnitGUID(self.unit);
		if ( UnitExists(self.unit) and guid ~= self.guid ) then
			
			self:SetUnitGUID(self.unit);
			self:Update();
		end
	end
end

local function InitialisePartyTargetFrame(self, parent)

	parent.targetFrame = self;
	parent.handlerList.targetFrame = "targetFrame";
	local prefix = self:GetName();
	local frameType = "PartyTargetFrame";
	local onRightClick = nil;
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];

	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false, false);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	self:SetUnit("targettarget");
	self:SetScript("OnUpdate", PartyTargetOnUpdate);
	self:SetAttribute("alframelock", true);
end

local function InitialisePartyPetFrame(self, parent)

	parent.petFrame = self;
	parent.handlerList.petFrame = "petFrame";
	local prefix = self:GetName();
	local frameType = "PartyPetFrame";
	local onRightClick = nil;
	local healthBar = _G[prefix.."HealthBar"];
	local healthBarText = _G[prefix.."HealthBarText"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false, false);
	ArenaLiveCore:AddFrame(_G[prefix.."TargetIndicator"], "TargetIndicator", self);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame(healthBarText, "StatusBarText", "HealthBarText", "DEAD_OR_GHOST", nil, true, self);
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	self:SetAttribute("alframelock", true);
end

local function InitialisePartyFrame(self)
	local prefix = self:GetName();
	local frameType = "PartyFrames";
	local onRightClick = "togglemenu";
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local levelText = _G[prefix.."LevelText"];
	local icon1 = _G[prefix.."Icon1"];
	local icon2 = _G[prefix.."Icon2"];
	local ccIndicator = _G[prefix.."PortraitOverlay"];
	local id = self:GetID();

	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false, true);
	ArenaLiveCore:AddFrame(_G[prefix.."TargetIndicator"], "TargetIndicator", self);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame (_G[prefix.."HealthBarText"], "StatusBarText", "HealthBarText", "DEAD_OR_GHOST", nil, true, self);
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, false);
	ArenaLiveCore:AddFrame (_G[prefix.."PowerBarText"], "StatusBarText", "PowerBarText", nil, true, nil, self)
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(levelText, "LevelText", nil, "(%s)", self);
	ArenaLiveCore:AddFrame(icon1, "Icon", _G[prefix.."Icon1Texture"], _G[prefix.."Icon1Cooldown"], _G[prefix.."Icon1CooldownText"], self);
	ArenaLiveCore:AddFrame(icon2, "Icon", _G[prefix.."Icon2Texture"], _G[prefix.."Icon2Cooldown"], _G[prefix.."Icon2CooldownText"], self);
	ArenaLiveCore:AddFrame(ccIndicator, "CCIndicator", _G[prefix.."PortraitOverlayIcon"], _G[prefix.."PortraitOverlayCooldown"], _G[prefix.."PortraitOverlayCooldownText"], self);
	ArenaLiveCore:AddFrame(_G[prefix.."CastBar"], "CastBar", _G[prefix.."CastBarBorder"], _G[prefix.."CastBarBorderShieldGlow"], _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], true, true, self);
	ArenaLiveCore:AddFrame (_G[prefix.."AuraFrame"], "Aura", _G[prefix.."AuraFrameBuffFrame"], _G[prefix.."AuraFrameDebuffFrame"], "ArenaLive_BuffTemplate", "ArenaLive_DebuffTemplate", self);
	ArenaLiveCore:AddFrame(_G[prefix.."PVPIcon"], "PvPIcon", 24, 24, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."LeaderIcon"], "LeaderIcon", 16, 16, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."MasterLooterIcon"], "MasterLooterIcon", 16, 16, "HORIZONTAL", self);
	ArenaLiveCore:AddFrame(_G[prefix.."ReadyCheck"], "ReadyCheck", self);
	
	-- Initialise Pet and party target frames.
	InitialisePartyTargetFrame(_G[prefix.."TargetFrame"], self);
	InitialisePartyPetFrame(_G[prefix.."PetFrame"], self);
	
	-- Party Frame OnUpdate script:
	self:SetScript("OnUpdate", PartyFrameOnUpdate);
end

function ALUF_PartyFrames:Initialise()
	local prefix = self:GetName();
	local scale = ArenaLiveCore:GetDBEntry(addonName, "PartyFrames/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
	
	ArenaLiveCore:AddFrame(self, "PartyHeader", addonName, "PartyFrames", _G["ALUF_PartyFrame1"], _G["ALUF_PartyFrame2"], _G["ALUF_PartyFrame3"], _G["ALUF_PartyFrame4"])
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
	
	local frame --[[= _G["ALUF_PartyPlayerFrame"];
	InitialisePartyFrame(frame);]]
	
	for i = 1, 4 do
		frame = _G["ALUF_PartyFrame"..i]
		InitialisePartyFrame(frame);
	end	
end

function ALUF_PartyFrames:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		self:Enable();
	else
		self:Disable();
	end

	-- Set/Reset party frames
	local frame --[[= self["partyPlayerFrame"]
	local petFrame = frame.petFrame;
	local targetFrame = frame.targetFrame;
	frame:Hide()
	if ( enabled ) then
		if ( not self.unit ) then
			frame:SetUnit("player");
		end
		ALUF_PartyFrames:TogglePetFrame(frame, "pet");
		ALUF_PartyFrames:ToggleTargetFrame(frame, "target");
	else
		frame:ResetUnit();
		petFrame:ResetUnit();
		targetFrame:ResetUnit();
	end	]]
	
	for i = 1, 4 do
		frame = self["partyFrame"..i];
		petFrame = frame.petFrame;
		targetFrame = frame.targetFrame;
	if ( enabled ) then
		if ( not self.unit ) then
			frame:SetUnit("party"..i);
		end
		if ( not UnitGUID("party"..i) ) then
			frame:Hide()
		end
		ALUF_PartyFrames:ToggleTargetFrame(frame, "party"..i.."target");
		ALUF_PartyFrames:TogglePetFrame(frame, "partypet"..i);
	else
		frame:ResetUnit();
		petFrame:ResetUnit();
		targetFrame:ResetUnit();
	end	
	end	
end
function ALUF_PartyFrames:ToggleTargetFrame(partyFrame, targetUnit)

	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/TargetFrame/Enabled");

	if (enabled) then
		partyFrame.targetFrame:SetUnit(targetUnit);
	else
		partyFrame.targetFrame:ResetUnit();
	end
	
end

function ALUF_PartyFrames:TogglePetFrame(partyFrame, petUnit)

	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/PetFrame/Enabled");
	
	if (enabled) then
		partyFrame.petFrame:SetUnit(petUnit);
	else
		partyFrame.petFrame:ResetUnit();
	end
end

local castBarEnabled, castBarPosition, auraFrameEnabled, auraFramePosition, targetFrameEnabled, targetFramePosition, petFrameEnabled, petFramePosition;
local function UpdateFrameAttachements(self)

	-- Reset all points
	self.castBar:ClearAllPoints();
	self.auraFrame:ClearAllPoints();
	self.targetFrame:ClearAllPoints();
	self.petFrame:ClearAllPoints();
	
	-- Set new castbar position
	if ( castBarPosition == targetFramePosition and targetFrameEnabled ) then
		
		if ( castBarPosition == "LEFT" ) then
			self.castBar:SetPoint("TOPRIGHT", self.targetFrame, "TOPLEFT", -3, -10)
		elseif ( castBarPosition == "RIGHT" ) then
			self.castBar:SetPoint("TOPLEFT",  self.targetFrame, "TOPRIGHT", 28, -10)
		end
	else
		if ( castBarPosition == "LEFT" ) then
			self.castBar:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, -14)
		elseif ( castBarPosition == "RIGHT" ) then
			self.castBar:SetPoint("TOPLEFT", self, "TOPRIGHT", 25, -14)
		end	
	end
	
	-- Set new pet frame direction
	if ( petFramePosition == "LEFT" ) then
		self.petFrame:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 10, -18);
	elseif ( petFramePosition == "RIGHT" ) then
		self.petFrame:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", -10, -18);
	end	
	
	-- Set new target frame direction
	if ( targetFramePosition == "LEFT" ) then
		self.targetFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -3, 5);
	elseif ( targetFramePosition == "RIGHT" ) then
		self.targetFrame:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 0, 5);
	end		
	
	-- Set new auraframe position
	if ( auraFramePosition == "BELOW" ) then
		self.auraFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 28, 3);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "PartyFrames/AuraFrame/GrowUpwards", false);
	elseif ( auraFramePosition == "ABOVE" ) then
		self.auraFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 28, 2);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "PartyFrames/AuraFrame/GrowUpwards", true);
	end	

end

function ALUF_PartyFrames:UpdateAttachements()

	castBarEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/CastBar/Enabled");
	castBarPosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/CastBar/Position");
	auraFrameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/AuraFrame/Enabled");
	auraFramePosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/AuraFrame/Position");
	targetFrameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/TargetFrame/Enabled");
	targetFramePosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/TargetFrame/Position");
	petFrameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/PetFrame/Enabled");
	petFramePosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PartyFrames/PetFrame/Position");
	
	local frame --[[= self["partyPlayerFrame"];
	UpdateFrameAttachements(frame);]]
	
	for i = 1 , 4 do
		frame = self["partyFrame"..i];
		UpdateFrameAttachements(frame);
	end
end