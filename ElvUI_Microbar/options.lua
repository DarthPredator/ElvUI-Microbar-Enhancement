﻿--------------------------------------------------------
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
local E, L, P, G = unpack(ElvUI); --Engine
local MB = E:GetModule('Microbar', 'AceEvent-3.0');

--Defaults
P['microbar'] = {
	['mouse'] = false, --Mouseover
    ['backdrop'] = true, --Backdrop
	['combat'] = false, --Hide in combat
	['alpha'] = 1, --Transparency
	['scale'] = 1, --Scale
	['layout'] = "Micro_Hor", --Button layuot format
}

--Options
E.Options.args.microbar = {
	type = "group",
    name = L["Microbar"],
    get = function(info) return E.db.microbar[ info[#info] ] end,
    set = function(info, value) E.db.microbar[ info[#info] ] = value end, 
	order = 200,
   	args = {
		intro = {
			order = 1,
			type = "description",
			name = L['Module for adding micromenu to ElvUI.'],
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				mouse = {
					order = 1,
					type = "toggle",
					name = L['On Mouse Over'],
					desc = L['Hide microbar unless you mouse over it.'],
					--get = function(info) return E.db.microbar.mouse end,
					set = function(info, value) E.db.microbar.mouse = value; end,
				},
				backdrop = {
					order = 2,
					type = "toggle",
					name = L['Backdrop'],
					desc = L['Show backdrop for micromenu'],
					--get = function(info) return E.db.microbar.backdrop end,
					set = function(info, value) E.db.microbar.backdrop = value; MB:Backdrop(); end,
				},
				combat = {
					order = 3,
					type = "toggle",
					name = L['Hide in Combat'],
					desc = L['Hide Microbar in combat.'],
					--get = function(info) return E.db.microbar.combat end,
					set = function(info, value) E.db.microbar.combat = value; end,
				},
				alpha = {
					order = 4,
					type = "range",
					name = L['Set Alpha'],
					desc = L['Sets alpha of the microbar'],
					min = 0.2, max = 1, step = 0.01,
					--get = function(info) return E.db.microbar.alpha end,
					set = function(info, value) E.db.microbar.alpha = value; end,
				},
				scale = {
					order = 5,
					type = "range",
					name = L['Set Scale'],
					desc = L['Sets Scale of the microbar'],
					isPercent = true,
					min = 0.3, max = 2, step = 0.01,
					--get = function(info) return E.db.microbar.scale end,
					set = function(info, value) E.db.microbar.scale = value; MB:Scale(); end,
				},
				layout = {
					order = 6,
					type = "select",
					name = L["Microbar Layout"],
					desc = L["Change the positioning of buttons on Microbar."],
					--get = function(info) return E.db.microbar.scale end,
					set = function(info, value) E.db.microbar.layout = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); end,
					values = {
						['Micro_Hor'] = L["Horizontal"],
						['Micro_Ver'] = L["Vertical"],
						['Micro_26'] = L["2 in a row"],
						['Micro_34'] = L["3 in a row"],
						['Micro_43'] = L["4 in a row"],
						['Micro_62'] = L["6 in a row"],
					},
				},
			
			}
		}
	}
}