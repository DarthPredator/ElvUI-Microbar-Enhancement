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

local microbarS = CreateFrame('Frame', "MicroParentS", E.UIParent);
local CharB
local SpellB
local TalentB
local AchievB
local QuestB
local GuildB
local PVPB
local LFDB
local CompB
local EJB
local MenuB
local HelpB

--Options
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

function AB:SymbolsCreateButtons() --Creating and setting properties to second bar
	--Character
	CharB:Size(20, 26)
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
	end)
	
	CharB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Spellbook
	SpellB:Size(20, 26)
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
	end)
	
	SpellB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Talents
	TalentB:Size(20, 26)
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
	end)
	
	TalentB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Achievements
	AchievB:Size(20, 26)
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
	end)
	
	AchievB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Quests
	QuestB:Size(20, 26)
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
	end)
	
	QuestB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Guild
	GuildB:Size(20, 26)
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
	end)
	
	GuildB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--PvP
	PVPB:Size(20, 26)
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
	end)
	
	PVPB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--LFD
	LFDB:Size(20, 26)
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
	end)
	
	LFDB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Mounts and pets
	CompB:Size(20, 26)
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
	end)
	
	CompB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Journal
	EJB:Size(20, 26)
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
	end)
	
	EJB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Menu
	MenuB:Size(20, 26)
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
	end)
	
	MenuB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Help
	HelpB:Size(20, 26)
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
	end)
	
	HelpB:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
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
end

function AB:MenuShow()
	if E.db.actionbar.microbar.symbolic then
		if E.db.actionbar.microbar.enabled then
			ElvUI_MicroBar:Hide()
			CharB:Show()
			SpellB:Show()
			TalentB:Show()
			AchievB:Show()
			QuestB:Show()
			GuildB:Show()
			PVPB:Show()
			LFDB:Show()
			CompB:Show()
			EJB:Show()
			MenuB:Show()
			HelpB:Show()
		else
			CharB:Hide()
			SpellB:Hide()
			TalentB:Hide()
			AchievB:Hide()
			QuestB:Hide()
			GuildB:Hide()
			PVPB:Hide()
			LFDB:Hide()
			CompB:Hide()
			EJB:Hide()
			MenuB:Hide()
			HelpB:Hide()
		end
	else
		if E.db.actionbar.microbar.enabled then
			ElvUI_MicroBar:Show()
		end
		CharB:Hide()
		SpellB:Hide()
		TalentB:Hide()
		AchievB:Hide()
		QuestB:Hide()
		GuildB:Hide()
		PVPB:Hide()
		LFDB:Hide()
		CompB:Hide()
		EJB:Hide()
		MenuB:Hide()
		HelpB:Hide()
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