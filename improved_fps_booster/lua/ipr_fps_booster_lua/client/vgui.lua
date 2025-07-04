// SCRIPT BY Inj3 
// https://steamcommunity.com/id/Inj3/
// General Public License v3.0
// https://github.com/Inj3-GT

local Ipr = {}
local Ipr_Infinity = math.huge

Ipr.Settings = {
    Blur = Material("pp/blurscreen"),
    SetLang = Ipr_Fps_Booster.Settings.Language,
    Debug = true,
    Font = "Ipr_Fps_Booster_Font",
    Status = {
        Name = "FPS Status",
        State = false,
    },
    Fps =  {
        Max = {
            Int = 0,
            Name = "Max : "
        },
        Min = {
            Int = Ipr_Infinity,
            Name = "Min : "},
        Low = {
            Lists = {},
            MaxFrame = 10,
            InProgress = false,
            Name = "Low 1% : ",
        },
    },
    TColor = {
        ["blanc"] = Color(236, 240, 241),
        ["vert"] = Color(39, 174, 96),
        ["rouge"] = Color(192, 57, 43),
        ["orange"] = Color(226, 149, 25),
        ["orangec"] = Color(175, 118, 27),
        ["gvert"] = Color(28, 143, 24, 182),
        ["gvert_"] = Color(28, 143, 24, 232),
        ["bleu"] = Color(52, 73, 94),
        ["bleuc"] = Color(27, 66, 99),
    },
    Country = {
        ["BE"] = true,
        ["FR"] = true,
        ["DZ"] = true,
        ["MA"] = true,
        ["CA"] = true
    },
    Vgui = {
        Primary = false,
        Secondary = false,
        ToolTip = false,
    },
    StartupLaunch = {
        Name = "IprFpsBooster_ApplyToStartup",
        Delay = 300,
    },
    Copy = {},
}

Ipr.Func = {}

Ipr.Func.CreateData = function()
    local Ipr_CreateDir = file.Exists(Ipr_Fps_Booster.Settings.Save, "DATA")
    if not Ipr_CreateDir then
        file.CreateDir(Ipr_Fps_Booster.Settings.Save)
    end

    local Ipr_FileLangs, Ipr_TCountry = file.Exists(Ipr_Fps_Booster.Settings.Save.. "language.json", "DATA")
    if not Ipr_FileLangs then
        local Ipr_GCountry = not game.IsDedicated() and system.GetCountry()
        Ipr_TCountry = (Ipr_GCountry) and Ipr.Settings.Country[Ipr_GCountry] and "FR" or Ipr_Fps_Booster.Settings.Language

        file.Write(Ipr_Fps_Booster.Settings.Save.. "language.json", Ipr_TCountry)
    end
    Ipr.Settings.SetLang = Ipr_TCountry or file.Read(Ipr_Fps_Booster.Settings.Save.. "language.json", "DATA")

    local Ipr_FileConvars, Ipr_TData = file.Exists(Ipr_Fps_Booster.Settings.Save.. "convars.json", "DATA")
    if not Ipr_FileConvars then
        Ipr_TData = {}

        local Ipr_ConvarsLists = Ipr_Fps_Booster.DefaultCommands
        for i = 1, #Ipr_ConvarsLists do
            Ipr_TData[#Ipr_TData + 1] = {
                Name = Ipr_ConvarsLists[i].Name,
                Checked = Ipr_ConvarsLists[i].DefaultCheck
            }
        end

        local Ipr_SettingsLists = Ipr_Fps_Booster.DefaultSettings
        for i = 1, #Ipr_SettingsLists do
            Ipr_TData[#Ipr_TData + 1] = {
                Vgui = Ipr_SettingsLists[i].Vgui,
                Name = Ipr_SettingsLists[i].Name,
                Checked = Ipr_SettingsLists[i].DefaultCheck
            }
        end

        file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_TData))
    end
    Ipr_Fps_Booster.Convars = Ipr_TData or util.JSONToTable(file.Read(Ipr_Fps_Booster.Settings.Save.. "convars.json", "DATA"))
end

Ipr.Func.GetConvar = function(name)
    for i = 1, #Ipr_Fps_Booster.Convars do
        local Ipr_Convars = Ipr_Fps_Booster.Convars[i]

        if (Ipr_Convars.Name == name) then
            return Ipr_Convars.Checked
        end
    end

    if (Ipr.Settings.Debug) then
        print("Convar not found !", " " ..name)
    end
    return nil
end

Ipr.Func.SetConvar = function(name, value, save)
    local Ipr_ConvarNotExists = (Ipr.Func.GetConvar(name) == nil)
    if (Ipr_ConvarNotExists) then
        Ipr_Fps_Booster.Convars[#Ipr_Fps_Booster.Convars + 1] = {
            Name = name,
            Checked = value,
        }
        file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))

        if (Ipr.Settings.Debug) then
            print("Creating new convar : " ..name, value, save)
        end
    else
        for i = 1, #Ipr_Fps_Booster.Convars do
            local Ipr_ToggleCount = Ipr_Fps_Booster.Convars[i]

            if (Ipr_ToggleCount.Name == name) then
                Ipr_Fps_Booster.Convars[i].Checked = value
                break
            end
        end

        if (save == 1) then
            if timer.Exists("IprFpsBooster_SetConvar") then
                timer.Remove("IprFpsBooster_SetConvar")
            end

            timer.Create("IprFpsBooster_SetConvar", 1, 1, function()
                file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
            end)
        elseif (save == 2) then
            file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
        end
    end
end

Ipr.Func.InfoNum = function(cmd, exist)
    local Ipr_InfoNum = LocalPlayer():GetInfoNum(cmd, -99)
    if (exist) then
        return (Ipr_InfoNum == -99)
    end

    return tonumber(Ipr_InfoNum)
end

Ipr.Func.MatchConvar = function(bool)
    local Ipr_ConvarsCheck = bool

    for i = 1, #Ipr_Fps_Booster.DefaultCommands do
        local Ipr_NameCommand = Ipr_Fps_Booster.DefaultCommands[i].Name
        local Ipr_ConvarCommand = Ipr_Fps_Booster.DefaultCommands[i].Convars

        for k, v in pairs(Ipr_ConvarCommand) do
            if isbool(Ipr.Func.GetConvar(Ipr_NameCommand)) then
                if (bool) then
                    Ipr_ConvarsCheck = Ipr.Func.GetConvar(Ipr_NameCommand)
                end

                local Ipr_Toggle = (Ipr_ConvarsCheck) and v.Enabled or v.Disabled
                Ipr_Toggle = tonumber(Ipr_Toggle)

                local Ipr_InfoCmds = Ipr.Func.InfoNum(k)
                if Ipr.Func.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Toggle) then
                    continue
                end

                return true
            end
        end
    end

    return false
end

Ipr.Func.IsChecked = function()
    for i = 1, #Ipr_Fps_Booster.Convars do
        if not Ipr_Fps_Booster.Convars[i].Vgui and (Ipr_Fps_Booster.Convars[i].Checked == true) then
            return true
        end
    end
    
    return false
end

Ipr.Func.Activate = function(bool)
    local Ipr_LocalPlayer = LocalPlayer()
    local Ipr_ConvarsCheck = bool

    for i = 1, #Ipr_Fps_Booster.DefaultCommands do
        local Ipr_NameCommand = Ipr_Fps_Booster.DefaultCommands[i].Name
        local Ipr_ConvarCommand = Ipr_Fps_Booster.DefaultCommands[i].Convars

        for k, v in pairs(Ipr_ConvarCommand) do
            if isbool(Ipr.Func.GetConvar(Ipr_NameCommand)) then
                if (bool) then
                    Ipr_ConvarsCheck = Ipr.Func.GetConvar(Ipr_NameCommand)
                end

                local Ipr_Toggle = (Ipr_ConvarsCheck) and v.Enabled or v.Disabled
                Ipr_Toggle = tonumber(Ipr_Toggle)

                local Ipr_InfoCmds = Ipr.Func.InfoNum(k)
                if Ipr.Func.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Toggle) then
                    continue
                end
                
                Ipr_LocalPlayer:ConCommand(k.. " " ..Ipr_Toggle)

                if (Ipr.Settings.Debug) then
                    print("Convar " ..k.. " set " ..Ipr_InfoCmds.. " to " ..Ipr_Toggle.. " was updated")
                end
            end
        end
    end

    Ipr.Func.SetStatus(bool)
end

Ipr.Func.FpsCalculator = function()
    local Ipr_CurTime = CurTime()

    if (Ipr_CurTime > (Ipr.CurNext or 0)) then
        Ipr.Settings.FpsCurrent = math.Round(1 / FrameTime())
        Ipr.Settings.FpsCurrent = math.abs(Ipr.Settings.FpsCurrent) > 999 and 999 or Ipr.Settings.FpsCurrent

        if (Ipr.Settings.FpsCurrent < Ipr.Settings.Fps.Min.Int) then
            Ipr.Settings.Fps.Min.Int = Ipr.Settings.FpsCurrent
        end
        if (Ipr.Settings.FpsCurrent > (Ipr.Settings.Fps.Max.Int ~= Ipr_Infinity and Ipr.Settings.Fps.Max.Int or 0)) then
            Ipr.Settings.Fps.Max.Int = Ipr.Settings.FpsCurrent
        end

        Ipr.Settings.Fps.Low.InProgress  = Ipr.Settings.Fps.Low.InProgress or Ipr.Settings.Fps.Min.Int

        if (#Ipr.Settings.Fps.Low.Lists <= Ipr.Settings.Fps.Low.MaxFrame) then
            Ipr.Settings.Fps.Low.Lists[#Ipr.Settings.Fps.Low.Lists + 1] = Ipr.Settings.FpsCurrent
        else
            table.sort(Ipr.Settings.Fps.Low.Lists, function(a, b) return a < b end)

            Ipr.Settings.Fps.Low.InProgress = Ipr.Settings.Fps.Low.Lists[2]
            Ipr.Settings.Fps.Low.Lists = {}
        end

        Ipr.CurNext = Ipr_CurTime + 0.3
    end

    return Ipr.Settings.FpsCurrent, Ipr.Settings.Fps.Min.Int, Ipr.Settings.Fps.Max.Int, Ipr.Settings.Fps.Low.InProgress
end

Ipr.Func.ResetFps = function()
    Ipr.Settings.Fps.Min.Int = Ipr_Infinity
    Ipr.Settings.Fps.Max.Int = 0
end

Ipr.Func.SetStatus = function(bool)
    Ipr.Settings.Status.State = bool
end

Ipr.Func.CurrentStatus = function()
    return Ipr.Settings.Status.State
end

Ipr.Func.ColorTransition = function(int)
    return (int <= 30) and Ipr.Settings.TColor["rouge"] or (int > 30 and int <= 50) and Ipr.Settings.TColor["orange"] or Ipr.Settings.TColor["vert"]
end

Ipr.Func.OverridePaint = function(panel)
    local Ipr_PanelChild = panel:GetChildren()

    local Ipr_Override = {
        ["DPanel"] = function(frame)
            frame.Paint = function(self, w, h)
                draw.RoundedBox(12, 9, 6, w - 10, h - 10, Ipr.Settings.TColor["blanc"])
            end
        end,
        ["DSlider"] = function(frame)
            for _, ent in ipairs(Ipr_PanelChild) do
                if (ent:GetName() == "DTextEntry") then
                    ent:SetFont(Ipr.Settings.Font)
                    ent:SetTextColor(Ipr.Settings.TColor["blanc"])
                end
            end

            frame.Knob.Paint = function(self, w, h)
                draw.RoundedBox(3, 5, 2, w - 10, h - 4, Ipr.Settings.TColor["vert"])
            end
            frame.Paint = function(self, w, h)
                draw.RoundedBox(3, 7, 8, 3, h - 16, Ipr.Settings.TColor["rouge"])
                draw.RoundedBox(3, w / 2, 8, 3, h - 16, Ipr.Settings.TColor["rouge"])
                draw.RoundedBox(3, w - 8, 8, 3, h - 16, Ipr.Settings.TColor["rouge"])

                draw.RoundedBox(3, 7, h / 2 - 2, w - 12, h / 2 - 10, Ipr.Settings.TColor["rouge"])
            end
        end,
        ["DCheckBox"] = function(frame)
            frame.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, frame:GetChecked() and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"])
                draw.RoundedBox(12, 7, 7, 2, 2, frame:GetChecked() and Ipr.Settings.TColor["blanc"] or color_black)
            end
        end,
    }

    for _, v in ipairs(Ipr_PanelChild) do
        local Ipr_FindClass = Ipr_Override[v:GetName()]
        if (Ipr_FindClass) then
            Ipr_FindClass(v)
        end
    end
end

local Ipr_Wide = ScrW()
local Ipr_Height = ScrH()

Ipr.Func.RenderBlur = function(panel, colors, border)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(Ipr.Settings.Blur)

    local Ipr_Posx, Ipr_Posy = panel:LocalToScreen(0, 0)
    Ipr.Settings.Blur:SetFloat("$blur", 1.5)
    Ipr.Settings.Blur:Recompute()

    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(Ipr_Posx * -1, Ipr_Posy * -1, Ipr_Wide, Ipr_Height)

    local Ipr_VguiWide = panel:GetWide()
    local Ipr_VguiHeight = panel:GetTall()

    draw.RoundedBoxEx(border, 0, 0, Ipr_VguiWide, Ipr_VguiHeight, colors, true, true, true, true)
end

Ipr.Func.ClosePanel = function()
    for _, v in pairs(Ipr.Settings.Vgui) do
        if not IsValid(v) then
            continue
        end

        if (v:GetName() == "DFrame") then
            v:AlphaTo(0, 0.3, 0, function()
                if IsValid(v) then
                    v:Remove()
                end
            end)
        else
            v:Remove()
        end
    end
end

Ipr.Func.SetToolTip = function(text, panel, hover)
    if not IsValid(Ipr.Settings.Vgui.ToolTip) then
        Ipr.Settings.Vgui.ToolTip = vgui.Create("DTooltip")
        Ipr.Settings.Vgui.ToolTip:SetText("")
        Ipr.Settings.Vgui.ToolTip:SetTextColor(color_white)
        Ipr.Settings.Vgui.ToolTip:SetFont(Ipr.Settings.Font)

        Ipr.Settings.Vgui.ToolTip.Paint = function(self, w, h)
            Ipr.Func.RenderBlur(self, ColorAlpha(color_black, 130), 6)
        end

        Ipr.Settings.Vgui.ToolTip:SetVisible(false)
    end

    local Ipr_OverrideChildren = panel:GetChildren()
    Ipr_OverrideChildren[#Ipr_OverrideChildren + 1] = panel

    for i = 1, #Ipr_OverrideChildren do
        Ipr_OverrideChildren[i].OnCursorMoved = function(self)
            if not IsValid(Ipr.Settings.Vgui.ToolTip) then
                return
            end

            local ipr_InputX, ipr_InputY = input.GetCursorPos()
            local ipr_Pos = ipr_InputX - Ipr.Settings.Vgui.ToolTip:GetWide() / 2

            Ipr.Settings.Vgui.ToolTip:SetPos(ipr_Pos, ipr_InputY - 30)
        end
        Ipr_OverrideChildren[i].OnCursorExited = function()
            if not IsValid(Ipr.Settings.Vgui.ToolTip) then
                return
            end

            Ipr.Settings.Vgui.ToolTip:SetVisible(false)
        end
        Ipr_OverrideChildren[i].OnCursorEntered = function(self)
            if not IsValid(Ipr.Settings.Vgui.ToolTip) then
                return
            end
            
            Ipr.Settings.Vgui.ToolTip:SetText((hover) and text or text[Ipr.Settings.SetLang])
            Ipr.Settings.Vgui.ToolTip:SetTextColor(color_white)
            Ipr.Settings.Vgui.ToolTip:SetFont(Ipr.Settings.Font)

            Ipr.Settings.Vgui.ToolTip:SetVisible(true)

            Ipr.Settings.Vgui.ToolTip:SetAlpha(0)
            Ipr.Settings.Vgui.ToolTip:AlphaTo(255, 0.8, 0)

            timer.Simple(0.0001, function()
                if IsValid(self) then
                    self:OnCursorMoved()
                end
            end)
        end
    end
end

Ipr.Func.FogActivate = function(bool)
    if not bool then
        hook.Remove("SetupWorldFog", "IprFpsBooster_WorldFog")
        hook.Remove("SetupSkyboxFog", "IprFpsBooster_SkyboxFog")
    else
        hook.Add("SetupWorldFog", "IprFpsBooster_WorldFog", function()
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(Ipr.Func.GetConvar("FogStart"))
            render.FogEnd(Ipr.Func.GetConvar("FogEnd"))
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)

        hook.Add("SetupSkyboxFog", "IprFpsBooster_SkyboxFog", function(scale)
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(Ipr.Func.GetConvar("FogStart") * scale)
            render.FogEnd(Ipr.Func.GetConvar("FogEnd") * scale)
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)
    end
end

local function Ipr_FpsBooster_Options(primary)
    if IsValid(Ipr.Settings.Vgui.Secondary) then
        Ipr.Settings.Vgui.Secondary:Remove()
    end

    Ipr.Settings.Vgui.Secondary = vgui.Create("DFrame")

    Ipr.Settings.Vgui.Secondary:SetTitle("")
    Ipr.Settings.Vgui.Secondary:SetSize(240, 450)
    Ipr.Settings.Vgui.Secondary:MakePopup()
    Ipr.Settings.Vgui.Secondary:ShowCloseButton(false)
    Ipr.Settings.Vgui.Secondary:SetDraggable(true)

    if IsValid(primary) then
        local function Ipr_MovedVgui()
            Ipr.Settings.Vgui.Secondary:AlphaTo(255, 1.5, 0)

            local Ipr_CenterSecondaryH = primary:GetY() - (Ipr.Settings.Vgui.Secondary:GetTall() / 2)
            local Ipr_FirstPosW = primary:GetX() + primary:GetWide()
            Ipr.Settings.Vgui.Secondary:SetPos(Ipr_FirstPosW, Ipr_CenterSecondaryH)

            Ipr_CenterSecondaryH = Ipr_CenterSecondaryH + (primary:GetTall() / 2)
            Ipr.Settings.Vgui.Secondary:MoveTo(Ipr_FirstPosW, Ipr_CenterSecondaryH, 0.5, 0)

            local Ipr_CenterSecondaryW = Ipr_FirstPosW + 10
            Ipr.Settings.Vgui.Secondary:MoveTo(Ipr_CenterSecondaryW, Ipr_CenterSecondaryH, 0.5, 0.5)
        end

        Ipr.Settings.Vgui.Secondary:SetAlpha(0)

        if not primary.PMoved then
            primary:MoveTo(primary:GetX() - (Ipr.Settings.Vgui.Secondary:GetWide() / 2), primary:GetY(), 0.3, 0, -1, Ipr_MovedVgui)
        else
            Ipr_MovedVgui()
        end
    else
        Ipr.Settings.Vgui.Secondary:Center()
    end
    
    Ipr.Settings.Vgui.Secondary.Paint = function(self, w, h)
        if (self.Dragging) and IsValid(primary) then
            local Ipr_CenterPrimaryW = self:GetX() - primary:GetWide() - 10
            local Ipr_CenterPrimaryH = self:GetY() + (self:GetTall() / 2)
            Ipr_CenterPrimaryH = Ipr_CenterPrimaryH - (primary:GetTall() / 2)

            primary:SetPos(Ipr_CenterPrimaryW, Ipr_CenterPrimaryH)

            if not primary.PMoved then
               primary.PMoved = true
            end
        end

        Ipr.Func.RenderBlur(self, ColorAlpha(color_black, 130), 6)
        
        draw.RoundedBoxEx(6, 0, 0, w, 20, Ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText("Options FPS Booster", Ipr.Settings.Font, w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("FPS Limit : ", Ipr.Settings.Font, 5, h - 20, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)

        local Ipr_FpsLimit = math.Round(Ipr.Func.InfoNum("fps_max"))
        draw.SimpleText(Ipr_FpsLimit, Ipr.Settings.Font, 67, h - 20, Ipr.Func.ColorTransition(Ipr_FpsLimit), TEXT_ALIGN_LEFT)
        
        draw.SimpleText(Ipr_Fps_Booster.Settings.Developer, Ipr.Settings.Font, w - 5, h - 20, Ipr.Settings.TColor["vert"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_Fps_Booster.Settings.Version.. " By", Ipr.Settings.Font, w - 28, h - 20, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
    end

    local function Ipr_PaintBar(Scroll)
        Scroll.Paint = nil
        
        Scroll.btnUp.Paint = function(self, w, h)
           draw.RoundedBoxEx(3, 0, 0, w, h, Ipr.Settings.TColor["bleu"], true, true, false, false)
        end
        Scroll.btnDown.Paint = function(self, w, h)
           draw.RoundedBoxEx(3, 0, 0, w, h, Ipr.Settings.TColor["bleu"], false, false, true, true)
        end
        Scroll.btnGrip.Paint = function(self, w, h)
           draw.RoundedBox(1, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
        end
    end

    local Ipr_Close = vgui.Create("DImageButton", Ipr.Settings.Vgui.Secondary)
    Ipr_Close:SetSize(16, 16)
    Ipr_Close:SetPos(Ipr.Settings.Vgui.Secondary:GetWide() - Ipr_Close:GetWide() - 1, 2)
    Ipr_Close:SetImage("icon16/cross.png")
    Ipr_Close.Paint = nil
    Ipr_Close.DoClick = function()
        Ipr.Settings.Vgui.Secondary:AlphaTo(0, 0.3, 0, function()
            if IsValid(Ipr.Settings.Vgui.Secondary) then
                Ipr.Settings.Vgui.Secondary:Remove()
            end

            if IsValid(primary) and not primary.PMoved then
                primary:MoveTo(Ipr_Wide / 2 - primary:GetWide() / 2, Ipr_Height / 2 - primary:GetTall() / 2, 0.3, 0)
            end
        end)
    end

    local Ipr_CenterVgui = Ipr.Settings.Vgui.Secondary:GetWide() / 2
    local Ipr_CheckboxState = {
        Default = Ipr.Func.IsChecked(), 
        Icon = {
            [false] = "icon16/joystick_add.png", 
            [true] = "icon16/joystick_delete.png"
        }
    }

    local Ipr_CheckUncheckAll = vgui.Create("DImageButton", Ipr.Settings.Vgui.Secondary)
    Ipr_CheckUncheckAll:SetPos(3, 2)
    Ipr_CheckUncheckAll:SetSize(16, 16)
    Ipr_CheckUncheckAll:SetImage(Ipr_CheckboxState.Icon[true])
    Ipr_CheckUncheckAll.Paint = nil

    Ipr.Settings.Vgui.CheckBox = {}
    Ipr.Func.SetToolTip(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].CheckUncheckAll, Ipr_CheckUncheckAll, true)

    Ipr_CheckUncheckAll.DoClick = function()
        Ipr_CheckboxState.Default = not Ipr_CheckboxState.Default
        for i = 1, #Ipr.Settings.Vgui.CheckBox do 
            if (i > #Ipr_Fps_Booster.DefaultCommands) then
                break
            end

            Ipr.Settings.Vgui.CheckBox[i].Vgui:SetValue(Ipr_CheckboxState.Default)
        end

        Ipr_CheckUncheckAll:SetImage(Ipr_CheckboxState.Icon[Ipr_CheckboxState.Default])
    end

    local Ipr_SettingsConvars = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsConvars:SetSize(232, 165)
    Ipr_SettingsConvars:SetPos(Ipr_CenterVgui - (Ipr_SettingsConvars:GetWide() / 2), 90)
    Ipr_SettingsConvars.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(color_black, 90))
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].TSettings, Ipr.Settings.Font, w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    local Ipr_ScrollBarConvars = vgui.Create("DScrollPanel", Ipr_SettingsConvars)
    Ipr_ScrollBarConvars:Dock(FILL)
    Ipr_ScrollBarConvars:DockMargin(5, 22, 0, 5)
    local Ipr_VScrollBarConvars = Ipr_ScrollBarConvars:GetVBar()
    Ipr_VScrollBarConvars:SetWide(11)
    Ipr_PaintBar(Ipr_VScrollBarConvars)

    local Ipr_ConvarsLists = Ipr_Fps_Booster.DefaultCommands
    for i = 1, #Ipr_ConvarsLists do
        local Ipr_OptimizeConfig = vgui.Create("DPanel", Ipr_ScrollBarConvars)
        Ipr_OptimizeConfig:SetSize(225, 25)
        Ipr_OptimizeConfig:Dock(TOP)
        Ipr_OptimizeConfig.Paint = nil

        local Ipr_DboxConvars = vgui.Create("DCheckBoxLabel", Ipr_OptimizeConfig)
        Ipr_DboxConvars:Dock(FILL)
        Ipr_DboxConvars:SetText("")

        local Ipr_ConvarsExists = (Ipr.Func.GetConvar(Ipr_ConvarsLists[i].Name) ~= nil)
        if not Ipr_ConvarsExists then
            Ipr.Func.SetConvar(Ipr_ConvarsLists[i].Name, Ipr_ConvarsLists[i].DefaultCheck)

            Ipr.Settings.Copy.Data = table.Copy(Ipr_Fps_Booster.Convars)
            Ipr.Settings.Copy.Set = false
        end
        
        Ipr_DboxConvars:SetValue(Ipr.Func.GetConvar(Ipr_ConvarsLists[i].Name))
        Ipr_DboxConvars:SetWide(200)

        Ipr.Func.SetToolTip(Ipr_Fps_Booster.DefaultCommands[i].Localization.ToolTip, Ipr_DboxConvars)
        Ipr.Func.OverridePaint(Ipr_DboxConvars)
        
        function Ipr_DboxConvars:Paint(w, h)
            draw.SimpleText(Ipr_Fps_Booster.DefaultCommands[i].Localization.Text[Ipr.Settings.SetLang], Ipr.Settings.Font, 22, 5, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        end
        Ipr_DboxConvars.OnChange = function(self)
            Ipr.Func.SetConvar(Ipr_ConvarsLists[i].Name, self:GetChecked())

            local Ipr_Compare = Ipr_ConvarsLists[i].Name
            local Ipr_ConvarFind = false
            local Ipr_BlackList = {
                ["Startup"] = true,
            }

            for i = 1, #Ipr.Settings.Copy.Data do
                local Ipr_CopyDataName = Ipr.Settings.Copy.Data[i].Name
                if Ipr.Settings.Copy.Data[i].Vgui or Ipr_BlackList[Ipr_CopyDataName] then
                    continue
                end

                local Ipr_CopyDataCheck = Ipr.Settings.Copy.Data[i].Checked
                for c = 1, #Ipr_Fps_Booster.Convars do
                     if (Ipr_CopyDataName == Ipr_Fps_Booster.Convars[c].Name) and (Ipr_CopyDataCheck ~= Ipr_Fps_Booster.Convars[c].Checked) then
                         Ipr_ConvarFind = true
                         break
                     end
                end
            end

            if (Ipr.Settings.Copy.Set ~= Ipr_ConvarFind) then
                Ipr.Settings.Copy.Set = Ipr_ConvarFind
            end
        end

        Ipr.Settings.Vgui.CheckBox[#Ipr.Settings.Vgui.CheckBox + 1] = {Vgui = Ipr_DboxConvars, Default = Ipr_ConvarsLists[i].DefaultCheck, Name = Ipr_ConvarsLists[i].Name, Paired = Ipr_ConvarsLists[i].Paired}
    end

    local Ipr_SettingsCheckBox = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsCheckBox:SetSize(232, 165)
    Ipr_SettingsCheckBox:SetPos(Ipr_CenterVgui - (Ipr_SettingsCheckBox:GetWide() / 2), 260)
    Ipr_SettingsCheckBox.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(color_black, 90))
        draw.SimpleText("Configuration :", Ipr.Settings.Font, w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    local Ipr_ScrollBarCheckBox = vgui.Create("DScrollPanel", Ipr_SettingsCheckBox)
    Ipr_ScrollBarCheckBox:Dock(FILL)
    Ipr_ScrollBarCheckBox:DockMargin(5, 22, 0, 5)
    local Ipr_VScrollBarSettings = Ipr_ScrollBarCheckBox:GetVBar()
    Ipr_VScrollBarSettings:SetWide(11)
    Ipr_PaintBar(Ipr_VScrollBarSettings)

    local Ipr_OverrideVgui = {
        ["DCheckBoxLabel"] = {
            Func = function(panel, tbl, primary)
                function panel:Paint(w, h)
                    draw.SimpleText(tbl.Localization.Text[Ipr.Settings.SetLang], Ipr.Settings.Font, 22, 4, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
                end

                panel:SetValue(Ipr.Func.GetConvar(tbl.Name))
                panel:SetWide(210)

                panel:Dock(FILL)

                Ipr.Func.SetToolTip(tbl.Localization.ToolTip, panel)

                local Ipr_Name = tbl.Name
                panel.OnChange = function(self)
                   local Ipr_GetChecked = self:GetChecked()
                   Ipr.Func.SetConvar(Ipr_Name, Ipr_GetChecked, 1)

                   for i = 1, #Ipr.Settings.Vgui.CheckBox do 
                        if (Ipr.Settings.Vgui.CheckBox[i].Paired == Ipr_Name) then
                            local Ipr_Vgui = Ipr.Settings.Vgui.CheckBox[i].Vgui
                            Ipr_Vgui = Ipr_Vgui:GetParent()

                            if IsValid(Ipr_Vgui) then
                                Ipr_Vgui:SetDisabled(not Ipr_GetChecked)
                            end
                        end
                   end

                   if (tbl.HookFog) then
                        Ipr.Func.FogActivate(Ipr_GetChecked)
                   end
                end
            end,

            Parent = function()
                local Ipr_CheckBoxConfig = vgui.Create("DPanel", Ipr_ScrollBarCheckBox)
                Ipr_CheckBoxConfig:SetSize(225, 25)
                Ipr_CheckBoxConfig:Dock(TOP)
                Ipr_CheckBoxConfig.Paint = nil

                return Ipr_CheckBoxConfig
            end,
        },
        ["DNumSlider"] = {
            Func = function(panel, tbl, primary)
                function primary:Paint(w, h)
                    draw.SimpleText(tbl.Localization.Text[Ipr.Settings.SetLang].. " [" ..math.Round(panel:GetValue()).. "]", Ipr.Settings.Font, w / 2, 0, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
                end

                local Ipr_DNumChildren = panel:GetChildren()
                local Ipr_PrimaryWide = primary:GetWide()

                for _, v in ipairs(Ipr_DNumChildren) do
                    local Ipr_GName = v:GetName()

                    if (Ipr_GName == "DSlider") then
                        v:Dock(FILL)
                        v:SetSize(Ipr_PrimaryWide, 25)
                    elseif (Ipr_GName == "DLabel") then
                        v:GetChildren()[1]:SetVisible(false)
                        v:SetVisible(false)
                    elseif (Ipr_GName == "DTextEntry") then
                        v:SetVisible(false)
                    end
                end

                panel:SetSize(Ipr_PrimaryWide, 25)
                panel:Dock(BOTTOM)

                panel:SetMinMax(0, tbl.Max or 100)
                panel:SetValue(Ipr.Func.GetConvar(tbl.Name))
                panel:SetDecimals(0)

                panel.OnValueChanged = function(self)
                   Ipr.Func.SetConvar(tbl.Name, self:GetValue(), 1)
                end
            end,
            
            Parent = function(int, tbl)
                local Ipr_DNumConfig = vgui.Create("DPanel", Ipr_ScrollBarCheckBox)
                Ipr_DNumConfig:SetSize(225, 39)
                Ipr_DNumConfig:Dock(TOP)
                
                return Ipr_DNumConfig
            end,
        },
    }

    local Ipr_SettingsLists = Ipr_Fps_Booster.DefaultSettings
    for i = 1, #Ipr_SettingsLists do
        local Ipr_PrimaryVgui = Ipr_OverrideVgui[Ipr_SettingsLists[i].Vgui].Parent(i, Ipr_SettingsLists[i])
        local Ipr_SettingsCreate = vgui.Create(Ipr_SettingsLists[i].Vgui, Ipr_PrimaryVgui)

        Ipr_SettingsCreate:Dock(TOP)
        Ipr_SettingsCreate:SetText("")

        Ipr.Func.OverridePaint(Ipr_SettingsCreate)

        Ipr_OverrideVgui[Ipr_SettingsLists[i].Vgui].Func(Ipr_SettingsCreate, Ipr_SettingsLists[i], Ipr_PrimaryVgui)
        Ipr.Settings.Vgui.CheckBox[#Ipr.Settings.Vgui.CheckBox + 1] = {Vgui = Ipr_SettingsCreate, Default = Ipr_SettingsLists[i].DefaultCheck, Name = Ipr_SettingsLists[i].Name, Paired = Ipr_SettingsLists[i].Paired}
   
        if (Ipr_SettingsLists[i].Paired) then
            Ipr_PrimaryVgui:SetDisabled(not Ipr.Func.GetConvar(Ipr_SettingsLists[i].Paired))
        end
    end

    local Ipr_SettingsBut = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsBut:SetSize(150, 60)
    Ipr_SettingsBut:SetPos(Ipr_CenterVgui - (Ipr_SettingsBut:GetWide() / 2), 25)
    Ipr_SettingsBut.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(color_black, 90))
    end
    local Ipr_ScrollBut = vgui.Create("DScrollPanel", Ipr_SettingsBut)
    Ipr_ScrollBut:Dock(FILL)
    Ipr_ScrollBut:DockMargin(-1, 2, 0, 2)
    local Ipr_SScrollSlide = Ipr_ScrollBut:GetVBar()
    Ipr_SScrollSlide:SetWide(5)
    Ipr_PaintBar(Ipr_SScrollSlide)

    local Ipr_Dbuttons = {
        {
            Vgui = "DButton",
            Icon = "icon16/bullet_disk.png",
            Sound = "buttons/button9.wav",
            DrawLine = true,
            Localization = {
                        Text = "Save optimization",
                        ToolTip = {
                            ["FR"] = "Sauvegarde les paramètres d'optimisation !",
                            ["EN"] = "Save optimization settings !",
                        },
            },
            Func = function()
                if not Ipr.Settings.Copy.Set then
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "ERROR", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].CheckedBox)
                    return
                end

                if timer.Exists(Ipr.Settings.StartupLaunch.Name) then
                    timer.Remove(Ipr.Settings.StartupLaunch.Name)
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupAbandoned)
                end

                local ipr_CurrentState = Ipr.Func.CurrentStatus()
                if (ipr_CurrentState) then
                    Ipr.Func.Activate(true)
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].OptimizationReloaded)
                end

                Ipr.Func.SetConvar("Startup", false, 2)

                Ipr.Settings.Copy.Data = table.Copy(Ipr_Fps_Booster.Convars)
                Ipr.Settings.Copy.Set = false

                file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
                chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].SettingsSaved)
            end
        },
        {
            Vgui = "DButton",
            Icon = "icon16/bullet_key.png",
            Sound = "buttons/button9.wav",
            DataDelayed = {Name = Ipr.Settings.StartupLaunch.Name, Start = Ipr.Settings.StartupLaunch.Delay},
            DrawLine = true,
            Convar = {
                Name = "Startup",
                DefaultCheck = false,
            },
            Localization = {
                        Text = "Apply to startup",
                        ToolTip = {
                            ["FR"] = "Optimisation lancée au démarrage du jeu (orange : en attente, vert : optimisation lancée)",
                            ["EN"] = "Optimization launched at game startup (orange : waiting, green : optimization launched)",
                        },
            },
            Func = function(name, value)
                if timer.Exists(Ipr.Settings.StartupLaunch.Name) then
                    timer.Remove(Ipr.Settings.StartupLaunch.Name)
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupAbandoned)
                end

                local Ipr_SetStartup = value
                if (Ipr_SetStartup) then
                    Ipr.Func.SetConvar(name, Ipr_SetStartup)

                    timer.Create(Ipr.Settings.StartupLaunch.Name, Ipr.Settings.StartupLaunch.Delay, 1, function()
                        Ipr.Func.SetConvar(name, true, 2)
                        chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["vert"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupEnabled)
                    end)

                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupLaunched)
                else
                    Ipr.Func.SetConvar(name, Ipr_SetStartup, 1)
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupDisabled)
                end
            end
        },
        {
            Vgui = "DButton",
            Icon = "icon16/bullet_wrench.png",
            Sound = "buttons/button9.wav",
            DrawLine = false,
            Localization = {
                        Text = "Default settings",
                        ToolTip = {
                            ["FR"] = "Rétablir tout les paramètres par défaut !",
                            ["EN"] = "Set default parameters !",
                        },
            },
            Func = function()
                for i = 1, #Ipr.Settings.Vgui.CheckBox do 
                   Ipr.Settings.Vgui.CheckBox[i].Vgui:SetValue(Ipr.Settings.Vgui.CheckBox[i].Default)
                end

                chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].DefaultConfig)
            end
        },
    }

    for i = 1, #Ipr_Dbuttons do
        local Ipr_SettingsDbutton = Ipr_Dbuttons[i]
        local Ipr_SettingsCreate = vgui.Create(Ipr_SettingsDbutton.Vgui, Ipr_ScrollBut)

        Ipr_SettingsCreate:SetPos(7, i * (1 + 25) - 20)
        Ipr_SettingsCreate:SetSize(135, 20)
        Ipr_SettingsCreate:SetText("")
        Ipr_SettingsCreate:SetImage(Ipr_SettingsDbutton.Icon)

        Ipr.Func.SetToolTip(Ipr_SettingsDbutton.Localization.ToolTip, Ipr_SettingsCreate)

        if (Ipr_SettingsDbutton.Convar) then
            local Ipr_SetStartup = Ipr.Func.GetConvar(Ipr_SettingsDbutton.Convar.Name)
            Ipr.Func.SetConvar(Ipr_SettingsDbutton.Convar.Name, Ipr_SetStartup or false)
        end

        local Ipr_ConvarColor = color_white
        Ipr_SettingsCreate.Paint = function(self, w, h)
            local Ipr_Hovered = self:IsHovered()

            if (Ipr_SettingsDbutton.DrawLine) then
                if (Ipr_SettingsDbutton.Convar) then
                    draw.RoundedBoxEx(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"], true, true, false, false)

                    Ipr_ConvarColor = (Ipr_SettingsDbutton.DataDelayed and timer.Exists(Ipr_SettingsDbutton.DataDelayed.Name)) and Ipr.Settings.TColor["orange"] or Ipr.Func.GetConvar(Ipr_SettingsDbutton.Convar.Name) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"]
                    draw.RoundedBox(0, 0, h- 1, w, h, Ipr_ConvarColor)
                else
                    if (Ipr.Settings.Copy.Set) then
                        local Ipr_CurTime = CurTime()
                        local Ipr_ColorAbs = math.abs(math.sin(Ipr_CurTime * 2.5) * 255)

                        draw.RoundedBoxEx(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"], true, true, false, false)
                        draw.RoundedBox(0, 0, h- 1, w, h, Color(Ipr_ColorAbs, Ipr_ColorAbs, 0))
                    else
                        draw.RoundedBox(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
                    end
                end
            else
               draw.RoundedBox(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["gvert_"] or Ipr.Settings.TColor["gvert"])
            end
            
            draw.SimpleText(Ipr_SettingsDbutton.Localization.Text, Ipr.Settings.Font, w / 2 + 6, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        end

        Ipr_SettingsCreate.DoClick = function()
            surface.PlaySound(Ipr_SettingsDbutton.Sound)

            if (Ipr_SettingsDbutton.Convar) then
                local Ipr_TimerData = timer.Exists(Ipr_SettingsDbutton.DataDelayed.Name)
                local Ipr_GConvar = false

                if (Ipr_SettingsDbutton.DataDelayed) and (Ipr_TimerData) then
                    Ipr_GConvar = not Ipr_TimerData
                else
                    Ipr_GConvar = not Ipr.Func.GetConvar(Ipr_SettingsDbutton.Convar.Name)
                end

                Ipr_SettingsDbutton.Func(Ipr_SettingsDbutton.Convar.Name, Ipr_GConvar)
                return
            end

            Ipr_SettingsDbutton.Func()
        end
    end
end

local function Ipr_FpsBooster()
    Ipr.Func.ClosePanel()

    Ipr.Settings.Vgui.Primary = vgui.Create("DFrame")

    local Ipr_PrimaryProperty = vgui.Create("DPropertySheet", Ipr.Settings.Vgui.Primary)
    local Ipr_PrimaryLanguage = vgui.Create("DComboBox", Ipr.Settings.Vgui.Primary)
    local Ipr_PrimaryClose = vgui.Create("DImageButton", Ipr.Settings.Vgui.Primary)

    local Ipr_PrimaryExternal = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    local Ipr_PrimaryEnabled = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    local Ipr_PrimaryDisabled = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    local Ipr_PrimarySettings = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    local Ipr_PrimaryResetFps = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)

    Ipr.Settings.Vgui.Primary:SetTitle("")
    Ipr.Settings.Vgui.Primary:SetSize(300, 270)
    Ipr.Settings.Vgui.Primary:Center()
    Ipr.Settings.Vgui.Primary:MakePopup()
    
    Ipr.Settings.Vgui.Primary:SetMouseInputEnabled(false)

    timer.Simple(0.01, function()
         if not IsValid(Ipr.Settings.Vgui.Primary) then
            return 
         end

         input.SetCursorPos(Ipr.Settings.Vgui.Primary:GetX() + (Ipr.Settings.Vgui.Primary:GetWide() / 2), Ipr.Settings.Vgui.Primary:GetY() + (Ipr.Settings.Vgui.Primary:GetTall() - 50))
         Ipr.Settings.Vgui.Primary:SetMouseInputEnabled(true)
    end)

    Ipr.Settings.Vgui.Primary:ShowCloseButton(false)
    Ipr.Settings.Vgui.Primary:SetDraggable(true)

    Ipr.Settings.Vgui.Primary:SetAlpha(0)
    Ipr.Settings.Vgui.Primary:AlphaTo(255, 1, 0)

    Ipr.Settings.Copy.Data = table.Copy(Ipr_Fps_Booster.Convars)
    Ipr.Settings.Copy.Set = false
    
    Ipr.Settings.Vgui.Primary.Paint = function(self, w, h)
        if (self.Dragging) then
            if IsValid(Ipr.Settings.Vgui.Secondary) then
                local Ipr_CenterSecondaryW = self:GetX() + self:GetWide() + 10
                local Ipr_CenterSecondaryH = self:GetY() - (Ipr.Settings.Vgui.Secondary:GetTall() / 2)
                Ipr_CenterSecondaryH = Ipr_CenterSecondaryH + (self:GetTall() / 2)
    
                Ipr.Settings.Vgui.Secondary:SetPos(Ipr_CenterSecondaryW, Ipr_CenterSecondaryH)
            end

            if not self.PMoved then
               self.PMoved = true
            end
        end

        Ipr.Func.RenderBlur(self, ColorAlpha(color_black, 130), 6)
        
        draw.RoundedBoxEx(6, 0, 0, w, 33, Ipr.Settings.TColor["bleu"], true, true, false, false)

        local Ipr_CurrentStatus = Ipr.Func.CurrentStatus()
        draw.SimpleText("FPS :",Ipr.Settings.Font, (Ipr_CurrentStatus) and w / 2 - 25 or w / 2 -10, 16, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].TEnabled,Ipr.Settings.Font,w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        
        local Ipr_TCurrentStatus = (Ipr_CurrentStatus) and "On (Boost)" or "Off"
        local ipr_TCurrentColor = (Ipr_CurrentStatus) and (Ipr.Settings.Copy.Set) and Ipr.Settings.TColor["orange"] or (Ipr_CurrentStatus) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"]
        draw.SimpleText(Ipr_TCurrentStatus, Ipr.Settings.Font, (Ipr_CurrentStatus) and w / 2 + 22 or w / 2 + 18, 16, ipr_TCurrentColor, TEXT_ALIGN_CENTER)
    end
    
    Ipr_PrimaryProperty:Dock(FILL)
    Ipr_PrimaryProperty:DockPadding(52, 10, 0, 0)

    local Ipr_Icon = {
        Computer = Material("icon/Ipr_boost_computer.png", "noclamp smooth"),
        Wrench = Material("icon/Ipr_boost_wrench.png", "noclamp smooth"),
    }
    local Ipr_Rotate = {start = 10, s_end = 35, step = 5}
    local Ipr_Copy = table.Copy(Ipr_Rotate)

    Ipr_Copy.NextStep = 0.2
    Ipr_Copy.Update = 0

    Ipr_Copy.Loop = function()
        local Ipr_CurTime = CurTime()

        if (Ipr_CurTime > Ipr_Copy.Update) then
            for i = Ipr_Copy.start, Ipr_Copy.s_end, Ipr_Copy.step do
                Ipr_Copy.start = i + Ipr_Copy.step

                if (i == Ipr_Copy.s_end) then
                    local Ipr_min = (Ipr_Copy.step < 0)

                    Ipr_Copy.start = Ipr_min and Ipr_Rotate.start or Ipr_Copy.s_end
                    Ipr_Copy.s_end = Ipr_min and Ipr_Rotate.s_end or Ipr_Rotate.start
                    Ipr_Copy.step = Ipr_min and Ipr_Rotate.step or -Ipr_Rotate.step
                end
                break
            end
            Ipr_Copy.Update = Ipr_CurTime + Ipr_Copy.NextStep
        end

        return Ipr_Copy.start
    end

    Ipr_Copy.Draw = function(x, y, w, h, rotate, x0)
        local Ipr_Rad = math.rad(rotate)
        local Ipr_Cos, Ipr_Sin = math.cos(Ipr_Rad), math.sin(Ipr_Rad)
        local Ipr_Newx = Ipr_Sin - x0 * Ipr_Cos
        local Ipr_NewY = Ipr_Cos + x0 * Ipr_Sin

        surface.DrawTexturedRectRotated(x + Ipr_Newx, y + Ipr_NewY, w, h, rotate)
    end

    Ipr_PrimaryProperty.Paint = function(self, w, h)
        local Ipr_FpsCurrent, Ipr_FpsMin, Ipr_FpsMax, Ipr_FpsLow = Ipr.Func.FpsCalculator()

        draw.SimpleText(Ipr.Settings.Status.Name, Ipr.Settings.Font, w / 2, h / 2 - 63, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].FpsCurrent, Ipr.Settings.Font, w / 2 + 10, h / 2 - 45, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsCurrent, Ipr.Settings.Font, w / 2 + 15, h / 2 - 45, Ipr.Func.ColorTransition(Ipr_FpsCurrent), TEXT_ALIGN_LEFT)

        draw.SimpleText(Ipr.Settings.Fps.Max.Name, Ipr.Settings.Font, w / 2 + 10, h / 2 - 30, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsMax, Ipr.Settings.Font, w / 2 + 13, h / 2 - 30, Ipr.Func.ColorTransition(Ipr_FpsMax), TEXT_ALIGN_LEFT)

        draw.SimpleText(Ipr.Settings.Fps.Min.Name, Ipr.Settings.Font, w / 2 + 5, h / 2 - 15, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsMin, Ipr.Settings.Font, w / 2 + 9, h / 2 - 15, Ipr.Func.ColorTransition(Ipr_FpsMin), TEXT_ALIGN_LEFT)

        draw.SimpleText(Ipr.Settings.Fps.Low.Name, Ipr.Settings.Font, w / 2 + 15, h / 2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsLow, Ipr.Settings.Font, w / 2 + 18, h / 2, Ipr.Func.ColorTransition(Ipr_FpsLow), TEXT_ALIGN_LEFT)

        surface.SetMaterial(Ipr_Icon.Computer)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-10, 0, 350, 235)

        surface.SetMaterial(Ipr_Icon.Wrench)
        surface.SetDrawColor(255, 255, 255, 255)

        local Ipr_Loop = Ipr_Copy.Loop()
        Ipr_Copy.Draw(207, 120, 220, 220, Ipr_Loop, -25)
    end

    Ipr_PrimaryClose:SetPos(282, 2)
    Ipr_PrimaryClose:SetSize(16, 16)
    Ipr_PrimaryClose:SetImage("icon16/cross.png")
    Ipr_PrimaryClose.Paint = nil
    Ipr_PrimaryClose.DoClick = function()
        Ipr.Func.ClosePanel()
    end

    Ipr_PrimaryExternal:SetPos(97, 80)
    Ipr_PrimaryExternal:SetSize(110, 90)
    Ipr_PrimaryExternal:SetText("")
    Ipr.Func.SetToolTip("Improved FPS Booster System " ..Ipr_Fps_Booster.Settings.Version.. " by Inj3", Ipr_PrimaryExternal, true)
    Ipr_PrimaryExternal.Paint = nil
    Ipr_PrimaryExternal.DoClick = function()
        gui.OpenURL(Ipr_Fps_Booster.Settings.ExternalLink)
    end

    Ipr_PrimaryEnabled:SetPos(6, 240)
    Ipr_PrimaryEnabled:SetSize(110, 24)
    Ipr_PrimaryEnabled:SetImage("icon16/tick.png")
    Ipr_PrimaryEnabled:SetText("")
    function Ipr_PrimaryEnabled:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].VEnabled, Ipr.Settings.Font, w / 2 + 3, 3, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimaryEnabled.DoClick = function()
        local Ipr_CheckBox = Ipr.Func.IsChecked()
        if not Ipr_CheckBox then
            return chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].CheckedBox)
        end

        local Ipr_ConvarsEnabled = Ipr.Func.MatchConvar(true)
        if (Ipr_ConvarsEnabled) then
            Ipr.Func.Activate(true)
            Ipr.Func.ResetFps()

            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].PreventCrash)
        else
            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].AEnabled)
        end

        local Ipr_CloseFpsBooster = Ipr.Func.GetConvar("AutoClose")
        if (Ipr_CloseFpsBooster) then
            Ipr.Func.ClosePanel()
        end

        surface.PlaySound("buttons/combine_button7.wav")
    end

    Ipr_PrimaryDisabled:SetPos(184, 240)
    Ipr_PrimaryDisabled:SetSize(110, 24)
    Ipr_PrimaryDisabled:SetImage("icon16/cross.png")
    Ipr_PrimaryDisabled:SetText("")
    function Ipr_PrimaryDisabled:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].VDisabled, Ipr.Settings.Font, w / 2 + 6, 3, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimaryDisabled.DoClick = function()
        local Ipr_ConvarsEnabled = Ipr.Func.MatchConvar(false)
        if (Ipr_ConvarsEnabled) then
            Ipr.Func.Activate(false)
            Ipr.Func.ResetFps()

            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].Optimization)
        else
            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].ADisabled)
        end

        local Ipr_CloseFpsBooster = Ipr.Func.GetConvar("AutoClose")
        if (Ipr_CloseFpsBooster) then
            Ipr.Func.ClosePanel()
        end
        
        surface.PlaySound("buttons/combine_button5.wav")
    end

    Ipr_PrimarySettings:SetPos(200, 38)
    Ipr_PrimarySettings:SetSize(95, 20)
    Ipr_PrimarySettings:SetText("")
    Ipr_PrimarySettings:SetImage("icon16/cog.png")
    Ipr.Func.SetToolTip(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].Options, Ipr_PrimarySettings, true)
    function Ipr_PrimarySettings:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText("Options ", Ipr.Settings.Font, w / 2 + 7, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimarySettings.DoClick = function()
        if IsValid(Ipr.Settings.Vgui.Secondary) then
            return
        end

        Ipr_FpsBooster_Options(Ipr.Settings.Vgui.Primary)
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_PrimaryResetFps:SetPos(77, 192)
    Ipr_PrimaryResetFps:SetSize(150, 20)
    Ipr_PrimaryResetFps:SetText("")
    Ipr_PrimaryResetFps:SetImage("icon16/arrow_refresh.png")
    function Ipr_PrimaryResetFps:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText("Reset FPS max/min", Ipr.Settings.Font, w / 2 + 7, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimaryResetFps.DoClick = function()
        Ipr.Func.ResetFps()

        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_PrimaryLanguage:SetPos(5, 38)
    Ipr_PrimaryLanguage:SetSize(105, 20)
    Ipr_PrimaryLanguage:SetFont(Ipr.Settings.Font)
    Ipr_PrimaryLanguage:SetValue(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].SelectLangue.. " " ..Ipr.Settings.SetLang)
    
    for k, v in pairs(Ipr_Fps_Booster.Lang) do
        Ipr_PrimaryLanguage:AddChoice(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].SelectLangue.. " " ..k, k, false, "materials/flags16/" ..v.Icon)
    end
    Ipr_PrimaryLanguage:SetTextColor(Ipr.Settings.TColor["blanc"])

    function Ipr_PrimaryLanguage:Paint(w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
    end
    Ipr.Func.OverridePaint(Ipr_PrimaryLanguage)

    Ipr_PrimaryLanguage.OnMenuOpened = function(self)
        local Ipr_ComboChild = self:GetChildren()
        for _, v in ipairs(Ipr_ComboChild) do
            v.Paint = function(p, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
            end
            if (v:GetName() == "DPanel") then
               continue
            end

            local Ipr_DPanelChild = v:GetChildren()
            for _, d in ipairs(Ipr_DPanelChild) do
                if (d:GetName() == "DVScrollBar") then
                   continue
                end

                local Ipr_VChild = d:GetChildren()
                for _, y in ipairs(Ipr_VChild) do
                    y:SetTextColor(Ipr.Settings.TColor["blanc"])
                    y:SetFont( Ipr.Settings.Font )
                end
            end
        end
        
        Ipr.Func.OverridePaint(self)
    end
    Ipr_PrimaryLanguage.OnSelect = function(self, index, value)
        local Ipr_SetLang = self.Data[index]
        if (Ipr_SetLang == Ipr.Settings.SetLang) then
            return
        end

        self:Clear()
        self:SetValue(Ipr_Fps_Booster.Lang[Ipr_SetLang].SelectLangue.. " " ..Ipr_SetLang)
        for k, v in pairs(Ipr_Fps_Booster.Lang) do
            self:AddChoice(Ipr_Fps_Booster.Lang[Ipr_SetLang].SelectLangue.. " " ..k, k, false, "materials/flags16/" ..v.Icon)
        end

        Ipr.Settings.SetLang = Ipr_SetLang
        file.Write(Ipr_Fps_Booster.Settings.Save.. "language.json", Ipr_SetLang)
        
        surface.PlaySound("buttons/button9.wav")
    end
end

local Ipr_DefaultCommands = {
    ["/boost"] = {
        Func = function()
            Ipr.Func.CreateData()
            Ipr_FpsBooster()

            return true
        end
    },
    ["/reset"] = {
        Func = function()
            Ipr.Func.ResetFps()
            Ipr.Func.Activate(false)

            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "Improved FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].SReset)
            surface.PlaySound("buttons/combine_button5.wav")

            return true
        end
    },
}

local function Ipr_ChatCmds(ply, text)
    if (ply == LocalPlayer()) then
        text = string.lower(text)

        if (Ipr_DefaultCommands[text]) then
            Ipr_DefaultCommands[text].Func()
        end
    end
end

local function Ipr_InitPostPlayer()
    Ipr.Func.CreateData()
    
    timer.Create("IprFpsBooster_Startup", 5, 1, function()
        local Ipr_Startup = Ipr.Func.GetConvar("Startup")
        Ipr.Func.Activate(Ipr_Startup)
        if (Ipr_Startup) then
            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "Improved FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupEnabled)
        end
        
        local Ipr_ForcedOpen = Ipr.Func.GetConvar("ForcedOpen")
        if (Ipr_ForcedOpen) and not IsValid(Ipr.Settings.Vgui.Primary) then
            Ipr_FpsBooster()
        end
        
        local Ipr_EnabledFog = Ipr.Func.GetConvar("EnabledFog")
        if (Ipr_EnabledFog) then
           Ipr.Func.FogActivate(Ipr_EnabledFog)
           chat.AddText(Ipr.Settings.TColor["rouge"], "[", "Improved FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].FogEnabled)
        end
    end)
end

local function Ipr_PlayerShutDown()
    if timer.Exists(Ipr.Settings.StartupLaunch.Name) then
        print(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang].StartupAbandoned)
    end
end

local Ipr_Map = game.GetMap()
local Ipr_Escape = 5

local function Ipr_DrawMultipleTextAligned(tbl)
    local Ipr_OldWide = 0
    local Ipr_NewWide = 0

    for t = 1, #tbl do
        local Ipr_TextTbl = tbl[t]
        local FirstText = (t == 1)
        local Ipr_Pos = Ipr_TextTbl.Pos

        for i = 1, #Ipr_TextTbl do
            local Ipr_NameText = Ipr_TextTbl[i].Name

            surface.SetFont(Ipr.Settings.Font)
            local Ipr_TWide = surface.GetTextSize(Ipr_NameText)

            if not FirstText or (i > 1) then
               Ipr_NewWide = Ipr_OldWide
            end
            Ipr_OldWide = Ipr_OldWide + Ipr_TWide + Ipr_Escape

            draw.SimpleText(Ipr_NameText, Ipr.Settings.Font, Ipr_Pos.PWide + Ipr_NewWide, Ipr_Pos.PHeight, Ipr_TextTbl[i].FColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end

        Ipr_OldWide = 0
    end
end

local function Ipr_HUD()
    local Ipr_HudEnable = Ipr.Func.GetConvar("FpsView")
    if not Ipr_HudEnable then
        return
    end

    local Ipr_FpsCurrent, Ipr_FpsMin, Ipr_FpsMax, Ipr_FpsLow = Ipr.Func.FpsCalculator()
    local Ipr_HHeight = Ipr_Height * Ipr.Func.GetConvar("FpsPosHeight") / 100
    local Ipr_HWide = Ipr_Wide * Ipr.Func.GetConvar("FpsPosWidth") / 100
    local Ipr_PlayerPing = LocalPlayer():Ping()
    
    local Ipr_RenderFpsText = {
        {
           {Name = "FPS :", FColor = color_white},
           {Name = Ipr_FpsCurrent, FColor = Ipr.Func.ColorTransition(Ipr_FpsCurrent)},
           {Name = "|", FColor = color_white},
           {Name = "Min :", FColor = color_white},
           {Name = Ipr_FpsMin, FColor = Ipr.Func.ColorTransition(Ipr_FpsMin)},
           {Name = "|", FColor = color_white},
           {Name = "Max :", FColor = color_white},
           {Name = Ipr_FpsMax, FColor = Ipr.Func.ColorTransition(Ipr_FpsMax)},
           {Name = "|", FColor = color_white},
           {Name = "Low 1% :", FColor = color_white},
           {Name = Ipr_FpsLow, FColor = Ipr.Func.ColorTransition(Ipr_FpsMax)},

           Pos = {PWide = Ipr_HWide, PHeight = Ipr_HHeight},
        },

        {
           {Name = "Map :", FColor = color_white},
           {Name = Ipr_Map, FColor = Ipr.Settings.TColor["bleu"]},
           {Name = "|", FColor = color_white},
           {Name = "Ping :", FColor = color_white},
           {Name = Ipr_PlayerPing, FColor = Ipr.Settings.TColor["bleu"]},

           Pos = {PWide = Ipr_HWide - 1, PHeight = Ipr_HHeight + 20},
        },
    }

    Ipr_DrawMultipleTextAligned(Ipr_RenderFpsText)
end

local function Ipr_OnScreenSize()
    Ipr_Wide, Ipr_Height = ScrW(), ScrH()
end

hook.Add("ShutDown", "IprFpsBooster_ShutDown", Ipr_PlayerShutDown)
hook.Add("PostDrawHUD", "IprFpsBooster_HUD", Ipr_HUD)
hook.Add("OnScreenSizeChanged", "IprFpsBooster_OnScreen", Ipr_OnScreenSize)
hook.Add("InitPostEntity", "IprFpsBooster_InitPlayer", Ipr_InitPostPlayer)
hook.Add("OnPlayerChat", "IprFpsBooster_ChatCmds", Ipr_ChatCmds)
