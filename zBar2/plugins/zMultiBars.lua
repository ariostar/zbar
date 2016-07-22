if zBar2.lite then return end
local _G = getfenv(0)

zMultiBars = {}
function zMultiBars:GetName() return "zMultiBars" end
zBar2:RegisterPlugin(zMultiBars)

local bars = {
	[3] = {"zMultiR1","MultiBarRight"},
	[4] = {"zMultiR2","MultiBarLeft"},
	[5] = {"zMultiBR","MultiBarBottomRight"},
	[6] = {"zMultiBL","MultiBarBottomLeft"},
}
-- create and register
for id, value in pairs(bars) do
	zBar2:RegisterBar(
		CreateFrame("Frame",value[1],UIParent)
	)
end

function zMultiBars:Init()
	for k,v in pairs(bars) do
		local bar = _G[v[1]]
		bar:SetID(10+1-k)
		bar:SetFrameStrata("MEDIUM")
		bar:SetClampedToScreen(true)
		bar:SetWidth(36); bar:SetHeight(36);
--~ 		bar:SetAttribute("unit2","player")
		bar:SetAttribute("actionpage",k)
		
		for i = 1, 12 do
			--bar:SetAttribute("addchild", _G[v[2].."Button"..i])
      _G[v[2].."Button"..i]:SetParent(bar)
			zBar2.buttons[v[1]..i] = v[2].."Button"..i
			_G[v[2].."Button"..i.."NormalTexture"]:SetWidth(60)
			_G[v[2].."Button"..i.."NormalTexture"]:SetHeight(60)
		end
		_G[v[2].."Button1"]:ClearAllPoints()
		_G[v[2].."Button1"]:SetPoint("CENTER")
	end
end