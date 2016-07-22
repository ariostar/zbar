zButtonFacade = {}
zBar2:RegisterPlugin(zButtonFacade)

function zButtonFacade:Init()
  if LibStub then
    local LBF = LibStub('LibButtonFacade', true)
    if LBF then
      LBF:RegisterSkinCallback('zBar3', self.SkinCallback, self)
      for name, bar in pairs(zBar2.bars) do
        if bar:GetID() < 13 then
          LBF:Group('zBar3', name)
        end
      end
    end
  end
end

function zButtonFacade:SkinCallback(SkinID,Gloss,Backdrop,Group,Button,Colors)
end