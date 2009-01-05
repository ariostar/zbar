zButtonFacade = {}
zBar2:RegisterPlugin(zButtonFacade)

function zButtonFacade:Init()
  if LibStub then
    local LBF = LibStub('LibButtonFacade', true)
    if LBF then
      LBF:RegisterSkinCallback('zBar2', self.SkinCallback, self)
      for name, bar in pairs(zBar2.bars) do
        if bar:GetID() < 13 then
          local group = LBF:Group('zBar2', name)
          if zBar2Saves.ButtonFacade and zBar2Saves.ButtonFacade[name] then
            group:Skin(zBar2Saves.ButtonFacade[name].SkinID,
                       zBar2Saves.ButtonFacade[name].Gloss,
                       zBar2Saves.ButtonFacade[name].Backdrop,
                       zBar2Saves.ButtonFacade[name].Colors)
          end
          for i = 1, zBar2.defaults[name].saves.max or NUM_ACTIONBAR_BUTTONS do
            local button = _G[zBar2.buttons[name..i]]
            if button then
              group:AddButton(button)
              if button.GetNormalTexture then
                button:GetNormalTexture():SetWidth(1)
                button:GetNormalTexture():SetHeight(1)
              end
            else
              --print(name..i)
            end
          end
        end
      end
    end
  end
end

function zButtonFacade:SkinCallback(SkinID,Gloss,Backdrop,Group,Button,Colors)
  zBar2Saves.ButtonFacade = zBar2Saves.ButtonFacade or {}
  if (Group) then
    zBar2Saves.ButtonFacade[Group] = zBar2Saves.ButtonFacade[Group] or {}
    zBar2Saves.ButtonFacade[Group].SkinID,
    zBar2Saves.ButtonFacade[Group].Gloss,
    zBar2Saves.ButtonFacade[Group].Backdrop,
    zBar2Saves.ButtonFacade[Group].Colors = 
    SkinID,Gloss,Backdrop,Colors
  end
end