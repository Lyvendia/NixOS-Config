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

  home-manager.users.luna = { pkgs, ... }: {
    programs = {
      xmobar = {
        extraConfig = ''
          Config { overrideRedirect = False
                 , font     = "xft:SauceCodePro Nerd Font Mono:size=8:antialias=true"
                 , bgColor  = "#000000"
                 , fgColor  = "#f8cdae"
                 , position = Static { xpos = 0, ypos = 0, width = 1808, height = 16 }
                 , commands = [ Run Cpu
                                  [ "-L", "3"
                                  , "-H", "50"
                                  , "--high"  , "red"
                                  , "--normal", "green"
                                  ] 10
                              , Run Memory ["--template", "Mem: <usedratio>%"] 10
                              , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                              , Run XMonadLog
                              ]
                 , sepChar  = "%"
                 , alignSep = "}{"
                 , template = "%XMonadLog% }{ %cpu% | %memory% | %date% "
                 }
        '';
      };
      stalonetray = {
        config = {
          background = "#000000";
          geometry = "7x1-0+0";
          icon_size = 16;
          kludges = "force_icons_size";
          window_layer = "bottom";
          grow_gravity = "SE";
          icon_gravity = "SE";
        };
      };
    };
  };
}
