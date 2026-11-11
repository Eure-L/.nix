{ config, pkgs, lib, ... }:

{
  # Stable scripts live here as packages: they land in
  # /run/current-system/sw/bin, so they are callable from shells, systemd,
  # cron and desktop launchers, and are versioned with this config.
  #
  # Workflow: develop a script in ~/.local/bin (no rebuild needed), then
  # promote it here once stable. Example:
  #
  #   (pkgs.writeShellScriptBin "my-script" ''
  #     set -euo pipefail
  #     ${lib.getExe pkgs.git} status
  #   '')
  environment.systemPackages = with pkgs; [ ];
}
