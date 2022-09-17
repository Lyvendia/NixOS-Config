{ config, pkgs, ... }:

{
  imports =
    [ 
      ./boot.nix
      ./configuration.nix
      ./environment.nix
      ./home.nix
      ./networking.nix
      ./programs.nix
      ./services.nix
      ./systemPackages.nix
    ];
}
