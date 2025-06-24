// SCRIPT BY Inj3 
// https://steamcommunity.com/id/Inj3/
// General Public License v3.0
// https://github.com/Inj3-GT

Ipr_Fps_Booster.DefaultSettings = {
    {
        Vgui = "DCheckBoxLabel",
        Name = "FpsView",
        DefaultCheck = false,
        Wide = 210,
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
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "AutoClose",
        DefaultCheck = true,
        Wide = 210,
        Localization = {
            Text = {
                ["FR"] = "Fermer (activer/désactiver)",
                ["EN"] = "Closed (enable/disable)",
            },
            ToolTip = {
                ["FR"] = "Si vous appuyez sur les boutons activer ou désactiver, le panneau se fermera automatiquement !",
                ["EN"] = "If you press the activate or deactivate buttons, the panel will close automatically !",
            },
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "ForcedOpen",
        DefaultCheck = false,
        Wide = 210,
        Localization = {
            Text = {
                ["FR"] = "Forcer ouverture",
                ["EN"] = "Forced open",
            },
            ToolTip = {
                ["FR"] = "Désactiver l'ouverture automatique du panel à la fin du chargement.",
                ["EN"] = "Disable automatic panel opening at the end of loading.",
            },
        },
    },
    {
        Vgui = "DNumSlider",
        Name = "FpsPosWidth",
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
        DefaultCheck = 28,
        Localization = {
            Text = {
                ["FR"] = "FPS Position Hauteur",
                ["EN"] = "FPS Position Height",
            },
        },
    },
}