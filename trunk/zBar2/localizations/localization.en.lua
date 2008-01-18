if not zBar2.loc then
	zBar2.loc = {}
	local loc = zBar2.loc

	loc.Labels = {
		zMultiR1 = "Right", zMultiR2 = "Left", zMultiBR = "BRight", zMultiBL = "BLeft",
		zMainBar = "Main", zPetBar = "Pet", zStanceBar = "Stance", zBagBar = "Bag",
		zMicroBar = "Micro", zXPBar = "XP", zCastBar = "Cast", All = "All",
		zExBar1 = "Extra1", zShadow1 = "Shadow1", zExBar2 = "Extra2", zShadow2 = "Shadow2",
	}

	loc.Option = {
		Title = "zBar Option",
		SelectBar	= "Select Bar",
		Attribute	= "Attribute",
		Layout		= "Layout",
		Commons = "Commons",
		Reset    = "Reset Bar",

		Hide = "Hide",
		Label = "Label",
		Lock = "Lock",
		Pop = "Pop",

		Suit1 = "Suit1",
		Suit2 = "Suit2",
		Trigon1 = "Trigon1",
		Trigon2 = "Trigon2",
		Circle = "Circle",

		HotKey = "Hide HotKey",
		HideTip = "Hide Tooltip",
		LockButtons = "Lock All Buttons",
		HideGrid = "Hide Empty Buttons",
		PageTrigger = "Auto Page",

		Scale = "Scale",
		Inset = "Button Spacing",
		Num = "Num of Buttons",
		NumPerLine = "Num per Line",
		Alpha = "Alpha",
	}

	loc.Tips = {
		Hide		= "Show / Hide this bar",
		Label	= "Show / Hide name of this bar",
		Lock		= "Lock bar and hide tab",
		Pop		= "Pop up when Targeting Enemy or In Combat, Hide otherwise",

		Suit1		= "Predefined Layout Suit 1",
		Suit2		= "Predefined Layout Suit 2",
		Trigon1	= "Trigon1",
		Trigon2	= "Trigon2",
		Circle		= "Circle",

		HotKey			= "Show / Hide Hotkeys for all buttons",
		HideTip		= "Show / Hide Tooltips",
		LockButtons	= "Lock All Buttons",
		HideGrid		= "Hide Grid of Empty Buttons",
		PageTrigger = "Auto switch page of MainBar While Alt key down or has Assistable target",

		Scale			= "Drag slider, Change Scale to appropriate size",
		Inset			= "Adjust button spacing",
		Num				= "Number of Buttons to show in bar",
		NumPerLine	= "Set Number of Buttons per Line\nSort Buttons Vertical / Horizontal / Multi Line",
		Alpha			= "Transparent when mouse leave\nNormal when enter",
	}

	--[[ Bindings ]]--
	BINDING_HEADER_ZEXBUTTON = "zBar Bindings"
	for i = 1, 24 do
		setglobal("BINDING_NAME_CLICK zExButton"..i..":LeftButton", "zExButton"..i)
	end
end