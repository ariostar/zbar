local _G = getfenv(0)
NUM_ZEXBAR_BUTTONS = 24

zExBars = {}
function zExBars:GetName() return "zExBars" end
zBar2:RegisterPlugin(zExBars)

zExBars.actions = {}

function zExBars:Init()
	local bar
	for id = 1, 2 do
		bar = CreateFrame("Frame", "zExBar"..id, UIParent, "SecureStateHeaderTemplate")
		zBar2:RegisterBar(bar)
		
		bar:SetID(id)
		bar:SetFrameStrata("MEDIUM")
		bar:SetClampedToScreen(true)
		bar:SetWidth(36); bar:SetHeight(36);
		bar:SetAttribute("unit2","player")
		
		for i = 1, 12 do
			bar:SetAttribute("addchild", self:GetButton(bar, i))
			zBar2.buttons["zExBar"..id..i] = self:GetButton(bar, i):GetName()
		end
		self:GetButton(bar, 1):ClearAllPoints()
		self:GetButton(bar, 1):SetPoint("CENTER")
	end
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
	self:SetScript("OnEvent", self.OnEvent)
end

function zExBars:OnEvent()
	if event == "PLAYER_ENTERING_WORLD" then
		-- scan actions, store empty actions
		for i = 120, 1 do
			if not HasAction(i) then
				table.insert(self.actions, i)
			else
				for j = 1, NUM_ZEXBAR_BUTTONS do
					if _G["zExButton"..i].action == i then
						local page = mod(i,12)
						local id = (i - 12*page)
						if page > 6 then -- bonus action
						elseif page == 1 then -- main
						else -- multi 
						end
					end
				end
			end
		end
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		-- use a new action when it's not available
		if arg1 == 0 then
		
		elseif arg1 then
		
		end
	end
end

function zExBars:GetButton(bar, id)
	local button = _G["zExButton"..id+(bar:GetID()-1)*12]
	if button then return button end
	
	button = CreateFrame("CheckButton", "zExButton"..id+(bar:GetID()-1)*12,bar,"ActionBarButtonTemplate")
	if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
		button.showgrid = 1
	end
	button:SetAttribute("useparent-actionpage", nil)
	_G[button:GetName().."NormalTexture"]:SetWidth(60)
	_G[button:GetName().."NormalTexture"]:SetHeight(60)
	
	button:SetScript("OnAttributeChanged", zExButton.AttributeChanged)
	button:SetScript("OnDragStart", zExButton.DragStart)
	button:SetScript("OnDragStop", zExButton.DragStop)
	
	return button
end

--[[ Button Functions ]]
zExButton = {}
-- 
function zExButton:AttributeChanged(name, value)
	if name == "statehidden" then
	
	elseif name == "actionpage" then
	
	end
end

-- drag, change position when ctrl down,
-- the position is relative to prev button
function zExButton:DragStart()
	if IsControlKeyDown() then
		this:StartMoving()
		
	elseif LOCK_ACTIONBAR ~= "1" or IsModifiedClick("PICKUPACTION") then
		PickupAction(this.action);
		ActionButton_UpdateState();
		ActionButton_UpdateFlash();
	end
end

function zExButton:DragStop()
	if this.moving then
		this.moving = nil
		
		
		this:StopMovingOrSizing()
	end
end

