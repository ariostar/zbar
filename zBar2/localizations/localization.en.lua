if not zBar2.loc then
	zBar2.loc = {}
	local loc = zBar2.loc

	loc.Labels = {
		zMultiR1 = "Right", zMultiR2 = "Left", zMultiBR = "BRight", zMultiBL = "BLeft",
		zMainBar = "Main", zPetBar = "Pet", zStanceBar = "Stance", zBagBar = "Bag",
		zMicroBar = "Micro", zXPBar = "XP", zCastBar = "Cast", zPossessBar = "Possess",
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

		Suite1 = "Suite1",
		Suite2 = "Suite2",
		Circle = "Circle",
		Free = "Free",
		Invert = "Invert",

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

		Suite1		= "Classic Shapes\nTry addjust Button Spacing when num is 12",
		Suite2		= "Fancy Shapes\nTry addjust Button Spacing when num is 12",
		Circle		= "Ringed around. \nSet the Button Spacing to change radius",
		Free			= "Moves when dragging and hold Ctrl+Alt+Shift\nScale on mouse wheel",
		Invert		= "Mirror it horizontally, left to right, right to left",

		HotKey			= "Show / Hide Hotkeys for all buttons",
		HideTip		= "Show / Hide Tooltips",
		LockButtons	= "Lock All Buttons",
		HideGrid		= "Hide Grid of Empty Buttons",
		PageTrigger = "Auto switch page of MainBar While Alt key down or has Assistable target",

		Scale			= "Drag slider, Change Scale to appropriate size",
		Inset			= "Adjust button spacing",
		Num				= "Number of Buttons to show in bar\nIf this is Extra Bar, then the Shadow bar of this will Change it's Max Num",
		NumPerLine	= "Set Number of Buttons per Line\nSort Buttons Vertical / Horizontal / Multi Line",
		Alpha			= "Transparent when mouse leave\nNormal when enter",
	}

	--[[ Bindings ]]--
	BINDING_HEADER_ZPOSSESS = "zBar2 - Possessive Switch"
	setglobal("BINDING_NAME_CLICK zPossessButton1:LeftButton", "Possessive Switch")
	BINDING_HEADER_ZEXBUTTON = "zBar2 - Extra Buttons"
	for i = 1, 24 do
		setglobal("BINDING_NAME_CLICK zExButton"..i..":LeftButton", "zExButton"..i)
	end
end