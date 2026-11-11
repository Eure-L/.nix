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

  programs.bash = {
    enable = true;

    interactiveShellInit = builtins.readFile ./bashfuns.sh;

    promptInit = ''
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\]\$ '
    '';

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ll = "ls -lah";
      la = "ls -A";
      nix-clean = "nix-collect-garbage -d";
      gl = "git log --oneline --graph --decorate";
      df = "df -h";
      du = "du -h";
      ports = "ss -tulpn";
    };
  };

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


