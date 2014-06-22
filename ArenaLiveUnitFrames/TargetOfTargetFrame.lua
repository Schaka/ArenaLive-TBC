local addonName = "ArenaLiveUnitFrames";
local function TargetOfTargetOnUpdate(self, elapsed)
	if ( self.unit ) then
		local guid = UnitGUID(self.unit);
		
		if ( UnitExists(self.unit) and guid ~= self.guid ) then
			self:SetUnitGUID(self.unit);
			self:Update();
		end
	end
end

function ALUF_TargetofTargetFrame:Initialise()

	local prefix = self:GetName();
	local frameType = "TargetOfTargetFrame";
	local onRightClick = nil;
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local scale = ArenaLiveCore:GetDBEntry(addonName, "TargetOfTargetFrame/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
		
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
	self:SetUnit("targettarget");
	self:SetScript("OnUpdate", TargetOfTargetOnUpdate);
end

function ALUF_TargetofTargetFrame:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		if ( not self.unit ) then
			self:SetUnit("targettarget");
		end
	else
		self:ResetUnit();
	end
end

function ALUF_TargetofTargetFrame:ResetPosition()
	local prefix = self.frameType.."/Position/";
	
	ArenaLiveCore:SetDBEntry(addonName, prefix.."Point", ArenaLiveUnitFrames.DEFAULTS[prefix.."Point"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."RelativeTo", ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativeTo"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."RelativePoint", ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativePoint"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."XOffset", ArenaLiveUnitFrames.DEFAULTS[prefix.."XOffset"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."YOffset", ArenaLiveUnitFrames.DEFAULTS[prefix.."YOffset"]);
	
	self:ClearAllPoints();
	self:SetPoint(ArenaLiveUnitFrames.DEFAULTS[prefix.."Point"], ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativeTo"], ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativePoint"], ArenaLiveUnitFrames.DEFAULTS[prefix.."XOffset"], ArenaLiveUnitFrames.DEFAULTS[prefix.."YOffset"]);
end

function ALUF_TargetofFocusFrame:Initialise()

	local prefix = self:GetName();
	local frameType = "TargetOfFocusFrame";
	local onRightClick = nil;
	local healthBar = _G[prefix.."HealthBar"];
	local powerBar = _G[prefix.."PowerBar"];
	local portrait = _G[prefix.."Portrait"];
	local name = _G[prefix.."Name"];
	local scale = ArenaLiveCore:GetDBEntry(addonName, "TargetOfFocusFrame/Scale"); 
	scale = scale / 100; 
		
	self:SetScale(scale);
		
	ArenaLiveCore:AddFrame(self, "UnitFrame", addonName, frameType, onRightClick, false);
	ArenaLiveCore:AddFrame(healthBar, "HealthBar", self, true);
	ArenaLiveCore:AddFrame(powerBar, "PowerBar", self, true);
	ArenaLiveCore:AddFrame(portrait, "Portrait", _G[prefix.."PortraitTexture"], _G[prefix.."Portrait3D"], self);
	ArenaLiveCore:AddFrame(name, "NameText", self);
	ArenaLiveCore:AddFrame(_G[prefix.."Mover"], "FrameMover", _G[prefix.."MoverText"], self);
	self:SetUnit("focus-target");
	self:SetScript("OnUpdate", TargetOfTargetOnUpdate);
end

function ALUF_TargetofFocusFrame:Toggle()
	local enabled = ArenaLiveCore:GetDBEntry("ArenaLiveUnitFrames", self.frameType.."/Enabled");
	
	if ( enabled ) then
		if ( not self.unit ) then
			self:SetUnit("focus-target");
		end
	else
		self:ResetUnit();
	end
end

function ALUF_TargetofFocusFrame:ResetPosition()
	local prefix = self.frameType.."/Position/";
	
	ArenaLiveCore:SetDBEntry(addonName, prefix.."Point", ArenaLiveUnitFrames.DEFAULTS[prefix.."Point"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."RelativeTo", ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativeTo"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."RelativePoint", ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativePoint"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."XOffset", ArenaLiveUnitFrames.DEFAULTS[prefix.."XOffset"]);
	ArenaLiveCore:SetDBEntry(addonName, prefix.."YOffset", ArenaLiveUnitFrames.DEFAULTS[prefix.."YOffset"]);
	
	self:ClearAllPoints();
	self:SetPoint(ArenaLiveUnitFrames.DEFAULTS[prefix.."Point"], ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativeTo"], ArenaLiveUnitFrames.DEFAULTS[prefix.."RelativePoint"], ArenaLiveUnitFrames.DEFAULTS[prefix.."XOffset"], ArenaLiveUnitFrames.DEFAULTS[prefix.."YOffset"]);
end