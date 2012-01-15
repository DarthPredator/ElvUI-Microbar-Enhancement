local E, L, DF = unpack(ElvUI); --Engine
local AB = E:GetModule('ActionBars', 'AceHook-3.0', 'AceEvent-3.0');

DF.alpha = 1 --Set defalt alpha to 100%

--OPTIONS
E.Options.args.microbar = {
	type = "group",
	name = L['Microbar'],
	order = 11,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L['Module for adding micromenu to ElvUI.'],
		},			
		microbar = {
			order = 2,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				mouseover = { --Enable/disable moue over function
					order = 1,
					type = "toggle",
					name = L['On Mouse Over'],
					desc = L['Hide microbar unless you mouse over it.'],
					get = function(info) return E.db.mouseover end,
					set = function(info, value) E.db.mouseover = value end,
				},
				alpha = { --Set transparency
					type = "range",
					order = 2,
					name = L['Set Alpha'],
					desc = L['Sets alpha of the microbar'],
					type = "range",
					min = 0.5, max = 1, step = 0.01,
					get = function(info) return E.db.alpha end,
					set = function(info, value) E.db.alpha = value end,
				},
			},
		},
	}
}

local microbuttons = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"QuestLogMicroButton",
	"PVPMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"RaidMicroButton",
	"HelpMicroButton",
	"MainMenuMicroButton",
	"AchievementMicroButton"
}

local f = CreateFrame("Frame", "MicroParent", E.UIParent); --Setting a main frame for Menu

--Recreate frame after portals and so on
f:SetScript("OnUpdate", function(self,event,...) 
	UpdateMicroButtonsParent(f)

	--Setting menu properties
	MicroParent:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2) --Default microbar position. Edit this to move it.
	MicroParent:SetWidth(((CharacterMicroButton:GetWidth() + 4) * 9) + 12)
	MicroParent:SetHeight(CharacterMicroButton:GetHeight() - 26)
	--MicroParent:CreateShadow("Default") -- actually that's not needed. Just helped to see real frame border

	--Setting first button properties
	CharacterMicroButton:ClearAllPoints()
	CharacterMicroButton:SetPoint("BOTTOMLEFT", MicroParent, "BOTTOMLEFT", -2,  -2)
	CharacterMicroButton.SetPoint = E.dummy
	CharacterMicroButton.ClearAllPoints = E.dummy
	
	--Mouseover function
	if E.db.mouseover then
		if (MouseIsOver(MicroParent)) then
			MicroParent:SetAlpha(E.db.alpha)
		else	
			MicroParent:SetAlpha(0)
		end
	else
		MicroParent:SetAlpha(E.db.alpha)
	end
	
end)

--Create buttons
function AB:CreateMenu()

	for i, button in pairs(microbuttons) do
		local m = _G[button]
		local pushed = m:GetPushedTexture()
		local normal = m:GetNormalTexture()
		local disabled = m:GetDisabledTexture()
	
		m:SetParent(MicroParent)
		m.SetParent = E.dummy
		_G[button.."Flash"]:SetTexture("")
		m:SetHighlightTexture("")
		m.SetHighlightTexture = E.dummy

		local f = CreateFrame("Frame", nil, m)
		f:SetFrameLevel(2)
		f:SetFrameStrata("BACKGROUND")
		f:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 2, 5)
		f:SetPoint("TOPRIGHT", m, "TOPRIGHT", -2, -28)
		f:SetTemplate("Default", true)
		m.frame = f
	
		pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		pushed:ClearAllPoints()
		pushed:SetPoint("TOPLEFT", m.frame, "TOPLEFT", E.Scale(2), E.Scale(-2))
		pushed:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", E.Scale(-2), E.Scale(2))
	
		normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT", m.frame, "TOPLEFT", E.Scale(2), E.Scale(-2))
		normal:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", E.Scale(-2), E.Scale(2))
	
		if disabled then
			disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
			disabled:ClearAllPoints()
			disabled:SetPoint("TOPLEFT", m.frame, "TOPLEFT", E.Scale(2), E.Scale(-2))
			disabled:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", E.Scale(-2), E.Scale(2))
		end
		
	end
end