# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fd9f8def-c50b-44df-9b7f-7868eea22024";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-c325aa85-30db-4ddd-b06e-899624ae33fe".device = "/dev/disk/by-uuid/c325aa85-30db-4ddd-b06e-899624ae33fe";

  boot.initrd.luks.devices."luks-96e04338-0a59-4699-b2d1-1e0bbb552688".device = "/dev/disk/by-uuid/96e04338-0a59-4699-b2d1-1e0bbb552688";
  boot.initrd.luks.devices."luks-96e04338-0a59-4699-b2d1-1e0bbb552688".keyFile = "/crypto_keyfile.bin";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/F31B-B852";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/de806f95-a024-4cd5-b233-2337312de69d"; }
    ];

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.br0.useDHCP = lib.mkDefault true;
  networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


  boot = {
    blacklistedKernelModules = [
      "snd_hda_codec_hdmi"
    ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
    '';
  };

  networking = {
    hostName = "Luxputer"; 
    networkmanager.enable = true;
    bridges = {
      "br0" = {
        interfaces = [ "enp0s31f6" ];
      };
    };
    firewall = {
      extraCommands = ''
        iptables -A nixos-fw -p tcp --source 192.168.0.0/24 -j nixos-fw-accept
        iptables -A nixos-fw -p udp --source 192.168.0.0/24 -j nixos-fw-accept
        ip6tables -A nixos-fw -p tcp --source fc00::/7 -j nixos-fw-accept
        ip6tables -A nixos-fw -p udp --source fc00::/7 -j nixos-fw-accept
      '';

      extraStopCommands = ''
        iptables -D nixos-fw -p tcp --source 192.168.0.0/24 -j nixos-fw-accept || true
        iptables -D nixos-fw -p udp --source 192.168.0.0/24 -j nixos-fw-accept || true
        ip6tables -D nixos-fw -p tcp --source fc00::/7 -j nixos-fw-accept || true    
        ip6tables -D nixos-fw -p udp --source fc00::/7 -j nixos-fw-accept || true
      '';
    };
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      screenSection = ''
        Option        "metamodes" "DP-2: 2560x1440_100 +0+0 {AllowGSYNC=Off}" 
      '';
      deviceSection = ''
        Option        "Coolbits" "12"
      '';
    };
    pipewire = {
      jack.enable = true;
      alsa.support32Bit = true;
      config.pipewire = {
        "context.properties" = {
          ##"link.max-buffers" = 64;
          "link.max-buffers" = 16; # version < 3 clients can't handle more than this
          "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
          "default.clock.rate" = 44100;
          "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
    udev = {
      extraRules = ''
        SUBSYSTEM=="pci", ATTR{power/control}="auto"
      '';
    };
    fstrim.enable = true;
  };
  
  environment = {
    shellAliases = {
      run-supertuxkart = "gamemoderun gamescope -h 823 -U -f --sharpness 0 -- supertuxkart > /dev/null";
    };
    systemPackages = with pkgs; [
      polychromatic
      ardour
      calf
      helm
      surge-XT
      brave
      ledger-live-desktop
      lutris
      spotdl
      ventoy-bin
      gwe
      nvtop
      heimdall
    ];
    etc = {
      "wireplumber/main.lua.d/50-alsa-config.lua".text = ''
        alsa_monitor.enabled = true
        alsa_monitor.properties = {
          ["alsa.reserve"] = true,
          ["alsa.midi"] = true,
          ["alsa.midi.monitoring"] = true,
          ["vm.node.defaults"] = {
            ["api.alsa.period-size"] = 256,
            ["api.alsa.headroom"] = 8192,
          },
        }
        alsa_monitor.rules = {
          {
            matches = {
              {
                { "device.name", "matches", "alsa_card.*" },
              },
            },
            apply_properties = {
              ["api.alsa.use-acp"] = true,
              ["api.acp.auto-profile"] = false,
              ["api.acp.auto-port"] = false,
            },
          },
          {
            matches = {
              {
                { "node.name", "matches", "alsa_input.*" },
              },
              {
                { "node.name", "matches", "alsa_output.*" },
              },
            },
            apply_properties = {
              ["session.suspend-timeout-seconds"] = 0
            },
          },
        }
      '';
    };
  };

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  hardware = {
    openrazer.enable = true;
    openrazer.users = [ "luna" ];
    nvidia = {
      modesetting.enable = true;
      package = (config.nur.repos.arc.packages.nvidia-patch.overrideAttrs (_: rec {
        src = pkgs.fetchFromGitHub {
          owner = "keylase";
          repo = "nvidia-patch";
          rev = "e1adaaedfa4490c135e359095e085673d6cb1570";
          sha256 = "sha256-KI3kHwZewxXpdwdPM2hFPDLFtf/F9u6KCA+7+/tSLSY=";
        };
      })).override {
        linuxPackages = config.boot.kernelPackages;
      };
    };
    opengl.driSupport32Bit = true;
  };

  powerManagement = {
    cpuFreqGovernor = "powersave";
    scsiLinkPolicy = "med_power_with_dipm";
  };

  systemd.services.nvidia-tdp = {
    enable = true;
    description = "Set NVIDIA power limit";
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nvidia-smi -pl 200";
    };
  };

  home-manager.users.luna = { pkgs, ... }: {
    programs = {
      alacritty.settings.font.size = 11;
      xmobar = {
        extraConfig = ''
          Config { overrideRedirect = False
                 , font     = "xft:SauceCodePro Nerd Font Mono:size=8:antialias=true"
                 , bgColor  = "#000000"
                 , fgColor  = "#f8cdae"
                 , position = Static { xpos = 0, ypos = 0, width = 2448, height = 16 }
                 , commands = [ Run DynNetwork
                              [ "--template"  , "<dev>: <tx>kB/s|<rx>kB/s"
                              , "--Low"       , "1000"       -- units: B/s
                              , "--High"      , "5000"       -- units: B/s
                              ] 50

                              , Run MultiCpu        
                              [ "--template"  , "Cpu: <total>%"
                              , "--Low"       , "50"         -- units: %
                              , "--High"      , "85"         -- units: %
                              , "--low"       , "#f8cdae"
                              , "--normal"    , "darkorange"
                              , "--high"      , "darkred"
                              ] 50
        
                              , Run MultiCoreTemp
                              [ "--template"  , "Temp: <avg>°C"
                              , "--Low"       , "70"        -- units: °C
                              , "--High"      , "80"        -- units: °C
                              , "--low"       , "#f8cdae"
                              , "--normal"    , "darkorange"
                              , "--high"      , "darkred"
                              ] 200
                              
                              , Run Memory
                              [ "--template"  ,"Mem: <usedratio>%"
                              , "--Low"       , "50"        -- units: %
                              , "--High"      , "90"        -- units: %
                              , "--low"       , "#f8cdae"
                              , "--normal"    , "darkorange"
                              , "--high"      , "darkred"
                              ] 50

                              , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                              , Run XMonadLog
                              ]
                 , sepChar  = "%"
                 , alignSep = "}{"
                 , template = "%XMonadLog% }{ %multicpu% | %multicoretemp% | %memory% | %dynnetwork% | %date% "
                 }
        '';
      };
    };
    services = {
      stalonetray = {
        config = {
          background = "#000000";
          geometry = "7x1-0+0";
          icon_size = 16;
          kludges = "force_icons_size";
          window_layer = "bottom";
          grow_gravity = "SE";
          icon_gravity = "SE";
        };
      };
    };
  };
}
