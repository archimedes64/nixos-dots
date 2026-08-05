{ config, pkgs, constants, ... }: 
{

 imports = [
   ./style.nix
   #./swayosd.nix
 ];

 wayland.windowManager.sway = {
  enable = true;
  package = pkgs.swayfx;

  wrapperFeatures.gtk = true;
  
  config = rec {
   modifier = "Mod4";
   terminal = "alacritty";
   input."*".xkb_options = "caps:swapescape";

  };

  checkConfig = false; # allows swayfx features to be used without exceptions being raised
 };

}
