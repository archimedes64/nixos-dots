{ config, pkgs, constants, lib, ... }: {

 imports = [
   ./style.nix
   ./swayosd.nix
   ./swayfx.nix
 ];

 options.usr.sway.enable =  lib.mkEnableOption "Sway";

 config.wayland.windowManager.sway = lib.mkIf config.usr.sway.enable {
  enable = true;
  
  wrapperFeatures.gtk = true;
  
  config = rec {
   modifier = "Mod4";
   terminal = "alacritty";
   input."*".xkb_options = "caps:swapescape";

  };

  
 };

}
