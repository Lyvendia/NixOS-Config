{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxputer-Nix"; 
    networkmanager.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      screenSection = ''
        Option         "metamodes" "DP-2: 2560x1440_120 +0+0 {AllowGSYNC=Off}, DP-4: 1920x1080_120 +2560+0 {rotation=left, AllowGSYNC=Off}"
      '';
    };

    pipewire = {
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
  };

  hardware = {
    nvidia.powerManagement.enable = true;
  };

}