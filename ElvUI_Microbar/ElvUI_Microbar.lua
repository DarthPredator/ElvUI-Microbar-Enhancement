-------------------------------------------------
--
-- ElvUI Microbar Enhancement by Darth Predator
-- Дартпредатор - Вечная Песня (Eversong) RU
--
-------------------------------------------------
--
-- Thanks to / Благодарности:
-- Elv and ElvUI community
-- Blazeflack for helping with option storage and profile changing
--
-------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
-------------------------------------------------

local E, L, V, P, G, _ =  unpack(ElvUI);
local AB = E:GetModule('ActionBars');
local EP = LibStub("LibElvUIPlugin-1.0")
local S = E:GetModule('Skins')
local addon = ...
local UB

P.actionbar.microbar.scale = 1
P.actionbar.microbar.symbolic = false
P.actionbar.microbar.shop = true
P.actionbar.microbar.xoffset = 0
P.actionbar.microbar.yoffset = 0
P.actionbar.microbar.backdrop = false
P.actionbar.microbar.colorS = {r = 1,g = 1,b = 1 }
P.actionbar.microbar.classColor = false

-- GLOBALS: MICRO_BUTTONS, ElvUI_MicroBar, PlayerTalentFrame_Toggle
local _G = _G
local bw, bh = E.PixelMode and 23 or 21, E.PixelMode and 30 or 28
local CLASS = CLASS
local floor, tinsert = floor, tinsert
local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel
local GameTooltip = GameTooltip
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local CHARACTER_BUTTON, SPELLBOOK_ABILITIES_BUTTON, TALENTS_BUTTON, ACHIEVEMENT_BUTTON, QUESTLOG_BUTTON, GUILD, DUNGEONS_BUTTON, ENCOUNTER_JOURNAL, COLLECTIONS, MAINMENU_BUTTON, HELP_BUTTON = CHARACTER_BUTTON, SPELLBOOK_ABILITIES_BUTTON, TALENTS_BUTTON, ACHIEVEMENT_BUTTON, QUESTLOG_BUTTON, GUILD, DUNGEONS_BUTTON, ENCOUNTER_JOURNAL, COLLECTIONS, MAINMENU_BUTTON, HELP_BUTTON
local UnitLevel = UnitLevel
local ToggleCharacter, ToggleSpellBook, ToggleAchievementFrame, ToggleQuestLog, ToggleGuildFrame, ToggleLFDParentFrame, ToggleEncounterJournal, ToggleCollectionsJournal, ToggleStoreUI, ToggleHelpFrame = ToggleCharacter, ToggleSpellBook, ToggleAchievementFrame, ToggleQuestLog, ToggleGuildFrame, ToggleLFDParentFrame, ToggleEncounterJournal, ToggleCollectionsJournal, ToggleStoreUI, ToggleHelpFrame
local LoadAddOn = LoadAddOn
local PERFORMANCEBAR_UPDATE_INTERVAL, PERFORMANCEBAR_MEDIUM_LATENCY, PERFORMANCEBAR_LOW_LATENCY = PERFORMANCEBAR_UPDATE_INTERVAL, PERFORMANCEBAR_MEDIUM_LATENCY, PERFORMANCEBAR_LOW_LATENCY
local GetFileStreamingStatus, GetBackgroundLoadingStatus, GetNetStats = GetFileStreamingStatus, GetBackgroundLoadingStatus, GetNetStats
local MainMenuBarPerformanceBarFrame_OnEnter = MainMenuBarPerformanceBarFrame_OnEnter
local MicroButtonTooltipText = MicroButtonTooltipText
local BLIZZARD_STORE = BLIZZARD_STORE

local Sbuttons = {}
local ColorTable
local microbarS
local __buttons = {}
if(C_StorePublic.IsEnabled()) then
	__buttons[10] = "StoreMicroButton"
	for j = 1, 9 do
		__buttons[j] = MICRO_BUTTONS[j]
	end
	for i=10, #MICRO_BUTTONS do
		__buttons[i + 1] = MICRO_BUTTONS[i]
	end
end

--Options
function AB:GetOptions()
E.Options.args.actionbar.args.microbar.args.scale = {
	order = 5,
	type = "range",
	name = L["Set Scale"],
	desc = L["Sets Scale of the Micro Bar"],
	isPercent = true,
	min = 0.3, max = 2, step = 0.01,
	get = function(info) return AB.db.microbar.scale end,
	set = function(info, value) AB.db.microbar.scale = value; AB:UpdateMicroPositionDimensions() end,
}
E.Options.args.actionbar.args.microbar.args.spacer = {
	order = 6,
	type = "description",
	name = "",
}
E.Options.args.actionbar.args.microbar.args.backdrop = {
	order = 7,
	type = 'toggle',
	name = L["Backdrop"],
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.backdrop end,
	set = function(info, value) AB.db.microbar.backdrop = value; AB:UpdateMicroPositionDimensions() end,
}
E.Options.args.actionbar.args.microbar.args.symbolic = {
	order = 8,
	type = 'toggle',
	name = L["As Letters"],
	desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.symbolic end,
	set = function(info, value) AB.db.microbar.symbolic = value; AB:MenuShow(); end,
}
E.Options.args.actionbar.args.microbar.args.shop = {
	order = 9,
	type = "toggle",
	name = BLIZZARD_STORE,
	desc = L["Show in game shop button, if disabled will show help button instead."],
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.shop end,
	set = function(info, value) AB.db.microbar.shop = value; AB:UpdateMicroButtons() end,
}
E.Options.args.actionbar.args.microbar.args.spacer2 = {
	order = 10,
	type = "description",
	name = "",
}
E.Options.args.actionbar.args.microbar.args.xoffset = {
	order = 11,
	type = "range",
	name = L["X-Offset"],
	min = -20, max = 20, step = 1,
	get = function(info) return AB.db.microbar.xoffset end,
	set = function(info, value) AB.db.microbar.xoffset = value; AB:UpdateMicroPositionDimensions() end,
}
E.Options.args.actionbar.args.microbar.args.yoffset = {
	order = 12,
	type = "range",
	name = L["Y-Offset"],
	min = -20, max = 20, step = 1,
	get = function(info) return AB.db.microbar.yoffset end,
	set = function(info, value) AB.db.microbar.yoffset = value; AB:UpdateMicroPositionDimensions() end,
}
E.Options.args.actionbar.args.microbar.args.spacer3 = {
	order = 13,
	type = "description",
	name = "",
}
E.Options.args.actionbar.args.microbar.args.color = {
	order = 14,
	type = 'color',
	name = L["Text Color"],
	get = function(info)
		local t = AB.db.microbar.colorS
		local d = P.actionbar.microbar.colorS
		return t.r, t.g, t.b, d.r, d.g, d.b
	end,
	set = function(info, r, g, b)
		E.db.sle.minimap.instance.colorS = {}
		local t = AB.db.microbar.colorS
		t.r, t.g, t.b = r, g, b
		AB:SetSymbloColor()
	end,
	disabled = function() return not AB.db.microbar.enabled or AB.db.microbar.classColor end,
}
E.Options.args.actionbar.args.microbar.args.class = {
	order = 15,
	type = "toggle",
	name = CLASS,
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.classColor end,
	set = function(info, value) AB.db.microbar.classColor = value; AB:SetSymbloColor() end,
}
end

--Set Scale
function AB:MicroScale()
	local height = floor(12/AB.db.microbar.buttonsPerRow)
	ElvUI_MicroBar.mover:SetWidth(AB.MicroWidth*AB.db.microbar.scale)
	ElvUI_MicroBar.mover:SetHeight(AB.MicroHeight*AB.db.microbar.scale);
	ElvUI_MicroBar:SetScale(AB.db.microbar.scale)
	microbarS:SetScale(AB.db.microbar.scale)
end

E.UpdateAllMB = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllMB(self)
	AB:MicroScale()
	AB:MenuShow()
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

function AB:CreateSymbolButton(name, text, tooltip, click)
	local button = CreateFrame("Button", name, microbarS)
	button:SetScript("OnClick", click)
	button.tooltip = tooltip
	button.updateInterval = 0
	if tooltip then
		button:SetScript("OnEnter", function(self)
			Letter_OnEnter()
			button.hover = 1
			button.updateInterval = 0
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(button.tooltip, 1, 1, 1, 1, 1, 1)
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
		button.text = button:CreateFontString(nil,"OVERLAY",button)
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
	local color = AB.db.microbar.classColor and ColorTable or AB.db.microbar.colorS
	for i = 1, #Sbuttons do
		Sbuttons[i].text:SetTextColor(color.r, color.g, color.b)
	end
end

function AB:SetupSymbolBar()
	microbarS = CreateFrame("Frame", "MicroParentS", E.UIParent)
	microbarS:SetPoint("CENTER", ElvUI_MicroBar, 0, 0)
	microbarS:SetScript('OnEnter', Letter_OnEnter)
	microbarS:SetScript('OnLeave', Letter_OnLeave)

	AB:CreateSymbolButton("EMB_Character", "C", MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0"),  function() ToggleCharacter("PaperDollFrame") end)
	AB:CreateSymbolButton("EMB_Spellbook", "S", MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK"),  function() ToggleSpellBook("spell") end)
	AB:CreateSymbolButton("EMB_Talents", "T", MicroButtonTooltipText(TALENTS_BUTTON, "TOGGLETALENTS"),  function()
		if UnitLevel("player") >= 10 then
			if not _G["PlayerTalentFrame"] then LoadAddOn("Blizzard_TalentUI") end
			PlayerTalentFrame_Toggle()
		end
	end)
	AB:CreateSymbolButton("EMB_Achievement", "A", MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT"),  function() ToggleAchievementFrame() end)
	AB:CreateSymbolButton("EMB_Quest", "Q", MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG"),  function() ToggleQuestLog() end)
	AB:CreateSymbolButton("EMB_Guild", "G", MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB"),  function() ToggleGuildFrame() end)
	AB:CreateSymbolButton("EMB_LFD", "L", MicroButtonTooltipText(DUNGEONS_BUTTON, "TOGGLEGROUPFINDER"),  function() ToggleLFDParentFrame() end)
	AB:CreateSymbolButton("EMB_Journal", "J", MicroButtonTooltipText(ENCOUNTER_JOURNAL, "TOGGLEENCOUNTERJOURNAL"),  function() ToggleEncounterJournal() end)
	AB:CreateSymbolButton("EMB_Collections", "Col", MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS"),  function() ToggleCollectionsJournal() end)
	AB:CreateSymbolButton("EMB_Shop", "Sh", BLIZZARD_STORE,  function() ToggleStoreUI() end)
	AB:CreateSymbolButton("EMB_MenuSys", "M", "",  function()
		if _G["GameMenuFrame"]:IsShown() then
				HideUIPanel(_G["GameMenuFrame"])
			else
				ShowUIPanel(_G["GameMenuFrame"])
			end
	end)
	AB:CreateSymbolButton("EMB_Help", "?", HELP_BUTTON,  function() ToggleHelpFrame() end)
	
	AB:UpdateMicroPositionDimensions()
end

function AB:UpdateMicroPositionDimensions()
	if not ElvUI_MicroBar then return; end
	local numRows = 1
	local prevButton = ElvUI_MicroBar
	for i=1, (#MICRO_BUTTONS - 1) do
		local button = _G[__buttons[i]] or _G[MICRO_BUTTONS[i]]
		local lastColumnButton = i-self.db.microbar.buttonsPerRow;
		lastColumnButton = _G[__buttons[lastColumnButton]] or _G[MICRO_BUTTONS[lastColumnButton]]
		button:Width(28)
		button:Height(58)
		button:ClearAllPoints();

		if prevButton == ElvUI_MicroBar then
			button:SetPoint("TOPLEFT", prevButton, "TOPLEFT", -1, 27)
		elseif (i - 1) % self.db.microbar.buttonsPerRow == 0 then
			button:Point('TOP', lastColumnButton, 'BOTTOM', 0, 27 - self.db.microbar.yoffset);	
			numRows = numRows + 1
		else
			button:Point('LEFT', prevButton, 'RIGHT', -3 + self.db.microbar.xoffset, 0);
		end

		prevButton = button
	end

	if AB.db.microbar.mouseover then
		ElvUI_MicroBar:SetAlpha(0)
	else
		ElvUI_MicroBar:SetAlpha(self.db.microbar.alpha)
	end	
	AB.MicroWidth = ((_G["CharacterMicroButton"]:GetWidth() - 3) * self.db.microbar.buttonsPerRow)+(self.db.microbar.xoffset*(self.db.microbar.buttonsPerRow-1))+1
	AB.MicroHeight = ((_G["CharacterMicroButton"]:GetHeight() - 26) * numRows)+((numRows-1)*self.db.microbar.yoffset)-(numRows-1)
	ElvUI_MicroBar:Width(AB.MicroWidth)
	ElvUI_MicroBar:Height(AB.MicroHeight)
	
	if not ElvUI_MicroBar.backdrop then
		ElvUI_MicroBar:CreateBackdrop("Transparent")
	end

	if self.db.microbar.enabled then
		ElvUI_MicroBar:Show()
	else
		ElvUI_MicroBar:Hide()
	end

	if not Sbuttons[1] then return end
	AB:MenuShow()
	local numRowsS = 1
	local prevButtonS = microbarS
	for i=1, (#Sbuttons - 1) do
		local button = Sbuttons[i]
		
		local lastColumnButton = i-self.db.microbar.buttonsPerRow
		lastColumnButton = Sbuttons[lastColumnButton]
		button:Width(bw)
		button:Height(bh)
		button:ClearAllPoints();

		if prevButtonS == microbarS then
			button:SetPoint("TOPLEFT", prevButtonS, "TOPLEFT", 1, -1)
		elseif (i - 1) % AB.db.microbar.buttonsPerRow == 0 then
			button:Point('TOP', lastColumnButton, 'BOTTOM', 0, (E.PixelMode and -1 or -3)- AB.db.microbar.yoffset);	
			numRowsS = numRowsS + 1
		else
			button:Point('LEFT', prevButtonS, 'RIGHT', (E.PixelMode and 2 or 4) + AB.db.microbar.xoffset, 0);
		end
		prevButtonS = button
	end

	microbarS:Width(AB.MicroWidth)
	microbarS:Height(AB.MicroHeight)
	
	if not microbarS.backdrop then
		microbarS:CreateBackdrop("Transparent")
	end
	
	if AB.db.microbar.backdrop then
		ElvUI_MicroBar.backdrop:Show()
		microbarS.backdrop:Show()
	else
		ElvUI_MicroBar.backdrop:Hide()
		microbarS.backdrop:Hide()
	end
	
	if AB.db.microbar.mouseover then
		microbarS:SetAlpha(0)
	elseif not AB.db.microbar.mouseover and  AB.db.microbar.symbolic then
		microbarS:SetAlpha(AB.db.microbar.alpha)
	end
	
	AB:MicroScale()
	AB:SetSymbloColor()
end

function AB:MenuShow()
	if AB.db.microbar.symbolic then
		if AB.db.microbar.enabled then
			ElvUI_MicroBar:Hide()
			microbarS:Show()
			if not AB.db.microbar.mouseover then
				E:UIFrameFadeIn(microbarS, 0.2, microbarS:GetAlpha(), AB.db.microbar.alpha)
			end
		else
			microbarS:Hide()
		end
	else
		if AB.db.microbar.enabled then
			ElvUI_MicroBar:Show()
		end
		microbarS:Hide()
	end
end

-- function AB:CreateUIButton()
	-- UB:CreateDropdownButton(true, "Addon", "Microbar", L["Micro Bar"], L["Micro Bar"], nil, function() E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "actionbar", "microbar") end)
-- end

function AB:UpdateMicroButtons()
	_G["GuildMicroButtonTabard"]:ClearAllPoints()
	_G["GuildMicroButtonTabard"]:SetPoint("TOP", _G["GuildMicroButton"].backdrop, "TOP", 0, 25)
	if E.db.actionbar.microbar.shop then 
		__buttons[10] = "StoreMicroButton"
		for i=10, #MICRO_BUTTONS do
			__buttons[i + 1] = MICRO_BUTTONS[i]
		end
		_G["HelpMicroButton"]:Hide();
		_G["StoreMicroButton"]:Show();
		Sbuttons[10] = _G["EMB_Shop"]
		Sbuttons[11] = _G["EMB_MenuSys"]
		_G["EMB_Shop"]:Show()
		_G["EMB_Help"]:Hide()
	else
		for i=1, #MICRO_BUTTONS do
			__buttons[i] = MICRO_BUTTONS[i]
		end
		_G["HelpMicroButton"]:Show();
		_G["StoreMicroButton"]:Hide();
		Sbuttons[10] = _G["EMB_MenuSys"]
		Sbuttons[11] = _G["EMB_Help"]
		_G["EMB_Shop"]:Hide()
		_G["EMB_Help"]:Show()
	end
	self:UpdateMicroPositionDimensions()
end

local NewReassignBindings = AB.ReassignBindings
function AB:ReassignBindings(event)
	NewReassignBindings(self, event)
	if event ~= "UPDATE_BINDINGS" then return end
	_G["EMB_Character"].tooltip = MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0")
	_G["EMB_Spellbook"].tooltip = MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK")
	_G["EMB_Talents"].tooltip = MicroButtonTooltipText(TALENTS_BUTTON, "TOGGLETALENTS")
	_G["EMB_Achievement"].tooltip = MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT")
	_G["EMB_Quest"].tooltip = MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG")
	_G["EMB_Guild"].tooltip = MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB")
	_G["EMB_LFD"].tooltip = MicroButtonTooltipText(DUNGEONS_BUTTON, "TOGGLEGROUPFINDER")
	_G["EMB_Journal"].tooltip = MicroButtonTooltipText(ENCOUNTER_JOURNAL, "TOGGLEENCOUNTERJOURNAL");
	_G["EMB_Collections"].tooltip = MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS")
end

function AB:EnhancementInit()
	ColorTable = E.myclass == 'PRIEST' and E.PriestColors or RAID_CLASS_COLORS[E.myclass]
	EP:RegisterPlugin(addon,AB.GetOptions)
	AB:SetupSymbolBar()
	AB:MicroScale()
	AB:MenuShow()

	-- if not IsAddOnLoaded("ElvUI_SLE") then return end
	-- UB = E:GetModule('SLE_UIButtons');
	-- hooksecurefunc(UB, "InsertButtons", AB.CreateUIButton)

	_G["MainMenuMicroButton"]:SetScript("OnUpdate", function(self, elapsed)
		if (self.updateInterval > 0) then
			self.updateInterval = self.updateInterval - elapsed;
		else
			self.updateInterval = PERFORMANCEBAR_UPDATE_INTERVAL;
			local status = GetFileStreamingStatus();
			if(status==0) then
				status = (GetBackgroundLoadingStatus()~=0) and 1 or 0;
			end
			if(status == 0) then
				_G["MainMenuBarDownload"]:Hide();
				self:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-World-Up");
				self:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-World-Down");
				self:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-World-Disabled");
			else
				self:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Up");
				self:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Down");
				self:SetDisabledTexture("Interface\\Buttons\\UI-MicroButtonStreamDL-Up");
				if (status == 1) then
					_G["MainMenuBarDownload"]:SetTexture("Interface\\BUTTONS\\UI-MicroStream-Green");
				elseif (status == 2) then
					_G["MainMenuBarDownload"]:SetTexture("Interface\\BUTTONS\\UI-MicroStream-Yellow");
				elseif (status == 3) then
					_G["MainMenuBarDownload"]:SetTexture("Interface\\BUTTONS\\UI-MicroStream-Red");
				end
				_G["MainMenuBarDownload"]:Show();
			end
			local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats();
			local latency = latencyHome > latencyWorld and latencyHome or latencyWorld;
			if (latency > PERFORMANCEBAR_MEDIUM_LATENCY) then
				_G["MainMenuBarPerformanceBar"]:SetVertexColor(1, 0, 0);
			elseif (latency > PERFORMANCEBAR_LOW_LATENCY) then
				_G["MainMenuBarPerformanceBar"]:SetVertexColor(1, 1, 0);
			else
				_G["MainMenuBarPerformanceBar"]:SetVertexColor(0, 1, 0);
			end
			if (self.hover) then
				MainMenuBarPerformanceBarFrame_OnEnter(self);
			end
		end
	end)
	
	_G["EMB_MenuSys"]:SetScript("OnUpdate", function(self, elapsed)
		if (self.updateInterval > 0) then
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