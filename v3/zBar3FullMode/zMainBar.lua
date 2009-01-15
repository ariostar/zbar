local _G = getfenv(0)
local format = string.format

CreateFrame("Frame", "zMainBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zMainBar, zBar3FullMode)
zBar3:AddBar(zMainBar)

--[[
	functional
--]]
function zMainBar:Load()
	self:SetID(10)
	self:SetFrameStrata("HIGH")
	self:SetClampedToScreen(true)
	self:SetWidth(36) self:SetHeight(36)

	for id=1,NUM_ACTIONBAR_BUTTONS do
		self:AddButton(_G["ActionButton"..id], id)
		zBar3.buttons["zMainBar"..id] = "ActionButton"..id
		_G["ActionButton"..id.."NormalTexture"]:SetWidth(60)
		_G["ActionButton"..id.."NormalTexture"]:SetHeight(60)
	end
	ActionButton1:ClearAllPoints()
	ActionButton1:SetPoint("CENTER")

	self:Execute( [[ActionButtons = table.new(self:GetChildren())]] )
	self:SetAttribute('_onstate-actionpage',[[
		for i, button in ipairs(ActionButtons) do
			button:SetAttribute('action', abs(button:GetID()) + (newstate-1) * 12)
		end
	]])

	self:UpdateStateHeader()
	
	self:Hook()

	-- grid stuff
	zBar3:RegisterGridUpdater(self)
end

--[[
	Privates
--]]

function zMainBar:AddButton(button, id)
	button:SetParent(self)
	button:SetID(-id)
end

--[[ Hooks ]]
function zMainBar:Hook()
	BonusActionBarFrame:UnregisterAllEvents()
	BonusActionBarFrame:Hide()

	MainMenuBar:SetParent(zBar3.hiddenFrame)

	if VehicleMenuBar then
		VehicleMenuBar:SetFrameStrata("HIGH")
		BonusActionBarFrame:SetAttribute('unit','vehicle')
		RegisterUnitWatch(BonusActionBarFrame)
	end
end

--[[ Page Mapping ]]
function zMainBar:GetStateCommand()
	local header, state = "[bonusbar:5]11;", ""
	
	if zBar3Data["pageTrigger"] then
		header = header .. '[mod:SELFCAST]2;[help]2;'
	end

	if zBar3Data["catStealth"] then
		header = header .. "[bar:1,bonusbar:1,stealth]10;"
	end

	for i=1,4 do
		state = format('[bar:1,bonusbar:%d]%d;', i, i+6)
		header = header .. state
	end

	for i=1,6 do
		state = format("[bar:%d]%d;", i, i)
		header = header .. state
	end

	return header .. "0"
end

function zMainBar:UpdateStateHeader()
	UnregisterStateDriver(zMainBar, "actionpage")
	RegisterStateDriver(zMainBar, "actionpage", zMainBar:GetStateCommand())
end