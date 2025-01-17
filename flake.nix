{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sensitive.url = "git+file:sensitive";
  };

  outputs =
    {
      self,
      nixpkgs,
      impermanence,
      deploy-rs,
      sensitive,
      ...
    }:
    {
      nixosConfigurations = {
        nyke = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
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

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nyke;
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
