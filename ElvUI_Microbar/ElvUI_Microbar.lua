-------------------------------------------------
--
-- ElvUI Microbar by Darth Predator
-- Дартпредатор - Свежеватель Душ (Soulflyer) RU
--
-------------------------------------------------
-- Thanks to / Благодарности: --
-- Elv and ElvUI community
-- Slipslop for scale option
-- Blazeflack for helping with option storage and profile changing
--
-------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
-------------------------------------------------

local E, L, P, G = unpack(ElvUI); --Engine, Locales, Profile, Global
local MB = E:NewModule('Microbar', 'AceHook-3.0', 'AceEvent-3.0');

--Setting all variables al locals to avoid possible conflicts with other addons
local microbar
local microbarcontrol
local CharB
local SpellB
local TalentB
local AchievB
local QuestB
local GuildB
local PVPB
local LFDB
local RaidB
local EJB
local MenuB
local HelpB

--Setting loacle shortnames and on update script for mouseover/alpha (can't get rid of using it at the moment)
function MB:SetNames()
	microbar = CreateFrame('Frame', "MicroParent", E.UIParent); --Setting a main frame for Menu
	microbarcontrol = CreateFrame('Frame', "MicroControl", E.UIParent); --Setting Control Fraqme to handle events
	
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
	
	--On update functions
	microbarcontrol:SetScript("OnUpdate", function(self,event,...)
		MB:Mouseover()
	end)
end

--Setting default positioning for menu frame
function MB:CreateMenu()
	microbar:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	microbar:Hide()
	--Backdrop creation
	microbar:CreateBackdrop('Default');
	microbar.backdrop:SetAllPoints();
	microbar.backdrop:Point("BOTTOMLEFT", microbar, "BOTTOMLEFT", 0,  -1);
	
	microbarcontrol:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
end

--Backdrop show/hide
function MB:Backdrop()
	if E.db.microbar.backdrop then
		microbar.backdrop:Show();
	else
		microbar.backdrop:Hide();
	end
end

--Mouseover and Alpha function
function MB:Mouseover()
	if E.db.microbar.mouse then
		if (MouseIsOver(MicroParent)) then
			MicroParent:SetAlpha(E.db.microbar.alpha)
		else	
			MicroParent:SetAlpha(0)
		end
	else
		MicroParent:SetAlpha(E.db.microbar.alpha)
	end
end

--Set Scale
function MB:Scale()
	microbar:SetScale(E.db.microbar.scale)
end

--Show/Hide in combat
function MB:EnterCombat()
	if E.db.microbar.combat then
		microbar:Hide()
	else
		microbar:Show()
	end	
end

--Show after leaving combat
function MB:LeaveCombat()
	microbar:Show()
end

--Sets mover size based on the frame layout
function MB:MicroMoverSize()
	microbar.mover:SetWidth(E.db.microbar.scale * MicroParent:GetWidth())
	microbar.mover:SetHeight(E.db.microbar.scale * MicroParent:GetHeight() + 1);
end

--Positionin of buttons
function MB:MicroButtonsPositioning()
	if E.db.microbar.layout == "Micro_Hor" then --Horizontal
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25,  0)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 25,  0)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25,  0)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_Ver" then --Vertical
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 0, -33)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 0, -33)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 0, -33)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 0, -33)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 0, -33)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 0, -33)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 0, -33)
	elseif E.db.microbar.layout == "Micro_26" then --2 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25, 0)
		TalentB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25, 0)
		QuestB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 0, -33)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25, 0)
		PVPB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25, 0)
		RaidB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25, 0)
		MenuB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 0, -33)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25, 0)
	elseif E.db.microbar.layout == "Micro_34" then --3 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  20)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25,  0)
		EJB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_43" then --4 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  20)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25,  0)
		QuestB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 25,  0)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_62" then --6 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 0,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25,  0)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25,  0)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	end
end

--Setting frame size to change view of backdrop
function MB:MicroFrameSize()
	if E.db.microbar.layout == "Micro_Hor" then
		microbar:Size(305, 37)
	elseif E.db.microbar.layout == "Micro_Ver" then
		microbar:Size(29, 400)
	elseif E.db.microbar.layout == "Micro_26" then
		microbar:Size(55, 202)
	elseif E.db.microbar.layout == "Micro_34" then
		microbar:Size(80, 137)
	elseif E.db.microbar.layout == "Micro_43" then
		microbar:Size(105, 104)
	elseif E.db.microbar.layout == "Micro_62" then
		microbar:Size(154, 70)
	else
		microbar:Size(305, 37)
	end
end

--Buttons points clear
function MB:ButtonsSetup()
	CharB:ClearAllPoints()
	SpellB:ClearAllPoints()	
	TalentB:ClearAllPoints()	
	AchievB:ClearAllPoints()
	QuestB:ClearAllPoints()
	GuildB:ClearAllPoints()
	PVPB:ClearAllPoints()
	LFDB:ClearAllPoints()
	RaidB:ClearAllPoints()
	EJB:ClearAllPoints()
	MenuB:ClearAllPoints()
	HelpB:ClearAllPoints()
end

--Forcing buttons to show up even when thet shouldn't e.g. in vehicles
function MB:ShowMicroButtons()
	CharB:Show()
	SpellB:Show()
	TalentB:Show()
	QuestB:Show()
	PVPB:Show()
	GuildB:Show()
	LFDB:Show()
	EJB:Show()
	RaidB:Show()
	HelpB:Show()
	MenuB:Show()
	AchievB:Show()
end

--For recreate after portals and so on
function MB:MenuShow()
	UpdateMicroButtonsParent(microbar)
	microbar:Show();
	MB:ButtonsSetup();
	MB:MicroButtonsPositioning();
	MB:ShowMicroButtons();
end

--Copy of Elv's UpdateAll function that includes microbar. Forcing re-check of setting and execute them when profile is changed.
function E:UpdateAll()
    self.data = LibStub("AceDB-3.0"):New("ElvData", self.DF, true);
    self.data.RegisterCallback(self, "OnProfileChanged", "UpdateAll")
    self.data.RegisterCallback(self, "OnProfileCopied", "UpdateAll")
    self.data.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
    self.db = self.data.profile;
    self.global = self.data.global;

    self:UpdateMedia()
    self:UpdateFrameTemplates()
    self:SetMoversPositions()

    local CH = self:GetModule('Chat')
    CH.db = self.db.chat
    CH:PositionChat(true); 

    local AB = self:GetModule('ActionBars')
    AB.db = self.db.actionbar
    AB:UpdateButtonSettings()
    AB:SetMoverPositions()

    local bags = E:GetModule('Bags');
    bags:Layout();
    bags:Layout(true);
    bags:PositionBagFrames()
    bags:SizeAndPositionBagBar()

    self:GetModule('Skins'):SetEmbedRight(E.db.skins.embedRight)
    self:GetModule('Layout'):ToggleChatPanels()

    local CT = self:GetModule('ClassTimers')
    CT.db = self.db.classtimer
    CT:PositionTimers()
    CT:ToggleTimers()

    local DT = self:GetModule('DataTexts')
    DT.db = self.db.datatexts
    DT:LoadDataTexts()

    local NP = self:GetModule('NamePlates')
    NP.db = self.db.nameplate
    NP:UpdateAllPlates()

    local UF = self:GetModule('UnitFrames')
    UF.db = self.db.unitframe
    UF:Update_AllFrames()
    ElvUF:ResetDB()
    ElvUF:PositionUF()

    self:GetModule('Auras').db = self.db.auras
    self:GetModule('Tooltip').db = self.db.tooltip

    if self.db.install_complete == nil or (self.db.install_complete and type(self.db.install_complete) == 'boolean') or (self.db.install_complete and type(tonumber(self.db.install_complete)) == 'number' and tonumber(self.db.install_complete) <= 3.05) then
        self:Install()
    end

    self:GetModule('Minimap'):UpdateSettings()

    --self:LoadKeybinds()

    self:GetModule('Microbar'):UpdateMicroSettings()

    collectgarbage('collect');
end

--Update settings after profile change
function MB:UpdateMicroSettings()
    MB:Backdrop();
    MB:Scale();
    MB:MicroMoverSize();
    MB:MicroButtonsPositioning();
    MB:MicroFrameSize();
end

--Initialization
function MB:Initialize()
	MB:SetNames()
	MB:CreateMenu();
	MB:Backdrop();
	MB:MicroFrameSize();
	MB:Scale();
	E:CreateMover(microbar, "MicroMover", L['Microbar'])
	MB:MicroMoverSize();
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "MenuShow");
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "MenuShow");	
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "MenuShow");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "LeaveCombat");
end

E:RegisterModule(MB:GetName())