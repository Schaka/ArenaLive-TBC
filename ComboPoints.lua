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
ComboPoints:RegisterEvent("PLAYER_COMBO_POINTS");

local function ComboPointShineFadeIn(frame)
	-- Fade in the shine and then fade it out with the ComboPointShineFadeOut function
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = COMBOFRAME_SHINE_FADE_IN;
	fadeInfo.finishedFunc = ComboPointShineFadeOut;
	fadeInfo.finishedArg1 = frame:GetName();
	UIFrameFade(frame, fadeInfo);
end

--hack since a frame can't have a reference to itself in it
local function ComboPointShineFadeOut(frameName)
	UIFrameFadeOut(getglobal(frameName), COMBOFRAME_SHINE_FADE_OUT);
end


-- *** FRAME FUNCTIONS ***
local function Update (self)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self:Reset();
		return;
	end
	
	local comboPoints = GetComboPoints("player", unit);
	local comboPointShine, comboPointHighlight;
	
	if ( comboPoints > 0 ) then
		if ( not self:IsShown() ) then
			self:Show();
			UIFrameFadeIn(self, COMBOFRAME_FADE_IN);
		end
		
		local fadeInfo = {}
		for i = 1, 5 do
			local comboPoint = self["comboPoint"..i];
			local comboPointName = comboPoint:GetName();
		
			if ( comboPointName ) then
				comboPointShine = _G[comboPointName.."Shine"];
				comboPointHighlight = _G[comboPointName.."Highlight"];				
			end
			
			if ( i <= comboPoints ) then
				comboPoint:Show();
				
				if ( comboPointShine and ( i > self.lastNumComboPoints )  ) then
					fadeInfo.mode = "IN";
					fadeInfo.timeToFade = COMBOFRAME_HIGHLIGHT_FADE_IN;
					fadeInfo.finishedFunc = ComboPointShineFadeIn;
					fadeInfo.finishedArg1 = comboPointShine;
					UIFrameFade(comboPointHighlight, fadeInfo);
				end
			else
				comboPointHighlight:SetAlpha(0);
				comboPointShine:SetAlpha(0);
				comboPoint:Hide();	
			end
		end
	else
		self:Hide();
	end
	
	self.lastNumComboPoints = comboPoints;

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
	comboPointFrame.comboPoint2 = comboPoint2;
	comboPointFrame.comboPoint3 = comboPoint3;
	comboPointFrame.comboPoint4 = comboPoint4;
	comboPointFrame.comboPoint5 = comboPoint5;
	
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

	if ( event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_COMBO_POINTS") then
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