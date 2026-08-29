{ config, lib, pkgs, ...}:
let
  cfg = config.usr.cursor;
in
{
  options.usr.cursor.enable = lib.mkEnableOption "Rose Pine Cursor";
  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      size = 24; 
    };

  };
}
