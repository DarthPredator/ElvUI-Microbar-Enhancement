local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "esES") or AceLocale:NewLocale("ElvUI", "esMX")
if not L then return; end

L["Set Scale"] = "Configurar Escala"
L["Sets Scale of the Micro Bar"] = "Configurar Escala de la Microbarra"
L["As Letters"] = true
L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."] = true