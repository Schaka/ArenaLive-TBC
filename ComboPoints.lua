--[[ ArenaLive Core Functions: ComboPoint Handler
Created by: Vadrak
Creation Date: 21.06.2013
Last Update: "
TargetIndicator is used to indicate which unit the player is currently targeting.
Usually a border is shown around the frames to indicate that.
]]--

local addonName = "ArenaLiveCore";

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local ComboPoints = ArenaLiveCore:AddHandler("ComboPoints", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
ComboPoints:RegisterEvent("PLAYER_TARGET_CHANGED");
ComboPoints:RegisterEvent("UNIT_COMBO_POINTS");



-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	local comboPoints = GetComboPoints("player", unit);
	local comboPointAnimation;
	
	if ( comboPoints > 0 ) then
		if ( not self:IsShown() ) then
			self:Show();
		end
		
		for i = 1, 5 do
			local comboPoint = self["comboPoint"..i];
			local comboPointName = comboPoint:GetName();
		
			if ( comboPointName ) then
			
				-- Always name your combo point show-animation "$parentFadeIn", if you want to create a custom one!
				comboPointAnimation = _G[comboPointName.."FadeIn"];
			end
			
			if ( i <= comboPoints ) then
				comboPoint:Show();
				
				if ( ( comboPointAnimation ) and (i > self.lastNumComboPoints ) ) then
					comboPoint:SetAlpha(0);
					comboPointAnimation:Play();
				end
			else
				comboPoint:Hide();	
			end
		end
	else
		self:Hide();
	end
	
	self.lastNumComboPoints = comboPoints;

end

local function OnAnimFinished(animation)
	local frame = animation:GetParent();
	frame:SetAlpha(1);
end

local function Reset (self)
	self.comboPoint1:Hide();
	self.comboPoint2:Hide();
	self.comboPoint3:Hide();
	self.comboPoint4:Hide();
	self.comboPoint5:Hide();
	self.lastNumComboPoints = 0;
	self:Hide();
end


-- *** HANDLER FUNCTIONS ***
function ComboPoints:AddFrame (comboPointFrame, comboPoint1, comboPoint2, comboPoint3, comboPoint4, comboPoint5, unitFrame)

	-- Create a reference for the target indicator inside the unit frame and vice versa.
	unitFrame.comboPoints = comboPointFrame;
	comboPointFrame.unitFrame = unitFrame;
	
	-- Create references for combo points
	comboPointFrame.comboPoint1 = comboPoint1;
	--comboPoint1.animation = _G[comboPoint1:GetName().."FadeIn"];
	--comboPoint1.animation:SetScript("OnFinished", OnAnimFinished);
	
	comboPointFrame.comboPoint2 = comboPoint2;
	--comboPoint2.animation = _G[comboPoint2:GetName().."FadeIn"];
	--comboPoint2.animation:SetScript("OnFinished", OnAnimFinished);
	
	comboPointFrame.comboPoint3 = comboPoint3;
	--comboPoint3.animation = _G[comboPoint3:GetName().."FadeIn"];
	--comboPoint3.animation:SetScript("OnFinished", OnAnimFinished);
	
	comboPointFrame.comboPoint4 = comboPoint4;
	--comboPoint4.animation = _G[comboPoint4:GetName().."FadeIn"];
	--comboPoint4.animation:SetScript("OnFinished", OnAnimFinished);
	
	comboPointFrame.comboPoint5 = comboPoint5;
	--comboPoint5.animation = _G[comboPoint5:GetName().."FadeIn"];
	--comboPoint5.animation:SetScript("OnFinished", OnAnimFinished);
	
	comboPointFrame.lastNumComboPoints = 0;
	unitFrame.handlerList.comboPoints = true;
	
	-- Set the basic functions for the castbar.
	comboPointFrame.Update = Update;
	comboPointFrame.Reset = Reset;

end

--[[ Function: OnEvent
	 OnEvent function for the threat indicator handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function ComboPoints:OnEvent (event, ...)

	if ( event == "PLAYER_TARGET_CHANGED" or event == "UNIT_COMBO_POINTS" ) then
		local unit = "target";
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					
					if ( affectedFrame.handlerList.comboPoints ) then
						affectedFrame.comboPoints:Update();
					end
				end
			end
		end
	end

end