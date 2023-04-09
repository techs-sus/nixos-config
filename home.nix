{ nix-vscode-extensions, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tech";
  home.homeDirectory = "/home/tech";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    firefox
    keepassxc
    discord
    rnix-lsp
    stylua
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/brinkervii/grapejuice/user_settings.json".text = ''
      {
        "version": 3,
        "hardware_profile": {
          "graphics_id": "9d3583c0490362c7a84c0e23e0980ff1e63602c6a9f6dcf54f9c503cb7ae939e",
          "gpu_vendor_id": 1,
          "gpu_pci_id": "00:01.0",
          "gpu_can_do_vulkan": false,
          "provider_index": 0,
          "provider_name": "MULLINS @ pci:0000:00:01.0",
          "should_prime": false,
          "use_mesa_gl_override": false,
          "preferred_roblox_renderer_string": "OpenGL",
          "is_multi_gpu": false,
          "version": 2
        },
        "show_fast_flag_warning": false,
        "release_channel": "master",
        "disable_updates": false,
        "try_profiling_hardware": true,
        "default_wine_home": "/nix/store/y77yylvs2j2knvid9h807yhysh3g4nk2-wine-wow-8.5",
        "wineprefixes": [
          {
            "id": "b5e971c6-fc33-4ddf-8863-a6433d4680b1",
            "priority": 0,
            "name_on_disk": "player",
            "display_name": "Player",
            "wine_home": "",
            "dll_overrides": "dxdiagn=;winemenubuilder.exe=",
            "prime_offload_sink": -1,
            "use_mesa_gl_override": false,
            "enable_winedebug": false,
            "winedebug_string": "",
            "roblox_renderer": "Vulkan",
            "env": {
              "LD_PRELOAD": "libgamemodeauto.so"
            },
            "hints": [
              "player",
              "app"
            ],
            "fast_flags": {},
            "third_party": {
              "fps_unlocker": true,
              "dxvk": false
            },
            "dxvk_overrides": [
              "d3d11",
              "d3d9",
              "dxgi",
              "d3d10core"
            ]
          }
        ],
        "unsupported_settings": {}
      }
    '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tech/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.fish.plugins = [
    # I need tide to automatically install itself lol
    { name = "tide"; src = pkgs.fishPlugins.tide.src; }
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # NOTE: When editing settings in VSCode, you will not be able to save the settings.json file.
  # This is due to file being read-only, because home-manager will create it and fill it in.
  # Please DO NOT write to the file directly, and instead modify userSettings in programs.vscode instead.
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    userSettings = {
      # This is literally just JSON but with equal signs
      "nix.enableLanguageServer" = true;
      "workbench.colorTheme" = "Dracula";
      "workbench.iconTheme" = "eq-material-theme-icons-palenight";
      "editor.insertSpaces" = false;
      "editor.tabSize" = 2;
      "files.autoSave" = "onFocusChange";
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.cursorStyle" = "line";
      "editor.cursorBlinking" = "solid";
      "editor.multiCursorLimit" = 1000;
      "robloxLsp.completion.callParenthesess" = true;
      "robloxLsp.diagnostics.workspaceRate" = 100;
      "robloxLsp.hint.enable" = true;
      "robloxLsp.misc.serverPort" = 0;
      "robloxLsp.typeChecking.mode" = "Non Strict";
      "robloxLsp.workspace.library" = [
        # This resolves to a Nix store path.
        ./types.lua
      ];
      "robloxLsp.diagnostics.globals" = [ "owner" "NS" "NLS" ];
      "editor.fontFamily" = "'FiraCode Nerd Font'";
      "editor.fontLigatures" = true;
      # Tell stylua to get a binary from the Nix store.
      "stylua.styluaPath" = "${pkgs.stylua}/bin/stylua";
      "git.autofetch" = true;
    };
    extensions = with pkgs.vscode-extensions;
      [
        dracula-theme.theme-dracula
      ] ++ [
        # I don't know if you can add extensions through VSCode itself anymore.
        # Although you probably shouldn't do that anyway.
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.johnnymorganz.stylua
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.nightrains.robloxlsp
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jnoortheen.nix-ide
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.equinusocio.vsc-material-theme-icons
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.rust-lang.rust-analyzer
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.usernamehw.errorlens
      ];
  };
}
