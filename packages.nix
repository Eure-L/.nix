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
    usbutils
    fastfetch
    fprintd
    ncdu
    sshfs
  
    # Dev
    rustup
    rustc
    cargo
    python3
    python3Packages.pip
    podman
    podman-compose
    podman-tui
    clang
    gcc
    stdenv.cc.cc.lib

    # IDEs
    vim
    wget
    jetbrains.rust-rover
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.clion
    vscodium

    python3Packages.numpy
  
  ];

  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      zstd
      openssl
      libxml2
    ];
  };
  
}


