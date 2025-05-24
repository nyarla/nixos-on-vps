all:
	@echo hi,

_IN_NIX_SHELL:
	@test "$${IN_NIX_SHELL}" != "" || (echo 'Please enter to operation shell by `make shell`' >&2 ; exit 1)

shell:
	@nix shell nixpkgs#nixVersions.git --command env NIXPKGS_ALLOW_UNFREE=1 nix develop --impure

sensitive: _IN_NIX_SHELL
	nix flake update sensitive

bump: _IN_NIX_SHELL
	nix flake update

build:
	nixos-rebuild build --flake .#nyke --impure

boot: _IN_NIX_SHELL
	deploy --boot .#nyke -- --impure

dry-run: _IN_NIX_SHELL
	deploy --dry-activate .#nyke -- --impure

up: _IN_NIX_SHELL
	deploy .#nyke -- --impure
