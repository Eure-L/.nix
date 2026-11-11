{ config, pkgs, ... }:

{
  imports =
    [
    ./configuration.nix
    ./packages.nix
    ./shell.nix
    ./scripts.nix
    ./firefox.nix
    ./vscodium.nix
    ];
}
