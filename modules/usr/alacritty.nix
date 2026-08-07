{ config, pkgs,lib, self, helpers, ... }: 
let
  mkOptionalOption = helpers.mkOptionalOption;
  cfg = config.usr.alacritty;
in
{
  options.usr.alacritty = with lib; {
    enable = mkEnableOption "alacritty";
    colorScheme = mkOptionalOption (types.attrsOf types.unspecified) "The color scheme to be used, currently must be made using the rose pine schema";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
     enable = true;
     settings = {
       colors = {
       	primary = {
            background = cfg.colorScheme.base;
            foreground = cfg.colorScheme.text;
          };

          cursor = {
            text = cfg.colorScheme.text;
            cursor = cfg.colorScheme.highlights.high;
          };

          vi_mode_cursor = {
            text = cfg.colorScheme.text;
            cursor = cfg.colorScheme.highlights.high;
          };

          selection = {
            text = cfg.colorScheme.text;
            background = cfg.colorScheme.highlights.med;
          };

          normal = {
            black = cfg.colorScheme.overlay;
            red = cfg.colorScheme.love;
            green = cfg.colorScheme.pine;
            yellow = cfg.colorScheme.gold;
            blue = cfg.colorScheme.foam;
            magenta = cfg.colorScheme.iris;
            cyan = cfg.colorScheme.rose;
            white = cfg.colorScheme.text;
          };

          bright = {
            black = cfg.colorScheme.muted;
            red = cfg.colorScheme.love;
            green = cfg.colorScheme.pine;
            yellow = cfg.colorScheme.gold;
            blue = cfg.colorScheme.foam;
            magenta = cfg.colorScheme.iris;
            cyan = cfg.colorScheme.rose;
            white = cfg.colorScheme.text;
          };
        };
      };
    };
  };
}
