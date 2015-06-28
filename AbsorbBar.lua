--[[ ArenaLive Core Functions: AbsorbBar Handler
Created by: Vadrak
Creation Date: 02.06.2013
Last Update: 06.06.2013
This file contains all relevant functions for health bars and their behaviour.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local AbsorbBar = ArenaLiveCore:AddHandler("AbsorbBar", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
AbsorbBar:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED");
AbsorbBar:RegisterEvent("UNIT_MAXHEALTH");

-- Set up a table to store all absorb bars. This way it is easier to update them.
local absorbBars = {};

-- *** FRAME FUNCTIONS ***
--[[ Function: Enable
	 Enables the absorb bar.
]]--
local function Enable (self, elapsed)
	self.enabled = true;
	self.unitFrame.handlerList.absorbBar = true;
	self:Update();
end

--[[ Function: Disable
	 Disables the absorb bar.
]]--
local function Disable(self)
	self.enabled = nil;
	self.unitFrame.handlerList.absorbBar = nil;
	self:Update();
end

--[[ Function: Update
	 General update function for the absorb bar.
]]--
local function Update(self)
	local unit = self.unitFrame.unit;
	local healthBar = self.unitFrame.healthBar;
	-- Only use absorb bar, if there is a healthbar attached to the unit frame. otherwise it would cause LUA errors.
	if ( not healthBar or healthBar.lockValues or not unit or not self.enabled ) then
		self:Reset();
		return;
	end
		
	local absorb = UnitGetTotalAbsorbs(unit) or 0;
	
	local health = UnitHealth(unit);
	local minHealth = healthBar:GetMinMaxValues();
	local maxHealth = UnitHealthMax(unit);
	local oldMaxHealth;
		
	-- If maxhealth is smaller than current health and absorb combined, we set the new maxValue to be current health plus the amount of absorb.
	if ( health + absorb > maxHealth ) then
		oldMaxHealth = maxHealth;
		maxHealth = health + absorb;
			
		-- The full HP indicvator is a small line to indicate the 100% HP mark, when current HP + Absobr > Max-HP
		if ( self.fullHPIndicator ) then
			self.fullHPIndicator:Show();
		end
	else
		if ( self.fullHPIndicator ) then
			self.fullHPIndicator:Hide();
		end		
	end
		
	healthBar:SetMinMaxValues(minHealth, maxHealth);
		
	if ( absorb == 0 ) then
		self:Hide();
			
		if ( self.overlay ) then
			self.overlay:Hide();
		end
	else
		self:ClearAllPoints();

		-- Set the position of the absorb bar according to reverse fill settings of the healthbar
		if ( healthBar:GetReverseFill() ) then
			self:SetPoint("TOPRIGHT", healthBar:GetStatusBarTexture(), "TOPLEFT", 0, 0);
			self:SetPoint("BOTTOMRIGHT",healthBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0);
		else
			self:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0);
			self:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0);
		end

		local totalWidth, totalHeight = healthBar:GetSize();
		local _, totalMax = healthBar:GetMinMaxValues();

		local barWidth = (absorb / totalMax) * totalWidth;
		self:SetWidth(barWidth);
		self:Show();
			
		if ( self.overlay ) then
			self.overlay:SetTexCoord(0, barWidth / self.overlay.tileSize, 0, totalHeight / self.overlay.tileSize);
			self.overlay:Show();
		end
			
		if ( self.fullHPIndicator and self.fullHPIndicator:IsShown() ) then
				
			local xOffset = (oldMaxHealth / totalMax ) * totalWidth;
			self.fullHPIndicator:ClearAllPoints();
				
			if ( healthBar:GetReverseFill() ) then
				self.fullHPIndicator:SetPoint("TOPRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT", -xOffset, 0);
			else
				self.fullHPIndicator:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT", xOffset, 0);
			end
				
			self.fullHPIndicator:SetHeight(healthBar:GetHeight());
		end
	end
end

--[[ Function: Reset
	 Reset the absorb bar.
]]--
local function Reset(self)
	self:Hide();
		
	if ( self.overlay ) then
		self.overlay:Hide();
	end
	if ( self.fullHPIndicator ) then
		self.fullHPIndicator:Hide();
	end	
end



-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a statusbar to be the healthbar of a unit frame.
	 Arguments:
		healthBar: The statusBar that will be registered as a healthbar.
		unitFrame: the unit frame the healthbar belongs to.
		frequentUpdates: If true, the healthbar will update itself via an OnUpdate script.
]]--
function AbsorbBar:AddFrame (absorbBar, overlay, overlayTileSize, fullHPIndicator, unitFrame)

	-- Create a reference for the absorb bar inside the unit frame and vice versa.
	unitFrame.absorbBar = absorbBar;
	absorbBar.unitFrame = unitFrame;
	
	-- Register the healthbar in the unit frame's handler list.
	unitFrame.handlerList.absorbBar = true;
	
	-- Create references for overlay and full HP indicator.
	absorbBar.overlay = overlay;
	absorbBar.fullHPIndicator = fullHPIndicator;
	
	-- Set the absorb bar overlay to be as large as the absorb bar.
	if ( overlay ) then
		overlay:SetAllPoints(absorbBar);
		overlay.tileSize = overlayTileSize;
	end
	
	absorbBar.Enable = Enable;
	absorbBar.Disable = Disable;
	absorbBar.Update = Update;
	absorbBar.Reset = Reset;

	-- Enable or disable the bar according to saved variables
	local DBKey = "Absorb/Enabled"
	local enabled = ArenaLiveCore:GetDBEntry(addonName, DBKey);	

	if ( enabled ) then
		absorbBar:Enable();
	else
		absorbBar:Disable();
	end
	
	-- Set an entry in the absorb bar table.
	table.insert(absorbBars, absorbBar)
	
end

function AbsorbBar:ToggleAll()
	local DBKey = "Absorb/Enabled"
	local enabled = ArenaLiveCore:GetDBEntry(addonName, DBKey);
	
	for key, absorbBar in ipairs(absorbBars) do
		if ( enabled ) then
			absorbBar:Enable();
		else
			absorbBar:Disable();
		end
	end

end

--[[ Function: OnEvent
	 OnEvent function for the HealthBar handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function AbsorbBar:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_ABSORB_AMOUNT_CHANGED" or "UNIT_MAXHEALTH" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.absorbBar  ) then
						affectedFrame.absorbBar:Update();
					end
				end
			end
		end
	end

end