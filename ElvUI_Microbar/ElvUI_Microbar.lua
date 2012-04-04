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

local E, L, DF, P, G = unpack(ElvUI); --Engine
local AB = E:GetModule('ActionBars', 'AceHook-3.0', 'AceEvent-3.0');

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
do
	f:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	f:Hide()
	f:SetScript('OnShow', function(self)
		E:CreateMover(self, "MicroMover", L['Microbar'])
	end)
	
	--Backdrop creation
	f:CreateBackdrop('Default');
	f.backdrop:SetAllPoints();
	f.backdrop:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 0,  -1);
end

--Backdrop show/hide
function MicroBackDrop()
	if E.db.microdrop then
		f.backdrop:Show();
	else
		f.backdrop:Hide();
	end
end

--Mouseover function
function MicroMouse()
	
	if E.db.mouseover then
		if (MouseIsOver(MicroParent)) then
			MicroParent:SetAlpha(E.db.alpha)
		else	
			MicroParent:SetAlpha(0)
		end
	else
		MicroParent:SetAlpha(E.db.alpha)
	end
end

--Show/Hide in combat
function MicroCombat()
	if InCombatLockdown() and E.db.microcombat then
		f:Hide()
	else
		f:Show()
	end	
end

--Sets mover size based on the frame layout
function MicroMoverSize()
	f.mover:SetWidth(E.db.scale * MicroParent:GetWidth())
	f.mover:SetHeight(E.db.scale * MicroParent:GetHeight() + 1);
end

--On update functions
cf:SetScript("OnUpdate", function(self,event,...)
	FirstRun()
	MicroFrameSize()
	MicroBackDrop()
	MicroMouse()
	MicroCombat()
	f:SetScale(E.db.scale)
	MicroMoverSize()
	MicroButtonsPositioning()
end)

--Positionin of buttons
function MicroButtonsPositioning()
	if E.db.general.microlayout == "Micro_Hor" then --Horizontal
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
	elseif E.db.general.microlayout == "Micro_Ver" then --Vertical
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
	elseif E.db.general.microlayout == "Micro_26" then --2 in a row
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
	elseif E.db.general.microlayout == "Micro_34" then --3 in a row
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
	elseif E.db.general.microlayout == "Micro_43" then --4 in a row
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
	elseif E.db.general.microlayout == "Micro_62" then --6 in a row
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
	else --Setting horizontal positions for first load just in case
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
	end
end

--Setting frame size to change view of backdrop
function MicroFrameSize()
	if E.db.general.microlayout == "Micro_Hor" then
		f:Size(305, 37)
	elseif E.db.general.microlayout == "Micro_Ver" then
		f:Size(29, 400)
	elseif E.db.general.microlayout == "Micro_26" then
		f:Size(55, 202)
	elseif E.db.general.microlayout == "Micro_34" then
		f:Size(80, 137)
	elseif E.db.general.microlayout == "Micro_43" then
		f:Size(105, 104)
	elseif E.db.general.microlayout == "Micro_62" then
		f:Size(154, 70)
	else
		f:Size(305, 37)
	end
end

--Button points clear
function ButtonsSetup()
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
end

--Forcing buttons to show up even when thet shouldn't e.g. in vehicles
function ShowMicroButtons()
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
end

--First run function. Walkaround of my inability to force default layout
function FirstRun()
	if not E.db.general.microinstall then
		E.db.general.microlayout = "Micro_Hor"
		E.db.general.microinstall = true
	end
end

--For recreate after portals and so on
cf:SetScript("OnEvent", function(self,event,...) 
	UpdateMicroButtonsParent(f)
	f:Show();
	ButtonsSetup();
	ShowMicroButtons();
end)
cf:RegisterEvent("PLAYER_ENTERING_WORLD")
cf:RegisterEvent("UNIT_EXITED_VEHICLE")	
cf:RegisterEvent("UNIT_ENTERED_VEHICLE")