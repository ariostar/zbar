if GetLocale() == "zhCN" then
	zBar2.loc = {}
	local loc = zBar2.loc

	loc.Labels = {
		zMultiR1 = "右1", zMultiR2 = "右2", zMultiBR = "右下", zMultiBL = "左下",
		zMainBar = "主1", zPetBar = "宠物", zStanceBar = "姿态", zBagBar = "背包",
		zMicroBar = "帮助", zXPBar = "经验", zCastBar = "施法", zPossessBar = "控制",
		zExBar1 = "扩展1", zShadow1 = "影射1", zExBar2 = "扩展2", zShadow2 = "影射2",
	}

	loc.Option = {
		Title = "zBar 设置",
		SelectBar	= "选择动作条",
		Attribute	= "属性",
		Layout		= "排列",
		Commons = "公共属性",
		Reset    = "重置位置",

		Hide = "隐藏",
		Label = "名字",
		Lock = "锁定",
		Pop = "弹出",

		Suit1 = "组合1",
		Suit2 = "组合2",
		Trigon1 = "锥形",
		Trigon2 = "倒椎",
		Circle = "圆环",

		HotKey = "隐藏快捷键",
		HideTip = "隐藏鼠标提示",
		LockButtons = "锁定所有按钮",
		HideGrid = "隐藏空按钮",
		PageTrigger = "自动翻页",

		Scale = "缩放",
		Inset = "按钮间距",
		Num = "按钮数",
		NumPerLine = "每行按钮数",
		Alpha = "透明度",
	}

	loc.Tips = {
		Hide		= "显示 / 隐藏 动作条",
		Label	= "显示 / 隐藏 动作条的名字",
		Lock		= "锁定动作条，并隐藏标签",
		Pop		= "选择敌对目标或进入战斗状态时弹出，平时隐藏",

		Suit1		= "保守一些的排列方式，双排为横向",
		Suit2		= "较为新颖的排列方式，双排为纵向",
		Circle		= "圆环",
		Trigon1	= "锥形",
		Trigon2	= "倒椎",

		HotKey			= "显示 / 隐藏 动作条按钮的快捷键",
		HideTip		= "显示 / 隐藏按钮鼠标提示",
		LockButtons	= "锁定所有动作条的按钮",
		HideGrid		= "当按钮中无技能或物品时隐藏按钮",
		PageTrigger = "按下Alt时或切换到可协助目标时，主1自动翻页",

		Scale			= "拖动滑块缩放动作条到合适大小",
		Inset			= "调整按钮的间距",
		Num				= "显示的按钮数量\n如果是扩展条,设置此值会增减影射条的按钮总数",
		NumPerLine	= "设置每行按钮的数量\n从而组合出横向、纵向、多行的排列方式",
		Alpha			= "设置动作条透明度\n鼠标进入时透明度还原",
	}


	--[[ Bindings ]]--
	BINDING_HEADER_ZPOSSESS = "炽火控制切换"
	setglobal("BINDING_NAME_CLICK zPossessButton1:LeftButton", "控制切换")
	BINDING_HEADER_ZEXBUTTON = "炽火动作条绑定"
	for i = 1, 24 do
		setglobal("BINDING_NAME_CLICK zExButton"..i..":LeftButton", "扩展按钮"..i)
	end

end