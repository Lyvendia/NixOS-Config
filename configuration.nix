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

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    ];
  };

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
          vim.o.autoindent = true

          require'nvim-treesitter.configs'.setup {
            ensure_installed = { "nix" },
            sync_install = false,
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          }

          vim.g.tokyonight_style = "night"

          vim.cmd("colorscheme tokyonight")

          EOF
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ nvim-treesitter tokyonight-nvim ];
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
          font_family = "SauceCodePro Nerd Font Mono";
          remember_window_size = "yes";
         
          ## name: Tokyo Night
          ## license: MIT
          ## author: Folke Lemaitre
          ## upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty_tokyonight_night.conf

          background = "#1a1b26";
          foreground = "#c0caf5";
          selection_background = "#33467C";
          selection_foreground = "#c0caf5";
          url_color = "#73daca";
          cursor = "#c0caf5";

          # Tabs
          active_tab_background = "#7aa2f7";
          active_tab_foreground = "#1f2335";
          inactive_tab_background = "#292e42";
          inactive_tab_foreground = "#545c7e";
          #tab_bar_background = "#15161E";

          # normal
          color0 = "#15161E";
          color1 = "#f7768e";
          color2 = "#9ece6a";
          color3 = "#e0af68";
          color4 = "#7aa2f7";
          color5 = "#bb9af7";
          color6 = "#7dcfff";
          color7 = "#a9b1d6";

          # bright
          color8 = "#414868";
          color9 = "#f7768e";
          color10 = "#9ece6a";
          color11 = "#e0af68";
          color12 = "#7aa2f7";
          color13 = "#bb9af7";
          color14 = "#7dcfff";
          color15 = "#c0caf5";

          # extended colors
          color16 = "#ff9e64";
          color17 = "#db4b4b";
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
