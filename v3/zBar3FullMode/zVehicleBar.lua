local _G = getfenv(0)

CreateFrame("Frame","zVehicleBar",UIParent,"SecureHandlerBaseTemplate")
zBar3:AddPlugin(zVehicleBar, zMainBar)

local OnMainMenuBarHide = function(self)
	if self.state == "vehicle" then
		zVehicleBar.state = self.state
		zMicroBar:UnHook()
	end
end

local OnVehicleMenuBarHide = function(self)
	if zVehicleBar.state == "vehicle" then
		zVehicleBar.state = "player"
		zMicroBar:UnHook()
		for i=1,zMicroBar:GetNumButtons() do
			zMicroBar:GetButton(i):SetParent(zMicroBar)
			zMicroBar:GetButton(i):Show()
		end
		zMicroBar:UpdateLayouts()
		zMicroBar:GetButton(1):zClearAllPoints()
		zMicroBar:GetButton(1):zSetPoint("BOTTOM")
	end
end
local AfterUpdateTalentButton = function()
	zMicroBar:Hook()
end

function zVehicleBar:Load()
	--CharacterMicroButton.SetParent = zMicroButtonSetParent
	hooksecurefunc(MainMenuBar, "Hide", OnMainMenuBarHide)
	hooksecurefunc(VehicleMenuBar, "Hide", OnVehicleMenuBarHide)
	hooksecurefunc("MainMenuBar_ToVehicleArt",AfterUpdateTalentButton)
	for name,bar in pairs(zBar3.bars) do
		bar:SetParent(zBar3)
	end
	RegisterStateDriver(zBar3, "visibility", "[target=vehicle,exists]hide;show")
end

function zVehicleBar:ToVehicleArt()
	if zMicroBar then
		zMicroBar:UnHook()
	end
end

function zVehicleBar:ToPlayerArt()
	if zMicroBar then
		zMicroBar:Hook()
	end
end

function zVehicleBar:Test()
	if MainMenuBar.state == "vehicle" then
		MainMenuBar_ToPlayerArt(MainMenuBar)
	else
		MainMenuBar_ToVehicleArt(MainMenuBar)
	end
end