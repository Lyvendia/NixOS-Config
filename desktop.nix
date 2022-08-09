{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxputer-Nix"; 
  };

  services = {
    pipewire = {
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

  environment.systemPackages = with pkgs; [
    polychromatic
    lutris
    xclip
  ];

}
