--[[ ArenaLive Core Functions: Portrait Handler
Created by: Vadrak
Creation Date: 09.06.2013
Last Update: "
This file contains all relevant functions for portrait and 3D Portrait frames.
]]--

-- Local version is said to be faster.
local ArenaLiveCore = ArenaLiveCore;

-- Set up a new handler.
local Portrait = ArenaLiveCore:AddHandler("Portrait", "EventCore");

-- Get the global UnitFrame handler.
local UnitFrame = ArenaLiveCore:GetHandler("UnitFrame");

-- Register the handler for all needed events.
Portrait:RegisterEvent("UNIT_MODEL_CHANGED");
Portrait:RegisterEvent("PLAYER_TARGET_CHANGED");



-- *** FRAME FUNCTIONS ***
local function Update (self, event)
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self.texture:SetTexture(0, 0, 0, 1);
		self.texture:SetTexCoord(0, 1, 0, 1);
		self.threeDFrame:Hide();
		return;
	end
	
	local portraitType = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/Portrait/Type");
	
	if ( portraitType == "threeD" ) then
		if ( event == "UNIT_MODEL_CHANGED" or event == "PLAYER_TARGET_CHANGED" ) then
			self.threeDFrame:SetUnit(unit);
			self.threeDFrame:SetCamera(0);
			self.texture:SetTexture(0, 0, 0, 1);
			self.texture:SetTexCoord(0, 1, 0, 1);
			self.threeDFrame:Show();
		end
		
	elseif ( portraitType == "class" ) then
		
		local _, class = UnitClass(unit);
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		local unitNumber = tonumber(string.match(unit, "^[a-z]+([0-9]+)$"));
		local isPlayer = UnitIsPlayer(unit);

		if ( class and isPlayer ) then
			self.threeDFrame:Hide();
			self.texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
			self.texture:SetTexCoord(unpack(CLASS_BUTTONS[class]));
		elseif ( unitType == "arena" and unitNumber ) then
			--[[ For ArenaFrames we can get the class via GetArenaOpponentSpec() and GetSpecializationInfoByID(). 
			Therefore we need to have a fallback option when "ARENA_PREP_OPPONENT_SPECIALIZATIONS" fires.]]--
				if ( class ) then
					self.threeDFrame:Hide();
					self.texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
					self.texture:SetTexCoord(unpack(CLASS_BUTTONS[class]));
				else
					self.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
					self.texture:SetTexCoord(0, 1, 0, 1);
				end
		elseif (not isPlayer ) then
			-- If the unit is a NPC we fall back to 3D-Portrait.
			self.texture:SetTexture(0, 0, 0, 1);
			self.texture:SetTexCoord(0, 1, 0, 1);
			self.threeDFrame:Show();
			self.threeDFrame:SetUnit(unit);
			self.threeDFrame:SetCamera(0);
		end
		
	end	

end

local function OnShow (self, event)
	local portraitType = ArenaLiveCore:GetDBEntry(self.unitFrame.addonName, self.unitFrame.frameType.."/Portrait/Type");
	local unit = self.unitFrame.unit;
	
	if ( not unit ) then
		self.threeDFrame:Hide();
		self.texture:SetTexture();
		self.texture:SetTexCoord(0, 1, 0, 1);
		return;
	end
	
	
	local isPlayer = UnitIsPlayer(unit);
	local _, race = UnitRace(unit);
	if ( portraitType == "threeD" ) then
		self.threeDFrame:SetUnit(unit);
		self.threeDFrame:SetCamera(0);
		self.threeDFrame:Show();
	elseif ( ( portraitType == "class" ) and ( not isPlayer ) ) then
		-- Fix for NPCs to show the portrait camera correctly.
		self.threeDFrame:SetUnit(unit);
		self.threeDFrame:SetCamera(0);
		self.threeDFrame:Show();
	end

end

-- *** HANDLER FUNCTIONS ***
--[[ Function: AddFrame
	 Adds a portrait frame to a unit frame.
	 Arguments:
		portrait: The superordinated portrait frame.
		texture: The texture of the portrait frame. This will be used as background for 3D portraits or as a class icon.
		threeDFrame: PlayerModel frame that is used to display 3D portraits.
		unitFrame: The unit frame the healthbar belongs to.
]]--
function Portrait:AddFrame (portrait, texture, threeDFrame, unitFrame)

	-- Create a reference for the healthbar inside the unit frame and vice versa.
	unitFrame.portrait = portrait;
	portrait.unitFrame = unitFrame;
	
	-- Register the healthbar in the unit frame's handler list.
	unitFrame.handlerList.portrait = true;
	
	-- Set References for 3D Frame and texture.
	portrait.texture = texture;
	portrait.threeDFrame = threeDFrame;

	portrait.Update = Update;
	portrait.OnShow = OnShow;
	
	portrait:SetScript("OnShow", portrait.OnShow);
end

--[[ Function: OnEvent
	 OnEvent function for the Portrait handler.
	 Arguments:
		event: The event that fired.
		...: A list of arguments that accompany the event.
]]--
local affectedFrame;
function Portrait:OnEvent (event, ...)
	local unit = ...;
	if( event == "PLAYER_TARGET_CHANGED" ) then 
		unit = "target";
	end	
	if ( event == "UNIT_MODEL_CHANGED" or event == "PLAYER_TARGET_CHANGED" ) then
		if ( UnitFrame.UnitIDTable[unit] ) then
			for key, value in pairs(UnitFrame.UnitIDTable[unit]) do
				if ( value and UnitFrame.UnitFrameTable[key] ) then
					affectedFrame = UnitFrame.UnitFrameTable[key];
					if ( affectedFrame.portrait ) then
						affectedFrame.portrait:Update(event);
					end
				end
			end
		end
	end

end