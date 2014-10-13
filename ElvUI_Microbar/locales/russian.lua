--Файл локализации для ruRU
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "ruRU")
if not L then return; end

L["Set Scale"] = "Масштаб"
L["Sets Scale of the Micro Bar"] = "Устанавливает масштаб микроменю"
L["As Letters"] = "В виде букв"
L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."] = "Заменить иконки буквами.\n|cffFF0000Внимание:|r это отключит оригинальные подсказки микроменю от Blizzard."
L["Use 10th button for accessing in game shop, if disabled will bring up the support panel.\n|cffFF0000Warning:|r this option requieres to reload the ui to take effect."] = "Использовать 10ю кнопку для открытия магазина. Если отключено, будет появляться панель поддержки.\n|cffFF0000Внимание:|r для вступления в силу понадобится перезагрузка интерфейса."