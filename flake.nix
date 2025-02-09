{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.inputs.nixpkgs.follows = "nixpkgs";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    impermanence.url = "github:nix-community/impermanence";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sensitive.url = "git+file:sensitive";
  };

  outputs =
    {
      self,
      flake-utils,

      nixpkgs,
      unstable,

      impermanence,
      deploy-rs,

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
        overlays = [ ];
      };

      devShells.default = pkgs.mkShell {
        name = "nixos-on-vps";
        packages = [
          (pkgs.callPackage ./default.nix { })
        ] ++ [ pkgs.deploy-rs ];
      };
    });
}
