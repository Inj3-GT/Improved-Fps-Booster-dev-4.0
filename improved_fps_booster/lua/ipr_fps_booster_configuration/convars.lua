// SCRIPT BY Inj3 
// https://steamcommunity.com/id/Inj3/
// General Public License v3.0
// https://github.com/Inj3-GT

Ipr_Fps_Booster.DefaultCommands = {
    {

        Name = "Multicore",
        DefaultCheck = true,
        Convars = {
            ["gmod_mcore_test"] = {
                Enabled = "1",
                Disabled = "0"
            },
        },
        Localization = {
            Text = {
                ["FR"] = "Rendu Multicoeur",
                ["EN"] = "Multicore Rendering"
            },
            ToolTip = {
                ["FR"] = "Tirer parti d'un processeur multicoeur avec le moteur de Garry's Mod",
                ["EN"] = "Multi-threading Source Engine"
            }
        },
    },
    {

        Name = "Corde",
        DefaultCheck = false,
        Convars = {
            ["r_queued_ropes"] = {
                Enabled = "1",
                Disabled = "0"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Rendu des cordes",
                ["EN"] = "Rope Rendering"
            },
            ToolTip = {
                ["FR"] = "Utilise une méthode de rendu optimisée pour les cordes",
                ["EN"] = "Uses a rendering method optimized for ropes"
            }
        },
    },
    {

        Name = "Skybox",
        DefaultCheck = false,
        Convars = {
            ["r_3dsky"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Skybox 3D",
                ["EN"] = "3D skybox"
            },
            ToolTip = {
                ["FR"] = "Désactive le rendu du ciel",
                ["EN"] = "Disables skybox rendering"
            }
        },

    },
    {

        Name = "Material processing",
        DefaultCheck = false,
        Convars = {
            ["mat_queue_mode"] = {
                Enabled = "2",
                Disabled = "-1"
            },
        },
        Localization = {
            Text = {
                ["FR"] = "Traitement des matériaux",
                ["EN"] = "Material processing"
            },
            ToolTip = {
                ["FR"] = "Ce paramètre détermine le mode de gestion des threads utilisé par le système de matériaux",
                ["EN"] = "This setting determines the threading mode the material system uses"
            }
        },
    },
    {
        Name = "Shadow Quality",
        DefaultCheck = true,
        Convars = {
            ["mat_shadowstate"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["r_shadowmaxrendered"] = {
                Enabled = "0",
                Disabled = "32"
            },
            ["r_shadowrendertotexture"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["nb_shadow_dist"] = {
                Enabled = "0",
                Disabled = "3000"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Rendu des ombres",
                ["EN"] = "Shadow Rendering"
            },
            ToolTip = {
                ["FR"] = "Réduit la qualité des ombres (ne les supprimes pas complétement)",
                ["EN"] = "Reduces the quality of shadows (does not removed them completely)"
            }
        },
    },
    {
        Name = "Texture filtering",
        DefaultCheck = false,
        Convars = {
            ["mat_filtertextures"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Filtrage texture",
                ["EN"] = "Texture filtering"
            },
            ToolTip = {
                ["FR"] = "Désactive le filtrage des textures",
                ["EN"] = "Disables texture filtering"
            }
        },
    },
    {
        Name = "Source Engine",
        DefaultCheck = false,
        Convars = {
            ["r_threaded_particles"] = {
                Enabled = "1",
                Disabled = "0"
            },
            ["r_threaded_renderables"] = {
                Enabled = "-1",
                Disabled = "0"
            },
            ["r_threaded_client_shadow_manager"] = {
                Enabled = "1",
                Disabled = "0"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Comportement moteur",
                ["EN"] = "Modify the behavior (engine)"
            },
            ToolTip = {
                ["FR"] = "Modifie le comportement du moteur (particule, matrice osseuse, corde, pvs - threads séparés)",
                ["EN"] = "Modifies engine behavior (particle, bone matrix, string, pvs - separate threads)"
            }
        },
    },
    {
        Name = "Hardware acceleration",
        DefaultCheck = true,
        Convars = {
            ["r_fastzreject"] = {
                Enabled = "-1",
                Disabled = "0"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Accéleration materiel",
                ["EN"] = "Hardware acceleration"
            },
            ToolTip = {
                ["FR"] = "Algorithme de calcul de perspective plus rapide",
                ["EN"] = "Faster perspective calculation algorithm"
            }
        },
    },
    {
        Name = "TeethPM",
        DefaultCheck = false,
        Convars = {
            ["r_teeth"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Rendu des dents (PM)",
                ["EN"] = "Teeth rendering (PM)"
            },
            ToolTip = {
                ["FR"] = "Désactive l'affichage des dents (playermodel)",
                ["EN"] = "Disables teeth rendering (playermodel)"
            }
        },
    },
    {
        Name = "Blood",
        DefaultCheck = false,
        Convars = {
            ["violence_ablood"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["violence_agibs"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["violence_hblood"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["violence_hgibs"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Rendu du sang",
                ["EN"] = "Blood rendering"
            },
            ToolTip = {
                ["FR"] = "Désactive le rendu du sang",
                ["EN"] = "Disables blood rendering"
            }
        },
    },
    {
        Name = "Small Object",
        DefaultCheck = false,
        Convars = {
            ["cl_phys_props_enable"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["cl_phys_props_max"] = {
                Enabled = "0",
                Disabled = "300"
            },
            ["props_break_max_pieces"] = {
                Enabled = "0",
                Disabled = "-1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Objets physiques",
                ["EN"] = "Physical objects"
            },
            ToolTip = {
                ["FR"] = "Désactive les petits objets (bouteilles, petites boîtes de conserve, briques)",
                ["EN"] = "Disables small objects (bottles, small cans, bricks)"
            }
        },
    },
    {
        Name = "Bloom",
        DefaultCheck = false,
        Convars = {
            ["mat_bloom_scalefactor_scalar"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["mat_bloomscale"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Flou lumineux",
                ["EN"] = "Bloom"
            },
            ToolTip = {
                ["FR"] = "Désactive le flou lumineux (effet graphique)",
                ["EN"] = "Disables bloom (graphical effect)"
            }
        },
    },
    {
        Name = "WaterSplashEffect",
        DefaultCheck = false,
        Convars = {
            ["cl_show_splashes"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Eclaboussures d'eau",
                ["EN"] = "Splash Effects"
            },
            ToolTip = {
                ["FR"] = "Désactiver l'effet d'éclaboussures d'eau",
                ["EN"] = "Disable water splash effect"
            }
        },
    },
    {
        Name = "M9K effect",
        DefaultCheck = true,
        Convars = {
            ["M9KGasEffect"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = {
                ["FR"] = "Effets de gaz M9K (arme)",
                ["EN"] = "M9K Gas Effects (weapon)"
            },
            ToolTip = {
                ["FR"] = "Désactive les effets de nuages de fumée et les éclaboussures de gaz sur les armes M9K",
                ["EN"] = "Disables smoke cloud and gas splash effects on M9K weapons"
            }
        },
    },
    {
        Name = "Muzzleflash",
        DefaultCheck = false,
        Convars = {
            ["muzzleflash_light"] = {
                Enabled = "0",
                Disabled = "1"
            },
        },
        Localization = {
            Text = {
                ["FR"] = "Muzzle flash (arme)",
                ["EN"] = "Muzzle flash (weapon)",
            },
            ToolTip = {
                ["FR"] = "Désactive la lumière générée par le flash de bouche",
                ["EN"] = "Disables the light generated by the muzzle flash",
            }
        },
    },
    {
        Name = "Ejectedshells",
        DefaultCheck = false,
        Convars = {
            ["cl_ejectbrass"] = {
                Enabled = "0",
                Disabled = "1"
            },
        },
        Localization = {
            Text = {
                ["FR"] = "Douilles éjectées (arme)",
                ["EN"] = "Ejected shells (weapon)",
            },
            ToolTip = {
                ["FR"] = "Désactive le rendu des douilles éjectées",
                ["EN"] = "Disable rendering of ejected shells",
            }
        },
    },
}
