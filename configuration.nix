# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];

  # Enable grub because systemd-boot doesn't work on lustrate
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  # boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.waydroid.enable = true;
  virtualisation.lxd.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  # AMDGPU support + Vulkan
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "radeon.si_support=0"
    "amdgpu.si_support=1"

    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
  ];
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable desktop stuff
  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # AMDGPU
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  sound.mediaKeys.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tech.isNormalUser = true;
  users.users.tech.initialPassword = "password";
  # wheel is sudo permissions
  users.users.tech.extraGroups = [ "wheel" "audio" ];
  users.users.tech.shell = pkgs.fish;
  programs.fish.enable = true;
  programs.gamemode.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    neofetch
    grapejuice
    git
    gh
    gamescope
    wl-clipboard
    htop
  ];
  # needed for grapejuice
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  # GC
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-unstable";
  };

  # Nix configuration
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d"; # 1 week
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # 1 cpu -> 4 cores -> 8 cores (with hyperthreading)
  nix.settings.max-jobs = 8;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  users.users.root.initialHashedPassword = "";
}
