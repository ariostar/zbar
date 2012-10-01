zBar3FullMode = {}
zBar3:AddPlugin(zBar3FullMode, zExBars)

function zBar3FullMode:Load()
	-- zBar3 defaults

	zBar3.defaults["zMainBar"] = {
	  init = {id=10,frameStrata="HIGH"},
		saves = {linenum = 12, hideTab=true,},
		pos = {"BOTTOM",-100,60-24},
	}
	zBar3.defaults["zMultiR1"] = {
	  init = {id=8},
		saves = {linenum = 1, label=true},
		pos ={"RIGHT",-7,180},
	}
	zBar3.defaults["zMultiR2"] = {
	  init = {id=7},
		saves = {linenum = 1, label=true},
		pos ={"RIGHT",-47,180},
	}
	zBar3.defaults["zMultiBR"] = {
	  init = {id=6},
		saves = {linenum = 12, hideTab=true,},
		pos ={"BOTTOM",-100,132-24},
	}
	zBar3.defaults["zMultiBL"] = {
	  init = {id=5},
		saves = {linenum = 12, hideTab=true,},
		pos ={"BOTTOM",-100,96-24},
	}
	zBar3.defaults["zPetBar"] = {
	  init = {id=11,width=30,height=30,frameStrata="LOW"},
		saves = {num = 10, inset = 6, linenum = 10, max = 10, scale = 0.8,
			hideTab=true,hideHotkey=true, label=true},
		pos = {"BOTTOM",-100,200},
	}
	zBar3.defaults["zStanceBar"] = {
	  init = {id=12,width=30,height=30,frameStrata="LOW"},
		saves = {num=10, inset = 10, linenum = 10, max = 10, scale = 0.9,
			hideTab=true,hideHotkey=true, label=true},
		pos = {"BOTTOM",-30,216},
	}
	zBar3.defaults["zPossessBar"] = {
	  init = {id=20,width=30,height=30,frameStrata="HIGH"},
		saves = {num=2, inset = 10, linenum = 2, max = 2, scale = 0.8,
			hideTab=true,hideHotkey=true, label=true},
		pos = {"BOTTOM",330,200},
	}
	zBar3.defaults["zBagBar"] = {
	  init = {id=13,width=37,height=37,frameStrata="LOW"},
		saves = {num=6, linenum=6, max=6, scale=0.9, hideTab=true, invert=true},
		pos = {"BOTTOMRIGHT",-3,90-24/0.9},
	}
	zBar3.defaults["zMicroBar"] = {
	  init = {id=14,width=29,height=36,frameStrata="LOW"},
		saves = {num=10, linenum=10, max=10, scale=0.68, hideTab=true},
		pos = {"BOTTOMRIGHT",-238,70-24/0.68},
	}
	zBar3.defaults["zXPBar"] = {
	  init = {id=15,width=34,height=22,frameStrata="BACKGROUND"},
		saves = {num = 2, max = 3, scale=0.562, hideTab=true},
		pos = {"BOTTOM",98, 121},
	}

end
