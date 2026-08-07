{ config, pkgs, helpers, lib, ... }: 
let
  

  mkOptionalOption = helpers.mkOptionalOption;
  ifSet = helpers.addAttrIfNotNull;

  createColorSet = color: {
    background = color;
    border = color;
    childBorder = color;
    indicator = color;
    text = color;
  };

  cfg = config.usr.sway.style;
in
{

  options.usr.sway.style = with lib.types; { 
    colors = {
      focused = mkOptionalOption str "The color (hex code) used on windows in focus.";
      unfocused = mkOptionalOption str "The color (hex code) used on windows not in focus.";
    };

    gapsInner = mkOptionalOption int "The amount of space (pixels) between windows.";

    gapsOuter = mkOptionalOption int "The amount of space (pixels) between a window and the edge of the monitor.";
         
    border = mkOptionalOption int "How large the border on windows are in pixles.";
  };

  config.wayland.windowManager.sway.config = {
    fonts.size = 0.001; 

    gaps = (ifSet cfg.gapsInner  { inner = cfg.gapsInner; })
        // (ifSet cfg.gapsOuter  { outer = cfg.gapsOuter; });

    window = ifSet cfg.border  { border = cfg.border; };     

    colors = (ifSet cfg.colors.focused { 
      focused = createColorSet cfg.colors.focused; 
    })
    //       (ifSet cfg.colors.unfocused {
      unfocused       = createColorSet cfg.colors.unfocused;
      focusedInactive = createColorSet cfg.colors.unfocused;
      urgent          = createColorSet cfg.colors.unfocused;
      placeholder     = createColorSet cfg.colors.unfocused;
    });
  };
}
