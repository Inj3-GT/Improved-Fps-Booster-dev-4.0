// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    {
        Vgui = "DButton",
        Icon = "icon16/bullet_disk.png",
        DrawLine = true,
        Sound = "buttons/button9.wav",
        Localization = {
            Text = "SaveOpti",
            ToolTip = "TSaveOpti",
        },
        Function = function(tbl)
            if not tbl.Settings.Data.Set then
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].CheckedBox)
                return
            end

            local Ipr_CurrentState = tbl.Function.CurrentState()
            if (Ipr_CurrentState) then
                tbl.Function.Activate(true)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].OptimizationReloaded)
            end

            local Ipr_StartupDelay = timer.Exists(tbl.Settings.StartupLaunch.Name)
            if (Ipr_StartupDelay) then
                timer.Remove(tbl.Settings.StartupLaunch.Name)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupAbandoned)
            end

            tbl.Function.SetConvar("Startup", false, 2)
            tbl.Function.CopyData()

            file.Write(tbl.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
            chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].SettingsSaved)
        end
    },
    {
        Vgui = "DButton",
        Icon = "icon16/bullet_key.png",
        DrawLine = true,
        DataDelayed = true,
        Sound = "buttons/button9.wav",
        Convar = {
            Name = "Startup",
            DefaultCheck = false,
        },
        Localization = {
            Text = "ApplyStartup",
            ToolTip = "TApplyStartup",
        },
        Function = function(tbl, but)
            local Ipr_StartupDelay = timer.Exists(tbl.Settings.StartupLaunch.Name)
            if (Ipr_StartupDelay) then
                timer.Remove(tbl.Settings.StartupLaunch.Name)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupAbandoned)
            end

            local Ipr_SetStartup = not Ipr_StartupDelay
            if (Ipr_SetStartup) then
                local Ipr_CurrentState = tbl.Function.CurrentState()
                if not Ipr_CurrentState then
                    tbl.Function.Activate(true)
                end

                tbl.Function.SetConvar(but.Convar.Name, Ipr_SetStartup)

                timer.Create(tbl.Settings.StartupLaunch.Name, tbl.Settings.StartupLaunch.Delay, 1, function()
                    tbl.Function.SetConvar(but.Convar.Name, true, 2)
                    chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["vert"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupEnabled)
                end)

                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupLaunched)
            else
                tbl.Function.SetConvar(but.Convar.Name, Ipr_SetStartup, 1)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupDisabled)
            end
        end
    },
    {
        Vgui = "DButton",
        Icon = "icon16/bullet_wrench.png",
        Sound = "buttons/button9.wav",
        DrawLine = false,
        Localization = {
            Text = "SetDefaultSettings",
            ToolTip = "TSetDefaultSettings",
        },
        Function = function(tbl)
            for i = 1, #tbl.Settings.Vgui.CheckBox do
                tbl.Settings.Vgui.CheckBox[i].Vgui:SetValue(tbl.Settings.Vgui.CheckBox[i].Default)
            end

            chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].DefaultConfig)
        end
    },
}