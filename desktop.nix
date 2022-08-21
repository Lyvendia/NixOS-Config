{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxputer-Nix"; 
  };

  services = {
    pipewire = {
      jack.enable = true;
      alsa.support32Bit = true;
      config.pipewire = {
        "context.properties" = {
          ##"link.max-buffers" = 64;
          "link.max-buffers" = 16; # version < 3 clients can't handle more than this
          "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
  };
  
  environment.etc = {
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

  networking.firewall = {
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

  hardware = {
    openrazer.enable = true;
    openrazer.users = [ "luna" ];
  };

  powerManagement = {
    cpuFreqGovernor = "performance";
    scsiLinkPolicy = "med_power_with_dipm";
  };

  environment.shellAliases = {
    run-supertuxkart = "gamemoderun gamescope -h 823 -U -f --sharpness 0 -- supertuxkart > /dev/null";
  };

  environment.systemPackages = with pkgs; [
    polychromatic
    mangohud
    goverlay
    vkBasalt
    ardour
    calf
    helm
    aether-lv2
    cardinal
    dragonfly-reverb
    zam-plugins
    surge-XT
    brave
    ledger-live-desktop
    android-file-transfer
    lutris
  ];

}
