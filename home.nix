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
    { name = "tide"; src = pkgs.fishPlugins.tide.src; }
  ];
  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
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
      "editor.cursorStyle" = "block";
      "editor.cursorBlinking" = "solid";
      "editor.multiCursorLimit" = 1000;
      "robloxLsp.completion.callParenthesess" = true;
      "robloxLsp.diagnostics.workspaceRate" = 50;
      "robloxLsp.hint.enable" = true;
      "robloxLsp.misc.serverPort" = 0;
      "robloxLsp.typeChecking.mode" = "Non Strict";
      "robloxLsp.workspace.library" = [
        ./types.lua
      ];
      "editor.fontFamily" = "'Fira Code'";
      "editor.fontLigatures" = true;
    };
    extensions = with pkgs.vscode-extensions;
      [
        dracula-theme.theme-dracula
      ] ++ [
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.johnnymorganz.stylua
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.nightrains.robloxlsp
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jnoortheen.nix-ide
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.equinusocio.vsc-material-theme-icons
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.rust-lang.rust-analyzer
        nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.usernamehw.errorlens
      ];
  };
}
