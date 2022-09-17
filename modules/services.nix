{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;    
      displayManager = {
        sddm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "luna";
        defaultSession = "none+xmonad";
      };
      desktopManager = {
        wallpaper.mode = "fill";
        runXdgAutostartIfNone = true;
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = (builtins.readFile ./xmonad/config.hs);
      };
      libinput = {
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
        };
      };
      layout = "de";
      xkbVariant = "nodeadkeys";
      xkbOptions = "caps:escape"; 
      autoRepeatDelay = 600;
      autoRepeatInterval = 25;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    journald.extraConfig = ''
      SystemMaxUse=2G
    '';
    picom = {
      enable = true;
      shadow = true;
      vSync = true;
      inactiveOpacity = 0.8;
    };
    openssh = {
      enable = false;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    flatpak.enable = true;
    usbmuxd.enable = true;
    spice-vdagentd.enable = true;
  }; 
}
