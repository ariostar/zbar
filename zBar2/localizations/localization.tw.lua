if GetLocale() == "zhTW" then
	zBar2.loc = {}
	local loc = zBar2.loc

	loc.Labels = {
		zMultiR1 = "右1", zMultiR2 = "右2", zMultiBR = "右下", zMultiBL = "左下",
		zMainBar = "主1", zPetBar = "寵物", zStanceBar = "姿態", zBagBar = "背包",
		zMicroBar = "幫助", zXPBar = "經驗", zCastBar = "施法", zPossessBar = "控制",
		zExBar1 = "擴展1", zShadow1 = "影射1", zExBar2 = "擴展2", zShadow2 = "影射2",
	}

	loc.Option = {
		Title = "zBar 設置",
		SelectBar	= "選擇動作條",
		Attribute	= "屬性",
		Layout		= "排列",
		InCombat = "戰斗時",
		Commons = "公共屬性",
		Reset    = "還原動作條",

		Hide = "隱藏",
		Label = "名字",
		Lock = "鎖定",
		HotKey = "隱藏綁定",

		AutoPop = "自動彈出",
		AutoHide = "自動隱藏",

		Suite1 = "組合1",
		Suite2 = "組合2",
		Circle = "圓環",
		Free = "隨意",
		Invert = "反向",

		HideTip = "隱藏滑鼠提示",
		LockButtons = "鎖定所有按鈕",
		HideGrid = "隱藏空按鈕",
		PageTrigger = "自動繙頁",

		Scale = "縮放",
		Inset = "按鈕間距",
		Num = "按鈕數",
		NumPerLine = "每行按鈕數",
		Alpha = "透明度",
	}

	loc.Tips = {
		Hide		= "顯示 / 隱藏 動作條",
		Label	= "顯示 / 隱藏 動作條的名字",
		Lock		= "鎖定動作條，並隱藏標簽",
		HotKey			= "顯示 / 隱藏 按鈕的快捷鍵",

		AutoPop	= "選擇敵對目標或進入戰鬥狀態時彈出，平時隱藏",
		AutoHide	= "戰斗中自動隱藏，平時顯示",

		Suite1		= "保守一些的排列方式\n12個按鈕時請調整間距",
		Suite2		= "較爲新穎的排列方式\n12個按鈕時請調整間距",
		Circle		= "圓環。設置間距可調整半徑。",
		Free			= "Ctrl+Alt+Shift 移動按鈕，滑鼠滾輪進行縮放",
		Invert		= "水平翻轉，左右倒置",

		HideTip		= "顯示 / 隱藏 按鈕的滑鼠提示",
		LockButtons	= "鎖定所有動作條的按鈕",
		HideGrid		= "當按鈕中無技能或物品時隱藏按鈕",
		PageTrigger = "按下Alt時或切換到協助目標時，主1自動繙頁",

		Scale			= "移動滑塊縮放動作條到合適大小",
		Inset			= "調整按鈕的間距",
		Num				= "設置動作條顯示的按鈕數量\n如果是擴展條，設置此值會增減影射條的按鈕總數",
		NumPerLine	= "設置每行按鈕的數量\n從而組合出橫向、縱向、多行的排列方式",
		Alpha			= "設置動作條透明度\n滑鼠移入時透明度還原",
	}

	--[[ Bindings ]]--
	BINDING_HEADER_ZPOSSESS = "熾火控制切換"
	setglobal("BINDING_NAME_CLICK zPossessButton1:LeftButton",  "控制切換")
	BINDING_HEADER_ZEXBUTTON = "熾火動作條綁定"
	for i = 1, 24 do
		setglobal("BINDING_NAME_CLICK zExButton"..i..":LeftButton", "擴展按鈕"..i)
	end

	loc.Possessed = SPELL_FAILED_POSSESSED .. " ! ?"

end