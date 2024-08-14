local E, L, V, P, G, _ =  unpack(ElvUI);
local AB = E:GetModule('ActionBars');
local EP = LibStub("LibElvUIPlugin-1.0")
local S = E:GetModule('Skins')
local addon = ...
local UB

P.actionbar.microbar.Enh = {}
P.actionbar.microbar.Enh.scale = 1
P.actionbar.microbar.Enh.symbolic = false
P.actionbar.microbar.Enh.backdrop = false
P.actionbar.microbar.Enh.colorS = {r = 1,g = 1,b = 1 }
P.actionbar.microbar.Enh.classColor = false
P.actionbar.microbar.Enh.combat = false

-- GLOBALS: MICRO_BUTTONS, PlayerTalentFrame_Toggle, CreateFrame
local _G = _G
local bw, bh = E.PixelMode and 23 or 21, E.PixelMode and 30 or 28
local CLASS = CLASS
local floor, tinsert = floor, tinsert
local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel
local GameTooltip = GameTooltip
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local RED_FONT_COLOR = RED_FONT_COLOR
local CHARACTER_BUTTON, PROFESSIONS_BUTTON, PLAYERSPELLS_BUTTON, ACHIEVEMENT_BUTTON, QUESTLOG_BUTTON, GUILD_AND_COMMUNITIES, DUNGEONS_BUTTON, ADVENTURE_JOURNAL, COLLECTIONS, MAINMENU_BUTTON, HELP_BUTTON = CHARACTER_BUTTON, PROFESSIONS_BUTTON, PLAYERSPELLS_BUTTON, ACHIEVEMENT_BUTTON, QUESTLOG_BUTTON, GUILD_AND_COMMUNITIES, DUNGEONS_BUTTON, ADVENTURE_JOURNAL, COLLECTIONS, MAINMENU_BUTTON, HELP_BUTTON
local UnitLevel = UnitLevel
local ToggleCharacter, ToggleProfessionsBook, ToggleAchievementFrame, ToggleQuestLog, ToggleGuildFrame, ToggleLFDParentFrame, ToggleEncounterJournal, ToggleCollectionsJournal, ToggleStoreUI, ToggleHelpFrame = ToggleCharacter, ToggleProfessionsBook, ToggleAchievementFrame, ToggleQuestLog, ToggleGuildFrame, ToggleLFDParentFrame, ToggleEncounterJournal, ToggleCollectionsJournal, ToggleStoreUI, ToggleHelpFrame
local PERFORMANCEBAR_UPDATE_INTERVAL, PERFORMANCEBAR_MEDIUM_LATENCY, PERFORMANCEBAR_LOW_LATENCY = PERFORMANCEBAR_UPDATE_INTERVAL, PERFORMANCEBAR_MEDIUM_LATENCY, PERFORMANCEBAR_LOW_LATENCY
local GetFileStreamingStatus, GetBackgroundLoadingStatus, GetNetStats = GetFileStreamingStatus, GetBackgroundLoadingStatus, GetNetStats
local MainMenuBarPerformanceBarFrame_OnEnter = MainMenuBarPerformanceBarFrame_OnEnter
local MicroButtonTooltipText = MicroButtonTooltipText
local BLIZZARD_STORE, GAMEMENU_HELP = BLIZZARD_STORE, GAMEMENU_HELP
local C_StorePublic_IsEnabled = C_StorePublic.IsEnabled
local GetValueOrCallFunction = GetValueOrCallFunction

local Sbuttons = {}
local ColorTable
local microbarS
local microBar = _G["ElvUI_MicroBar"]

local function ConvertDB()
	if not AB.db.microbar.Enh then AB.db.microbar.Enh = {} end
	if AB.db.microbar.symbolic then
		AB.db.microbar.Enh.symbolic = AB.db.microbar.symbolic
		AB.db.microbar.symbolic = nil
	end
	if AB.db.microbar.colorS then
		AB.db.microbar.Enh.colorS = AB.db.microbar.colorS
		AB.db.microbar.colorS = nil
	end
	if AB.db.microbar.classColor then
		AB.db.microbar.Enh.classColor = AB.db.microbar.classColor
		AB.db.microbar.classColor = nil
	end
	if AB.db.microbar.combat then
		AB.db.microbar.Enh.combat = AB.db.microbar.combat
		AB.db.microbar.combat = nil
	end
	if AB.db.microbar.scale then
		AB.db.microbar.Enh.scale = AB.db.microbar.scale
		AB.db.microbar.scale = nil
	end
end

--Options
local function GetOptions()
E.Options.args.actionbar.args.microbar.args.MicrobarEnh = {
	type = "group",
	order = 3,
	name = L["Microbar Enhancement"],
	inline = true,
	args = {
		symbolic = {
			order = 1,
			type = 'toggle',
			name = L["As Letters"],
			desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
			disabled = function() return not AB.db.microbar.enabled end,
			get = function(info) return AB.db.microbar.Enh.symbolic end,
			set = function(info, value) AB.db.microbar.Enh.symbolic = value; AB:MenuShow(); end,
		},
		color = {
			order = 2,
			type = 'color',
			name = L["Text Color"],
			disabled = function() return not AB.db.microbar.enabled or not AB.db.microbar.Enh.symbolic or AB.db.microbar.Enh.classColor end,
			get = function(info)
				local t = AB.db.microbar.Enh.colorS
				local d = P.actionbar.microbar.Enh.colorS
				return t.r, t.g, t.b, d.r, d.g, d.b
			end,
			set = function(info, r, g, b)
				local t = AB.db.microbar.Enh.colorS
				t.r, t.g, t.b = r, g, b
				AB:SetSymbloColor()
			end,
		},
		class = {
			order = 3,
			type = "toggle",
			name = CLASS,
			disabled = function() return not AB.db.microbar.enabled or not AB.db.microbar.Enh.symbolic end,
			get = function(info) return AB.db.microbar.Enh.classColor end,
			set = function(info, value) AB.db.microbar.Enh.classColor = value; AB:SetSymbloColor() end,
		},
		combat = {
			order = 4,
			type = "toggle",
			name = L["Hide in combat"],
			disabled = function() return not AB.db.microbar.enabled and not AB.db.microbar.Enh.symbolic end,
			get = function(info) return AB.db.microbar.Enh.combat end,
			set = function(info, value) AB.db.microbar.Enh.combat = value end,
		},
		scale = {
			order = 5,
			type = "range",
			name = L["Set Scale"],
			desc = L["Sets Scale of the Micro Bar"],
			isPercent = true,
			min = 0.3, max = 2, step = 0.01,
			get = function(info) return AB.db.microbar.Enh.scale end,
			set = function(info, value) AB.db.microbar.Enh.scale = value; AB:UpdateMicroButtons() end,
		}
	},
}
E.Options.args.actionbar.args.microbar.args.buttonGroup.args.buttonSpacing.min = -10
end

--Set Scale
function AB:MicroScale()
	local height = floor(12/AB.db.microbar.buttonsPerRow)
	if _G["ElvUI_MicroBar"].mover then
		_G["ElvUI_MicroBar"].mover:SetWidth(_G["ElvUI_MicroBar"]:GetWidth()*AB.db.microbar.Enh.scale)
		_G["ElvUI_MicroBar"].mover:SetHeight(_G["ElvUI_MicroBar"]:GetHeight()*AB.db.microbar.Enh.scale);
	end
	_G["ElvUI_MicroBar"]:SetScale(AB.db.microbar.Enh.scale)
	microbarS:SetScale(AB.db.microbar.Enh.scale)
end

local function Letter_OnEnter()
	if AB.db.microbar.mouseover then
		E:UIFrameFadeIn(microbarS, 0.2, microbarS:GetAlpha(), AB.db.microbar.alpha)
	end
end

local function Letter_OnLeave()
	if AB.db.microbar.mouseover then
		E:UIFrameFadeOut(microbarS, 0.2, microbarS:GetAlpha(), 0)
	end
end

local function Symbol_UpdateAll(self)
	if not AB.db.microbar.Enh or not AB.db.microbar.Enh.symbolic then ConvertDB() end
	AB:MicroScale()
	AB:MenuShow()
end

local function ClickTalentsSymbolButton()
	if _G.PlayerSpellsMicroButton.jumpToSpellID and (not _G.PlayerSpellsMicroButton.suggestedTab or _G.PlayerSpellsMicroButton.suggestedTab == _G.PlayerSpellsUtil.FrameTabs.SpellBook) then
		local knownSpellsOnly, toggleFlyout, flyoutReason = true, false, nil;
		_G.PlayerSpellsUtil.OpenToSpellBookTabAtSpell(_G.PlayerSpellsMicroButton.jumpToSpellID, knownSpellsOnly, toggleFlyout, flyoutReason)
		_G.PlayerSpellsMicroButton.jumpToSpellID = nil;
	else
		_G.PlayerSpellsUtil.TogglePlayerSpellsFrame(_G.PlayerSpellsMicroButton.suggestedTab);
	end
end

local function ClickMenuSymbolButton()
	if _G["GameMenuFrame"]:IsShown() then
		HideUIPanel(_G["GameMenuFrame"])
	else
		ShowUIPanel(_G["GameMenuFrame"])
	end
end


function AB:CreateSymbolButton(name, text, tooltip, click, parent)
	local button = CreateFrame("Button", name, microbarS)
	if click then button:SetScript("OnClick", click) end
	button.tooltip = tooltip
	button.updateInterval = 0
	if tooltip then
		button:SetScript("OnEnter", function(self)
			Letter_OnEnter()
			button.hover = 1
			button.updateInterval = 0
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(button.tooltip, 1, 1, 1, 1, 1, 1)
			if parent and parent.disabledTooltip then
				local disabledTooltipText = GetValueOrCallFunction(parent, "disabledTooltip");
				GameTooltip:AddLine(disabledTooltipText, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
			end
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self)
			Letter_OnLeave()
			button.hover = nil
			GameTooltip:Hide()
		end)
	else
		button:HookScript('OnEnter', Letter_OnEnter)
		button:HookScript('OnEnter', Letter_OnLeave)
	end
	S:HandleButton(button)

	if text then
		button.text = button:CreateFontString(nil,"OVERLAY")
		button.text:FontTemplate()
		button.text:SetPoint("CENTER", button, 'CENTER', 0, -1)
		button.text:SetJustifyH("CENTER")
		button.text:SetText(text)
		button:SetFontString(button.text)
	end

	tinsert(Sbuttons, button)
end

local function GetColor()
	local color = AB.db.microbar.colorS
	return color.r*255, color.g*255, color.b*255
end

function AB:SetSymbloColor()
	local color = AB.db.microbar.Enh.classColor and ColorTable or AB.db.microbar.Enh.colorS
	for i = 1, #Sbuttons do
		Sbuttons[i].text:SetTextColor(color.r, color.g, color.b)
	end
end

function AB:SetupSymbolBar()
	microbarS = CreateFrame("Frame", "MicroParentS", E.UIParent)
	microbarS:SetPoint("CENTER", _G["ElvUI_MicroBar"], 0, 0)
	microbarS:SetScript('OnEnter', Letter_OnEnter)
	microbarS:SetScript('OnLeave', Letter_OnLeave)
	microbarS:CreateBackdrop("Transparent")

	AB:CreateSymbolButton("EMB_Character", "C", MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0"),  function() ToggleCharacter("PaperDollFrame") end, _G.CharacterMicroButton)
	AB:CreateSymbolButton("EMB_Profs", "S", MicroButtonTooltipText(PROFESSIONS_BUTTON, "TOGGLESPELLBOOK"), function() ToggleProfessionsBook() end, _G.ProfessionMicroButton)
	AB:CreateSymbolButton("EMB_Talents", "T", MicroButtonTooltipText(PLAYERSPELLS_BUTTON, "TOGGLETALENTS"), function() ClickTalentsSymbolButton() end, _G.PlayerSpellsMicroButton)
	AB:CreateSymbolButton("EMB_Achievement", "A", MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT"), function() ToggleAchievementFrame() end, _G.AchievementMicroButton)
	AB:CreateSymbolButton("EMB_Quest", "Q", MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG"), function() ToggleQuestLog() end, _G.QuestLogMicroButton)
	AB:CreateSymbolButton("EMB_Guild", "G", MicroButtonTooltipText(GUILD_AND_COMMUNITIES, "TOGGLEGUILDTAB"), function() ToggleGuildFrame() end, _G.QuestLogMicroButton)
	AB:CreateSymbolButton("EMB_LFD", "L", MicroButtonTooltipText(DUNGEONS_BUTTON, "TOGGLEGROUPFINDER"),  function() ToggleLFDParentFrame() end, _G.LFDMicroButton)
	AB:CreateSymbolButton("EMB_Journal", "J", MicroButtonTooltipText(ADVENTURE_JOURNAL, "TOGGLEENCOUNTERJOURNAL"), function() ToggleEncounterJournal() end, _G.EJMicroButton)
	AB:CreateSymbolButton("EMB_Collections", "Col", MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS"), function() ToggleCollectionsJournal() end, _G.CollectionMicroButton)
	AB:CreateSymbolButton("EMB_MenuSys", "M", "", function() ClickMenuSymbolButton() end, _G.MainMenuMicroButton)
	
	if not C_StorePublic_IsEnabled() and GetCurrentRegionName() == "CN" then
		AB:CreateSymbolButton("EMB_Help", "?", HELP_BUTTON, function() ToggleHelpFrame() end)
	else
		AB:CreateSymbolButton("EMB_Shop", "Sh", BLIZZARD_STORE, function() ToggleStoreUI() end, _G.StoreMicroButton)
	end

	AB:UpdateMicroButtons()
end

local __buttonIndex = {
	[8] = "CollectionsMicroButton",
	[9] = "EJMicroButton",
	[10] = (not C_StorePublic_IsEnabled() and GetCurrentRegionName() == "CN") and "HelpMicroButton" or "StoreMicroButton",
	[11] = "MainMenuMicroButton"
}

local function Symbol_UpdateMicroButtons(self)
	if not microBar then return; end
	local db = AB.db.microbar

	if not microbarS then return end
	microbarS.db = db

	if self.db.microbar.enabled then
		_G["ElvUI_MicroBar"]:Show()
	else
		_G["ElvUI_MicroBar"]:Hide()
	end

	if not Sbuttons[1] then return end
	AB:MenuShow()
	local numRowsS = 1
	local lastButtonS, anchorRowButtonS = microbarS
	for i=1, (#Sbuttons) do
		local button = Sbuttons[i]
		local lastColumnButton = i - db.buttonsPerRow
		lastColumnButton = Sbuttons[lastColumnButton]
		button.db = db

		if i == 1 or i == db.buttonsPerRow then
			anchorRowButtonS = button
		end

		button.handleBackdrop = true -- keep over HandleButton
		AB:HandleButton(microbarS, button, i, lastButtonS, lastColumnButton)

		lastButtonS = button
	end

	microbarS:Width(_G["ElvUI_MicroBar"]:GetWidth())
	microbarS:Height(_G["ElvUI_MicroBar"]:GetHeight())

	if AB.db.microbar.backdrop then
		_G["ElvUI_MicroBar"].backdrop:Show()
		microbarS.backdrop:Show()
	else
		_G["ElvUI_MicroBar"].backdrop:Hide()
		microbarS.backdrop:Hide()
	end

	if AB.db.microbar.mouseover then
		microbarS:SetAlpha(0)
	elseif not AB.db.microbar.mouseover and  AB.db.microbar.Enh.symbolic then
		microbarS:SetAlpha(AB.db.microbar.alpha)
	end

	AB:MicroScale()
	AB:SetSymbloColor()
end

function AB:MenuShow()
	if AB.db.microbar.Enh.symbolic then
		if AB.db.microbar.enabled then
			_G["ElvUI_MicroBar"]:Hide()
			microbarS:Show()
			if not AB.db.microbar.mouseover then
				E:UIFrameFadeIn(microbarS, 0.2, microbarS:GetAlpha(), AB.db.microbar.alpha)
			end
		else
			microbarS:Hide()
		end
	else
		if AB.db.microbar.enabled then
			_G["ElvUI_MicroBar"]:Show()
		end
		microbarS:Hide()
	end
end

function AB:EnterCombat()
	if AB.db.microbar.Enh.combat then
		_G["ElvUI_MicroBar"]:Hide()
		microbarS:Hide()
	else
		if AB.db.microbar.enabled then
			if AB.db.microbar.Enh.symbolic then
				microbarS:Show()
			else
				_G["ElvUI_MicroBar"]:Show()
			end
		end
	end
end

function AB:LeaveCombat()
	if AB.db.microbar.enabled then
		if AB.db.microbar.Enh.symbolic then
			microbarS:Show()
		else
			_G["ElvUI_MicroBar"]:Show()
		end
	end
end

function Symbol_ReassignBindings(self, event)
	if event ~= "UPDATE_BINDINGS" then return end
	_G["EMB_Character"].tooltip = MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0")
	_G["EMB_Profs"].tooltip = MicroButtonTooltipText(PROFESSIONS_BUTTON, "TOGGLESPELLBOOK")
	_G["EMB_Talents"].tooltip = MicroButtonTooltipText(PLAYERSPELLS_BUTTON, "TOGGLETALENTS")
	_G["EMB_Achievement"].tooltip = MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT")
	_G["EMB_Quest"].tooltip = MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG")
	_G["EMB_Guild"].tooltip = MicroButtonTooltipText(GUILD_AND_COMMUNITIES, "TOGGLEGUILDTAB")
	_G["EMB_LFD"].tooltip = MicroButtonTooltipText(DUNGEONS_BUTTON, "TOGGLEGROUPFINDER")
	_G["EMB_Journal"].tooltip = MicroButtonTooltipText(ADVENTURE_JOURNAL, "TOGGLEENCOUNTERJOURNAL");
	_G["EMB_Collections"].tooltip = MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS")
end

function AB:EnhancementInit()
	ConvertDB()
	ColorTable = E.myclass == 'PRIEST' and E.PriestColors or RAID_CLASS_COLORS[E.myclass]
	EP:RegisterPlugin(addon, GetOptions)
	AB:SetupSymbolBar()
	AB:MicroScale()
	AB:MenuShow()
	
	hooksecurefunc(E, 'UpdateAll', Symbol_UpdateAll)
	hooksecurefunc(AB, "UpdateMicroButtons", Symbol_UpdateMicroButtons)
	hooksecurefunc(AB, "ReassignBindings", Symbol_ReassignBindings)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "LeaveCombat")
	
	_G.UIParent:HookScript("OnShow", function(self) AB:MenuShow() end) --This is actually stupid, but works for now

	_G["EMB_MenuSys"]:SetScript("OnUpdate", function(self, elapsed)
		if (self.updateInterval and self.updateInterval > 0) then
			self.updateInterval = self.updateInterval - elapsed;
		else
			self.updateInterval = PERFORMANCEBAR_UPDATE_INTERVAL;
			if (self.hover) then
				MainMenuBarPerformanceBarFrame_OnEnter(_G["MainMenuMicroButton"]);
			end
		end
	end)
end

hooksecurefunc(AB, "Initialize", AB.EnhancementInit)