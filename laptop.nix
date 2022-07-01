{ config, pkgs, ... }:

{
  networking = {
    hostName = "Luxtop"; 
    networkmanager.enable = true;
  };
}
