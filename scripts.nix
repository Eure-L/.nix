{ config, pkgs, lib, ... }:

{
  # Stable scripts live here as packages: they land in
  # /run/current-system/sw/bin, so they are callable from shells, systemd,
  # cron and desktop launchers, and are versioned with this config.
  #
  # Workflow: develop a script in ~/.local/bin (no rebuild needed), then
  # promote it here once stable.
  environment.systemPackages = with pkgs; [
    # Mount / unmount the home server's config directory over sshfs.
    #   hs | hs mount   -> mount homeserver-local, falling back to
    #                      homeserver-remote (force one with HS_HOST=...)
    #   hs umount       -> unmount (lazy if busy)
    (writeShellScriptBin "hs" ''
      set -euo pipefail

      mountpoint="/tmp/homeserver"
      remote_path="/home/$USER/services/home-server"
      opts="reconnect,ServerAliveInterval=5,ServerAliveCountMax=3,ConnectTimeout=5"

      # Read hostname/port from ssh config (no connection, no auth),
      # then check TCP reachability with a 3s timeout.
      probe() {
        local cfg="" hn="" pn=""
        cfg="$(${pkgs.openssh}/bin/ssh -G "$1" 2>/dev/null)" || return 1
        while IFS=' =' read -r k v; do
          case $k in
            hostname) hn=$v ;;
            port) pn=$v ;;
          esac
        done <<< "$cfg"
        [ -n "$hn" ] || return 1
        ${pkgs.coreutils}/bin/timeout 3 ${pkgs.bash}/bin/bash -c "</dev/tcp/$hn/''${pn:-22}" 2>/dev/null
      }

      case "''${1:-mount}" in
        mount)
          if ${pkgs.util-linux}/bin/findmnt -r "$mountpoint" >/dev/null 2>&1; then
            echo "hs: $mountpoint is already mounted"
            exit 0
          fi
          ${pkgs.coreutils}/bin/mkdir -p "$mountpoint"
          if [ -n "''${HS_HOST:-}" ]; then
            host="$HS_HOST"
          elif probe homeserver-local; then
            host=homeserver-local
          elif probe homeserver-remote; then
            host=homeserver-remote
          else
            echo "hs: neither homeserver-local nor homeserver-remote is reachable" >&2
            exit 1
          fi
          echo "hs: mounting $host on $mountpoint"
          exec ${pkgs.sshfs}/bin/sshfs "$host:$remote_path" "$mountpoint" -o "$opts"
          ;;
        umount | unmount)
          if ! ${pkgs.util-linux}/bin/findmnt -r "$mountpoint" >/dev/null 2>&1; then
            echo "hs: $mountpoint is not mounted"
            exit 0
          fi
          # fusermount3 must be called by name: it resolves to the setuid
          # wrapper in /run/wrappers/bin. A pinned store path is not setuid
          # and cannot unmount.
          if ! fusermount3 -u "$mountpoint"; then
            echo "hs: mount is busy, lazy-unmounting" >&2
            fusermount3 -uz "$mountpoint"
          fi
          ;;
        *)
          echo "usage: hs [mount|umount]" >&2
          exit 1
          ;;
      esac
    '')
  ];
}
