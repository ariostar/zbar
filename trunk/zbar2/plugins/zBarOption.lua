
local _G = getfenv(0)

CreateFrame("Frame", "zBarOption", UIParent)
zBar2:RegisterPlugin(zBarOption)

--[[ functional ]]
function zBarOption:Init()
	self:SetWidth(310); self:SetHeight(380);
	self:SetPoint("CENTER")
	self:SetMovable(true)
	self:SetToplevel(true)
	self:SetFrameStrata("DIALOG")
	self:SetClampedToScreen(true)
	
	SlashCmdList["ZBAR"] = function(msg)
		for name,bar in pairs(zBar2.bars) do
			zBarOption:Openfor(bar)
			return
		end
	end
	SLASH_ZBAR1 = "/zbar"
end

function zBarOption:Openfor(bar)
	self:CheckReady()
	self:Select(bar)
	self:LoadOptions()
	self:Show()
end

function zBarOption:GetSelected()
	if not self.bar then zBar2:print("Nothing selected") end
	return self.bar
end

--[[ Privates ]]
function zBarOption:CheckReady()
	-- run once
	if self.ready then return true end
	self.ready = true
	
	--[[ Create at first time ]]
	
	-- background
	self:SetBackdrop( { 
	  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
	  tile = true, tileSize = 16, edgeSize = 16, 
	  insets = { left = 5, right = 5, top = 5, bottom = 5 }
	});
	self:SetBackdropColor(0,0,0)
	self:SetBackdropBorderColor(0.5,0.5,0.5)
	
	-- drag
	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart",function() this:StartMoving() end)
	self:SetScript("OnDragStop",function() this:StopMovingOrSizing() end)
	
	-- label texts
	local name, args, label
	for name, args in pairs(self.labels) do
		label = self:CreateFontString(self:GetName()..name,"ARTWORK",args[1])
		label:SetTextColor(args[2],args[3],args[4])
		label:SetPoint(args[5],args[6],args[7])
		label:SetText(zBar2.loc.Option[name])
	end
	
	-- close button
	CreateFrame("Button","zBarOptionCloseButton",self,"UIPanelCloseButton"):SetPoint("TOPRIGHT")
	
	-- choose bar
	local id, bar, button
	for id, name in ipairs(self.bars) do
		bar = _G[name]
		
		button = CreateFrame("CheckButton", "zBarOptionBar"..name,self,"zBarOptionRadioButtonTemplate")
		button.bar = bar
		if not bar then button:Disable() end
		
		if id == 1 then
			button:SetPoint("TOPLEFT",zBarOptionSelectBar,"BOTTOMLEFT",0,-5)
		elseif mod(id, 4) == 1 then
			button:SetPoint("TOP","zBarOptionBar"..self.bars[id-4],"BOTTOM")
		else
			button:SetPoint("LEFT","zBarOptionBar"..self.bars[id-1],"RIGHT",55,0)
		end
		
		button:SetText(zBar2.loc.Labels[name])
		
		button:SetScript("OnClick", function()
			PlayClickSound()
			zBarOption:Openfor(this.bar)
		end)
		button:SetScript("OnEnter",nil)
	end
	
	-- reset button
	button = CreateFrame("Button","zBarOptionResetButton",self,"UIPanelButtonTemplate2")
	button:SetWidth(110); button:SetHeight(20);
	button:SetPoint("TOPRIGHT","zBarOption","TOPRIGHT",-20,-120)
	button:SetText(zBar2.loc.Option.Reset)
	button:SetScript("OnClick", function() zBarOption.bar:Reset(true) zBarOption:LoadOptions() end)
	
	-- check buttons
	for id, value in ipairs(self.buttons) do
		local template
		if value.radio then
			template = "zBarOptionRadioButtonTemplate"
		else
			template = "zBarOptionCheckButtonTemplate"
		end
		button = CreateFrame("CheckButton","zBarOption"..value.name,zBarOption, template)
		button:SetPoint(value.pos[1],value.pos[2],value.pos[3],value.pos[4],value.pos[5])
		button:SetText(zBar2.loc.Option[value.name])
		button.tooltipText = zBar2.loc.Tips[value.name]
		button:SetID(id)
		
		if value.notReady or (value.IsEnabled and not value.IsEnabled()) then button:Disable() end
		
		button:SetScript("OnClick",function()
			PlayClickSound()
			local value = zBarOption.buttons[this:GetID()]
			local checked = this:GetChecked()
			-- save the option value
			if value.common then
				zBar2Saves[value.var] = checked
			elseif value.var then
				zBar2Saves[zBarOption.bar:GetName()][value.var] = checked
			end
			if checked then
				value.OnChecked()
			else
				value.UnChecked()
			end
		end)
		
	end
	
	-- sliders
	local slider, value
	for id, value in ipairs(zBarOption.sliders) do
		slider = CreateFrame("Slider", "zBarOptionSlider"..id, zBarOption, "OptionsSliderTemplate")
		slider:SetPoint(value.pos[1],value.pos[2],value.pos[3],value.pos[4],value.pos[5])
		slider:SetMinMaxValues(value.min,value.max)
		slider:SetValueStep(value.step)
		slider:SetScript("OnValueChanged", value.setFunc)
		
		_G["zBarOptionSlider"..id.."Text"]:SetText(zBar2.loc.Option[value.name])
		slider.tooltipText = zBar2.loc.Tips[value.name]
		
		if value.factor then
			_G["zBarOptionSlider"..id.."Low"]:SetText(value.min * value.factor .. "%")
			_G["zBarOptionSlider"..id.."High"]:SetText(value.max * value.factor .. "%")
		else
			_G["zBarOptionSlider"..id.."Low"]:SetText(value.min)
			_G["zBarOptionSlider"..id.."High"]:SetText(value.max)
		end
	end
	CreateFrame("EditBox","zBarOptionSlider3EditBox",zBarOptionSlider3,"InputBoxTemplate")
	zBarOptionSlider3EditBox:SetWidth(30) zBarOptionSlider3EditBox:SetHeight(20)
	zBarOptionSlider3EditBox:SetAutoFocus(true)
	zBarOptionSlider3EditBox:SetNumeric(true)
	zBarOptionSlider3EditBox:SetMaxLetters(3)
	zBarOptionSlider3EditBox:SetFocus(true)
	zBarOptionSlider3EditBox:SetPoint("LEFT",zBarOptionSlider3Text,"RIGHT",6,0)
	
	zBarOptionSlider3EditBox:SetScript("OnEnterPressed", function()
		zBarOptionSlider3:SetValue(this:GetNumber()*0.01)
	end)
	zBarOptionSlider3EditBox:SetScript("OnEscapePressed", function()
		zBarOption:Hide()
	end)

	zBarOptionSlider3EditBox:CreateFontString("zBarOptionSlider3EditBoxText","ARTWORK","GameFontNormalSmall")
	zBarOptionSlider3EditBoxText:SetText('%')
	zBarOptionSlider3EditBoxText:SetPoint("LEFT",zBarOptionSlider3EditBox,"RIGHT")
end

function zBarOption:LoadOptions()
	local id, value, obj
	-- read check buttons value
	for id, value in ipairs(zBarOption.buttons) do
		obj = _G["zBarOption"..value.name]
		if value.var then
			if value.common then -- common attributes
				obj:SetChecked(zBar2Saves[value.var])
			else -- bar attributes
				obj:SetChecked(zBar2Saves[zBarOption.bar:GetName()][value.var])
			end
		elseif value.IsChecked then -- system attributes
			obj:SetChecked(value.IsChecked())
		end
	end
	-- read sliders value
	local min = 1
	local max = zBar2Saves[self.bar:GetName()].max or 12
	local num = zBar2Saves[zBarOption.bar:GetName()].num or 1
	local linenum = zBar2Saves[zBarOption.bar:GetName()].linenum or 1
	if max == 0 then min = 0 end
	zBarOptionSlider1:SetMinMaxValues(min,max)
	zBarOptionSlider1:SetValue(num)
	zBarOptionSlider1High:SetText(max)
	zBarOptionSlider2:SetMinMaxValues(min,max)
	zBarOptionSlider2:SetValue(linenum)
	zBarOptionSlider2High:SetText(max)
	for id, value in ipairs(zBarOption.sliders) do
		obj = _G["zBarOptionSlider"..id]
		obj:SetValue(zBar2Saves[zBarOption.bar:GetName()][value.var] or 1)
	end
end

function zBarOption:Select(bar)
	local id, name, button
	for id, name in pairs(self.bars) do
		button = _G["zBarOptionBar"..name]
		if button:GetChecked() then
			button:SetChecked(false)
			button:SetTextColor(1,0.82,0)
		end
	end
	button = _G["zBarOptionBar"..bar:GetName()]
	button:SetChecked(true)
	button:SetTextColor(0.1,1,0.1)

	self.bar = bar
end

--[[ Datas ]]
zBarOption.labels = {
	-- font, color-red, color-green, color-blue, pos, offset-x, offset-y
	["Title"] = {"GameFontNormalLarge",0.12,0.66,1,"TOP",0,-10},
	["SelectBar"] = {"GameFontNormalLarge",1.0,0.82,0.1,"TOPLEFT",10,-40},
	["Attribute"] = {"GameFontNormalLarge",1.0,0.82,0.1,"TOPLEFT",10,-120},
	["Layout"] = {"GameFontNormalLarge",1.0,0.82,0.1,"TOPLEFT",90,-120},
	["Commons"] = {"GameFontNormalLarge",1.0,0.82,0.1,"BOTTOMLEFT",10,130},
}
zBarOption.bars = { --[[ bar name and order ]]
	"zMultiBL", "zMultiBR",	"zMultiR2", "zMultiR1",
	"zMainBar", "zPetBar", "zStanceBar", "zBagBar",
	"zMicroBar", "zXPBar",  "zCastBar", "zExBar1",
}
zBarOption.buttons = { --[[ Check Buttons - for attribute setting ]]
	{-- show / hide bar
		name="Hide",var="hide",pos={"TOPLEFT","zBarOptionAttribute","BOTTOMLEFT",0,-5},
		OnChecked=function() zBarOption.bar:UpdateVisibility() end, 
		UnChecked=function()
			zBarOption.bar:UpdateVisibility()
			zBarOption.bar:UpdateButtons()
			zBarOption.bar:UpdateLayouts()
		end,
	},
	{-- show / hide name label
		name="Label",var="label",pos={"TOP","zBarOptionHide","BOTTOM",0,0},
		OnChecked=function() zBarOption.bar:GetLabel():Show() end,
		UnChecked=function() zBarOption.bar:GetLabel():Hide() end,
	},
	{-- show / hide tab
		name="Lock",var="hideTab",pos={"TOP","zBarOptionLabel","BOTTOM",0,0},
		OnChecked=function() zBarOption.bar:UpdateVisibility() end, 
		UnChecked=function() zBarOption.bar:UpdateVisibility() end,
	},
	{-- auto-pop mode
		name="Pop",var="autoPop",pos={"TOP","zBarOptionLock","BOTTOM",0,0},
		notReady = true,
		OnChecked=function() end,
		UnChecked=function() end,
	},
	{
		name="Suit1",var="suit1",pos={"TOPLEFT","zBarOptionLayout","BOTTOMLEFT",0,-5},
		radio = true,notReady = true,
		OnChecked=function() end,
		UnChecked=function() end,
	},
	{
		name="Suit2",var="suit2",pos={"TOP","zBarOptionSuit1","BOTTOM",0,-2},
		radio = true,notReady = true,
		OnChecked=function() end,
		UnChecked=function() end,
	},
	{
		name="Trigon1",var="trigon1",pos={"TOP","zBarOptionSuit2","BOTTOM",0,-2},
		radio = true,notReady = true,
		OnChecked=function() end,
		UnChecked=function() end,
	},
	{
		name="Trigon2",var="trigon2",pos={"TOP","zBarOptionTrigon1","BOTTOM",0,-2},
		radio = true,notReady = true,
		OnChecked=function() end,
		UnChecked=function() end,
	},
	{
		name="Circle",var="circle",pos={"TOP","zBarOptionTrigon2","BOTTOM",0,-2},
		radio = true,notReady = true,
		OnChecked=function() end,
		UnChecked=function() end,
	},
	--[[ commons ]]
	{-- show / hide hotkeys
		name="HotKey",var="hideHotkey",common=true,
		pos={"TOPLEFT","zBarOptionCommons","BOTTOMLEFT",0,-5},
		OnChecked=function()
			for name, bar in pairs(zBar2.bars) do
				bar:UpdateHotkeys()
			end
		end,
		UnChecked=function()
			for name, bar in pairs(zBar2.bars) do
				bar:UpdateHotkeys()
			end
		end,
	},
	{-- show / hide button tips
		name="HideTip",var="hideTip",common=true,
		pos={"TOP","zBarOptionHotKey","BOTTOM",0,0},
		OnChecked=function() end,
		UnChecked=function() end,
	},
	{-- lock / unlock all buttons
		name="LockButtons",
		pos={"TOP","zBarOptionHideTip","BOTTOM",0,0},
		IsChecked=function() return LOCK_ACTIONBAR == "1" end,
		OnChecked=function() LOCK_ACTIONBAR = "1" end,
		UnChecked=function() LOCK_ACTIONBAR = nil end,
	},
	{-- show / hide grid
		name="HideGrid",
		pos={"TOP","zBarOptionLockButtons","BOTTOM",0,0},
		IsChecked=function() return ALWAYS_SHOW_MULTIBARS ~= "1" and ALWAYS_SHOW_MULTIBARS ~= 1 end,
		OnChecked=function()
			ALWAYS_SHOW_MULTIBARS = nil
			MultiActionBar_UpdateGridVisibility()
			SetActionBarToggles(SHOW_MULTI_ACTIONBAR_1,
			SHOW_MULTI_ACTIONBAR_2, SHOW_MULTI_ACTIONBAR_3,
			SHOW_MULTI_ACTIONBAR_4, ALWAYS_SHOW_MULTIBARS);
		end,
		UnChecked=function()
			ALWAYS_SHOW_MULTIBARS = "1"
			MultiActionBar_UpdateGridVisibility()
			SetActionBarToggles(SHOW_MULTI_ACTIONBAR_1,
			SHOW_MULTI_ACTIONBAR_2, SHOW_MULTI_ACTIONBAR_3,
			SHOW_MULTI_ACTIONBAR_4, ALWAYS_SHOW_MULTIBARS);
		end,
	},
	{-- auto page
		name="PageTrigger",var="pageTrigger",common=true,
		pos={"TOP","zBarOptionHideGrid","BOTTOM",0,0},
		IsEnabled=function() return (zMainBar and true) end,
		OnChecked=zMainBar.UpdateStateHeader,
		UnChecked=zMainBar.UpdateStateHeader,
	},
}
zBarOption.sliders = { --[[ Sliders ]]
	[1] = {-- num of buttons
		name="Num",
		var="num", min=1, max=12, step=1,
		pos={"TOPRIGHT","zBarOption","TOPRIGHT",-10,-160},
		setFunc = function()
			zBar2Saves[zBarOption.bar:GetName()].num = this:GetValue()
			zBarOption.bar:UpdateButtons()
			zBarOption.bar:UpdateLayouts()
		end
	},
	[2] = {-- num per line
		name="NumPerLine",
		var="linenum", min=1, max=12, step=1,
		pos={"TOP","zBarOptionSlider1","BOTTOM",0,-25},
		setFunc = function()
--~ 			zBarOptionAttr5:SetChecked(false)
--~ 			zBarOptionAttr6:SetChecked(false)
			
			_G[this:GetName().."Thumb"]:Show()
		
			local name = zBarOption.bar:GetName()
			-- linenum can't be greater than num
			local num = this:GetValue()
			if num > zBar2Saves[name].num then
				this:SetValue(zBar2Saves[name].num)
				return
			end
		
			zBar2Saves[name].arrangement = "line"
			zBar2Saves[name].linenum = this:GetValue()
			zBarOption.bar:UpdateLayouts()
		end
	},
	[3] = {-- scale
		name="Scale",
		var="scale", min=0.2, max=1.8, step=0.001, factor=100,
		pos={"TOP","zBarOptionSlider2","BOTTOM",0,-30},
		setFunc = function()
			local value = this:GetValue()
			zBar2Saves[zBarOption.bar:GetName()].scale = value
			zBarOption.bar:SetScale(value)
			zBarOption.bar:GetTab():SetScale(value)
			-- set edit box text
			local tmp = _G[this:GetName().."EditBox"]
			tmp:SetText(floor(100 * value))
			tmp:HighlightText()
		end
	},
	[4] = {-- button spacing
		name="Inset",
		var="inset", min=0, max=20, step=2,
		pos={"TOP","zBarOptionSlider3","BOTTOM",0,-25},
		setFunc = function()
			zBar2Saves[zBarOption.bar:GetName()].inset = this:GetValue()
			zBarOption.bar:UpdateLayouts()
		end
	},
	[5] = {-- alpha
		name="Alpha",
		var="alpha", min=0, max = 1, step=0.1, factor=100,
		pos={"TOP","zBarOptionSlider4","BOTTOM",0,-25},
		setFunc = function()
			zBar2Saves[zBarOption.bar:GetName()].alpha = this:GetValue()
			zBarOption.bar:SetAlpha(this:GetValue())
		end
	},
}