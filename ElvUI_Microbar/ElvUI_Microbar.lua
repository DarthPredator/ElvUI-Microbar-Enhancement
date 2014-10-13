-------------------------------------------------
--
-- ElvUI Microbar by Darth Predator and Allaidia
-- Дартпредатор - Свежеватель Душ (Soulflyer) RU
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

local microbarS, CharB, SpellB, TalentB, AchievB, QuestB, GuildB, LFDB, CompB, EJB, MenuB, HelpB
local bw, bh = E.PixelMode and 22 or 20, E.PixelMode and 28 or 26

local Sletters = {
	CharacterB = "C",
	SpellbookB = "S",
	TalentsB = "T",
	AchievementB = "A",
	QuestB = "Q",
	GuildB = "G",
	LFDB = "L",
	CompanionB = "MP",
	JournalB = "J",
	MenuSysB = "M",
	TicketB = ""
}
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
	type = 'toggle',
	name = StoreMicroButton.tooltipText,
	desc = L["Use 10th button for accessing in game shop, if disabled will bring up the support panel.\n|cffFF0000Warning:|r this option requieres to reload the ui to take effect."],
	disabled = function() return not AB.db.microbar.enabled end,
	get = function(info) return AB.db.microbar.shop end,
	set = function(info, value) AB.db.microbar.shop = value; end,
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
	min = -2, max = 20, step = 1,
	get = function(info) return AB.db.microbar.xoffset end,
	set = function(info, value) AB.db.microbar.xoffset = value; AB:UpdateMicroPositionDimensions() end,
}
E.Options.args.actionbar.args.microbar.args.yoffset = {
	order = 11,
	type = "range",
	name = L["Y-Offset"],
	min = -2, max = 20, step = 1,
	get = function(info) return AB.db.microbar.yoffset end,
	set = function(info, value) AB.db.microbar.yoffset = value; AB:UpdateMicroPositionDimensions() end,
}
end

--Set Scale
function AB:MicroScale()
	local height = floor(12/AB.db.microbar.buttonsPerRow)
	ElvUI_MicroBar:SetScale(AB.db.microbar.scale)
	ElvUI_MicroBar.mover:SetWidth(AB.db.microbar.scale * (ElvUI_MicroBar:GetWidth() + AB.db.microbar.xoffset*(AB.db.microbar.buttonsPerRow-1)))-- - (12*2/height)-2))
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

function AB:SbuttonButtonsScripts() --Setting scripts to symbol buttons
	--Character
	do
		CharB:SetScript("OnClick", function(self)
			if CharacterFrame:IsShown() then
				HideUIPanel(CharacterFrame)
			else
				ShowUIPanel(CharacterFrame)
			end
		end)
		
		CharB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(CharB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(CHARACTER_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		CharB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Spellbook
	do
		SpellB:SetScript("OnClick", function(self)
			if SpellBookFrame:IsShown() then
				HideUIPanel(SpellBookFrame)
			else
				ShowUIPanel(SpellBookFrame)
			end
		end)
		
		SpellB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(SpellB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(SPELLBOOK_ABILITIES_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		SpellB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Talents
	do
		TalentB:SetScript("OnClick", function(self)
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
		
		TalentB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(TalentB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(TALENTS_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		TalentB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Achievements
	do
		AchievB:SetScript("OnClick", function(self)
			ToggleAchievementFrame()
		end)
		
		AchievB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(AchievB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(ACHIEVEMENT_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		AchievB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Questlog
	do
		QuestB:SetScript("OnClick", function(self)
			if WorldMapFrame:IsShown() then
				HideUIPanel(WorldMapFrame)
			else
				ShowUIPanel(WorldMapFrame)
			end
		end)
		
		QuestB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(QuestB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(QUESTLOG_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		QuestB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Guild
	do
		GuildB:SetScript("OnClick", function(self)
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
		
		GuildB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(GuildB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(GUILD)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		GuildB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--LFD
	do
		LFDB:SetScript("OnClick", function(self)
			ToggleLFDParentFrame()
		end)
		
		LFDB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(LFDB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(DUNGEONS_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		LFDB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Mounts and pets
	do
		CompB:SetScript("OnClick", function(self)
			TogglePetJournal()
		end)
		
		CompB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(CompB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(MOUNTS_AND_PETS)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		CompB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Journal
	do
		EJB:SetScript("OnClick", function(self)
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
		
		EJB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(EJB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(ENCOUNTER_JOURNAL)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		EJB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Menu
	do
		MenuB:SetScript("OnClick", function(self)
			if GameMenuFrame:IsShown() then
					HideUIPanel(GameMenuFrame)
				else
					ShowUIPanel(GameMenuFrame)
				end
		end)
		
		MenuB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(MenuB, "ANCHOR_RIGHT", 0, 29)
			GameTooltip:SetText(MAINMENU_BUTTON)
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		MenuB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
	
	--Help/Shop
	do
		if E.db.actionbar.microbar.shop then
			HelpB:SetScript("OnClick", function(self)
				ToggleStoreUI()
			end)
		else
			HelpB:SetScript("OnClick", function(self)
				ToggleHelpFrame()
			end)
		end
		
		HelpB:HookScript('OnEnter', function(self)
			GameTooltip:SetOwner(HelpB, "ANCHOR_RIGHT", 0, 29)
			if E.db.actionbar.microbar.shop then
				GameTooltip:SetText(StoreMicroButton.tooltipText)
			else
				GameTooltip:SetText(HELP_BUTTON)
			end
			GameTooltip:Show()
			Letter_OnEnter()
		end)
		
		HelpB:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
			Letter_OnLeave()
		end)
	end
end

function AB:HandleSymbolbuttons(button)
	assert(button, 'Invalid micro button name.')
	button:SetParent(microbarS)
	button:CreateBackdrop()
	button:HookScript('OnEnter', Letter_OnEnter)
	button:HookScript('OnLeave', Letter_OnLeave)
	
	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:SetFont(E["media"].normFont, 10)
	for b, s in pairs (Sletters) do
		if b == button:GetName() then
			button.text:SetText(s)
			break
		end
	end
	button.text:SetPoint("CENTER", button)

	S:HandleButton(button)
end

function AB:SetupSymbolBar()
	microbarS = CreateFrame("Frame", "MicroParentS", E.UIParent)

	CharB = CreateFrame("Button", "CharacterB", microbarS)
	SpellB = CreateFrame("Button", "SpellbookB", microbarS)
	TalentB = CreateFrame("Button", "TalentsB", microbarS)
	AchievB = CreateFrame("Button", "AchievementB", microbarS)
	QuestB = CreateFrame("Button", "QuestB", microbarS)
	GuildB = CreateFrame("Button", "GuildB", microbarS)
	LFDB = CreateFrame("Button", "LFDB", microbarS)
	CompB = CreateFrame("Button", "CompanionB", microbarS)
	EJB = CreateFrame("Button", "JournalB", microbarS)
	MenuB = CreateFrame("Button", "MenuSysB", microbarS)
	HelpB = CreateFrame("Button", "TicketB", microbarS)
	
	Sbuttons = {
		CharB,
		SpellB,
		TalentB,
		AchievB,
		QuestB,
		GuildB,
		LFDB,
		EJB,
		CompB,
		HelpB,
		MenuB
	}
	
	microbarS:SetPoint("CENTER", ElvUI_MicroBar, 0, 0)
	microbarS:SetScript('OnEnter', Letter_OnEnter)
	microbarS:SetScript('OnLeave', Letter_OnLeave)
	for i=1, #Sbuttons do
		self:HandleSymbolbuttons(Sbuttons[i])
	end
	E.FrameLocks['MicroParentS'] = true
	microbarS:SetScript('OnShow', AB.MicroScale)
	ElvUI_MicroBar:SetScript('OnShow', AB.MicroScale)
	AB:UpdateMicroPositionDimensions()
end

local __buttons = {}
if(C_StorePublic.IsEnabled()) then
	__buttons[10] = "StoreMicroButton"
	for i=10, #MICRO_BUTTONS do
		__buttons[i + 1] = MICRO_BUTTONS[i]
	end
end

AB.UpdateMicroPositionDimensionsMB = AB.UpdateMicroPositionDimensions
function AB:UpdateMicroPositionDimensions()
	AB.UpdateMicroPositionDimensionsMB(self)
	if not CharB then return end
	microbarS:SetAlpha(AB.db.microbar.alpha)
	AB:MenuShow()
	local numRows = 1
	local numRowsS = 1
	for i=1, #Sbuttons do
		local button = Sbuttons[i]
		local prevButton = Sbuttons[i-1] or microbarS
		local lastColumnButton = Sbuttons[i-AB.db.microbar.buttonsPerRow];
		
		button:Width(bw)
		button:Height(bh)
		button:ClearAllPoints();

		if prevButton == microbarS then
			button:SetPoint("TOPLEFT", prevButton, "TOPLEFT", E.PixelMode and 1 or 2, E.PixelMode and -1 or -2)
		elseif (i - 1) % AB.db.microbar.buttonsPerRow == 0 then
			button:Point('TOP', lastColumnButton, 'BOTTOM', 0, (E.PixelMode and -3 or -5)- AB.db.microbar.yoffset);	
			numRowsS = numRowsS + 1
		else
			button:Point('LEFT', prevButton, 'RIGHT', (E.PixelMode and 3 or 5) + AB.db.microbar.xoffset, 0);
		end
	end
	
	if AB.db.microbar.xoffset ~= 0 or AB.db.microbar.yoffset ~= 0 then
		local prevButton = ElvUI_MicroBar
		for i=1, (#MICRO_BUTTONS - 1) do
			local button = _G[__buttons[i]] or _G[MICRO_BUTTONS[i]]
			local lastColumnButton = i-self.db.microbar.buttonsPerRow;
			lastColumnButton = _G[__buttons[lastColumnButton]] or _G[MICRO_BUTTONS[lastColumnButton]]

			button:ClearAllPoints();
	
			if prevButton == ElvUI_MicroBar then
				button:SetPoint("TOPLEFT", prevButton, "TOPLEFT", -2, 28)
			elseif (i - 1) % self.db.microbar.buttonsPerRow == 0 then
				button:Point('TOP', lastColumnButton, 'BOTTOM', 0, 27 - AB.db.microbar.yoffset);	
				numRows = numRows + 1
			else
				button:Point('LEFT', prevButton, 'RIGHT', -3 + AB.db.microbar.xoffset, 0);
			end
	
			prevButton = button
		end
	end
	
	microbarS:SetWidth(ElvUI_MicroBar:GetWidth())
	microbarS:SetHeight(ElvUI_MicroBar:GetHeight())
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
	if E.db.actionbar.microbar.shop then
		Sletters.TicketB = "Sh"
	else
		Sletters.TicketB = "?"
	end
	AB.InitializeMB(self)
	EP:RegisterPlugin(addon,AB.GetOptions)
	AB:SetupSymbolBar()
	AB:SbuttonButtonsScripts()
	AB:MicroScale()
	AB:MenuShow()
end