if GetLocale() == "zhTW" then
	zBar2.loc = {}
	local loc = zBar2.loc

	loc.Labels = {
		zMultiR1 = "右1", zMultiR2 = "右2", zMultiBR = "右下", zMultiBL = "左下",
		zMainBar = "主1", zPetBar = "寵物", zStanceBar = "姿態", zBagBar = "背包",
		zMicroBar = "幫助", zXPBar = "經驗", zCastBar = "施法", All = "全部",
		zExBar1 = "擴展1", zShadow1 = "影射1", zExBar2 = "擴展2", zShadow2 = "影射2",
	}

	loc.Option = {
		Title = "zBar 設置",
		SelectBar	= "選擇動作條",
		Attribute	= "屬性",
		Layout		= "排列",
		Commons = "公共屬性",
		Reset    = "還原位置",

		Hide = "隱藏",
		Label = "名字",
		Lock = "鎖定",
		Pop = "彈出",

		Suit1 = "組合1",
		Suit2 = "組合2",
		Trigon1 = "錐形",
		Trigon2 = "倒錐",
		Circle = "圓環",

		HotKey = "隱藏快捷鍵",
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
		Pop		= "選擇敵對目標或進入戰鬥狀態時彈出，平時隱藏",

		Suit1		= "保守一些的排列方式，雙排為橫向",
		Suit2		= "較爲新穎的排列方式，雙排為縱向",
		Trigon1	= "錐形",
		Trigon2	= "倒錐",
		Circle		= "圓環",

		HotKey			= "顯示 / 隱藏 按鈕的快捷鍵",
		HideTip		= "顯示 / 隱藏 按鈕的滑鼠提示",
		LockButtons	= "鎖定所有動作條的按鈕",
		HideGrid		= "當按鈕中無技能或物品時隱藏按鈕",
		PageTrigger = "按下Alt時或切換到協助目標時，主1自動繙頁",

		Scale			= "移動滑塊縮放動作條到合適大小",
		Inset			= "調整按鈕的間距",
		Num				= "設置動作條顯示的按鈕數量",
		NumPerLine	= "設置每行按鈕的數量\n從而組合出橫向、縱向、多行的排列方式",
		Alpha			= "設置動作條透明度\n滑鼠移入時透明度還原",
	}

	--[[ Bindings ]]--
	BINDING_HEADER_ZEXBUTTON = "熾火動作條綁定"
	for i = 1, 24 do
		setglobal("BINDING_NAME_CLICK zExButton"..i..":LeftButton", "擴展按鈕"..i)
	end
end