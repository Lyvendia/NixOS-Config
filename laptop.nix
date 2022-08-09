{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxtop"; 
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    bluetooth.powerOnBoot = false;
  };

  services = {
    tlp.enable = true;
    #fwupd.service = true;
  };
}
