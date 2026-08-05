{ config, pkgs, constants, ... }: 
let
 colorScheme = constants.user.colorScheme;
 unfocused = {
   background = colorScheme.highlights.med;
   border = colorScheme.highlights.med;
   childBorder = colorScheme.highlights.med;
   indicator = colorScheme.highlights.med;
   text = colorScheme.highlights.med;
 };
in
{
 wayland.windowManager.sway.config = {
   gaps.inner = 25;
   gaps.outer = 30;

   window.border = 1;

   fonts.size = 0.001;

   colors = {
     focused = {
       background = colorScheme.rose;
       border = colorScheme.rose;
       childBorder = colorScheme.rose;
       indicator = colorScheme.rose;
       text = colorScheme.rose;
     };

     unfocused = unfocused;

     focusedInactive = unfocused;

     urgent = unfocused;

     placeholder = unfocused;

   };
 };
 
 wayland.windowManager.sway.extraConfig = ''
   blur                         enable
   blur_xray                    disable
   blur_passes                   3
   blur_radius                   3
   blur_noise                    0
   blur_brightness               1
   blur_contrast                 1.00
   blur_saturation              1

   shadows enable
   shadow_color          ${colorScheme.overlay}
 
 
   shadow_blur_radius 10
   shadow_offset 3 2.5
 '';
}
