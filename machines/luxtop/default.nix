{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4010097b-59ef-4253-b822-fce4fee1ee26";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-4fc0fd2c-3182-4b4d-9b7d-c9814e3c9fd4".device = "/dev/disk/by-uuid/4fc0fd2c-3182-4b4d-9b7d-c9814e3c9fd4";

  boot.initrd.luks.devices."luks-d0d6cb9b-0135-4819-b46d-13605a4106ad".device = "/dev/disk/by-uuid/d0d6cb9b-0135-4819-b46d-13605a4106ad";
  boot.initrd.luks.devices."luks-d0d6cb9b-0135-4819-b46d-13605a4106ad".keyFile = "/crypto_keyfile.bin";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/C656-4527";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/3ffbc02b-66bc-42ab-9752-1815bea8a303"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    kernelParams = [
      "initcall_blacklist=acpi_cpufreq_init"
    ];
    kernelModules = [ "kvm-amd" "amd-pstate" ];
  };

  networking = {
    hostName = "Luxtop"; 
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  environment = {
    shellAliases = {
      run-supertuxkart = "gamemoderun gamescope -h 540 -U -f --sharpness 0 -- supertuxkart > /dev/null";
    };
    systemPackages = with pkgs; [
      lutris
    ];
  };

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 2"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 2"; }
    ];
  };

  services = {
    xserver = {
      libinput = {
        enable = true;
      };
    };
    tlp = {
      enable = true;
    };
    #fwupd.service = true;
    fstrim.enable = true;
  };

  home-manager.users.luna = { pkgs, ... }: {
    programs = {
      alacritty.settings.font.size = 8;
      xmobar = {
        extraConfig = ''
          Config { overrideRedirect = False
                 , font     = "xft:SauceCodePro Nerd Font Mono:size=10:antialias=true"
                 , bgColor  = "#000000"
                 , fgColor  = "#f8cdae"
                 , position = Static { xpos = 0, ypos = 0, width = 1800, height = 24 }
                 , commands = [ Run DynNetwork     
                              [ "--template"  , "<dev>: <tx>kB/s|<rx>kB/s"
                              , "--Low"       , "1000"       -- units: B/s
                              , "--High"      , "5000"       -- units: B/s
                              ] 50
                              
                              , Run MultiCpu        
                              [ "--template"  , "Cpu: <total>%"
                              , "--Low"       , "50"         -- units: %
                              , "--High"      , "85"         -- units: %
                              , "--low"       , "#f8cdae"
                              , "--normal"    , "darkorange"
                              , "--high"      , "red"
                              ] 50
        
                              , Run K10Temp "0000:00:18.3"
                              [ "--template"  , "Temp: <Tctl>°C"
                              , "--Low"       , "70"        -- units: °C
                              , "--High"      , "80"        -- units: °C
                              , "--low"       , "#f8cdae"
                              , "--normal"    , "darkorange"
                              , "--high"      , "red"
                              ] 200
                              
                              , Run Memory
                              [ "--template"  ,"Mem: <usedratio>%"
                              , "--Low"       , "50"        -- units: %
                              , "--High"      , "90"        -- units: %
                              , "--low"       , "#f8cdae"
                              , "--normal"    , "darkorange"
                              , "--high"      , "red"
                              ] 50

                              , Run Battery
                              [ "--template"  , "Batt: <acstatus>"
                              , "--Low"       , "20"        -- units: %
                              , "--High"      , "80"        -- units: %
                              , "--low"       , "darkorange"
                              , "--normal"    , "#f8cdae"
                              , "--high"      , "darkgreen"

                              , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging</fc> <left>% (<timeleft>)"
                                       -- charged status
                                       , "-i"	, "<fc=#006000>Charged</fc>"
                              ] 200

                              , Run Date 
                              "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 50
                              
                              , Run XMonadLog
                              ]
                 , sepChar  = "%"
                 , alignSep = "}{"
                 , template = "%XMonadLog% }{ %battery% | %multicpu% | %k10temp% | %memory% | %dynnetwork% | %date% "
                 }
        '';
      };
    };
    services = {
      stalonetray = {
        config = {
          background = "#000000";
          geometry = "5x1-0+0";
          icon_size = 24;
          kludges = "force_icons_size";
          window_layer = "bottom";
          grow_gravity = "SE";
          icon_gravity = "SE";
        };
      };
    };
  };
}
