--------------------------------------------------------
-- Thanks to / Благодарности: --
-- Elv and ElvUI community (especially BlackNet)
-- Slipslop for scale option
--
--------------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
--------------------------------------------------------

local E, L, DF, P, G = unpack(ElvUI); --Engine
local AB = E:GetModule('ActionBars', 'AceHook-3.0', 'AceEvent-3.0');

--DEFAULT SETTINGS
DF.alpha = 1 --alpha to 100%
DF.microdrop = true --backdrop showing
DF.scale = 1 --scale to 100%
DF.mouseover = false --mouse over option off
DF.microcombat = false --Show in combat
DF.microinstall = false --Check for first time runing on profile

--OPTIONS
E.Options.args.microbar = {
	type = "group",
	name = L['Microbar'],
	order = 5,
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
				mouseover = { --Enable/disable mouse over function
					order = 1,
					type = "toggle",
					name = L['On Mouse Over'],
					desc = L['Hide microbar unless you mouse over it.'],
					get = function(info) return E.db.mouseover end,
					set = function(info, value) E.db.mouseover = value end,
				},
				microdrop = { --Enable/disable bar bacground and border
					order = 2,
					type = "toggle",
					name = L['Backdrop'],
					desc = L['Show backdrop for micromenu'],
					get = function(info) return E.db.microdrop end,
					set = function(info, value) E.db.microdrop = value end,
				},
				microcombat = { --Enable/disable showing in combat
					order = 3,
					type = "toggle",
					name = L['Hide in Combat'],
					desc = L['Hide Microbar in combat.'],
					get = function(info) return E.db.microcombat end,
					set = function(info, value) E.db.microcombat = value end,
				},
				alpha = { --Set transparency
					type = "range",
					order = 4,
					name = L['Set Alpha'],
					desc = L['Sets alpha of the microbar'],
					type = "range",
					min = 0.2, max = 1, step = 0.01,
					get = function(info) return E.db.alpha end,
					set = function(info, value) E.db.alpha = value end,
				},
				scale = { --Set scale
					type = "range",
					order = 5,
					name = L['Set Scale'],
					desc = L['Sets Scale of the microbar'],
					type = "range",
					min = 0.3, max = 2, step = 0.01,
					isPercent = true,
					get = function(info) return E.db.scale end,
					set = function(info, value) E.db.scale = value end,
				},
				layout = {
					order = 6,
					type = 'select',
					name = L["Microbar Layout"],
					desc = L["Change the positioning of buttons on Microbar."],
					get = function(info) return E.db.general.microlayout end,
					set = function(info, value) E.db.general.microlayout = value end,
					values = {
						['Micro_Hor'] = L["Horizontal"],
						['Micro_Ver'] = L["Vertical"],
						['Micro_26'] = L["2 in a row"],
						['Micro_34'] = L["3 in a row"],
						['Micro_43'] = L["4 in a row"],
						['Micro_62'] = L["6 in a row"],
					},
				},
			},
		},
	}
}