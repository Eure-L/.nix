{ config, pkgs, ... }:

{
  imports =
    [
      /home/eurel/.nix/packages.nix
      /home/eurel/.nix/firefox.nix
      /home/eurel/.nix/vscodium.nix
    ];

}
