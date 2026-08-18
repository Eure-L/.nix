{ config, pkgs, ... }:

{
  imports =
    [
    ./configuration.nix
    ./packages.nix
    ./firefox.nix
    ./vscodium.nix
    ];
}
