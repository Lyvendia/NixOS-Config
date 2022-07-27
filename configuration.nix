# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secrets.nix
      <home-manager/nixos>
    ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot = {
        enable = true;
        consoleMode = "0";
        configurationLimit = 24;
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;

    # Setup keyfile
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "loglevel=3" "rd.systemd.show_status=auto" "rd.udev.log_level=3" ];
  };

  networking = {
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
  };

  security = {
    rtkit.enable = true;  
    sudo.wheelNeedsPassword = false;
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;    
      displayManager = {
        gdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "luna";
      };
      desktopManager.gnome.enable = true;
      layout = "de";
      xkbVariant = "nodeadkeys";
      xkbOptions = "caps:swapescape"; 
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      #alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    fwupd.enable = true;
    flatpak.enable = true;
    usbmuxd.enable = true;
    spice-vdagentd.enable = true;
    power-profiles-daemon.enable = false;
  };  

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  hardware = {
    ledger.enable = true;
    opengl = {
      enable = true;
    };
    opentabletdriver.enable = true;
    pulseaudio.enable = false;
  };

  # Enable sound with pipewire.
  sound.enable = true;

  fonts.fontDir.enable = true;

  users.users.luna = {
    isNormalUser = true;
    description = "Luna Specht";
    extraGroups = [ "networkmanager" "wheel" "audio" "disk" "input" "kvm" "optical" "scanner" "storage" "video" "libvirtd" "adbusers" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  # Browsers
    firefox
  # Gnome
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
    gnome-solanum
    gnomeExtensions.appindicator
    gnomeExtensions.legacy-gtk3-theme-scheme-auto-switcher
  # Utils
    htop
    ncdu
    usbutils
    file
    lm_sensors
    nmap
    smartmontools
    android-udev-rules
  # Audio
    pavucontrol
    helvum
    easyeffects
  # Other
    signal-desktop
    discord
    strongswan
    remmina
    virt-manager
    virt-viewer
    unstable.ledger-live-desktop
    checkra1n
    vscodium
    gimp
    android-file-transfer
  ];

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
          set nocompatible
          filetype on
          filetype plugin on
          filetype indent on
          syntax on
          set shiftwidth=2
          set tabstop=2
          set expandtab
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          # loaded on launch
          start = [ vim-nix ];
          # manually loadable by calling `:packadd $plugin-name`
          opt = [ ];
        };
      };
    };
    adb.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
  };

  environment.shellAliases = {
    nixos-edit = "sudoedit /etc/nixos/configuration.nix";
    nixos-apply = "sudo nixos-rebuild switch";
    nixos-apply-upgrade = "sudo nixos-rebuild switch --upgrade";
    fordc = "sudo swanctl -i -c SRB-EDV";
    fordd = "sudo swanctl -t -c SRB-EDV";
  };

  home-manager.users.luna = { pkgs, ... }: {
    home.packages = [  ];
    programs = {
      git = {
        enable = true;
        userName  = "Lyvendia";
        userEmail = "lyvendia@tutanota.com";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
