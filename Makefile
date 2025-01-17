all:
	@echo hi,

build:
	@nix-build

dry-run: build
	env PATH=$(shell pwd)/result/bin/nix:$$PATH deploy --dry-activate .#nyke

up: build
	env PATH=$(shell pwd)/result/bin/nix:$$PATH deploy .#nyke
