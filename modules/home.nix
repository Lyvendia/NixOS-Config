{ config, pkgs, ... }:

{
  home-manager.users.luna = { pkgs, ... }: {
    home = {
      packages = [ ];
      stateVersion = "22.05";
      pointerCursor = {
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
        size = 16;
        x11.enable = true;
        gtk.enable = true;
      };
    };
    xsession = {
      enable = true;
      initExtra = ''
        hsetroot -solid "#000000"
        xsetroot -cursor_name left_ptr
      '';
    };
    programs = {
      xmobar = {
        enable = true;
      };
      bash = {
        enable = true;
        bashrcExtra = ''
          set -o vi
        '';
      };
      git = {
        enable = true;
        userName  = "Lyvendia";
        userEmail = "lyvendia@tutanota.com";
        signing = {
          key = "5754213C2E27F5AD";
          signByDefault = true;
        };
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
          submodule = {
            recurse = true;
          };
        };
      };
      alacritty = {
        enable = true;
        settings = {
          font = {
            normal = {
              family = "SauceCodePro Nerd Font Mono";
            };
          };
        };
      };
      obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.obs-nvfbc ];
      };
    };
    services = {
      xscreensaver = {
        enable = true;
        settings = { 
          mode = "blank";
        };
      };
      stalonetray = {
        enable = true;
     };
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Red-Dark";
      };
      iconTheme = {
        package = pkgs.flat-remix-icon-theme;
        name = "Flat-Remix-Red-Dark";
      };
    };
  };
}
