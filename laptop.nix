{ config, pkgs, ... }:

{
  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    bluetooth.powerOnBoot = false;
  };

  services = {
    tlp.enable = true;
  };

  networking = {
    hostName = "Luxtop"; 
    networkmanager.enable = true;
  };
}
