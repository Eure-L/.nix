{ config, pkgs, ... }:


{
    environment.systemPackages = with pkgs; [
        (vscode-with-extensions.override {
            vscode = vscodium;
            vscodeExtensions = with vscode-extensions; [
            bbenoist.nix
            hediet.vscode-drawio
            ms-python.python
            ms-vscode-remote.remote-ssh
            ];
        })
    ];
}