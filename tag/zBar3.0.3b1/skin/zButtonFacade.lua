zButtonFacade = {}
zBar3:AddPlugin(zButtonFacade)

function zButtonFacade:Load()
	if not LibStub then return end
	local LBF = LibStub('LibButtonFacade', true)
	if not LBF then return end
	
	LBF:RegisterSkinCallback('zBar3', self.SkinCallback, self)
	for name, bar in pairs(zBar3.bars) do
		if bar:GetID() < 13 then
			local group = LBF:Group('zBar3', name)
			if zBar3Data.ButtonFacade and zBar3Data.ButtonFacade[name] then
				local db = zBar3Data.ButtonFacade[name]
				group:Skin(db.SkinID,db.Gloss,db.Backdrop,db.Colors)
			end
			for i = 1, zBar3.defaults[name].saves.max or NUM_ACTIONBAR_BUTTONS do
				local button = _G[zBar3.buttons[name..i]]
				if button then
					group:AddButton(button)
				end
			end
		end
	end
end

function zButtonFacade:SkinCallback(SkinID,Gloss,Backdrop,Group,Button,Colors)
	zBar3Data.ButtonFacade = zBar3Data.ButtonFacade or {}
	if (Group) then
		zBar3Data.ButtonFacade[Group] = zBar3Data.ButtonFacade[Group] or {}
		local db = zBar3Data.ButtonFacade[Group]
		db.SkinID,db.Gloss,db.Backdrop,db.Colors = SkinID,Gloss,Backdrop,Colors
	end
end