{options, config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix 
    ./git.nix
    ./sway
    ./rofi.nix
    ./cursor.nix
  ];
}
