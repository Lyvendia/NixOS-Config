# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
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
      };
    };

    # Setup keyfile
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    # Enable swap on luks
    initrd.luks.devices."luks-96e04338-0a59-4699-b2d1-1e0bbb552688".device = "/dev/disk/by-uuid/96e04338-0a59-4699-b2d1-1e0bbb552688";
    initrd.luks.devices."luks-96e04338-0a59-4699-b2d1-1e0bbb552688".keyFile = "/crypto_keyfile.bin";

    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "loglevel=3" "rd.systemd.show_status=auto" "rd.udev.log_level=3" ];

    plymouth.enable = true;
  };


  security.sudo.wheelNeedsPassword = false;

  networking = {
    hostName = "Luxputer-Nix"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;    
    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
      autoLogin.enable = true;
      autoLogin.user = "luna";
    };
    desktopManager.gnome.enable = true;
    layout = "de";
    xkbVariant = "nodeadkeys";
    videoDrivers = [ "nvidia" ];
    autoRepeatDelay = 100;
    autoRepeatInterval = 20;
    screenSection = ''
      Option         "metamodes" "DP-2: 2560x1440_120 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNC=Off}, DP-4: 1920x1080_120 +2560+0 {rotation=left, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNC=Off}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.flatpak.enable = true;

  hardware = {
    ledger.enable = true;
    opengl.enable = true;
    nvidia.powerManagement.enable = true;
    pulseaudio.enable = false;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    config.pipewire = {
      "context.properties" = {
        #"link.max-buffers" = 64;
        "link.max-buffers" = 16; # version < 3 clients can't handle more than this
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        "default.clock.rate" = 44100;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 8192;
      };
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luna = {
    isNormalUser = true;
    description = "Luna Specht";
    extraGroups = [ "networkmanager" "wheel" "audio" "disk" "input" "kvm" "optical" "scanner" "storage" "video" "libvirtd" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    firefox
    brave
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
    gnomeExtensions.appindicator
    bitwarden
    pavucontrol
    helvum
    htop
    ncdu
    signal-desktop
    discord
    easyeffects
    vulnix
    strongswan
    remmina
    gnumake
    cargo
    rustc
    gcc
    appimage-run
    virt-manager
    ardour
    gh
  ];

  programs.neovim = {
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

  programs.git = {
    enable = true;
    config = {

    };
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
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
    programs.git = {
      enable = true;
      userName  = "Lyvendia";
      userEmail = "lyvendia@tutanota.com";
    };
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
