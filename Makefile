all:
	@echo hi,

_IN_NIX_SHELL:
	@test "$${IN_NIX_SHELL}" != "" || (echo 'Please enter to operation shell by `make shell`' >&2 ; exit 1)

shell:
	@nix shell nixpkgs#nixVersions.git --command nix develop

sensitive: _IN_NIX_SHELL
	nix flake update sensitive

bump: _IN_NIX_SHELL
	nix flake update

build:
	nixos-rebuild build --flake .#nyke

boot: _IN_NIX_SHELL
	deploy --boot .#nyke

dry-run: _IN_NIX_SHELL
	deploy --dry-activate .#nyke

up: _IN_NIX_SHELL
	deploy .#nyke
