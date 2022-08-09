{ config, pkgs, ... }:

{
  services = {
    xserver = {
      #displayManager.gdm.wayland = false;
      videoDrivers = [ "nvidia" ];
      screenSection = ''
        Option        "metamodes" "DP-2: 2560x1440_120 +0+0 {AllowGSYNC=Off}, DP-4: 1920x1080_120 +2560+0 {rotation=left, AllowGSYNC=Off}"
      '';
      deviceSection = ''
        Option        "Coolbits" "12"
      '';
    };
  };

  hardware = {
    nvidia = {
      #powerManagement.enable = true;
      modesetting.enable = true;
      package = (pkgs.nur.repos.arc.packages.nvidia-patch.overrideAttrs (_: rec {
        src = pkgs.fetchFromGitHub {
          owner = "keylase";
          repo = "nvidia-patch";
          rev = "80368e3701ecfcf8c370852b8491348290afc0a8";
          sha256 = "sha256-IrFAUYO++cg5YAGmleDYGKvyyPdAHTJ/pOdohHUOy/o=";
        };
      })).override {
        linuxPackages = config.boot.kernelPackages;
      };
    };
  };

  systemd.services.nvidia-tdp = {
    enable = true;
    description = "Set NVIDIA power limit";
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nvidia-smi -pl 225";
    };
  };

  environment.systemPackages = with pkgs; [
    gwe
  ]; 
}

