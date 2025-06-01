{ pkgs, ... }:
let
  unstable = pkgs;
in
_: prev: {
  inherit (unstable) searxng cloudflared;
}
