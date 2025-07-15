// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local Ipr = {}

Ipr.Settings = include("table.lua")
Ipr.Function = {}

Ipr.Function.CreateData = function()
    local Ipr_CreateDir = file.Exists(Ipr.Settings.Save, "DATA")
    if not Ipr_CreateDir then
        file.CreateDir(Ipr.Settings.Save)
    end

    local Ipr_FileLangs, Ipr_SetLang = file.Exists(Ipr.Settings.Save.. "language.json", "DATA")
    if not Ipr_FileLangs then
        local Ipr_FileCountry = file.Exists("ipr_fps_booster_language/fr.lua", "LUA")
        if (Ipr_FileCountry) then
            local Ipr_GetCountry = system.GetCountry()
            Ipr_SetLang = (Ipr_GetCountry) and Ipr.Settings.Country[Ipr_GetCountry] and "FR"
        end
        Ipr_SetLang = (Ipr_SetLang) or Ipr.Function.SearchLang()

        file.Write(Ipr.Settings.Save.. "language.json", Ipr_SetLang)
    end
    Ipr.Settings.SetLang = (Ipr_SetLang) or file.Read(Ipr.Settings.Save.. "language.json", "DATA")

    local Ipr_FileConvars, Ipr_SetConvars = file.Exists(Ipr.Settings.Save.. "convars.json", "DATA")
    if not Ipr_FileConvars then
        Ipr_SetConvars = {}

        local Ipr_ConvarsLists = Ipr_Fps_Booster.Defaultconvars
        for i = 1, #Ipr_ConvarsLists do
            Ipr_SetConvars[#Ipr_SetConvars + 1] = {
                Name = Ipr_ConvarsLists[i].Name,
                Checked = Ipr_ConvarsLists[i].DefaultCheck
            }
        end

        local Ipr_SettingsLists = Ipr_Fps_Booster.Defaultsettings
        for i = 1, #Ipr_SettingsLists do
            Ipr_SetConvars[#Ipr_SetConvars + 1] = {
                Vgui = Ipr_SettingsLists[i].Vgui,
                Name = Ipr_SettingsLists[i].Name,
                Checked = Ipr_SettingsLists[i].DefaultCheck
            }
        end

        file.Write(Ipr.Settings.Save.. "convars.json", util.TableToJSON(Ipr_SetConvars))
    end
    Ipr_Fps_Booster.Convars = (Ipr_SetConvars) or util.JSONToTable(file.Read(Ipr.Settings.Save.. "convars.json", "DATA"))
end

Ipr.Function.SearchLang = function()
    local Ipr_SearchLang = file.Find("ipr_fps_booster_language/*", "LUA")

    for i = 1, #Ipr_SearchLang do
        local Ipr_Lang = Ipr_SearchLang[i]
        local Ipr_Size = file.Size("ipr_fps_booster_language/" ..Ipr_Lang, "LUA")

        if (Ipr_Size ~= 0) then
            return string.upper(string.gsub(Ipr_Lang, ".lua", ""))
        end
    end
end

Ipr.Function.GetConvar = function(name)
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

Ipr.Function.SetConvar = function(name, value, save, exist, copy)
    local Ipr_Convar = (Ipr.Function.GetConvar(name) == nil)

    if (Ipr_Convar) then
        Ipr_Fps_Booster.Convars[#Ipr_Fps_Booster.Convars + 1] = {
            Name = name,
            Checked = value,
        }
        file.Write(Ipr.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))

        if (Ipr.Settings.Debug) then
            print("Creating a new convar : " ..name, value, save)
        end
        if (copy) then
            Ipr.Function.CopyData()
        end
    else
        if (exist) then
            return
        end

        for i = 1, #Ipr_Fps_Booster.Convars do
            local Ipr_ToggleCount = Ipr_Fps_Booster.Convars[i]

            if (Ipr_ToggleCount.Name == name) then
                Ipr_Fps_Booster.Convars[i].Checked = value
                break
            end
        end

        if (save == 1) then
            local Ipr_SaveConvar = "IprFpsBooster_SetConvar"
            if (timer.Exists(Ipr_SaveConvar)) then
                timer.Remove(Ipr_SaveConvar)
            end

            timer.Create(Ipr_SaveConvar, 1, 1, function()
                file.Write(Ipr.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
            end)
        elseif (save == 2) then
            file.Write(Ipr.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
        end
    end
end

Ipr.Function.InfoNum = function(cmd, exist)
    local Ipr_InfoNum = LocalPlayer():GetInfoNum(cmd, -99)
    if (exist) then
        return (Ipr_InfoNum == -99)
    end

    return tonumber(Ipr_InfoNum)
end

Ipr.Function.MatchConvar = function(bool)
    local Ipr_ConvarsCheck = bool

    for i = 1, #Ipr_Fps_Booster.Defaultconvars do
        local Ipr_NameCommand = Ipr_Fps_Booster.Defaultconvars[i].Name
        local Ipr_ConvarCommand = Ipr_Fps_Booster.Defaultconvars[i].Convars

        for k, v in pairs(Ipr_ConvarCommand) do
            if isbool(Ipr.Function.GetConvar(Ipr_NameCommand)) then
                if (bool) then
                    Ipr_ConvarsCheck = Ipr.Function.GetConvar(Ipr_NameCommand)
                end

                local Ipr_Toggle = (Ipr_ConvarsCheck) and v.Enabled or v.Disabled
                Ipr_Toggle = tonumber(Ipr_Toggle)

                local Ipr_InfoCmds = Ipr.Function.InfoNum(k)
                if Ipr.Function.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Toggle) then
                    continue
                end

                return true
            end
        end
    end

    return false
end

Ipr.Function.IsChecked = function()
    for i = 1, #Ipr_Fps_Booster.Convars do
        if not Ipr_Fps_Booster.Convars[i].Vgui and (Ipr_Fps_Booster.Convars[i].Checked == true) then
            return true
        end
    end
    
    return false
end

Ipr.Function.CurrentState = function()
    return Ipr.Settings.Status.State
end

Ipr.Function.Activate = function(bool)
    local Ipr_ConvarsCheck = bool

    for i = 1, #Ipr_Fps_Booster.Defaultconvars do
        local Ipr_NameCommand = Ipr_Fps_Booster.Defaultconvars[i].Name
        local Ipr_ConvarCommand = Ipr_Fps_Booster.Defaultconvars[i].Convars

        for k, v in pairs(Ipr_ConvarCommand) do
            if isbool(Ipr.Function.GetConvar(Ipr_NameCommand)) then
                if (bool) then
                    Ipr_ConvarsCheck = Ipr.Function.GetConvar(Ipr_NameCommand)
                end

                local Ipr_Toggle = (Ipr_ConvarsCheck) and v.Enabled or v.Disabled
                Ipr_Toggle = tonumber(Ipr_Toggle)

                local Ipr_InfoCmds = Ipr.Function.InfoNum(k)
                if Ipr.Function.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Toggle) then
                    continue
                end

                RunConsoleCommand(k, Ipr_Toggle)

                if (Ipr.Settings.Debug) then
                    print("Updating " ..k.. " set " ..Ipr_InfoCmds.. " to " ..Ipr_Toggle)
                end
            end
        end
    end

    Ipr.Settings.Status.State = bool
end

Ipr.Function.FpsCalculator = function()
    local Ipr_SysTime = SysTime()

    if (Ipr_SysTime > (Ipr.CurNext or 0)) then
        local Ipr_AbsoluteFrameTime = engine.AbsoluteFrameTime()
        
        Ipr.Settings.FpsCurrent = math.Round(1 / Ipr_AbsoluteFrameTime)
        Ipr.Settings.FpsCurrent = (Ipr.Settings.FpsCurrent > 999) and 999 or Ipr.Settings.FpsCurrent

        if (Ipr.Settings.FpsCurrent < Ipr.Settings.Fps.Min.Int) then
            Ipr.Settings.Fps.Min.Int = Ipr.Settings.FpsCurrent
        end
        if (Ipr.Settings.FpsCurrent > (Ipr.Settings.Fps.Max.Int ~= Ipr.Settings.Infinity and Ipr.Settings.Fps.Max.Int or 0)) then
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

        Ipr.CurNext = Ipr_SysTime + 0.3
    end

    return Ipr.Settings.FpsCurrent, Ipr.Settings.Fps.Min.Int, Ipr.Settings.Fps.Max.Int, Ipr.Settings.Fps.Low.InProgress
end

Ipr.Function.CopyData = function()
    local Ipr_TypeData = {}
    local Ipr_DataName = {
        ["Startup"] = true,
    }

    for i = 1, #Ipr_Fps_Booster.Convars do
        local Ipr_CopyList = Ipr_Fps_Booster.Convars[i]

        if not Ipr_DataName[Ipr_CopyList.Name] and not Ipr_CopyList.Vgui then
            Ipr_TypeData[#Ipr_TypeData + 1] = Ipr_CopyList
        end
    end

    Ipr.Settings.Data = {
        Copy = table.Copy(Ipr_TypeData), 
        Set = false,
    }
end

Ipr.Function.GetCopyData = function()
    return Ipr.Settings.Data.Copy
end

Ipr.Function.ResetFps = function()
    Ipr.Settings.Fps.Min.Int = Ipr.Settings.Infinity
    Ipr.Settings.Fps.Max.Int = 0
end

Ipr.Function.ColorTransition = function(int)
    return (int <= 30) and Ipr.Settings.TColor["rouge"] or (int > 30 and int <= 50) and Ipr.Settings.TColor["orange"] or Ipr.Settings.TColor["vert"]
end

Ipr.Function.OverridePaint = function(panel)
    local Ipr_PanelChild = panel:GetChildren()

    local Ipr_Override = {
        ["DPanel"] = function(frame)
            frame.Paint = function(self, w, h)
                local Ipr_ArrowRight = {
                    {x = w / 2, y = h / 2 - 8 / 2},
                    {x = w / 2 + 5, y = h / 2},
                    {x = w / 2, y = h / 2 + 8 / 2},
                }
            
                surface.SetDrawColor(ColorAlpha(color_white, 170))
                draw.NoTexture()
                surface.DrawPoly(Ipr_ArrowRight)
            end
        end,
        ["DSlider"] = function(frame)
            for i = 1, #Ipr_PanelChild do
                local Ipr_CPanel = Ipr_PanelChild[i]
                local Ipr_CNamePanel = Ipr_CPanel:GetName()
                
                if (Ipr_CNamePanel == "DTextEntry") then
                    Ipr_CPanel:SetFont(Ipr.Settings.Font)
                    Ipr_CPanel:SetTextColor(Ipr.Settings.TColor["blanc"])
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
                local Ipr_FrameChecked = frame:GetChecked()
                
                draw.RoundedBox(6, 0, 0, w, h, (Ipr_FrameChecked) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"])
                draw.RoundedBox(12, 7, 7, 2, 2, (Ipr_FrameChecked) and Ipr.Settings.TColor["blanc"] or color_black)
            end
        end,
    }

    for i = 1, #Ipr_PanelChild do
        local Ipr_CPanel = Ipr_PanelChild[i]
        local Ipr_CNamePanel = Ipr_CPanel:GetName()

        local Ipr_FindClass = Ipr_Override[Ipr_CNamePanel]
        if (Ipr_FindClass) then
            Ipr_FindClass(Ipr_CPanel)
        end
    end
end

Ipr.Function.RenderBlur = function(panel, colors, border)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(Ipr.Settings.Blur)

    local Ipr_Posx, Ipr_Posy = panel:LocalToScreen(0, 0)
    Ipr.Settings.Blur:SetFloat("$blur", 1.5)
    Ipr.Settings.Blur:Recompute()

    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(Ipr_Posx * -1, Ipr_Posy * -1, Ipr.Settings.Pos.w, Ipr.Settings.Pos.h)

    local Ipr_VguiWide = panel:GetWide()
    local Ipr_VguiHeight = panel:GetTall()

    draw.RoundedBoxEx(border, 0, 0, Ipr_VguiWide, Ipr_VguiHeight, colors, true, true, true, true)
end

Ipr.Function.SetToolTip = function(text, panel, hover)
    if not IsValid(Ipr.Settings.Vgui.ToolTip) then
        Ipr.Settings.Vgui.ToolTip = vgui.Create("DTooltip")
        Ipr.Settings.Vgui.ToolTip:SetText("")
        Ipr.Settings.Vgui.ToolTip:SetTextColor(color_white)
        Ipr.Settings.Vgui.ToolTip:SetFont(Ipr.Settings.Font)

        Ipr.Settings.Vgui.ToolTip.Paint = function(self, w, h)
            Ipr.Function.RenderBlur(self, ColorAlpha(color_black, 130), 6)
        end

        Ipr.Settings.Vgui.ToolTip:SetVisible(false)
    end

    if not IsValid(panel) then
        return
    end
    
    local Ipr_OverrideChildren = panel:GetChildren()
    local Ipr_WhiteListPanel = {
        ["DButton"] = true,
        ["DImageButton"] = true,
    }

    if (Ipr_WhiteListPanel[panel:GetName()]) then
        Ipr_OverrideChildren[#Ipr_OverrideChildren + 1] = panel
    end

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

            Ipr.Settings.Vgui.ToolTip:SetText((hover) and text or Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang][text])
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

Ipr.Function.FogActivate = function(bool)
    if not bool then
        hook.Remove("SetupWorldFog", "IprFpsBooster_WorldFog")
        hook.Remove("SetupSkyboxFog", "IprFpsBooster_SkyboxFog")
    else
        hook.Add("SetupWorldFog", "IprFpsBooster_WorldFog", function()
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(Ipr.Function.GetConvar("FogStart"))
            render.FogEnd(Ipr.Function.GetConvar("FogEnd"))
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)

        hook.Add("SetupSkyboxFog", "IprFpsBooster_SkyboxFog", function(scale)
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(Ipr.Function.GetConvar("FogStart") * scale)
            render.FogEnd(Ipr.Function.GetConvar("FogEnd") * scale)
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)
    end
end

Ipr.Function.DrawMultipleTextAligned = function(tbl)
    local Ipr_OldWide = 0
    local Ipr_NewWide = 0

    for t = 1, #tbl do
        local Ipr_TextTbl = tbl[t]
        local Ipr_Pos = Ipr_TextTbl.Pos

        for i = 1, #Ipr_TextTbl do
            Ipr_NewWide = Ipr_OldWide

            surface.SetFont(Ipr.Settings.Font)

            local Ipr_NameText = Ipr_TextTbl[i].Name
            local Ipr_TWide = surface.GetTextSize(Ipr_NameText)

            Ipr_OldWide = Ipr_OldWide + Ipr_TWide + Ipr.Settings.Escape

            draw.SimpleText(Ipr_NameText, Ipr.Settings.Font, Ipr_Pos.PWide + Ipr_NewWide, Ipr_Pos.PHeight, Ipr_TextTbl[i].FColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end

        Ipr_OldWide = 0
    end
end

Ipr.Function.OverrideVgui = {
    ["DCheckBoxLabel"] = {
        Function = function(panel, box, hud)
            panel.Paint = function(self, w, h)
                draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang][box.Localization.Text], Ipr.Settings.Font, 22, 4, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
            end

            panel:SetValue(Ipr.Function.GetConvar(box.Name))
            panel:SetWide(210)
            panel:Dock(FILL)

            local Ipr_Name = box.Name
            panel.OnChange = function(self)
                local Ipr_GetChecked = self:GetChecked()
                Ipr.Function.SetConvar(Ipr_Name, Ipr_GetChecked, 1)

                for i = 1, #Ipr.Settings.Vgui.CheckBox do
                    if (Ipr.Settings.Vgui.CheckBox[i].Paired == Ipr_Name) then
                        local Ipr_Vgui = Ipr.Settings.Vgui.CheckBox[i].Vgui
                        Ipr_Vgui = Ipr_Vgui:GetParent()

                        if IsValid(Ipr_Vgui) then
                            Ipr_Vgui:SetDisabled(not Ipr_GetChecked)
                        end
                    end
                end

                if (box.Run_HookFog) then
                    Ipr.Function.FogActivate(Ipr_GetChecked)
                elseif (box.Run_HookFps) then
                    if (Ipr_GetChecked) then
                        hook.Add("PostDrawHUD", "IprFpsBooster_HUD", hud)
                    else
                        hook.Remove("PostDrawHUD", "IprFpsBooster_HUD", hud)
                    end
                elseif (box.Run_Debug) then
                    Ipr.Settings.Debug = Ipr_GetChecked
                end
            end
        end,

        Parent = function(panel)
            local Ipr_CheckBoxConfig = vgui.Create("DPanel", panel)
            Ipr_CheckBoxConfig:SetSize(225, 25)
            Ipr_CheckBoxConfig:Dock(TOP)
            Ipr_CheckBoxConfig.Paint = nil

            return Ipr_CheckBoxConfig
        end,
    },
    ["DNumSlider"] = {
        Function = function(panel, box)
            local Ipr_Parent = panel:GetParent()
            Ipr_Parent.Paint = function(self, w, h)
                draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr.Settings.SetLang][box.Localization.Text].. " [" ..math.Round(panel:GetValue()).. "]", Ipr.Settings.Font, w / 2, 0, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
            end

            local Ipr_DNumChildren = panel:GetChildren()
            local Ipr_PrimaryWide = Ipr_Parent:GetWide()
            local Ipr_OverrideSlider = {
                ["DSlider"] = function(slide)
                    slide:Dock(FILL)
                    slide:SetSize(Ipr_PrimaryWide, 25)
                end,
                ["DLabel"] = function(slide)
                    slide:GetChildren()[1]:SetVisible(false)
                    slide:SetVisible(false)
                end,
                ["DTextEntry"] = function(slide)
                    slide:SetVisible(false)
                end,
            }

            for i = 1, #Ipr_DNumChildren do
                local Ipr_CDNumChild = Ipr_DNumChildren[i]
                local Ipr_CNumPanel = Ipr_CDNumChild:GetName()
                local Ipr_FuncSlider = Ipr_OverrideSlider[Ipr_CNumPanel]

                if (Ipr_FuncSlider) then
                    Ipr_FuncSlider(Ipr_CDNumChild)
                end
            end

            panel:SetSize(Ipr_PrimaryWide, 25)
            panel:Dock(BOTTOM)
            panel:SetMinMax(0, box.Max or 100)
            panel:SetValue(Ipr.Function.GetConvar(box.Name))
            panel:SetDecimals(0)

            panel.OnValueChanged = function(self)
                Ipr.Function.SetConvar(box.Name, self:GetValue(), 1)
            end
        end,

        Parent = function(panel)
            local Ipr_DNumConfig = vgui.Create("DPanel", panel)
            Ipr_DNumConfig:SetSize(225, 39)
            Ipr_DNumConfig:Dock(TOP)

            return Ipr_DNumConfig
        end,
    },
}

return Ipr
