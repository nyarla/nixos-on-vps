{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    nixpkgs.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    { nixpkgs, impermanence, ... }:
    {
      nixosConfigurations = {
        nyke = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            impermanence.nixosModules.impermanence
            ./system/profile/nyke.nix
          ];
        };
      };
    };
}
