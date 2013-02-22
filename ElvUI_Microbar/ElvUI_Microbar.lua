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

P.actionbar.microbar.scale = 1
P.actionbar.microbar.symbolic = false

local microbarS = CreateFrame("Frame", "MicroParentS", E.UIParent)
local CharB, SpellB, TalentB, AchievB, QuestB, GuildB, PVPB, LFDB, CompB, EJB, MenuB, HelpB
local bw, bh = 20, 26

--Options
local function configTable()
E.Options.args.actionbar.args.microbar.args.scale = {
	order = 5,
	type = "range",
	name = L["Set Scale"],
	desc = L["Sets Scale of the Micro Bar"],
	isPercent = true,
	min = 0.3, max = 2, step = 0.01,
	set = function(info, value) E.db.actionbar.microbar.scale = value; AB:MicroScale(); end,
}
E.Options.args.actionbar.args.microbar.args.symbolic = {
	order = 6,
	type = 'toggle',
	name = L["As Letters"],
	desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
	disabled = function() return not E.db.actionbar.microbar.enabled end,
	set = function(info, value) E.db.actionbar.microbar.symbolic = value; AB:MenuShow(); end,
}
end

local ConfFrame = CreateFrame('Frame')
ConfFrame:RegisterEvent('ADDON_LOADED')
ConfFrame:SetScript('OnEvent',function(self, event, addon)
    if event == 'ADDON_LOADED' and addon == 'ElvUI_Config' then
        configTable()
        ConfFrame:UnregisterEvent('ADDON_LOADED')
    end
end)

--Set Scale
function AB:MicroScale()
	ElvUI_MicroBar:SetScale(E.db.actionbar.microbar.scale)
	ElvUI_MicroBar.mover:SetWidth(E.db.actionbar.microbar.scale * ElvUI_MicroBar:GetWidth())
	ElvUI_MicroBar.mover:SetHeight(E.db.actionbar.microbar.scale * ElvUI_MicroBar:GetHeight() + 1);
	CharB:SetScale(E.db.actionbar.microbar.scale)
	SpellB:SetScale(E.db.actionbar.microbar.scale)
	TalentB:SetScale(E.db.actionbar.microbar.scale)
	AchievB:SetScale(E.db.actionbar.microbar.scale)
	QuestB:SetScale(E.db.actionbar.microbar.scale)
	GuildB:SetScale(E.db.actionbar.microbar.scale)
	PVPB:SetScale(E.db.actionbar.microbar.scale)
	LFDB:SetScale(E.db.actionbar.microbar.scale)
	CompB:SetScale(E.db.actionbar.microbar.scale)
	EJB:SetScale(E.db.actionbar.microbar.scale)
	MenuB:SetScale(E.db.actionbar.microbar.scale)
	HelpB:SetScale(E.db.actionbar.microbar.scale)
end

E.UpdateAllMB = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllMB(self)
	AB:MicroScale()
	AB:MenuShow()
end

local function Letter_OnEnter()
	if AB.db.microbar.mouseover then
		E:UIFrameFadeIn(CharB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(SpellB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(TalentB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(AchievB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(QuestB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(GuildB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(PVPB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(LFDB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(CompB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(EJB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(MenuB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
		E:UIFrameFadeIn(HelpB, 0.2, CharB:GetAlpha(), AB.db.microbar.alpha)
	end
end

local function Letter_OnLeave()
	if AB.db.microbar.mouseover then
		E:UIFrameFadeOut(CharB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(SpellB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(TalentB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(AchievB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(QuestB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(GuildB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(PVPB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(LFDB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(CompB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(EJB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(MenuB, 0.2, CharB:GetAlpha(), 0)
		E:UIFrameFadeOut(HelpB, 0.2, CharB:GetAlpha(), 0)
	end
end

function AB:SymbolsCreateButtons() --Creating and setting properties to second bar
	--Character
	CharB:Size(bw, bh)
	CharB:CreateBackdrop()
	
	local CharB_text = CharB:CreateFontString(nil, 'OVERLAY')
	CharB_text:SetFont(E["media"].normFont, 10)
	CharB_text:SetText("C")
	CharB_text:SetPoint("CENTER", CharB, "CENTER")
	
	CharB:SetScript("OnClick", function(self)
		if CharacterFrame:IsShown() then
			HideUIPanel(CharacterFrame)
		else
			ShowUIPanel(CharacterFrame)
		end
	end)
	
	CharB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(CharB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(CHARACTER_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	CharB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Spellbook
	SpellB:Size(bw, bh)
	SpellB:CreateBackdrop()
	
	local SpellB_text = SpellB:CreateFontString(nil, 'OVERLAY')
	SpellB_text:SetFont(E["media"].normFont, 10)
	SpellB_text:SetText("S")
	SpellB_text:SetPoint("CENTER", SpellB, "CENTER")
	
	SpellB:SetScript("OnClick", function(self)
		if SpellBookFrame:IsShown() then
			HideUIPanel(SpellBookFrame)
		else
			ShowUIPanel(SpellBookFrame)
		end
	end)
	
	SpellB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(SpellB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(SPELLBOOK_ABILITIES_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	SpellB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Talents
	TalentB:Size(bw, bh)
	TalentB:CreateBackdrop()
	
	local TalentB_text = TalentB:CreateFontString(nil, 'OVERLAY')
	TalentB_text:SetFont(E["media"].normFont, 10)
	TalentB_text:SetText("T")
	TalentB_text:SetPoint("CENTER", TalentB, "CENTER")
	
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
	
	TalentB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(TalentB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(TALENTS_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	TalentB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Achievements
	AchievB:Size(bw, bh)
	AchievB:CreateBackdrop()
	
	local AchievB_text = AchievB:CreateFontString(nil, 'OVERLAY')
	AchievB_text:SetFont(E["media"].normFont, 10)
	AchievB_text:SetText("A")
	AchievB_text:SetPoint("CENTER", AchievB, "CENTER")
	
	AchievB:SetScript("OnClick", function(self)
		ToggleAchievementFrame()
	end)
	
	AchievB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(AchievB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(ACHIEVEMENT_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	AchievB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Quests
	QuestB:Size(bw, bh)
	QuestB:CreateBackdrop()
	
	local QuestB_text = QuestB:CreateFontString(nil, 'OVERLAY')
	QuestB_text:SetFont(E["media"].normFont, 10)
	QuestB_text:SetText("Q")
	QuestB_text:SetPoint("CENTER", QuestB, "CENTER")
	
	QuestB:SetScript("OnClick", function(self)
		if QuestLogFrame:IsShown() then
			HideUIPanel(QuestLogFrame)
		else
			ShowUIPanel(QuestLogFrame)
		end
	end)
	
	QuestB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(QuestB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(QUESTLOG_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	QuestB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Guild
	GuildB:Size(bw, bh)
	GuildB:CreateBackdrop()
	
	local GuildB_text = GuildB:CreateFontString(nil, 'OVERLAY')
	GuildB_text:SetFont(E["media"].normFont, 10)
	GuildB_text:SetText("G")
	GuildB_text:SetPoint("CENTER", GuildB, "CENTER")
	
	GuildB:SetScript("OnClick", function(self)
		if GuildFrame then
			if GuildFrame:IsShown() or (LookingForGuildFrame and LookingForGuildFrame:IsShown()) then
					if IsInGuild() then HideUIPanel(GuildFrame) else HideUIPanel(LookingForGuildFrame) end
				else
					if IsInGuild() then ShowUIPanel(GuildFrame) else ShowUIPanel(LookingForGuildFrame) end
			end
		else
			LoadAddOn("Blizzard_GuildUI")
			
			ShowUIPanel(EncounterJournal)
		end
	end)
	
	GuildB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(GuildB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(GUILD)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	GuildB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--PvP
	PVPB:Size(bw, bh)
	PVPB:CreateBackdrop()
	
	local PVPB_text = PVPB:CreateFontString(nil, 'OVERLAY')
	PVPB_text:SetFont(E["media"].normFont, 10)
	PVPB_text:SetText("P")
	PVPB_text:SetPoint("CENTER", PVPB, "CENTER")
	
	PVPB:SetScript("OnClick", function(self)
		if UnitLevel("player") >= 10 then
			if PVPFrame:IsShown() then
				HideUIPanel(PVPFrame)
			else
				ShowUIPanel(PVPFrame)
			end
		end
	end)
	
	PVPB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(PVPB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(PVP_OPTIONS)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	PVPB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--LFD
	LFDB:Size(bw, bh)
	LFDB:CreateBackdrop()
	
	local LFDB_text = LFDB:CreateFontString(nil, 'OVERLAY')
	LFDB_text:SetFont(E["media"].normFont, 10)
	LFDB_text:SetText("D")
	LFDB_text:SetPoint("CENTER", LFDB, "CENTER")
	
	LFDB:SetScript("OnClick", function(self)
		ToggleLFDParentFrame()
	end)
	
	LFDB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(LFDB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(DUNGEONS_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	LFDB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Mounts and pets
	CompB:Size(bw, bh)
	CompB:CreateBackdrop()
	
	local CompB_text = CompB:CreateFontString(nil, 'OVERLAY')
	CompB_text:SetFont(E["media"].normFont, 10)
	CompB_text:SetText("MP")
	CompB_text:SetPoint("CENTER", CompB, "CENTER")
	
	CompB:SetScript("OnClick", function(self)
		TogglePetJournal()
	end)
	
	CompB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(CompB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(MOUNTS_AND_PETS)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	CompB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Journal
	EJB:Size(bw, bh)
	EJB:CreateBackdrop()
	
	local EJB_text = EJB:CreateFontString(nil, 'OVERLAY')
	EJB_text:SetFont(E["media"].normFont, 10)
	EJB_text:SetText("J")
	EJB_text:SetPoint("CENTER", EJB, "CENTER")
	
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
	
	EJB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(EJB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(ENCOUNTER_JOURNAL)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	EJB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Menu
	MenuB:Size(bw, bh)
	MenuB:CreateBackdrop()
	
	local MenuB_text = MenuB:CreateFontString(nil, 'OVERLAY')
	MenuB_text:SetFont(E["media"].normFont, 10)
	MenuB_text:SetText("M")
	MenuB_text:SetPoint("CENTER", MenuB, "CENTER")
	
	MenuB:SetScript("OnClick", function(self)
		if GameMenuFrame:IsShown() then
				HideUIPanel(GameMenuFrame)
			else
				ShowUIPanel(GameMenuFrame)
			end
	end)
	
	MenuB:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(MenuB, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(MAINMENU_BUTTON)
		GameTooltip:Show()
		Letter_OnEnter()
	end)
	
	MenuB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		Letter_OnLeave()
	end)
	
	--Help
	HelpB:Size(bw, bh)
	HelpB:CreateBackdrop()
	
	local HelpB_text = HelpB:CreateFontString(nil, 'OVERLAY')
	HelpB_text:SetFont(E["media"].normFont, 10)
	HelpB_text:SetText("?")
	HelpB_text:SetPoint("CENTER", HelpB, "CENTER")
	
	HelpB:SetScript("OnClick", function(self)
		ToggleHelpFrame()
	end)
	
	HelpB:SetScript("OnEnter", function(self)
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

local mYoffset = -13
function AB:MicroButtonsPositioning()
	CharB:SetPoint("CENTER", CharacterMicroButton, "CENTER", 0, mYoffset)
	SpellB:SetPoint("CENTER", SpellbookMicroButton, "CENTER", 0, mYoffset)
	TalentB:SetPoint("CENTER", TalentMicroButton, "CENTER", 0, mYoffset)
	AchievB:SetPoint("CENTER", AchievementMicroButton, "CENTER", 0, mYoffset)
	QuestB:SetPoint("CENTER", QuestLogMicroButton, "CENTER", 0, mYoffset)
	GuildB:SetPoint("CENTER", GuildMicroButton, "CENTER", 0, mYoffset)
	PVPB:SetPoint("CENTER", PVPMicroButton, "CENTER", 0, mYoffset)
	LFDB:SetPoint("CENTER", LFDMicroButton, "CENTER", 0, mYoffset)
	CompB:SetPoint("CENTER", CompanionsMicroButton, "CENTER", 0, mYoffset)
	EJB:SetPoint("CENTER", EJMicroButton, "CENTER", 0, mYoffset)
	MenuB:SetPoint("CENTER", MainMenuMicroButton, "CENTER", 0, mYoffset)
	HelpB:SetPoint("CENTER", HelpMicroButton, "CENTER", 0, mYoffset)
end


--Setting loacle shortnames and on update script for mouseover/alpha (can't get rid of using it at the moment)
function AB:SetNames()
	CharB = CharacterMicroButton
	SpellB = SpellbookMicroButton
	TalentB = TalentMicroButton
	AchievB = AchievementMicroButton
	QuestB = QuestLogMicroButton
	GuildB = GuildMicroButton
	PVPB = PVPMicroButton
	LFDB = LFDMicroButton
	RaidB = RaidMicroButton
	EJB = EJMicroButton
	MenuB = MainMenuMicroButton
	HelpB = HelpMicroButton
	
	
	
	CharB = CreateFrame("Button", "CharacterB", microbarS)
	SpellB = CreateFrame("Button", "SpellbookB", microbarS)
	TalentB = CreateFrame("Button", "TalentsB", microbarS)
	AchievB = CreateFrame("Button", "AchievementB", microbarS)
	QuestB = CreateFrame("Button", "QuestB", microbarS)
	GuildB = CreateFrame("Button", "GuildB", microbarS)
	PVPB = CreateFrame("Button", "PVPB", microbarS)
	LFDB = CreateFrame("Button", "LFDB", microbarS)
	CompB = CreateFrame("Button", "RaidFinderB", microbarS)
	EJB = CreateFrame("Button", "JournalB", microbarS)
	MenuB = CreateFrame("Button", "MenuSysB", microbarS)
	HelpB = CreateFrame("Button", "TicketB", microbarS)

	AB:UpdateMicroPositionDimensions()
end

function AB:LetterAlpha()
	CharB:SetAlpha(E.db.actionbar.microbar.alpha)
	SpellB:SetAlpha(E.db.actionbar.microbar.alpha)
	TalentB:SetAlpha(E.db.actionbar.microbar.alpha)
	AchievB:SetAlpha(E.db.actionbar.microbar.alpha)
	QuestB:SetAlpha(E.db.actionbar.microbar.alpha)
	GuildB:SetAlpha(E.db.actionbar.microbar.alpha)
	PVPB:SetAlpha(E.db.actionbar.microbar.alpha)
	LFDB:SetAlpha(E.db.actionbar.microbar.alpha)
	CompB:SetAlpha(E.db.actionbar.microbar.alpha)
	EJB:SetAlpha(E.db.actionbar.microbar.alpha)
	MenuB:SetAlpha(E.db.actionbar.microbar.alpha)
	HelpB:SetAlpha(E.db.actionbar.microbar.alpha)
end

AB.UpdateMicroPositionDimensionsMB = AB.UpdateMicroPositionDimensions
function AB:UpdateMicroPositionDimensions()
	AB.UpdateMicroPositionDimensionsMB(self)
	if not CharB then return end
	AB:LetterAlpha()
	AB:MenuShow()
	microbarS:SetWidth(ElvUI_MicroBar:GetWidth())
	microbarS:SetHeight(ElvUI_MicroBar:GetHeight())
	if AB.db.microbar.mouseover then
		CharB:SetAlpha(0)
		SpellB:SetAlpha(0)
		TalentB:SetAlpha(0)
		AchievB:SetAlpha(0)
		QuestB:SetAlpha(0)
		GuildB:SetAlpha(0)
		PVPB:SetAlpha(0)
		LFDB:SetAlpha(0)
		CompB:SetAlpha(0)
		EJB:SetAlpha(0)
		MenuB:SetAlpha(0)
		HelpB:SetAlpha(0)
	else
		CharB:SetAlpha(E.db.actionbar.microbar.alpha)
		SpellB:SetAlpha(E.db.actionbar.microbar.alpha)
		TalentB:SetAlpha(E.db.actionbar.microbar.alpha)
		AchievB:SetAlpha(E.db.actionbar.microbar.alpha)
		QuestB:SetAlpha(E.db.actionbar.microbar.alpha)
		GuildB:SetAlpha(E.db.actionbar.microbar.alpha)
		PVPB:SetAlpha(E.db.actionbar.microbar.alpha)
		LFDB:SetAlpha(E.db.actionbar.microbar.alpha)
		CompB:SetAlpha(E.db.actionbar.microbar.alpha)
		EJB:SetAlpha(E.db.actionbar.microbar.alpha)
		MenuB:SetAlpha(E.db.actionbar.microbar.alpha)
		HelpB:SetAlpha(E.db.actionbar.microbar.alpha)
	end
end

function AB:MenuShow()
	if E.db.actionbar.microbar.symbolic then
		if E.db.actionbar.microbar.enabled then
			ElvUI_MicroBar:Hide()
			microbarS:Show()
		else
			microbarS:Hide()
		end
	else
		if E.db.actionbar.microbar.enabled then
			ElvUI_MicroBar:Show()
		end
		microbarS:Hide()
	end
end

AB.InitializeMB = AB.Initialize
function AB:Initialize()
	AB.InitializeMB(self)
	AB:SetNames()
	AB:SymbolsCreateButtons()
	AB:MicroButtonsPositioning()
	AB:MicroScale()
	AB:MenuShow()
end