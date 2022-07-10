{ config, pkgs, ... }:

{
  kernelPackages = pkgs.linuxPackages_latest;

  boot = {
    kernelParams = [
      "initcall_blacklist=acpi_cpufreq_init"
    ];
    kernelModules = ["amd-pstate"];
  };

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
