# Module for swayosd, a graphical indicator for changes to the devices volume or brightness
# see https://wiki.nixos.org/wiki/Swayosd
{ config, pkgs, lib, helpers, ... }: 
let
  cfg = config.usr.sway.swayosd;
  mkOptionalOption = helpers.mkOptionalOption;
in
{
 options.usr.sway.swayosd = {
   enable = lib.mkEnableOption "swayOSD";
 };

 config = lib.mkIf cfg.enable {
   home.packages = [
     pkgs.swayosd
   ];
   
   services.swayosd = {
     enable = true;
     topMargin = 0.9;
   };

   wayland.windowManager.sway.config = lib.mkMerge {
     keybindings = {
       # Audio Volume Controls (Sink - Output)
       "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
       "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
       "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
         
       # Microphone Volume Control (Source - Input)
       "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
         
       # Caps Lock
       "--release Caps_Lock" = "exec swayosd-client --caps-lock";
         
       # Brightness Controls
       "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
       "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";
          
       # Media Player Controls
       "XF86AudioPlay" = "exec swayosd-client --playerctl play-pause";
       "XF86AudioNext" = "exec swayosd-client --playerctl next";
       "XF86AudioPrev" = "exec swayosd-client --playerctl prev";
     };
   };
 };
}

