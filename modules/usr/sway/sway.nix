{ config, pkgs, constants, lib, ... }: 
let
  mod = "Mod4";
in
{

 imports = [
   ./style.nix
   ./swayosd.nix
   ./swayfx.nix
 ];

 options.usr.sway = {
   enable =  lib.mkEnableOption "Sway";
   enableRofi = lib.mkEnableOption "sway support for rofi";
 };
 config = lib.mkIf config.usr.sway.enable {
   wayland.windowManager.sway = {
     enable = true;
     
     systemd.variables = ["--all"];

     wrapperFeatures.gtk = true;
     
     config = {
      modifier = mod;
      terminal = "alacritty";

      input."*".xkb_options = "caps:swapescape";
      keybindings = (lib.mkIf config.usr.sway.enableRofi 
      (lib.mkOptionDefault {
        "${mod}+q" = "exec --no-startup-id rofi -show drun -show-icons";
      }));

     };
   };
   home.packages = [ pkgs.swaybg ];
 };

	}
