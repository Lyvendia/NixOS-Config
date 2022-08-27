{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxtop"; 
    networkmanger.enable = true;
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
