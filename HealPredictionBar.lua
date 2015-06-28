--[[ ArenaLive Core Functions: Heal Prediction Handler
Created by: Vadrak
Creation Date: 02.06.2013
Last Update: 06.06.2013
This file contains all relevant functions for health bars and their behaviour.
]]--
local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local HealPredictionBar = ArenaLiveCore:AddHandler("HealPredictionBar", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
HealPredictionBar:RegisterEvent("UNIT_HEAL_PREDICTION");

-- Set up a table to store all absorb bars. This way it is easier to update them.
local healPredictionBars = {};

-- *** FRAME FUNCTIONS ***
--[[ Function: Enable
	 Enables the absorb bar.
]]--
local function Enable (self, elapsed)
	self.enabled = true;
	self.unitFrame.handlerList.healPredictionBar = true;
	self:Update();
end

--[[ Function: Disable
	 Disables the absorb bar.
]]--
local function Disable(self)
	self.enabled = nil;
	self.unitFrame.handlerList.healPredictionBar = nil;
	self:Update();
end

--[[ Function: Update
	 General update function for the absorb bar.
]]--
local MAX_INCOMING_HEAL_OVERFLOW = 1.0;
local function Update(self)
	local unit = self.unitFrame.unit;
	local healthBar = self.unitFrame.healthBar
	
	if ( not self.enabled or not healthBar or healthBar.lockValues or not unit ) then
		self:Hide();
		return;
	end	
	
	local predictedHeal = UnitGetIncomingHeals(unit) or 0;
	
	local health = UnitHealth(unit);
	local maxHealth = UnitHealthMax(unit);
		
	if ( health + predictedHeal > maxHealth * MAX_INCOMING_HEAL_OVERFLOW ) then
		predictedHeal = maxHealth * MAX_INCOMING_HEAL_OVERFLOW - health;
	end
		
	if ( predictedHeal == 0 ) then
		self:Hide();
	else
		self:ClearAllPoints();
		
		-- Set the position of the health prediction bar according to reverse fill settings of the healthbar
		if ( healthBar:GetReverseFill() ) then
			self:SetPoint("TOPRIGHT", healthBar:GetStatusBarTexture(), "TOPLEFT", 0, 0);
		else
			self:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0);
		end

		local totalWidth, totalHeight = healthBar:GetSize();
		local _, totalMax = healthBar:GetMinMaxValues();

		local barWidth = (predictedHeal / totalMax) * totalWidth;
		self:SetSize(barWidth, totalHeight);
		self:Show();	
	end
end

--[[ Function: Reset
	 Reset the absorb bar.
]]--
local function Reset(self)
	self:Hide();
end



-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Sets up a statusbar to be the healthbar of a unit frame.
	 Arguments:
		healthBar: The statusBar that will be registered as a healthbar.
		unitFrame: the unit frame the healthbar belongs to.
		frequentUpdates: If true, the healthbar will update itself via an OnUpdate script.
]]--
function HealPredictionBar:AddFrame (healPredictionBar, unitFrame)

	-- Create a reference for the heal prediction bar inside the unit frame and vice versa.
	unitFrame.healPredictionBar = healPredictionBar;
	healPredictionBar.unitFrame = unitFrame;
	
	-- Register the heal prediction bar in the unit frame's handler list.
	unitFrame.handlerList.healPredictionBar = true;
	
	healPredictionBar.Enable = Enable;
	healPredictionBar.Disable = Disable;
	healPredictionBar.Update = Update;
	healPredictionBar.Reset = Reset;

	-- Enable or disable the bar according to saved variables
	local DBKey = "HealPrediction/Enabled"
	local enabled = ArenaLiveCore:GetDBEntry(addonName, DBKey);	

	if ( enabled ) then
		healPredictionBar:Enable();
	else
		healPredictionBar:Disable();
	end
	
	-- Set an entry in the absorb bar table.
	table.insert(healPredictionBars, healPredictionBar)
	
end

function HealPredictionBar:ToggleAll()
	local DBKey = "HealPrediction/Enabled"
	local enabled = ArenaLiveCore:GetDBEntry(addonName, DBkey);
	
	for key, healPredictionBar in ipairs(healPredictionBars) do
		if ( enabled ) then
			healPredictionBar:Enable();
		else
			healPredictionBar:Disable();
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
function HealPredictionBar:OnEvent (event, ...)

	local unit = ...;
	
	if ( event == "UNIT_HEAL_PREDICTION" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.healPredictionBar  ) then
						affectedFrame.healPredictionBar:Update();
					end
				end
			end
		end
	end

end