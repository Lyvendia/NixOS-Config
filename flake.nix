{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
      
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = github:nix-community/nur;
    };

  };
  outputs = { self, nixpkgs, home-manager, nur }: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true; 
      };
    };
  in
  {
    nixosConfigurations = {
      Luxputer = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [ 
          ./machines/luxputer
          ./NixOS-Secrets/vpn.nix
          ./modules
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
        ];
      };
      Luxtop = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [ 
          ./machines/luxtop
          ./NixOS-Secrets/vpn.nix
          ./NixOS-Secrets/wifi.nix
          ./NixOS-Secrets/vpnHome.nix
          ./modules
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
        ];
      };  
    };
  };
}
