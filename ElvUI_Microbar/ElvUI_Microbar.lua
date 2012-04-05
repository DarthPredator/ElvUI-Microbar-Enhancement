-------------------------------------------------
--
-- ElvUI Microbar by Darth Predator
-- Дартпредатор - Свежеватель Душ (Soulflyer) RU
--
-------------------------------------------------
-- Thanks to / Благодарности: --
-- Elv and ElvUI community (especially BlackNet)
-- Slipslop for scale option
--
-------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
-------------------------------------------------

local E, L, P, G = unpack(ElvUI); --Engine -- DF,
local MB = E:NewModule('Microbar', 'AceHook-3.0', 'AceEvent-3.0');

local microbuttons = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"QuestLogMicroButton",
	"PVPMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"RaidMicroButton",
	"HelpMicroButton",
	"MainMenuMicroButton",
	"AchievementMicroButton"
}

local f = CreateFrame('Frame', "MicroParent", E.UIParent); --Setting a main frame for Menu
local cf = CreateFrame('Frame', "MicroControl", E.UIParent); --Setting Control Fraqme to handle events
cf:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);

--Setting default positioning for menu frame
function MB:CreateMenu()
	f:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	f:Hide()
	f:SetScript('OnShow', function(self)
		--MB:MicroButtonsPositioning()
		E:CreateMover(self, "MicroMover", L['Microbar'])
		MB:MicroMoverSize();
	end)
	
	--Backdrop creation
	f:CreateBackdrop('Default');
	f.backdrop:SetAllPoints();
	f.backdrop:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 0,  -1);
end

--Backdrop show/hide
function MB:Backdrop()
	if E.db.microbar.backdrop then
		f.backdrop:Show();
	else
		f.backdrop:Hide();
	end
	
	ChatFrame1:AddMessage("|cff1784d1MB:Backdrop():|r отработал");
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

--Show/Hide in combat
function MB:Combat()
	if InCombatLockdown() and E.db.microbar.combat then
		f:Hide()
	else
		f:Show()
	end	
end

--Sets mover size based on the frame layout
function MB:MicroMoverSize()
	f.mover:SetWidth(E.db.microbar.scale * MicroParent:GetWidth())
	f.mover:SetHeight(E.db.microbar.scale * MicroParent:GetHeight() + 1);
	ChatFrame1:AddMessage("|cff1784d1MB:MicroMoverSize():|r отработал");
end

function MB:Scale()
	f:SetScale(E.db.microbar.scale)
	
	ChatFrame1:AddMessage("|cff1784d1MB:Scale():|r отработал");
end

--On update functions
cf:SetScript("OnUpdate", function(self,event,...)
	MB:Mouseover()
	MB:Combat()
end)

--Positionin of buttons
function MB:MicroButtonsPositioning()
	if E.db.microbar.layout == "Micro_Hor" then --Horizontal
		CharacterMicroButton:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  21)
		SpellbookMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 25,  0)
		TalentMicroButton:SetPoint("TOPLEFT", SpellbookMicroButton, "TOPLEFT", 25,  0)
		AchievementMicroButton:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", 25,  0)
		QuestLogMicroButton:SetPoint("TOPLEFT", AchievementMicroButton, "TOPLEFT", 25,  0)
		GuildMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 25,  0)
		PVPMicroButton:SetPoint("TOPLEFT", GuildMicroButton, "TOPLEFT", 25,  0)
		LFDMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 25,  0)
		RaidMicroButton:SetPoint("TOPLEFT", LFDMicroButton, "TOPLEFT", 25,  0)
		EJMicroButton:SetPoint("TOPLEFT", RaidMicroButton, "TOPLEFT", 25,  0)
		MainMenuMicroButton:SetPoint("TOPLEFT", EJMicroButton, "TOPLEFT", 25,  0)
		HelpMicroButton:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_Ver" then --Vertical
		CharacterMicroButton:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  21)
		SpellbookMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 0, -33)
		TalentMicroButton:SetPoint("TOPLEFT", SpellbookMicroButton, "TOPLEFT", 0, -33)
		AchievementMicroButton:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", 0, -33)
		QuestLogMicroButton:SetPoint("TOPLEFT", AchievementMicroButton, "TOPLEFT", 0, -33)
		GuildMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 0, -33)
		PVPMicroButton:SetPoint("TOPLEFT", GuildMicroButton, "TOPLEFT", 0, -33)
		LFDMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 0, -33)
		RaidMicroButton:SetPoint("TOPLEFT", LFDMicroButton, "TOPLEFT", 0, -33)
		EJMicroButton:SetPoint("TOPLEFT", RaidMicroButton, "TOPLEFT", 0, -33)
		MainMenuMicroButton:SetPoint("TOPLEFT", EJMicroButton, "TOPLEFT", 0, -33)
		HelpMicroButton:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 0, -33)
	elseif E.db.microbar.layout == "Micro_26" then --2 in a row
		CharacterMicroButton:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  21)
		SpellbookMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 25, 0)
		TalentMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 0, -33)
		AchievementMicroButton:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", 25, 0)
		QuestLogMicroButton:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", 0, -33)
		GuildMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 25, 0)
		PVPMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 0, -33)
		LFDMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 25, 0)
		RaidMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 0, -33)
		EJMicroButton:SetPoint("TOPLEFT", RaidMicroButton, "TOPLEFT", 25, 0)
		MainMenuMicroButton:SetPoint("TOPLEFT", RaidMicroButton, "TOPLEFT", 0, -33)
		HelpMicroButton:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 25, 0)
	elseif E.db.microbar.layout == "Micro_34" then --3 in a row
		CharacterMicroButton:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  20)
		SpellbookMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 25,  0)
		TalentMicroButton:SetPoint("TOPLEFT", SpellbookMicroButton, "TOPLEFT", 25,  0)
		AchievementMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 0, -33)
		QuestLogMicroButton:SetPoint("TOPLEFT", AchievementMicroButton, "TOPLEFT", 25,  0)
		GuildMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 25,  0)
		PVPMicroButton:SetPoint("TOPLEFT", AchievementMicroButton, "TOPLEFT", 0, -33)
		LFDMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 25,  0)
		RaidMicroButton:SetPoint("TOPLEFT", LFDMicroButton, "TOPLEFT", 25,  0)
		EJMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 0, -33)
		MainMenuMicroButton:SetPoint("TOPLEFT", EJMicroButton, "TOPLEFT", 25,  0)
		HelpMicroButton:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_43" then --4 in a row
		CharacterMicroButton:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  20)
		SpellbookMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 25,  0)
		TalentMicroButton:SetPoint("TOPLEFT", SpellbookMicroButton, "TOPLEFT", 25,  0)
		AchievementMicroButton:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", 25,  0)
		QuestLogMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 0, -33)
		GuildMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 25,  0)
		PVPMicroButton:SetPoint("TOPLEFT", GuildMicroButton, "TOPLEFT", 25,  0)
		LFDMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 25,  0)
		RaidMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 0, -33)
		EJMicroButton:SetPoint("TOPLEFT", RaidMicroButton, "TOPLEFT", 25,  0)
		MainMenuMicroButton:SetPoint("TOPLEFT", EJMicroButton, "TOPLEFT", 25,  0)
		HelpMicroButton:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_62" then --6 in a row
		CharacterMicroButton:SetPoint("TOPLEFT", f, "TOPLEFT", 0,  21)
		SpellbookMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 25,  0)
		TalentMicroButton:SetPoint("TOPLEFT", SpellbookMicroButton, "TOPLEFT", 25,  0)
		AchievementMicroButton:SetPoint("TOPLEFT", TalentMicroButton, "TOPLEFT", 25,  0)
		QuestLogMicroButton:SetPoint("TOPLEFT", AchievementMicroButton, "TOPLEFT", 25,  0)
		GuildMicroButton:SetPoint("TOPLEFT", QuestLogMicroButton, "TOPLEFT", 25,  0)
		PVPMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "TOPLEFT", 0, -33)
		LFDMicroButton:SetPoint("TOPLEFT", PVPMicroButton, "TOPLEFT", 25,  0)
		RaidMicroButton:SetPoint("TOPLEFT", LFDMicroButton, "TOPLEFT", 25,  0)
		EJMicroButton:SetPoint("TOPLEFT", RaidMicroButton, "TOPLEFT", 25,  0)
		MainMenuMicroButton:SetPoint("TOPLEFT", EJMicroButton, "TOPLEFT", 25,  0)
		HelpMicroButton:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 25,  0)
	end
	ChatFrame1:AddMessage("|cff1784d1MB:MicroButtonsPositioning():|r отработал");
end

--Setting frame size to change view of backdrop
function MB:MicroFrameSize()
	if E.db.microbar.layout == "Micro_Hor" then
		f:Size(305, 37)
	elseif E.db.microbar.layout == "Micro_Ver" then
		f:Size(29, 400)
	elseif E.db.microbar.layout == "Micro_26" then
		f:Size(55, 202)
	elseif E.db.microbar.layout == "Micro_34" then
		f:Size(80, 137)
	elseif E.db.microbar.layout == "Micro_43" then
		f:Size(105, 104)
	elseif E.db.microbar.layout == "Micro_62" then
		f:Size(154, 70)
	else
		f:Size(305, 37)
	end
	ChatFrame1:AddMessage("|cff1784d1MB:MicroFrameSize():|r отработал");
end

--Buttons points clear
function MB:ButtonsSetup()
	CharacterMicroButton:ClearAllPoints()
	SpellbookMicroButton:ClearAllPoints()	
	TalentMicroButton:ClearAllPoints()	
	AchievementMicroButton:ClearAllPoints()
	QuestLogMicroButton:ClearAllPoints()
	GuildMicroButton:ClearAllPoints()
	PVPMicroButton:ClearAllPoints()
	LFDMicroButton:ClearAllPoints()
	RaidMicroButton:ClearAllPoints()
	EJMicroButton:ClearAllPoints()
	MainMenuMicroButton:ClearAllPoints()
	HelpMicroButton:ClearAllPoints()
	
	ChatFrame1:AddMessage("|cff1784d1MB:ButtonsSetup():|r отработал");
end

--Forcing buttons to show up even when thet shouldn't e.g. in vehicles
function MB:ShowMicroButtons()
	CharacterMicroButton:Show()
	SpellbookMicroButton:Show()
	TalentMicroButton:Show()
	QuestLogMicroButton:Show()
	PVPMicroButton:Show()
	GuildMicroButton:Show()
	LFDMicroButton:Show()
	EJMicroButton:Show()
	RaidMicroButton:Show()
	HelpMicroButton:Show()
	MainMenuMicroButton:Show()
	AchievementMicroButton:Show()

	ChatFrame1:AddMessage("|cff1784d1MB:ShowMicroButtons():|r отработал");
end

--For recreate after portals and so on
function MB:MenuShow()
	UpdateMicroButtonsParent(f)
	f:Show();
	MB:ButtonsSetup();
	MB:MicroButtonsPositioning();
	MB:ShowMicroButtons();
end

--Initialization
function MB:Initialize()
	MB:CreateMenu();
	MB:Backdrop();
	MB:MicroFrameSize();
	MB:Scale();

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "MenuShow");
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "MenuShow");	
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "MenuShow");
end

E:RegisterModule(MB:GetName())