{ config, pkgs, ... }:

{
  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    bluetooth.powerOnBoot = false;
  };

  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = true;
  };

  networking = {
    hostName = "Luxtop"; 
    networkmanager.enable = true;
  };
}
