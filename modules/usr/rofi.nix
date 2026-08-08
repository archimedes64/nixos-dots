{ config, lib, helpers, pkgs, ... }:
let
  mkOptionalOption = helpers.mkOptionalOption;
  notNull = helpers.notNull;
  colorDescription = "A color (hex code).";
  colorOption = mkOption {
    type = lib.types.str;
    description = colorDescription;
  };
  cfg = options.usr.rofi;
in
{
 options.usr.rofi = with lib; {
   enable = mkEnableOption "rofi";
   colors = mkOption {
     description = "the colors to be used in the rofi config";
     type = with types; submodule {
       background = colorOption;
       surface = colorOption;
       foreground = colorOption;
       muted = colorOption;
       highlight = colorOption;
       mainAccent = colorOption;
       extraAccent1 = mkOptionalOption types.str colorDescription;
       extraAccent2 = mkOptionalOption types.str colorDescription;
     };
       
   };

   font = mkOption {
     description = "the font used by rofi (\"[font_name] [font_size]\")";
     type = types.str;
   };
 };

 config = lib.mkIf cfg.enable {
   programs.rofi = 
   let
   colors = cfg.colors;

   colors.extraAccent1 = if notNull cfg.colors.extraAccent1
   then cfg.colors.extraAccent1
   else mainAccent;

   colors.extraAccent2 = if notNull cfg.colors.extraAccent2
   then cfg.colors.extraAccent2
   else mainAccent;
   in
   {
     enable = true;
     font = cfg.font;
     theme = 
     let
       inherit (config.lib.formats.rasi) mkLiteral;
     in 
     {
       "*" = {
         active-background = mkLiteral colors.extraAccent1;
         active-foreground = mkLiteral colors.foreground;

         urgent-background = mkLiteral colors.extraAccent2;
         urgent-foreground = mkLiteral colors.foreground;
       };

       "window" = {
         background-color = mkLiteral colors.background;
	 border = 2;
	 border-color = mkLiteral colors.mainAccent;
	 border-radius = 10;
	 padding = mkLiteral "6px";
	 width = mkLiteral "40%";
       };

       "#message" = {
	 padding = mkLiteral "3px 6px";
         border = mkLiteral "1px dash 0px 0px";
         text-color = mkLiteral colors.mainAccent;
	 background-color = mkLiteral colors.surface;
       };

       "#listview" = {
         lines = 8;
	 spacing = mkLiteral "2px";
	 padding = mkLiteral "2px";
	 scrollbar = false;
       };

       "#element" = {
         padding = mkLiteral "4px 6px";
	 text-color = mkLiteral colors.foreground;
       };

       "#inputbar" {
         spacing = mkLiteral "2px";
	 padding = mkLiteral "4px 6px";
	 border-top = mkLiteral "1px dash 0px 0px";
	 border-color = mkLiteral colors.surface;
       };

       "#prompt" = { text-color = colors.highlight; };
       "#textbox" = {
         text-color = mkLiteral colors.foreground;
	 background-color transparent;
	 border = 0;
	 cursor-color = colors.highlight;
       };



     };
}





   };
 };

 



