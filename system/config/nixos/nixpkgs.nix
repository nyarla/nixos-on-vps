_: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  nix.gc = {
    automatic = true;
    dates = "Mon *-*-* 4:00:00";
    randomizedDelaySec = "3min";
    options = "--delete-older-than 10d";
  };

  system.stateVersion = "24.05";
}
