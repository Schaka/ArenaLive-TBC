local addonName = "ArenaLiveUnitFrames";

function ALUF_PetFrame:Initialise()

	local prefix = self:GetName();
	local frameType = "PetFrame";
	local onRightClick = "togglemenu";
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local ccIndicator = _G[prefix.."PortraitOverlay"];
	local scale = ArenaLiveCore:GetDBEntry(addonName, "PetFrame/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
		
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame (_G[prefix.."HealthBarText"], "StatusBarText", "HealthBarText", "DEAD_OR_GHOST", nil, true, self)
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame (_G[prefix.."PowerBarText"], "StatusBarText", "PowerBarText", nil, true, nil, self)
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(ccIndicator, "CCIndicator", _G[prefix.."PortraitOverlayIcon"], _G[prefix.."PortraitOverlayCooldown"], _G[prefix.."PortraitOverlayCooldownText"], self);
	ArenaLiveCore:AddFrame (_G[prefix.."AuraFrame"], "Aura", _G[prefix.."AuraFrameBuffFrame"], _G[prefix.."AuraFrameDebuffFrame"], "ArenaLive_BuffTemplate", "ArenaLive_DebuffTemplate", self);
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
	self:SetUnit("pet");
end

function ALUF_PetFrame:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		self:Hide()
		if ( not self.unit ) then
			self:SetUnit("pet");
		end
	else
		self:ResetUnit();
	end

end

function ALUF_PetFrame:UpdateAttachements()
	
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PetFrame/Enabled");
	local auraFrameEnabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PetFrame/AuraFrame/Enabled");
	local auraFramePosition = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", "PetFrame/AuraFrame/Position");
	
	self.auraFrame:ClearAllPoints();
	
	if ( auraFramePosition == "BELOW" ) then
		self.auraFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 3);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "PetFrame/AuraFrame/GrowUpwards", false);
	elseif ( auraFramePosition == "ABOVE" ) then
		self.auraFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2);
		ArenaLiveCore:SetDBEntry("ArenaLiveUnitFrames", "PetFrame/AuraFrame/GrowUpwards", true);
	end	
	
end