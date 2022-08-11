{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxtop"; 
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  services = {
    tlp.enable = true;
    #fwupd.service = true;
  };
}
