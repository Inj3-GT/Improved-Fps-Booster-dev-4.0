// SCRIPT BY Inj3 
// https://steamcommunity.com/id/Inj3/
// General Public License v3.0
// https://github.com/Inj3-GT

Ipr_Fps_Booster.DefaultSettings = {
    {
        Vgui = "DCheckBoxLabel",
        Name = "FpsView",
        DefaultCheck = false,
        Localization = {
            Text = {
                ["FR"] = "Compteur FPS visible",
                ["EN"] = "Display FPS on hud",
            },
            ToolTip = {
                ["FR"] = "Compteur de FPS visible sur votre HUD",
                ["EN"] = "Fps counter is visible on your screen",
            },
        },
        Run_HookFps = true,
    },
    {
        Vgui = "DNumSlider",
        Name = "FpsPosWidth",
        Paired = "FpsView",
        DefaultCheck = 44,
        Localization = {
            Text = {
                ["FR"] = "FPS Position Largeur",
                ["EN"] = "FPS Position Width",
            },
        },
    },
    {
        Vgui = "DNumSlider",
        Name = "FpsPosHeight",
        Paired = "FpsView",
        DefaultCheck = 28,
        Localization = {
            Text = {
                ["FR"] = "FPS Position Hauteur",
                ["EN"] = "FPS Position Height",
            },
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "EnabledFog",
        DefaultCheck = false,
        Localization = {
            Text = {
                ["FR"] = "Activer le brouillard",
                ["EN"] = "Enabled Fog",
            },
            ToolTip = {
                ["FR"] = "Ouverture automatique du panel à la fin du chargement",
                ["EN"] = "Automatic opening of the panel at the end of loading",
            },
        },
        Run_HookFog = true,
    },
    {
        Vgui = "DNumSlider",
        Name = "FogStart",
        Paired = "EnabledFog",
        DefaultCheck = 0,
        Max = 1000000,
        Localization = {
            Text = {
                ["FR"] = "Brouillard Position Début",
                ["EN"] = "Fog Position Start",
            },
        },
    },
    {
        Vgui = "DNumSlider",
        Name = "FogEnd",
        Paired = "EnabledFog",
        DefaultCheck = 5000,
        Max = 1000000,
        Localization = {
            Text = {
                ["FR"] = "Brouillard Position Fin",
                ["EN"] = "Fog Position End",
            },
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "AutoClose",
        DefaultCheck = true,
        Localization = {
            Text = {
                ["FR"] = "[Activer/Désactiver]",
                ["EN"] = "[Enable/Disable]",
            },
            ToolTip = {
                ["FR"] = "Si vous appuyez sur le bouton activer/désactiver, le panneau se fermera automatiquement !",
                ["EN"] = "If you press the activate/deactivate button, the panel will close automatically !",
            },
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "ForcedOpen",
        DefaultCheck = true,
        Localization = {
            Text = {
                ["FR"] = "[Join] Ouverture",
                ["EN"] = "[Join] Opening",
            },
            ToolTip = {
                ["FR"] = "Ouverture automatique du panel lorsque vous entrez sur le serveur !",
                ["EN"] = "Automatic opening of the panel when you enter the server !",
            },
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "ServerLeaveSettings",
        DefaultCheck = false,
        Localization = {
            Text = {
                ["FR"] = "[Leave] Désactivation",
                ["EN"] = "[Leave] Deactivation",
            },
            ToolTip = {
                ["FR"] = "Désactive automatiquement le FPS Booster une fois que vous quittez le serveur !",
                ["EN"] = "Automatically disables the FPS Booster once you leave the server !",
            },
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "EnableDebug",
        DefaultCheck = false,
        Localization = {
            Text = {
                ["FR"] = "[Dev] Debug",
                ["EN"] = "Debug",
            },
            ToolTip = {
                ["FR"] = "Affiche des logs dans la console !",
                ["EN"] = "Displays logs in the console !",
            },
        },
        Run_Debug = true,
    },
}
