{ config, pkgs, constants, lib, ... }: {

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
     
     config = rec {
      modifier = "Mod4";
      terminal = "alacritty";

      input."*".xkb_options = "caps:swapescape";
      keybindings = (lib.mkIf config.usr.sway.enableRofi 
      (let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in 
      {
        "${modifier}+q" = "exec --no-startup-id rofi --show drun -show-icons";
      }));

     };
   };
   home.packages = [ pkgs.swaybg ];
 };

}
