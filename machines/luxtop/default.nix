{ config, pkgs, ... }:

{
  boot = {
    kernelParams = [
      "initcall_blacklist=acpi_cpufreq_init"
    ];
    kernelModules = [ "amd-pstate" ];
  };

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

  environment.shellAliases = {
    run-supertuxkart = "gamemoderun gamescope -h 540 -U -f --sharpness 0 -- supertuxkart > /dev/null";
  };

  services = {
    tlp = {
      enable = true;
    };
    #fwupd.service = true;
  };
}
