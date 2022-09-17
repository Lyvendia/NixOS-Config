{ config, pkgs, ... }:

{
  networking = {
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
  };
}
