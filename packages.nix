{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [

    # Utils
    firefox
    borgbackup
    git
    htop
    libreoffice
    tmux
    tree

    # Dev
    rustup
    rustc
    python3
    python3Packages.pip
    podman
    podman-compose
    podman-tui

    # IDEs
    vim
    wget
    jetbrains.rust-rover
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.clion
    vscodium
  ];

  environment.sessionVariables.XDG_DATA_DIRS = [
	"${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
	"${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  ];
}


