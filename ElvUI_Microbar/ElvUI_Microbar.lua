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
local addon = ...

P.actionbar.microbar.scale = 1
P.actionbar.microbar.symbolic = false

local microbarS, CharB, SpellB, TalentB, AchievB, QuestB, GuildB, PVPB, LFDB, CompB, EJB, MenuB, HelpB
local bw, bh = E.PixelMode and 22 or 20, E.PixelMode and 28 or 26

local Sletters = {
	CharacterB = "C",
	SpellbookB = "S",
	TalentsB = "T",
	AchievementB = "A",
	QuestB = "Q",
	GuildB = "G",
	PVPB = "P",
	LFDB = "L",
	CompanionB = "MP",
	JournalB = "J",
	MenuSysB = "M",
	TicketB = "?"
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
	set = function(info, value) AB.db.microbar.scale = value; AB:MicroScale(); end,
}
E.Options.args.actionbar.args.microbar.args.symbolic = {
	order = 6,
	type = 'toggle',
	name = L["As Letters"],
	desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
	disabled = function() return not AB.db.microbar.enabled end,
	set = function(info, value) AB.db.microbar.symbolic = value; AB:MenuShow(); end,
}
end

--[[local ConfFrame = CreateFrame('Frame')
ConfFrame:RegisterEvent('ADDON_LOADED')
ConfFrame:SetScript('OnEvent',function(self, event, addon)
    if addon == 'ElvUI_Config' then
        configTable()
        ConfFrame:UnregisterEvent('ADDON_LOADED')
    end
end)]]

--Set Scale
function AB:MicroScale()
	ElvUI_MicroBar:SetScale(AB.db.microbar.scale)
	ElvUI_MicroBar.mover:SetWidth(AB.db.microbar.scale * ElvUI_MicroBar:GetWidth())
	ElvUI_MicroBar.mover:SetHeight(AB.db.microbar.scale * ElvUI_MicroBar:GetHeight() + 1);
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
	
	CharB:SetScript("OnLeave", function(self)
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
	
	SpellB:SetScript("OnLeave", function(self)
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
	
	TalentB:SetScript("OnLeave", function(self)
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
	
	AchievB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	end
	
	--Questlog
	do
	QuestB:SetScript("OnClick", function(self)
		if QuestLogFrame:IsShown() then
			HideUIPanel(QuestLogFrame)
		else
			ShowUIPanel(QuestLogFrame)
		end
	end)
	
	QuestB:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(QuestB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(QUESTLOG_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	QuestB:SetScript("OnLeave", function(self)
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
	
	GuildB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	end

	--PvP
	do
	PVPB:SetScript("OnClick", function(self)
		if PVPUIFrame then
			if UnitLevel("player") >= 10 then
				if PVPUIFrame:IsShown() then
					HideUIPanel(PVPUIFrame)
				else
					ShowUIPanel(PVPUIFrame)
				end
			end
		else
			LoadAddOn("Blizzard_PVPUI")
			ShowUIPanel(PVPUIFrame)
		end
	end)
	
	PVPB:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(PVPB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(PVP_OPTIONS)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	PVPB:SetScript("OnLeave", function(self)
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
	
	LFDB:SetScript("OnLeave", function(self)
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
	
	CompB:SetScript("OnLeave", function(self)
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
	
	EJB:SetScript("OnLeave", function(self)
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
	
	MenuB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	end
	
	--Help
	do
	HelpB:SetScript("OnClick", function(self)
		ToggleHelpFrame()
	end)
	
	HelpB:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(HelpB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(HELP_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	HelpB:SetScript("OnLeave", function(self)
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
	
	local button_text = button:CreateFontString(nil, 'OVERLAY')
	button_text:SetFont(E["media"].normFont, 10)
	for b, s in pairs (Sletters) do
		if b == button:GetName() then
			button_text:SetText(s)
			break
		end
	end
	button_text:SetPoint("CENTER", button)
	
	local f = CreateFrame("Frame", nil, button)
	f:SetFrameLevel(1)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2, 0)
	f:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -28)
	f:SetTemplate("Default", true)
	button.backdrop = f
end

function AB:SetupSymbolBar()
	microbarS = CreateFrame("Frame", "MicroParentS", E.UIParent)

	CharB = CreateFrame("Button", "CharacterB", microbarS)
	SpellB = CreateFrame("Button", "SpellbookB", microbarS)
	TalentB = CreateFrame("Button", "TalentsB", microbarS)
	AchievB = CreateFrame("Button", "AchievementB", microbarS)
	QuestB = CreateFrame("Button", "QuestB", microbarS)
	GuildB = CreateFrame("Button", "GuildB", microbarS)
	PVPB = CreateFrame("Button", "PVPB", microbarS)
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
		PVPB,
		LFDB,
		CompB,
		EJB,
		MenuB,
		HelpB
	}
	
	microbarS:SetPoint("CENTER", ElvUI_MicroBar, 0, 0)
	microbarS:SetScript('OnEnter', Letter_OnEnter)
	microbarS:SetScript('OnLeave', Letter_OnLeave)
	for i=1, #Sbuttons do
		self:HandleSymbolbuttons(Sbuttons[i])
	end
	E.FrameLocks['MicroParentS'] = true
	AB:UpdateMicroPositionDimensions()
end

AB.UpdateMicroPositionDimensionsMB = AB.UpdateMicroPositionDimensions
function AB:UpdateMicroPositionDimensions()
	AB.UpdateMicroPositionDimensionsMB(self)
	if not CharB then return end
	microbarS:SetAlpha(AB.db.microbar.alpha)
	AB:MenuShow()
	local numRows = 1
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
			button:Point('TOP', lastColumnButton, 'BOTTOM', 0, E.PixelMode and -3 or -5);	
			numRows = numRows + 1
		else
			button:Point('LEFT', prevButton, 'RIGHT', E.PixelMode and 3 or 5, 0);
		end
	end
	microbarS:SetWidth(ElvUI_MicroBar:GetWidth())
	microbarS:SetHeight(ElvUI_MicroBar:GetHeight())
	if AB.db.microbar.mouseover then
		microbarS:SetAlpha(0)
	elseif not AB.db.microbar.mouseover and  AB.db.microbar.symbolic then
		microbarS:SetAlpha(AB.db.microbar.alpha)
	end
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
	AB:SbuttonButtonsScripts()
	AB:MicroScale()
	AB:MenuShow()
end