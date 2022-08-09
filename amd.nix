{ config, pkgs, ... }:

{
  boot = {
    kernelParams = [
      "initcall_blacklist=acpi_cpufreq_init"
    ];
    kernelModules = [ "amd-pstate" ];
  };
}
