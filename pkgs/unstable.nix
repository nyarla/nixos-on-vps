{ pkgs, ... }:
let
  unstable = pkgs;
in
_: prev: {
  inherit (unstable) open-webui searxng;
}
