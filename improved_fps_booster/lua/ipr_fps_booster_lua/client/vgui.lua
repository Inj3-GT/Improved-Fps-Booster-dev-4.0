// SCRIPT BY Inj3 
// https://steamcommunity.com/id/Inj3/
// General Public License v3.0
// https://github.com/Inj3-GT

local Ipr = {}

Ipr.Settings = {
    Status = false,
    Fps = 0,
    Blur = Material("pp/blurscreen"),
    Updated = {},
    FpsDefault =  {Max = {Int = 0, Name = "Max : "}, Current = {Int = 0}, Min = {Int = math.huge, Name = "Min : "}, Gain = {Int = 0, Name = "Gain : "}, Status = {Name = "FPS Status"}},
    TColor = {["vert"] = Color(39, 174, 96), ["rouge"] = Color(192, 57, 43), ["orange"] = Color(226, 149, 25), ["orangec"] = Color(175, 118, 27), ["blanc"] = Color(236, 240, 241), ["bleu"] = Color(52, 73, 94), ["bleuc"] = Color(27, 66, 99)},
    Country = {["BE"] = true, ["FR"] = true, ["DZ"] = true, ["MA"] = true, ["CA"] = true},
    Vgui = {Primary = false, Secondary = false},
    StartupLaunch = {Name = "IprFpsBooster_ApplyToStartup", Delay = 300},
}

local Ipr_Language = Ipr_Fps_Booster.Settings.Language

Ipr.Settings.FpsCopy = table.Copy(Ipr.Settings.FpsDefault)
Ipr.Func = {}

Ipr.Func.CreateData = function(reset)
    local Ipr_CreateDir = file.Exists(Ipr_Fps_Booster.Settings.Save, "DATA")
    if not Ipr_CreateDir then
        file.CreateDir(Ipr_Fps_Booster.Settings.Save)
    end

    local Ipr_FileLangs = file.Exists(Ipr_Fps_Booster.Settings.Save.. "language.json", "DATA")
    local Ipr_TCountry = false
    if not Ipr_FileLangs then
        local Ipr_GCountry = not game.IsDedicated() and system.GetCountry()
        Ipr_TCountry = (Ipr_GCountry) and Ipr.Settings.Country[Ipr_GCountry] and "FR" or Ipr_Fps_Booster.Settings.Language

        file.Write(Ipr_Fps_Booster.Settings.Save.. "language.json", Ipr_TCountry)
    end
    Ipr_Language = Ipr_TCountry or file.Read(Ipr_Fps_Booster.Settings.Save.. "language.json", "DATA") or Ipr_Fps_Booster.Settings.Language

    local Ipr_FileConvars = file.Exists(Ipr_Fps_Booster.Settings.Save.. "convars.json", "DATA")
    local Ipr_TData = false
    if (reset) or not Ipr_FileConvars then
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
    Ipr_Fps_Booster.Settings.Convars = Ipr_TData or util.JSONToTable(file.Read(Ipr_Fps_Booster.Settings.Save.. "convars.json", "DATA"))
end

Ipr.Func.GetConvar = function(name)
    for i = 1, #Ipr_Fps_Booster.Settings.Convars do
        local Ipr_Convars = Ipr_Fps_Booster.Settings.Convars[i]

        if (Ipr_Convars.Name == name) then
            return Ipr_Convars.Checked
        end
    end

    return nil, print("Convar not found !", " " ..name)
end

Ipr.Func.SetConvar = function(name, value, save)
    local Ipr_ConvarExists = (Ipr.Func.GetConvar(name) == nil)
    if (Ipr_ConvarExists) then
        Ipr_Fps_Booster.Settings.Convars[#Ipr_Fps_Booster.Settings.Convars + 1] = {
            Name = name,
            Checked = value,
        }
        
        file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Settings.Convars))
        print("Creating new convar : " ..name, value, save)
    end

    for i = 1, #Ipr_Fps_Booster.Settings.Convars do
        local Ipr_ToggleCount = Ipr_Fps_Booster.Settings.Convars[i] 

        if (Ipr_ToggleCount.Name == name) then
            Ipr_Fps_Booster.Settings.Convars[i].Checked = value
            break
        end
    end

    if (save == 1) then
        if timer.Exists("Ipr_Fps_Booster_SetConvar") then
            timer.Remove("Ipr_Fps_Booster_SetConvar")
        end

        timer.Create("Ipr_Fps_Booster_SetConvar", 1, 1, function()
            file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Settings.Convars))
        end)
    elseif (save == 2) then
        file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Settings.Convars))
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
    for i = 1, #Ipr_Fps_Booster.DefaultCommands do
        local Ipr_NameCommand = Ipr_Fps_Booster.DefaultCommands[i].Name
        local Ipr_ConvarCommand = Ipr_Fps_Booster.DefaultCommands[i].Convars

        for k, v in pairs(Ipr_ConvarCommand) do
            if isbool(Ipr.Func.GetConvar(Ipr_NameCommand)) then
                local Ipr_Auto = (bool) and v.Enabled or v.Disabled
                Ipr_Auto = tonumber(Ipr_Auto)

                local Ipr_InfoCmds = Ipr.Func.InfoNum(k)
                if Ipr.Func.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Auto) then
                    continue
                end

                return true
            end
        end
    end

    return false
end

Ipr.Func.IsChecked = function()
    for i = 1, #Ipr_Fps_Booster.Settings.Convars do
        if not Ipr_Fps_Booster.Settings.Convars[i].Vgui and (Ipr_Fps_Booster.Settings.Convars[i].Checked == true) then
            return true
        end
    end
    
    return false
end

Ipr.Func.Activate = function(bool)
    for i = 1, #Ipr_Fps_Booster.DefaultCommands do
        local Ipr_NameCommand = Ipr_Fps_Booster.DefaultCommands[i].Name

        for k, v in pairs(Ipr_Fps_Booster.DefaultCommands[i].Convars) do
            if isbool(Ipr.Func.GetConvar(Ipr_NameCommand)) then
                local Ipr_Auto = (bool) and v.Enabled or v.Disabled
                Ipr_Auto = tonumber(Ipr_Auto)

                local Ipr_InfoCmds = Ipr.Func.InfoNum(k)
                if Ipr.Func.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Auto) then
                    continue
                end

                LocalPlayer():ConCommand(k.. " " ..Ipr_Auto)
                print("Convar " ..k.. " defini " ..Ipr_InfoCmds.. " à " ..Ipr_Auto.. " à était mise à jour")
            end
        end
    end

    Ipr.Func.SetStatus(bool)
end

Ipr.Func.FpsCalculator = function()
    local Ipr_CurTime = CurTime()

    if (Ipr_CurTime > (Ipr.CurNext or 0)) then
        Ipr.Settings.Fps = math.Round(1 / FrameTime())
        Ipr.Settings.Fps = math.abs(Ipr.Settings.Fps) > 999 and 999 or Ipr.Settings.Fps

        if (Ipr.Settings.Fps < Ipr.Settings.FpsCopy.Min.Int) then
            Ipr.Settings.FpsCopy.Min.Int = Ipr.Settings.Fps
        end
        if (Ipr.Settings.Fps > (Ipr.Settings.FpsCopy.Max.Int ~= math.huge and Ipr.Settings.FpsCopy.Max.Int or 0)) then
            Ipr.Settings.FpsCopy.Max.Int = Ipr.Settings.Fps
        end

        local Ipr_Status = Ipr.Func.CurrentStatus()
        if not Ipr_Status then
            Ipr.Settings.FpsCopy.Current.Int = Ipr.Settings.FpsCopy.Max.Int
        end
        if (Ipr.Settings.FpsCopy.Max.Int > Ipr.Settings.FpsCopy.Current.Int) then
            Ipr.Settings.FpsCopy.Gain.Int = Ipr.Settings.FpsCopy.Max.Int - Ipr.Settings.FpsCopy.Current.Int
        end

        Ipr.CurNext = Ipr_CurTime + 0.3
    end

    return Ipr.Settings.Fps, Ipr.Settings.FpsCopy.Min.Int, Ipr.Settings.FpsCopy.Max.Int, Ipr.Settings.FpsCopy.Gain.Int
end

Ipr.Func.ResetFps = function(reset)
    if not reset then
        Ipr.Settings.FpsCopy.Current.Int = Ipr.Settings.FpsDefault.Current.Int
    end

    Ipr.Settings.FpsCopy.Min.Int = Ipr.Settings.FpsDefault.Min.Int
    Ipr.Settings.FpsCopy.Max.Int = Ipr.Settings.FpsDefault.Max.Int
    Ipr.Settings.FpsCopy.Gain.Int = Ipr.Settings.FpsDefault.Gain.Int
end

Ipr.Func.SetStatus = function(bool)
    Ipr.Settings.Status = bool
end

Ipr.Func.CurrentStatus = function()
    return Ipr.Settings.Status
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
                     ent:SetFont("Ipr_Fps_Booster_Font")
                     ent:SetTextColor(Ipr.Settings.TColor["blanc"])
                end
            end

            frame.Knob.Paint = function(self, w, h)
                draw.RoundedBox(3, 5, 0, w - 10, h, Ipr.Settings.TColor["vert"])
            end
            frame.Paint = function(self, w, h)
                draw.RoundedBox(3, 7, h / 2 - 2, w - 12, h / 2 - 10, Ipr.Settings.TColor["rouge"])

                draw.RoundedBox(5, 7, 5, 3, h - 10, Ipr.Settings.TColor["rouge"])
                draw.RoundedBox(5, w - 8, 5, 3, h - 10, Ipr.Settings.TColor["rouge"])
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

Ipr.Func.RenderBlur = function(panel, colors, border)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(Ipr.Settings.Blur)

    local Ipr_Posx, Ipr_Posy = panel:LocalToScreen(0, 0)
    Ipr.Settings.Blur:SetFloat("$blur", 1.5)
    Ipr.Settings.Blur:Recompute()

    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(Ipr_Posx * -1, Ipr_Posy * -1, ScrW(), ScrH())

    local Ipr_VguiWide = panel:GetWide()
    local Ipr_VguiHeight = panel:GetTall()

    draw.RoundedBoxEx(border, 0, 0, Ipr_VguiWide, Ipr_VguiHeight, colors, true, true, true, true)
end

Ipr.Func.ClosePanel = function()
    if IsValid(Ipr.Settings.Vgui.Secondary) then
        Ipr.Settings.Vgui.Secondary:Remove()
    end
    if IsValid(Ipr.Settings.Vgui.Primary) then
        Ipr.Settings.Vgui.Primary:Remove()
    end
end

local function Ipr_FpsBooster_Options(primary, fast)
    if IsValid(Ipr.Settings.Vgui.Secondary) then
        Ipr.Settings.Vgui.Secondary:Remove()
    end

    Ipr.Settings.Vgui.Secondary = vgui.Create("DFrame")

    Ipr.Settings.Vgui.Secondary:SetTitle("")
    Ipr.Settings.Vgui.Secondary:SetSize(240, 450)
    Ipr.Settings.Vgui.Secondary:MakePopup()
    Ipr.Settings.Vgui.Secondary:ShowCloseButton(false)
    Ipr.Settings.Vgui.Secondary:SetDraggable(true)

    if not fast then
        Ipr.Settings.Vgui.Secondary:AlphaTo(5, 0, 0)
        Ipr.Settings.Vgui.Secondary:AlphaTo(255, 1, 0)
    end

    if IsValid(primary) then
        local Ipr_CenterSecondaryW = primary:GetX() + primary:GetWide() + 10
        local Ipr_CenterSecondaryH = primary:GetY() - (Ipr.Settings.Vgui.Secondary:GetTall() / 2)
        Ipr_CenterSecondaryH = Ipr_CenterSecondaryH + (primary:GetTall() / 2)

        Ipr.Settings.Vgui.Secondary:SetPos(Ipr_CenterSecondaryW, Ipr_CenterSecondaryH)
    else
        Ipr.Settings.Vgui.Secondary:Center()
    end
    
    Ipr.Settings.Vgui.Secondary.Paint = function(self, w, h)
        if (self.Dragging) and IsValid(primary) then
            local Ipr_CenterPrimaryW = Ipr.Settings.Vgui.Secondary:GetX() - primary:GetWide() - 10
            local Ipr_CenterPrimaryH = Ipr.Settings.Vgui.Secondary:GetY() + (Ipr.Settings.Vgui.Secondary:GetTall() / 2)
            Ipr_CenterPrimaryH = Ipr_CenterPrimaryH - (primary:GetTall() / 2)

            primary:SetPos(Ipr_CenterPrimaryW, Ipr_CenterPrimaryH)
        end

        Ipr.Func.RenderBlur(self, ColorAlpha(color_black, 130), 8)
        
        draw.RoundedBoxEx(6, 0, 0, w, 20, Ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText("Options FPS Booster", "Ipr_Fps_Booster_Font", w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("FPS Limit : ", "Ipr_Fps_Booster_Font", 5, h - 17, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)

        local Ipr_FpsLimit = math.Round(Ipr.Func.InfoNum("fps_max"))
        draw.SimpleText(Ipr_FpsLimit, "Ipr_Fps_Booster_Font", 67, h - 17, Ipr.Func.ColorTransition(Ipr_FpsLimit), TEXT_ALIGN_LEFT)
        draw.SimpleText(Ipr_Fps_Booster.Settings.Developer, "Ipr_Fps_Booster_Font", w - 5, h - 17, Ipr.Settings.TColor["vert"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_Fps_Booster.Settings.Version.. " By", "Ipr_Fps_Booster_Font", w - 28, h - 17, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
    end

    local function Ipr_PaintBar(Scroll)
        Scroll.Paint = nil
        
        Scroll.btnUp.Paint = function(self, w, h)
           draw.RoundedBox(3, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
        end
        Scroll.btnDown.Paint = function(self, w, h)
           draw.RoundedBox(3, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
        end
        Scroll.btnGrip.Paint = function(self, w, h)
           draw.RoundedBox(3, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
        end
    end

    local Ipr_Close = vgui.Create("DImageButton", Ipr.Settings.Vgui.Secondary)
    Ipr_Close:SetPos(221, 2)
    Ipr_Close:SetSize(17, 17)
    Ipr_Close:SetImage("icon16/cross.png")
    Ipr_Close.Paint = nil
    Ipr_Close.DoClick = function()
        if IsValid(Ipr.Settings.Vgui.Secondary) then
            Ipr.Settings.Vgui.Secondary:Remove()
        end
    end

    local Ipr_SettingsConvars = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsConvars:SetPos(5, 90)
    Ipr_SettingsConvars:SetSize(232, 160)
    Ipr_SettingsConvars.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, ColorAlpha(color_black, 90))
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.TSettings, "Ipr_Fps_Booster_Font", w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    local Ipr_ScrollBarConvars = vgui.Create("DScrollPanel", Ipr_SettingsConvars)
    Ipr_ScrollBarConvars:Dock(FILL)
    Ipr_ScrollBarConvars:DockMargin(0, 20, 0, 1)
    local Ipr_VScrollBarConvars = Ipr_ScrollBarConvars:GetVBar()
    Ipr_VScrollBarConvars:SetSize(12, 0)
    Ipr_PaintBar(Ipr_VScrollBarConvars)

    local Ipr_ConvarsLists = Ipr_Fps_Booster.DefaultCommands
    for i = 1, #Ipr_ConvarsLists do
        local Ipr_DboxConvars = vgui.Create("DCheckBoxLabel", Ipr_ScrollBarConvars)
        Ipr_DboxConvars:SetPos(5, i * (1 + 22) -22)
        Ipr_DboxConvars:SetText("")
        Ipr_DboxConvars:SetValue(Ipr.Func.GetConvar(Ipr_ConvarsLists[i].Name))
        Ipr_DboxConvars:SetTooltip(Ipr_Fps_Booster.DefaultCommands[i].Localization.ToolTip[Ipr_Language])
        Ipr_DboxConvars:SetWide(200)

        Ipr.Func.OverridePaint(Ipr_DboxConvars)
        function Ipr_DboxConvars:Paint(w, h)
            draw.SimpleText(Ipr_Fps_Booster.DefaultCommands[i].Localization.Text[Ipr_Language], "Ipr_Fps_Booster_Font", 22, 0, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        end
        Ipr_DboxConvars.OnChange = function(self)
            Ipr.Func.SetConvar(Ipr_ConvarsLists[i].Name, self:GetChecked())

            local Ipr_Compare = Ipr_ConvarsLists[i].Name
            local Ipr_ConvarFind = false
            local Ipr_BlackList = {
                ["Startup"] = true,
            }

            for i = 1, #Ipr.Settings.Updated.Data do
                local Ipr_CopyDataName = Ipr.Settings.Updated.Data[i].Name
                if Ipr.Settings.Updated.Data[i].Vgui or Ipr_BlackList[Ipr_CopyDataName] then
                    continue
                end

                local Ipr_CopyDataCheck = Ipr.Settings.Updated.Data[i].Checked
                for c = 1, #Ipr_Fps_Booster.Settings.Convars do
                     if (Ipr_CopyDataName == Ipr_Fps_Booster.Settings.Convars[c].Name) and (Ipr_CopyDataCheck ~= Ipr_Fps_Booster.Settings.Convars[c].Checked) then
                         Ipr_ConvarFind = true
                         break
                     end
                end
            end

            if (Ipr.Settings.Updated.Set ~= Ipr_ConvarFind) then
                Ipr.Settings.Updated.Set = Ipr_ConvarFind
            end
        end
    end

    local Ipr_SettingsCheckBox = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsCheckBox:SetPos(5, 260)
    Ipr_SettingsCheckBox:SetSize(232, 80)
    Ipr_SettingsCheckBox.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, ColorAlpha(color_black, 90))
        draw.SimpleText("Configuration :", "Ipr_Fps_Booster_Font", w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    local Ipr_ScrollBarCheckBox = vgui.Create("DScrollPanel", Ipr_SettingsCheckBox)
    Ipr_ScrollBarCheckBox:Dock(FILL)
    Ipr_ScrollBarCheckBox:DockMargin(0, 23, 0, 5)
    local Ipr_VScrollBarSettings = Ipr_ScrollBarCheckBox:GetVBar()
    Ipr_VScrollBarSettings:SetSize(12, 0)
    Ipr_PaintBar(Ipr_VScrollBarSettings)

    local Ipr_SettingsSlider = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsSlider:SetPos(5, 350)
    Ipr_SettingsSlider:SetSize(232, 80)
    Ipr_SettingsSlider.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, ColorAlpha(color_black, 90))
    end
    local Ipr_ScrollSlider = vgui.Create("DScrollPanel", Ipr_SettingsSlider)
    Ipr_ScrollSlider:Dock(FILL)
    Ipr_ScrollSlider:DockMargin(0, 2, 0, 0)
    local Ipr_VScrollSlide = Ipr_ScrollSlider:GetVBar()
    Ipr_VScrollSlide:SetSize(12, 0)
    Ipr_PaintBar(Ipr_VScrollSlide)

    local Ipr_OverrideVgui = {
        ["DCheckBoxLabel"] = {
            Func = function(panel, tbl)
                function panel:Paint(w, h)
                    draw.SimpleText(tbl.Localization.Text[Ipr_Language], "Ipr_Fps_Booster_Font", 22, 0, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
                end

                panel:SetValue(Ipr.Func.GetConvar(tbl.Name))
                panel:SetWide(tbl.Wide)
                panel:SetTooltip(tbl.Localization.ToolTip[Ipr_Language])

                panel.OnChange = function(self)
                   Ipr.Func.SetConvar(tbl.Name, self:GetChecked(), 1)
                end
            end,

            Parent = function()
                return Ipr_ScrollBarCheckBox
            end
        },
        ["DNumSlider"] = {
            Func = function(panel, tbl, primary)
                function primary:Paint(w, h)
                    draw.SimpleText(tbl.Localization.Text[Ipr_Language].. " / " ..math.Round(panel:GetValue()), "Ipr_Fps_Booster_Font", w / 2, 0, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
                end

                local Ipr_DNumChildren = panel:GetChildren()
                local Ipr_PrimaryWide = primary:GetWide()

                for _, v in ipairs(Ipr_DNumChildren) do
                    local Ipr_GName = v:GetName()

                    if (Ipr_GName == "DSlider") then
                        v:Dock(NODOCK)
                        v:SetSize(Ipr_PrimaryWide, 25)
                    elseif (Ipr_GName == "DLabel") then
                        v:GetChildren()[1]:SetVisible(false)
                        v:SetVisible(false)
                    elseif (Ipr_GName == "DTextEntry") then
                        v:SetVisible(false)
                    end
                end

                panel:Dock(BOTTOM)
                panel:SetSize(Ipr_PrimaryWide, 25)

                panel:SetMinMax(0, 100)
                panel:SetValue(Ipr.Func.GetConvar(tbl.Name))
                panel:SetDecimals(0)

                panel.OnValueChanged = function(self)
                   Ipr.Func.SetConvar(tbl.Name, self:GetValue(), 1)
                end
            end,
            
            Parent = function(int, tbl)
                local Ipr_CheckBoxConfig = vgui.Create("DPanel", Ipr_ScrollSlider)
                Ipr_CheckBoxConfig:SetPos(5, int * (1 + 20) - 22)
                Ipr_CheckBoxConfig:SetSize(225, 39)
                Ipr_CheckBoxConfig:Dock(TOP)
                
                return Ipr_CheckBoxConfig
            end
        },
    }

    local Ipr_SettingsLists = Ipr_Fps_Booster.DefaultSettings
    for i = 1, #Ipr_SettingsLists do
        local Ipr_PrimaryVgui = Ipr_OverrideVgui[Ipr_SettingsLists[i].Vgui].Parent(i, Ipr_SettingsLists[i])
        local Ipr_SettingsCreate = vgui.Create(Ipr_SettingsLists[i].Vgui, Ipr_PrimaryVgui)

        Ipr_SettingsCreate:SetPos(5, i * (1 + 20) - 22)
        Ipr_SettingsCreate:SetText("")
        
        Ipr_OverrideVgui[Ipr_SettingsLists[i].Vgui].Func(Ipr_SettingsCreate, Ipr_SettingsLists[i], Ipr_PrimaryVgui)
        Ipr.Func.OverridePaint(Ipr_SettingsCreate)
    end

    local Ipr_SettingsBut = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SettingsBut:SetPos(45, 25)
    Ipr_SettingsBut:SetSize(150, 60)
    Ipr_SettingsBut.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, ColorAlpha(color_black, 90))
    end
    local Ipr_ScrollBut = vgui.Create("DScrollPanel", Ipr_SettingsBut)
    Ipr_ScrollBut:Dock(FILL)
    Ipr_ScrollBut:DockMargin(-1, 2, 0, 2)
    local Ipr_SScrollSlide = Ipr_ScrollBut:GetVBar()
    Ipr_SScrollSlide:SetSize(5, 0)
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
                            ["EN"] = "Save optimization settings!",
                        },
            },
            Func = function()
                if not Ipr.Settings.Updated.Set then
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "ERROR", "] : ", Ipr.Settings.TColor["blanc"], "Please check the boxes in the optimization tab to be able to save !")
                    return
                end

                Ipr.Settings.Updated.Data = table.Copy(Ipr_Fps_Booster.Settings.Convars)
                Ipr.Settings.Updated.Set = false

                file.Write(Ipr_Fps_Booster.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Settings.Convars))
                chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Optimization parameters were saved !")
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
                            ["FR"] = "Optimisation lancée au démarrage du jeu.",
                            ["EN"] = "Optimization launched at game startup.",
                        },
            },
            Func = function(name, value)
                if timer.Exists(Ipr.Settings.StartupLaunch.Name) then
                    timer.Remove(Ipr.Settings.StartupLaunch.Name)

                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Startup launch automatically is avorted !")
                end

                local Ipr_SetStartup = value
                if (Ipr_SetStartup) then
                    Ipr.Func.SetConvar(name, Ipr_SetStartup)

                    timer.Create(Ipr.Settings.StartupLaunch.Name, Ipr.Settings.StartupLaunch.Delay, 1, function()
                        Ipr.Func.SetConvar(name, true, 2)
                        chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["vert"], "Startup launch is now enabled !")
                    end)

                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Startup launch is enabled automatically in 5 minutes for prevent crash, please wait !")
                else
                    Ipr.Func.SetConvar(name, Ipr_SetStartup, 1)
                    chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Startup launch is disabled !")
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
                            ["FR"] = "Définir les paramètres par défaut !",
                            ["EN"] = "Set default parameters !",
                        },
            },
            Func = function()
                Ipr.Func.CreateData(true)

                Ipr.Settings.Updated.Data = table.Copy(Ipr_Fps_Booster.Settings.Convars)
                Ipr.Settings.Updated.Set = false

                Ipr_FpsBooster_Options(primary, true)

                chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "The default configuration has been loaded !")
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
        Ipr_SettingsCreate:SetTooltip(Ipr_SettingsDbutton.Localization.ToolTip[Ipr_Language])

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

                    Ipr_ConvarColor = (Ipr_SettingsDbutton.DataDelayed and timer.Exists(Ipr_SettingsDbutton.DataDelayed.Name) or Ipr.Func.GetConvar(Ipr_SettingsDbutton.Convar.Name)) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"]
                    draw.RoundedBox(0, 0, h- 1, w, h, Ipr_ConvarColor)
                else
                    if (Ipr.Settings.Updated.Set) then
                        local Ipr_CurTime = CurTime()
                        local Ipr_ColorAbs = math.abs(math.sin(Ipr_CurTime * 2.5) * 255)

                        draw.RoundedBoxEx(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"], true, true, false, false)
                        draw.RoundedBox(0, 0, h- 1, w, h, Color(Ipr_ColorAbs, Ipr_ColorAbs, 0))
                    else
                        draw.RoundedBox(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
                    end
                end
            else
               draw.RoundedBox(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["orange"] or Ipr.Settings.TColor["orangec"])
            end
            
            draw.SimpleText(Ipr_SettingsDbutton.Localization.Text, "Ipr_Fps_Booster_Font", w / 2 + 6, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        end

        Ipr_SettingsCreate.DoClick = function()
            surface.PlaySound(Ipr_SettingsDbutton.Sound)

            if (Ipr_SettingsDbutton.Convar) then
                local Ipr_RunConvar = false

                if (Ipr_SettingsDbutton.DataDelayed) then
                    Ipr_RunConvar = not timer.Exists(Ipr_SettingsDbutton.DataDelayed.Name)
                else
                    Ipr_RunConvar = not Ipr.Func.GetConvar(Ipr_SettingsDbutton.Convar.Name)
                end

                Ipr_SettingsDbutton.Func(Ipr_SettingsDbutton.Convar.Name, Ipr_RunConvar)
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
    Ipr.Settings.Vgui.Primary:MakePopup()
    Ipr.Settings.Vgui.Primary:ShowCloseButton(false)
    Ipr.Settings.Vgui.Primary:SetDraggable(true)
    Ipr.Settings.Vgui.Primary:Center()
    Ipr.Settings.Vgui.Primary:AlphaTo(5, 0, 0)
    Ipr.Settings.Vgui.Primary:AlphaTo(255, 1, 0)

    Ipr.Settings.Updated.Data = table.Copy(Ipr_Fps_Booster.Settings.Convars)
    Ipr.Settings.Updated.Set = false
    
    Ipr.Settings.Vgui.Primary.Paint = function(self, w, h)
        if (self.Dragging) and IsValid(Ipr.Settings.Vgui.Secondary) then
            local Ipr_CenterSecondaryW = Ipr.Settings.Vgui.Primary:GetX() + Ipr.Settings.Vgui.Primary:GetWide() + 10
            local Ipr_CenterSecondaryH = Ipr.Settings.Vgui.Primary:GetY() - (Ipr.Settings.Vgui.Secondary:GetTall() / 2)
            Ipr_CenterSecondaryH = Ipr_CenterSecondaryH + (Ipr.Settings.Vgui.Primary:GetTall() / 2)

            Ipr.Settings.Vgui.Secondary:SetPos(Ipr_CenterSecondaryW, Ipr_CenterSecondaryH)
        end

        Ipr.Func.RenderBlur(self, ColorAlpha(color_black, 130), 8)
        
        draw.RoundedBoxEx(6, 0, 0, w, 33, Ipr.Settings.TColor["bleu"], true, true, false, false)

        local Ipr_CurrentStatus = Ipr.Func.CurrentStatus()
        draw.SimpleText("FPS :","Ipr_Fps_Booster_Font",(Ipr_CurrentStatus and w / 2 - 25) or w / 2 -10, 16, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.TEnabled,"Ipr_Fps_Booster_Font",w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText((Ipr_CurrentStatus and "On (Boost)") or "Off", "Ipr_Fps_Booster_Font", (Ipr_CurrentStatus and w / 2 + 22) or w / 2 + 18, 16, Ipr_CurrentStatus and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"], TEXT_ALIGN_CENTER)
    end
    
    Ipr_PrimaryProperty:Dock(FILL)
    Ipr_PrimaryProperty:DockPadding(52, 10, 0, 0)

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

    local Ipr_IconComputer = Material("icon/Ipr_boost_computer.png", "noclamp smooth")
    local Ipr_IconWrench = Material("icon/Ipr_boost_wrench.png", "noclamp smooth")

    Ipr_PrimaryProperty.Paint = function(self, w, h)
        draw.SimpleText(Ipr.Settings.FpsDefault.Status.Name, "Ipr_Fps_Booster_Font", w / 2, h / 2 - 63, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr.Settings.FpsDefault.Max.Name, "Ipr_Fps_Booster_Font", w / 2  -10, h / 2 - 31, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr.Settings.FpsDefault.Min.Name, "Ipr_Fps_Booster_Font", w / 2 - 10, h / 2 - 16, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr.Settings.FpsDefault.Gain.Name, "Ipr_Fps_Booster_Font", w / 2 - 10, h / 2 - 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.FpsCurrent, "Ipr_Fps_Booster_Font", w / 2 - 10, h / 2 - 46, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local Ipr_FpsCurrent, Ipr_FpsMin, Ipr_FpsMax, Ipr_FpsGain = Ipr.Func.FpsCalculator()
        local Ipr_CurrentStatus = Ipr.Func.CurrentStatus()

        draw.SimpleText(Ipr_FpsCurrent, "Ipr_Fps_Booster_Font", w / 2 + 15, h / 2 - 46, Ipr.Func.ColorTransition(Ipr_FpsCurrent), TEXT_ALIGN_LEFT)
        draw.SimpleText(Ipr_FpsMax, "Ipr_Fps_Booster_Font", w / 2 + 10, h / 2 - 31, Ipr.Func.ColorTransition(Ipr_FpsMax), TEXT_ALIGN_LEFT)
        draw.SimpleText(Ipr_FpsMin, "Ipr_Fps_Booster_Font", w / 2 + 10, h / 2 - 16, Ipr.Func.ColorTransition(Ipr_FpsMin), TEXT_ALIGN_LEFT)
        draw.SimpleText((Ipr_CurrentStatus and (Ipr_FpsMax ~= Ipr_FpsGain) and Ipr_FpsGain or "OFF"), "Ipr_Fps_Booster_Font", w / 2 + 10, h / 2 - 1, Ipr_CurrentStatus and (Ipr_FpsMax ~= Ipr_FpsGain) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"], TEXT_ALIGN_LEFT)

        surface.SetMaterial(Ipr_IconComputer)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-10, 0, 350, 235)

        surface.SetMaterial(Ipr_IconWrench)
        surface.SetDrawColor(255, 255, 255, 255)

        local Ipr_Loop = Ipr_Copy.Loop()
        Ipr_Copy.Draw(207, 120, 220, 220, Ipr_Loop, -25)
    end

    Ipr_PrimaryClose:SetPos(280, 3)
    Ipr_PrimaryClose:SetSize(17, 17)
    Ipr_PrimaryClose:SetImage("icon16/cross.png")
    Ipr_PrimaryClose.Paint = nil

    Ipr_PrimaryClose.DoClick = function()
        Ipr.Func.ClosePanel()
    end

    Ipr_PrimaryExternal:SetPos(97, 80)
    Ipr_PrimaryExternal:SetSize(110, 90)
    Ipr_PrimaryExternal:SetText("")
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
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.VEnabled, "Ipr_Fps_Booster_Font", w / 2 + 3, 3, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimaryEnabled.DoClick = function()
        local Ipr_CheckBox = Ipr.Func.IsChecked()
        if not Ipr_CheckBox then
            return chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Please check boxes in optimization to activate the fps booster !")
        end

        local Ipr_ConvarsEnabled = Ipr.Func.MatchConvar(true)
        if (Ipr_ConvarsEnabled) then
            Ipr.Func.Activate(true)
            Ipr.Func.ResetFps(true)

            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Si vous rencontrez des problèmes graphiques ou crashs, utilisez le bouton options pour modifier vos paramètres. Pour ouvrir Improved FPS Booster /boost.")
        else
            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Already enabled !")
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
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.VDisabled, "Ipr_Fps_Booster_Font", w / 2 + 6, 3, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimaryDisabled.DoClick = function()
        local Ipr_ConvarsEnabled = Ipr.Func.MatchConvar(false)
        if (Ipr_ConvarsEnabled) then
            Ipr.Func.Activate(false)
            Ipr.Func.ResetFps(true)
        else
            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Already disabled !")
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
    function Ipr_PrimarySettings:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText("Options ", "Ipr_Fps_Booster_Font", w / 2 + 7, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
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
        draw.SimpleText("Reset FPS max/min", "Ipr_Fps_Booster_Font", w / 2 + 7, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_PrimaryResetFps.DoClick = function()
        Ipr.Func.ResetFps(true)

        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_PrimaryLanguage:SetPos(5, 38)
    Ipr_PrimaryLanguage:SetSize(105, 20)
    Ipr_PrimaryLanguage:SetFont("Ipr_Fps_Booster_Font")
    Ipr_PrimaryLanguage:SetValue(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.SelectLangue.. " " ..Ipr_Language)
    
    for k, v in pairs(Ipr_Fps_Booster.Lang) do
        Ipr_PrimaryLanguage:AddChoice(Ipr_Fps_Booster.Lang[Ipr_Language].Localized.SelectLangue.. " " ..k, k, false, "materials/flags16/" ..v.Settings.Icon.. ".png")
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
                    y:SetFont( "Ipr_Fps_Booster_Font" )
                end
            end
        end
        
        Ipr.Func.OverridePaint(self)
    end
    Ipr_PrimaryLanguage.OnSelect = function(self, index, value)
        local Ipr_SetLang = self.Data[index]
        if (Ipr_SetLang == Ipr_Language) then
            return
        end

        self:Clear()
        self:SetValue(Ipr_Fps_Booster.Lang[Ipr_SetLang].Localized.SelectLangue.. " " ..Ipr_SetLang)
        for k, v in pairs(Ipr_Fps_Booster.Lang) do
            self:AddChoice(Ipr_Fps_Booster.Lang[Ipr_SetLang].Localized.SelectLangue.. " " ..k, k, false, "materials/flags16/" ..v.Settings.Icon.. ".png")
        end

        Ipr_Language = Ipr_SetLang
        file.Write(Ipr_Fps_Booster.Settings.Save.. "language.json", Ipr_SetLang)
        
        surface.PlaySound("buttons/button9.wav")
    end
end

local Ipr_DefaultCommands = {
    ["/boost"] = {
        Func = function()
            if timer.Exists("IprFpsBooster_Startup") then
                timer.Remove("IprFpsBooster_Startup")
                print("Startup is disabled !")
            end
            
            Ipr.Func.CreateData(false)
            Ipr_FpsBooster()

            return true
        end
    },
    ["/reset"] = {
        Func = function()
            Ipr.Func.ResetFps(false)
            Ipr.Func.Activate(false)

            chat.AddText(Ipr.Settings.TColor["rouge"], "[", "Improved FPS Booster", "] : ", Ipr.Settings.TColor["blanc"], "Reset is completed !")
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
    Ipr.Func.CreateData(false)
    
    timer.Create("IprFpsBooster_Startup", 5, 1, function()
        local Ipr_Startup = Ipr.Func.GetConvar("Startup")
        Ipr.Func.Activate(Ipr_Startup)
        
        local Ipr_ForcedOpen = Ipr.Func.GetConvar("ForcedOpen")
        if not Ipr_ForcedOpen then
            Ipr_FpsBooster()
        end
    end)
end

local function Ipr_PlayerShutDown()
    if timer.Exists(Ipr.Settings.StartupLaunch.Name) then
        print("[Improved FPS Booster] Startup launch is avorted !")
    end
end

local Ipr_Wide = ScrW()
local Ipr_Height = ScrH()
local Ipr_Map = game.GetMap()

local function Ipr_HUD()
    local Ipr_HudEnable = Ipr.Func.GetConvar("FpsView")
    if not Ipr_HudEnable then
        return
    end

    local Ipr_FpsCurrent, Ipr_FpsMin, Ipr_FpsMax, Ipr_FpsGain = Ipr.Func.FpsCalculator()
    local Ipr_HHeight = Ipr_Height * Ipr.Func.GetConvar("FpsPosHeight") / 100
    local Ipr_HWide = Ipr_Wide * Ipr.Func.GetConvar("FpsPosWidth") / 100
    local Ipr_Status = Ipr.Func.CurrentStatus()

    draw.SimpleText("Fps : " ..Ipr_FpsCurrent.. " Min : " ..Ipr_FpsMin.. " Max : " ..Ipr_FpsMax.. " " ..(Ipr_Status and (Ipr_FpsMax ~= Ipr_FpsGain) and "Gain : " ..Ipr_FpsGain or ""), "Ipr_Fps_Booster_Font", Ipr_HWide, Ipr_HHeight, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    draw.SimpleText("Map : " ..Ipr_Map, "Ipr_Fps_Booster_Font", Ipr_HWide, Ipr_HHeight + 20, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
end

local function Ipr_OnScreenSize()
    Ipr_Wide, Ipr_Height = ScrW(), ScrH()
end

hook.Add("ShutDown", "IprFpsBooster_ShutDown", Ipr_PlayerShutDown)
hook.Add("PostDrawHUD", "IprFpsBooster_HUD", Ipr_HUD)
hook.Add("OnScreenSizeChanged", "IprFpsBooster_OnScreen", Ipr_OnScreenSize)
hook.Add("InitPostEntity", "IprFpsBooster_InitPlayer", Ipr_InitPostPlayer)
hook.Add("OnPlayerChat", "IprFpsBooster_ChatCmds", Ipr_ChatCmds)
