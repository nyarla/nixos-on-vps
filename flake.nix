{
  inputs = {
    systems.url = "github:nix-systems/default";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    nixpkgs.inputs.nixpkgs.follows = "nixpkgs";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    impermanence.url = "github:nix-community/impermanence";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.inputs.utils.follows = "flake-utils";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.systems.follows = "systems";

    self.submodules = true;
    sensitive.url = ./sensitive;
  };

  outputs =
    {
      self,
      flake-utils,

      nixpkgs,
      unstable,

      impermanence,
      deploy-rs,

      agenix,

      sensitive,
      ...
    }:
    {
      nixosConfigurations = {
        nyke = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            vars = import ./system/nodes/nyke/vars.nix;
          };
          modules = [
            (_: {
              nixpkgs.overlays = [
                (import ./pkgs/default.nix)
                (import ./pkgs/unstable.nix { inherit (unstable.legacyPackages."x86_64-linux") pkgs; })
              ];
            })
            impermanence.nixosModules.impermanence
            sensitive.nixosModules.nyke
            agenix.nixosModules.default
            ./system/profile/nyke.nix
          ];
        };
      };

      deploy.nodes.nyke = {
        hostname = "nyke";
        sshUser = "console";
        interactiveSudo = true;
        activationTimeout = 600;
        confirmTimeout = 120;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nyke;
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    }
    // flake-utils.lib.eachDefaultSystem (system: rec {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
        ];
      };

      devShells.default = pkgs.mkShell {
        name = "nixos-on-vps";
        packages =
          [
            (pkgs.callPackage ./default.nix { })
          ]
          ++ [
            pkgs.deploy-rs
            agenix.packages.${system}.default
          ]
          ++ [
            (pkgs.nixos-rebuild.override { nix = pkgs.nixVersions.git; })
          ];
      };
    });
}
