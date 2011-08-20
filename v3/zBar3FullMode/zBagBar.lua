local _G = getfenv(0)

CreateFrame("Frame", "zBagBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zBagBar, zMainBar)
zBar3:AddBar(zBagBar)

function zBagBar:Load()
	-- bag packs
	MainMenuBarBackpackButton:SetParent(self)
	MainMenuBarBackpackButton:SetWidth(36)
	MainMenuBarBackpackButton:SetHeight(36)
	zBar3.buttons["zBagBar1"] = "MainMenuBarBackpackButton"
	MainMenuBarBackpackButtonNormalTexture:SetWidth(60)
	MainMenuBarBackpackButtonNormalTexture:SetHeight(60)
	MainMenuBarBackpackButton:ClearAllPoints()
	MainMenuBarBackpackButton:SetPoint("CENTER")

	for i=0,3 do
		_G["CharacterBag"..i.."Slot"]:SetParent(self)
		_G["CharacterBag"..i.."Slot"]:SetWidth(36)
		_G["CharacterBag"..i.."Slot"]:SetHeight(36)
		zBar3.buttons["zBagBar"..(2+i)] = "CharacterBag"..i.."Slot"
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetWidth(60)
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetHeight(60)
	end

	-- there is no keyring button since 4.2
	if KeyRingButton then
    -- keyring and performance bar
    CreateFrame("Frame","zBagBarButton6",self,"SecureFrameTemplate")
    zBagBarButton6:SetWidth(36); zBagBarButton6:SetHeight(36);
    zBagBarButton6:SetPoint("RIGHT",zBar3.buttons["zBagBar5"],"LEFT")
    zBar3.buttons["zBagBar6"] = "zBagBarButton6"
    
    KeyRingButton:SetParent(zBagBarButton6)
    KeyRingButton:SetFrameLevel(1)
    KeyRingButton:SetHeight(36)
    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint("RIGHT",zBagBarButton6)
    KeyRingButton:Show()
  else
    local defSave = zBar3.defaults.zBagBar.saves
    defSave.num = 5
    defSave.linenum = 5
    defSave.max = 5
    defSave.scale = 0.98
    local save = zBar3Data.zBagBar
    if save then
      save.max = 5
      if save.num > 5 then save.num = 5 end
      if save.linenum > 5 then save.linenum = 5 end
    end
	end

	self:GetTab():GetNormalTexture():SetWidth(60)
	self:GetTab():GetHighlightTexture():SetWidth(60)

	self:Hook()
end

function zBagBar:Hook()
end

function zBagBar:UpdateButtons()
	zBarT.UpdateButtons(self)
	if zBar3Data[self:GetName()].num == 1 then
	  if zBagBarButton6 then
      zBagBarButton6:Show()
      zBagBarButton6:SetAttribute("showstates", nil)
      zBagBarButton6:SetAttribute("statehidden", nil)
      zBagBarButton6:ClearAllPoints()
      zBagBarButton6:SetPoint("RIGHT",zBar3.buttons["zBagBar1"],"LEFT")
		end
	end
end