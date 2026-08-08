{ config, pkgs, constants, lib, ... }: {

 imports = [
   ./style.nix
   ./swayosd.nix
   ./swayfx.nix
 ];

 options.usr.sway.enable =  lib.mkEnableOption "Sway";

 config = lib.mkIf config.usr.sway.enable {
   wayland.windowManager.sway = {
     enable = true;
     
     systemd.variables = ["--all"];

     wrapperFeatures.gtk = true;
     
     config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      input."*".xkb_options = "caps:swapescape";

     };
   };
   home.packages = [ pkgs.swaybg ];
 };

}
