{ config, pkgs, ... }:

{
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
      XKB_DEFAULT_LAYOUT = "de";
      GTK_USE_PORTAL = "1";
    };
    shellAliases = {
      nixos-apply = "sudo nixos-rebuild switch --flake '.?submodules=1#'";
      nixos-dry-run = "sudo nixos-rebuild dry-run --flake '.?submodules=1#'";
      fordc = "sudo swanctl -i -c SRB-EDV";
      fordd = "sudo swanctl -t -c SRB-EDV";
    };
  };
}
