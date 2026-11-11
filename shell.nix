{ config, pkgs, ... }:

{
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

  # Appends to the system PATH (never replaces it on this NixOS version);
  # reaches shells, GUI apps and systemd user sessions, unlike an
  # `export PATH` in bashfuns.sh which only affects interactive bash.
  environment.sessionVariables.PATH = [ "$HOME/.opencode/bin" ];

  # Personal scratch scripts directory (XDG standard location)
  environment.localBinInPath = true;
}
