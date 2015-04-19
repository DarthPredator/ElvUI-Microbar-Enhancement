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

P.actionbar.microbar.scale = 1
P.actionbar.microbar.symbolic = false
P.actionbar.microbar.shop = true
P.actionbar.microbar.xoffset = 0
P.actionbar.microbar.yoffset = 0

local bw, bh = E.PixelMode and 22 or 20, E.PixelMode and 28 or 26

local Sbuttons = {}

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
	set = function(info, value) AB.db.microbar.scale = value; AB:MicroScale(); end,
}
E.Options.args.actionbar.args.microbar.args.spacer = {
	order = 6,
	type = "description",
	name = "",
}
E.Options.args.actionbar.args.microbar.args.symbolic = {
	order = 7,
	type = 'toggle',
	name = L["As Letters"],
	desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.symbolic end,
	set = function(info, value) AB.db.microbar.symbolic = value; AB:MenuShow(); end,
}
E.Options.args.actionbar.args.microbar.args.shop = {
	order = 8,
	type = "toggle",
	name = StoreMicroButton.tooltipText,
	desc = L["Show in game shop button, if disabled will show help button instead."],
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.shop end,
	set = function(info, value) AB.db.microbar.shop = value; UpdateMicroButtons() end,
}
E.Options.args.actionbar.args.microbar.args.spacer2 = {
	order = 9,
	type = "description",
	name = "",
}
E.Options.args.actionbar.args.microbar.args.xoffset = {
	order = 10,
	type = "range",
	name = L["X-Offset"],
	min = -20, max = 20, step = 1,
	get = function(info) return AB.db.microbar.xoffset end,
	set = function(info, value) AB.db.microbar.xoffset = value; AB:UpdateMicroPositionDimensions() end,
}
E.Options.args.actionbar.args.microbar.args.yoffset = {
	order = 11,
	type = "range",
	name = L["Y-Offset"],
	min = -20, max = 20, step = 1,
	get = function(info) return AB.db.microbar.yoffset end,
	set = function(info, value) AB.db.microbar.yoffset = value; AB:UpdateMicroPositionDimensions() end,
}
end

--Set Scale
function AB:MicroScale()
	local height = floor(12/AB.db.microbar.buttonsPerRow)
	ElvUI_MicroBar:SetScale(AB.db.microbar.scale)
	ElvUI_MicroBar.mover:SetWidth(AB.db.microbar.scale * (ElvUI_MicroBar:GetWidth() + AB.db.microbar.xoffset*(AB.db.microbar.buttonsPerRow-1)))
	ElvUI_MicroBar.mover:SetHeight(AB.db.microbar.scale * (ElvUI_MicroBar:GetHeight() + AB.db.microbar.yoffset*(height-1)) + 1);
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
	if tooltip then
		button:SetScript("OnEnter", function(self)
			Letter_OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(tooltip, 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self)
			Letter_OnLeave()
			GameTooltip:Hide() 
		end)
	else
		button:HookScript('OnEnter', Letter_OnEnter)
		button:HookScript('OnEnter', Letter_OnLeave)
	end
	S:HandleButton(button)
	
	if text then
		local t = button:CreateFontString(nil,"OVERLAY",button)
		t:FontTemplate()
		t:SetPoint("CENTER", button, 'CENTER', 0, -1)
		t:SetJustifyH("CENTER")
		t:SetText(text)
		button:SetFontString(t)
	end

	tinsert(Sbuttons, button)
end

function AB:SetupSymbolBar()
	microbarS = CreateFrame("Frame", "MicroParentS", E.UIParent)
	microbarS:SetPoint("CENTER", ElvUI_MicroBar, 0, 0)
	microbarS:SetScript('OnEnter', Letter_OnEnter)
	microbarS:SetScript('OnLeave', Letter_OnLeave)

	AB:CreateSymbolButton("EMB_Character", "C", CHARACTER_BUTTON,  function() 
		if CharacterFrame:IsShown() then
			HideUIPanel(CharacterFrame)
		else
			ShowUIPanel(CharacterFrame)
		end
	end)
	AB:CreateSymbolButton("EMB_Spellbook", "S", SPELLBOOK_ABILITIES_BUTTON,  function() 
		if SpellBookFrame:IsShown() then
			HideUIPanel(SpellBookFrame)
		else
			ShowUIPanel(SpellBookFrame)
		end
	end)
	AB:CreateSymbolButton("EMB_Talents", "T", TALENTS_BUTTON,  function()
		if UnitLevel("player") >= 10 then
			if PlayerTalentFrame then
				if PlayerTalentFrame:IsShown() then
					HideUIPanel(PlayerTalentFrame)
				else
					ShowUIPanel(PlayerTalentFrame)
				end
			else
				LoadAddOn("Blizzard_TalentUI")
			
				ShowUIPanel(PlayerTalentFrame)
			end
		end
	end)
	AB:CreateSymbolButton("EMB_Achievement", "A", ACHIEVEMENT_BUTTON,  function() ToggleAchievementFrame() end)
	AB:CreateSymbolButton("EMB_Quest", "Q", QUESTLOG_BUTTON,  function()
		if WorldMapFrame:IsShown() then
			HideUIPanel(WorldMapFrame)
		else
			ShowUIPanel(WorldMapFrame)
		end
	end)
	AB:CreateSymbolButton("EMB_Guild", "G", GUILD,  function()
		if GuildFrame or LookingForGuildFrame then
			if GuildFrame:IsShown() or (LookingForGuildFrame and LookingForGuildFrame:IsShown()) then
					if IsInGuild() then HideUIPanel(GuildFrame) else HideUIPanel(LookingForGuildFrame) end
				else
					if IsInGuild() then ShowUIPanel(GuildFrame) else ShowUIPanel(LookingForGuildFrame) end
			end
		else
			LoadAddOn("Blizzard_GuildUI")
			LoadAddOn("Blizzard_LookingForGuildUI")
			if IsInGuild() then
				ShowUIPanel(GuildFrame)
			else
				ShowUIPanel(LookingForGuildFrame)
			end
		end
	end)
	AB:CreateSymbolButton("EMB_LFD", "L", DUNGEONS_BUTTON,  function() ToggleLFDParentFrame() end)
	AB:CreateSymbolButton("EMB_Journal", "J", ENCOUNTER_JOURNAL,  function()
		if EncounterJournal then
			if EncounterJournal:IsShown() then
				HideUIPanel(EncounterJournal)
			else
				ShowUIPanel(EncounterJournal)
			end
		else
			LoadAddOn("Blizzard_EncounterJournal")
			
			ShowUIPanel(EncounterJournal)
		end
	end)
	AB:CreateSymbolButton("EMB_Companions", "MP", MOUNTS_AND_PETS,  function() ToggleCollectionsJournal() end)
	AB:CreateSymbolButton("EMB_MenuSys", "M", MAINMENU_BUTTON,  function()
		if GameMenuFrame:IsShown() then
				HideUIPanel(GameMenuFrame)
			else
				ShowUIPanel(GameMenuFrame)
			end
	end)
	AB:CreateSymbolButton("EMB_Shop", "Sh", StoreMicroButton.tooltipText,  function() ToggleStoreUI() end)
	AB:CreateSymbolButton("EMB_Help", "?", HELP_BUTTON,  function() ToggleHelpFrame() end)
	
	AB:UpdateMicroPositionDimensions()
end

local __buttons = {}
if(C_StorePublic.IsEnabled()) then
	__buttons[10] = "StoreMicroButton"
	for i=10, #MICRO_BUTTONS do
		__buttons[i + 1] = MICRO_BUTTONS[i]
	end
end
local __Sbuttons = {}
if(C_StorePublic.IsEnabled()) then
	__Sbuttons[11] = EMB_Shop
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
			button:SetPoint("TOPLEFT", prevButton, "TOPLEFT", -2, 28)
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
	local barWidth = (((CharacterMicroButton:GetWidth() - 0.5) * (#MICRO_BUTTONS - 2)) - 3) / numRows
	local barHeight = (CharacterMicroButton:GetHeight() - 27) * numRows
	ElvUI_MicroBar:SetWidth(barWidth)
	ElvUI_MicroBar:Height(barHeight)
	

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
		local button = __Sbuttons[i] or Sbuttons[i]
		
		local lastColumnButton = i-self.db.microbar.buttonsPerRow
		lastColumnButton = __Sbuttons[lastColumnButton] or Sbuttons[lastColumnButton]
		button:Width(bw)
		button:Height(bh)
		button:ClearAllPoints();

		if prevButtonS == microbarS then
			button:SetPoint("TOPLEFT", prevButtonS, "TOPLEFT", E.PixelMode and 1 or 2, E.PixelMode and -1 or -2)
		elseif (i - 1) % AB.db.microbar.buttonsPerRow == 0 then
			button:Point('TOP', lastColumnButton, 'BOTTOM', 0, (E.PixelMode and -3 or -5)- AB.db.microbar.yoffset);	
			numRowsS = numRowsS + 1
		else
			button:Point('LEFT', prevButtonS, 'RIGHT', (E.PixelMode and 3 or 5) + AB.db.microbar.xoffset, 0);
		end
		prevButtonS = button
	end

	microbarS:SetWidth(barWidth)
	microbarS:SetHeight(barHeight)
	
	if AB.db.microbar.mouseover then
		microbarS:SetAlpha(0)
	elseif not AB.db.microbar.mouseover and  AB.db.microbar.symbolic then
		microbarS:SetAlpha(AB.db.microbar.alpha)
	end
	AB:MicroScale()
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

AB.InitializeMB = AB.Initialize
function AB:Initialize()
	AB.InitializeMB(self)
	EP:RegisterPlugin(addon,AB.GetOptions)
	AB:SetupSymbolBar()
	AB:MicroScale()
	AB:MenuShow()
	hooksecurefunc("UpdateMicroButtons", function()
		if E.db.actionbar.microbar.shop then 
			__buttons[10] = "StoreMicroButton"
			for i=10, #MICRO_BUTTONS do
				__buttons[i + 1] = MICRO_BUTTONS[i]
			end
			HelpMicroButton:Hide();
			StoreMicroButton:Show();
			__Sbuttons[11] = EMB_Shop
			EMB_Shop:Show()
			EMB_Help:Hide()
		else
			for i=1, #MICRO_BUTTONS do
				__buttons[i] = MICRO_BUTTONS[i]
			end
			HelpMicroButton:Show();
			StoreMicroButton:Hide();
			__Sbuttons[11] = EMB_Help
			EMB_Shop:Hide()
			EMB_Help:Show()
		end
		AB:UpdateMicroPositionDimensions()
	end)
end