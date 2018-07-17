# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  #nixpkgs.config.packageOverrides = pkgs: {
  #  haskellPackages = pkgs.haskellPackages.override {
  #    overrides = self: super: {
  #      async = super.async_2_2_1;
  #      fsnotify = super.fsnotify_0_3_0_1;
  #      hinotify = super.hinotify_0_3_10;
  #      lifted-async = super.lifted-async_0_10_0_2;
  #    };
  #  };
  #};

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "timjb-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    exfat

    # CLIs
    fish
    wget
    vim
    git
    pciutils
    cowsay
    fortune
    pandoc
    unstable.bazel
    (ffmpeg-full.override {
      nonfreeLicensing = true;
      nvenc = true;
    })
    psmisc
    xsel # get/set contents of X clipboard
    binutils

    tilix # Terminal emulator
    firefox
    chromium
    unstable.vscode
    #emacs
    seafile-client
    spotify
    tdesktop # Telegram Desktop
    vlc
    gparted
    kdenlive
    yubikey-personalization
    yubikey-personalization-gui
    gnome3.geary
    #qt5ct
    breeze-icons
    audacity

    # Haskell
    stack
    haskellPackages.intero # needed by Haskelly
    #haskellPackages.stack-run # doesn't work # needed by Haskelly

    python35
    gcc

    # LaTeX
    (texlive.combine { inherit (texlive) scheme-full; })

    # Theorem provers
    isabelle
    haskellPackages.Agda

    # Gnome 3
    gnome3.gnome-tweak-tool
    gnome3.dconf-editor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.remove-dropdown-arrows
    gnomeExtensions.nohotcorner
    #gnomeExtensions.system-monitor
    arc-icon-theme

    # Config
    xbindkeys # xbindkeys-config
    xdotool
  ];

  fonts.fonts = with pkgs; [
    fira-code fira-code-symbols
    ubuntu_font_family
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # programs.qt5ct.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";

  services = {

    udev.packages = [ pkgs.yubikey-personalization ];

    # Enable the OpenSSH daemon.
    # openssh.enable = true;
  
    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      videoDrivers = [ "nvidia" ];
  
      # Enable touchpad support.
      # libinput.enable = true;
  
      displayManager.lightdm.enable = true;
      desktopManager = {
        gnome3.enable = true;
        default = "gnome3";
      };
    };

  };

  # doesn't work for some reason
  #systemd.user.services.xbindkeys = {
  #  description = "XBindKeys";
  #  serviceConfig = {
  #    #Type = "simple";
  #    ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys --nodaemon --file /home/.xbindkeysrc";
  #    ExecStop = "${pkgs.procps}/bin/pkill xbindkeys";
  #    Restart = "on-abort";
  #  };
  #  wantedBy = [ "graphical.target" ];
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    isNormalUser = true;
    home = "/home";
    description = "Tim Baumann";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  system.autoUpgrade.enable = true;

}
