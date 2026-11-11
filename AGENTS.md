# AGENTS.md

Supplementary NixOS modules for this machine — not a standalone, flake, or home-manager config.

## Wiring (easy to get wrong)

- The real system config is `/etc/nixos/configuration.nix` (**not in this repo**). It imports `/home/eurel/.nix/home.nix` by absolute path — the repo must stay at `~/.nix`, or the system build breaks.
- `home.nix` is the module entrypoint (it imports the other files). Despite the name, it uses plain NixOS system options, not home-manager.
- Naming traps: this repo's `configuration.nix` only holds Nix GC settings; the machine's actual config (bootloader, Plasma, user `eurel`, `hardware-configuration.nix`) lives in `/etc/nixos/`.
- `bashfuns.sh` is plain bash pulled in via `builtins.readFile` into `programs.bash.interactiveShellInit` — edits only take effect after a rebuild.
- VSCodium extensions are managed in `vscodium.nix` (`vscode-with-extensions` wrap), not in `packages.nix`.

## Commands

- Cheap syntax check of one module: `nix-instantiate --parse <file>.nix`
- Build without activating: `sudo nixos-rebuild build` (works from any directory; it reads `/etc/nixos`)
- Apply changes: `sudo nixos-rebuild switch` (or `test` to activate without creating a boot entry)
- No flakes, lockfile, CI, or formatter. Flakes are enabled system-wide but unused here — don't add flake tooling.

## Gotchas

- Unfree is allowed globally (`nixpkgs.config.allowUnfree` in `/etc/nixos/configuration.nix`) — the JetBrains IDEs and VSCodium extensions need it; no per-module setting required.
- `programs.nix-ld` (in `packages.nix`) lets precompiled/downloaded binaries run; if one fails on a missing library, add it to its `libraries` list.
- Nix GC runs weekly and keeps generations only 30 days — don't rely on old generations for rollback.
