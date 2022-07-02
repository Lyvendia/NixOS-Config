{ config, pkgs, ... }:

{
  powerManagement.cpuFreqGovernor = "schedutil";

  hardware.cpu.amd.updateMicrocode = true;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  networking = {
    hostName = "Luxtop"; 
    networkmanager.enable = true;
  };
}
