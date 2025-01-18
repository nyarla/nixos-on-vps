all:
	@echo hi,

build:
	@nix-build

bump: build
	result/bin/nix flake update

boot: build
	env PATH=$(shell pwd)/result/bin/nix:$$PATH deploy --boot .#nyke

dry-run: build
	env PATH=$(shell pwd)/result/bin/nix:$$PATH deploy --dry-activate .#nyke

up: build
	env PATH=$(shell pwd)/result/bin/nix:$$PATH deploy .#nyke
