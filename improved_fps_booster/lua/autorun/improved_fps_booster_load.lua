// SCRIPT BY Inj3 
// https://steamcommunity.com/id/Inj3/
// General Public License v3.0
// https://github.com/Inj3-GT

Ipr_Fps_Booster = Ipr_Fps_Booster or {}

local Ipr_SendFileCL = file.Find("ipr_fps_booster_lua/client/*", "LUA")
local Ipr_SendFileCLConfig = file.Find("ipr_fps_booster_configuration/*", "LUA")
local Ipr_SendFileLangCL = file.Find("ipr_fps_booster_language/*", "LUA")

Ipr_Fps_Booster.Settings = {}
Ipr_Fps_Booster.Settings.Version = "4.0"

if (CLIENT) then
    Ipr_Fps_Booster.Settings.Language = "EN"
    Ipr_Fps_Booster.Settings.Save = "improvedfpsbooster/"
    Ipr_Fps_Booster.Settings.ExternalLink = "https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370"
    Ipr_Fps_Booster.Settings.Developer = "Inj3"

    Ipr_Fps_Booster.Settings.Convars = {}
    Ipr_Fps_Booster.Lang = {}
    
    surface.CreateFont("Ipr_Fps_Booster_Font",{
        font = "Rajdhani Bold",
        size = 18,
        weight = 250,
        antialias = true
    })

    for _, f in pairs(Ipr_SendFileLangCL) do
        include("ipr_fps_booster_language/"..f)
    end
    for _, f in pairs(Ipr_SendFileCLConfig) do
        include("ipr_fps_booster_configuration/"..f)
    end
    for _, f in pairs(Ipr_SendFileCL) do
        include("ipr_fps_booster_lua/client/"..f)
    end
else
    local Ipr_Resource = {"resource/fonts/Rajdhani-Bold.ttf", "materials/icon/ipr_boost_computer.png", "materials/icon/ipr_boost_wrench.png"}
    for _, v in pairs(Ipr_Resource) do
        resource.AddFile(v)
    end

    for _, f in pairs(Ipr_SendFileLangCL) do
        AddCSLuaFile("ipr_fps_booster_language/"..f)
    end
    for _, f in pairs(Ipr_SendFileCLConfig) do
        AddCSLuaFile("ipr_fps_booster_configuration/"..f)
    end
    for _, f in pairs(Ipr_SendFileCL) do
        AddCSLuaFile("ipr_fps_booster_lua/client/"..f)
    end
    
    MsgC(Color(0, 250, 0), "\nImproved FPS Booster System " ..Ipr_Fps_Booster.Settings.Version.. " by Inj3\n")
end