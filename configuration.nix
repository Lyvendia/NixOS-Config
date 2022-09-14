# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #./secrets.nix
    ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

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
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

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
        sddm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "luna";
        defaultSession = "none+xmonad";
      };
      desktopManager = {
        wallpaper.mode = "fill";
        runXdgAutostartIfNone = true;
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = (builtins.readFile ./xmonad/config.hs);
      };
      libinput = {
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
        };
      };
      layout = "de";
      xkbVariant = "nodeadkeys";
      xkbOptions = "caps:escape"; 
      autoRepeatDelay = 600;
      autoRepeatInterval = 25;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    journald.extraConfig = ''
      SystemMaxUse=2G
    '';
    picom = {
      enable = true;
      shadow = true;
      vSync = true;
      inactiveOpacity = 0.8;
    };
    openssh = {
      enable = false;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    flatpak.enable = true;
    usbmuxd.enable = true;
    spice-vdagentd.enable = true;
  };  

  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  console.keyMap = "de-latin1-nodeadkeys";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware = {
    ledger.enable = true;
    opengl = {
      enable = true;
    };
    opentabletdriver.enable = true;
    pulseaudio.enable = false;
  };

  sound = {
    enable = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
    ];
  };

  users.users.luna = {
    isNormalUser = true;
    description = "Luna Specht";
    extraGroups = [ "networkmanager" "wheel" "audio" "disk" "input" "kvm" "optical" "scanner" "storage" "video" "libvirtd" "adbusers" "wireshark" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
#   Browsers
    firefox
    tor-browser-bundle-bin
#   Files
    pcmanfm
#   Utils
    bitwarden
    remmina
    virt-manager
    virt-viewer
    arandr
    htop
    ncdu
    usbutils
    checkra1n
    file
    lm_sensors
    nmap
    smartmontools
    android-udev-rules
    neofetch
    xclip
    killall
    pciutils
#   Menus etc
    dmenu
#   Audio
    pavucontrol
    helvum
    easyeffects
#   NUR
    config.nur.repos.dukzcry.gamescope
#   Language Servers
    rnix-lsp
    sumneko-lua-language-server
    haskell-language-server
#   Games
    polymc
    minetest
    superTuxKart
#   Chat
    signal-desktop
#   Vpn
    strongswan
#   Media
    gimp
    vlc
    mpv
    tauon
    # office
    onlyoffice-bin
    libreoffice-qt
    # spelling etc
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE
    # libs
    ffmpegthumbnailer
    poppler
    freetype
    libgsf
    pstree
#   Other
    vscodium
    git-crypt
  ];

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = (builtins.readFile ./neovim/init.lua);
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            (nvim-treesitter.withPlugins (
              (plugins: pkgs.tree-sitter.allGrammars)
            ))
            tokyonight-nvim
            nvim-lspconfig
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-cmdline
            nvim-cmp
            luasnip
            friendly-snippets
            cmp_luasnip
            lspkind-nvim
            lualine-nvim
            nvim-web-devicons
            nvim-tree-lua
          ];
          opt = [ ];
        };
      };
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
    adb.enable = true;
    tmux.enable = true;
    fish.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    wireshark.enable = true;
    file-roller.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    XKB_DEFAULT_LAYOUT = "de";
    GTK_USE_PORTAL = "1";
  };

  environment.shellAliases = {
    nixos-apply = "sudo nixos-rebuild switch --flake \".?submodules=1#\"";
    nixos-dry-run = "nixos-rebuild dry-run --flake \".?submodules=1#\"";
    fordc = "sudo swanctl -i -c SRB-EDV";
    fordd = "sudo swanctl -t -c SRB-EDV";
  };

  home-manager.users.luna = { pkgs, ... }: {
    home = {
      packages = [ ];
      stateVersion = "22.05";
      pointerCursor = {
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
        size = 16;
        x11.enable = true;
        gtk.enable = true;
      };
    };
    xsession = {
      enable = true;
      initExtra = ''
        xsetroot -cursor_name left_ptr
      '';
    };
    programs = {
      xmobar = {
        enable = true;
      };
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
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
          submodule = {
            recurse = true;
          };
        };
      };
      alacritty = {
        enable = true;
        settings = {
          font = {
            normal = {
              family = "SauceCodePro Nerd Font Mono";
            };
          };
        };
      };
      obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.obs-nvfbc ];
      };
    };
    services = {
      xscreensaver = {
        enable = true;
        settings = { 
          mode = "blank";
        };
      };
      stalonetray = {
        enable = true;
     };
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.pop-gtk-theme;
        name = "Pop-dark";
      };
      iconTheme = {
        package = pkgs.pop-icon-theme;
        name = "Pop";
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
