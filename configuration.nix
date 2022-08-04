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
      timeout = 0;
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
    flatpak.enable = true;
    usbmuxd.enable = true;
    spice-vdagentd.enable = true;
    power-profiles-daemon.enable = false;
  };  

  systemd.services = {
    packagekit.enable = false;
    NetworkManager-wait-online.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "audio" "disk" "input" "kvm" "optical" "scanner" "storage" "video" "libvirtd" "adbusers" "docker" ];
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
    bundix
    pinentry-curses
		gcc
  ];

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
          lua <<EOF

          vim.o.termguicolors = true
          vim.o.tabstop = 2
          vim.o.shiftwidth = 0
          vim.o.softtabstop = -1 
          vim.o.expandtab = true
          vim.o.clipboard = unnamedplus
          vim.o.number = true
          vim.o.relativenumber = true
          vim.o.ignorecase = true
          vim.o.smartcase = true
          vim.o.undofile = true

          require'nvim-treesitter.configs'.setup {
            ensure_installed = { "nix" },
            sync_install = false,
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          }

          vim.cmd("colorscheme nightfox")

          EOF
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ nvim-treesitter nightfox-nvim ];
          opt = [ ];
        };
      };
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
    adb.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "xterm-kitty";
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
      bash = {
        enable = true;
        bashrcExtra = ''
          set -o vi
        '';
      };
      git = {
        enable = true;
        userName  = "Lyvendia";
        userEmail = "lyvendia@tutanota.com";
        signing = {
          key = "5754213C2E27F5AD";
          signByDefault = true;
        };
      };
      kitty = {
        enable = true;
        settings = {
          font_size = "14.0";
          remember_window_size = "yes";
         
          # Nightfox colors for Kitty
          ## name: nightfox
          ## upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/nightfox/nightfox_kitty.conf

          background = "#192330";
          foreground = "#cdcecf";
          selection_background = "#2b3b51";
          selection_foreground = "#cdcecf";
          url_color = "#81b29a";

          # Cursor
          # uncomment for reverse background
          # cursor none
          cursor = "#cdcecf";

          # Border
          active_border_color = "#719cd6";
          inactive_border_color = "#39506d";
          bell_border_color = "#f4a261";

          # Tabs
          active_tab_background = "#719cd6";
          active_tab_foreground = "#131a24";
          inactive_tab_background = "#2b3b51";
          inactive_tab_foreground = "#738091";

          # normal
          color0 = "#393b44";
          color1 = "#c94f6d";
          color2 = "#81b29a";
          color3 = "#dbc074";
          color4 = "#719cd6";
          color5 = "#9d79d6";
          color6 = "#63cdcf";
          color7 = "#dfdfe0";

          # bright
          color8 = "#575860";
          color9 = "#d16983";
          color10 = "#8ebaa4";
          color11 = "#e0c989";
          color12 = "#86abdc";
          color13 = "#baa1e2";
          color14 = "#7ad4d6";
          color15 = "#e4e4e5";

          # extended colors
          color16 = "#f4a261";
          color17 = "#d67ad2";
        };
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
