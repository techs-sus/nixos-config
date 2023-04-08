{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = { nixpkgs, home-manager, nix-vscode-extensions, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        tech = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tech = {
                imports = [
                  (import ./home.nix {
                    inherit nix-vscode-extensions pkgs;
                  })
                ];
              };
            }
          ];
        };
      };
      # hmConfig = {
      #   tech = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [
      #       import ./home {
      #         inherit nix-vscode-extensions;
      #       }
      #       {
      #         home = {
      #           username = "tech";
      #           homeDirectory = "/home/tech";
      #           stateVersion = "23.05";
      #         };
      #       }
      #     ];
      #   };
      # };
    };
}
