{ config, lib, helpers, pkgs, ... }:
let
  mkOptionalOption = helpers.mkOptionalOption;
  notNull = helpers.notNull;
  colorDescription = "A color (hex code).";
  colorOption = lib.mkOption {
    type = lib.types.str;
    description = colorDescription;
  };
  cfg = config.usr.rofi;
in
{
 options.usr.rofi = with lib; {
   enable = mkEnableOption "rofi";

   colors = mkOption {
     description = "the colors to be used in the rofi config";
     type = with types; submodule {
       options = {
         background = colorOption;
         surface = colorOption; foreground = colorOption;
         muted = colorOption;
         highlight = colorOption;
         mainAccent = colorOption;
         extraAccent1 = mkOptionalOption str colorDescription;
         extraAccent2 = mkOptionalOption str colorDescription;
       };
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

   extraAccent1 = if notNull cfg.colors.extraAccent1
   then cfg.colors.extraAccent1
   else colors.mainAccent;

   extraAccent2 = if notNull cfg.colors.extraAccent2
   then cfg.colors.extraAccent2
   else colors.mainAccent;
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
	 background-color = mkLiteral colors.background;

         active-background = mkLiteral extraAccent1;
         active-foreground = mkLiteral colors.foreground;

         urgent-background = mkLiteral extraAccent2;
         urgent-foreground = mkLiteral colors.foreground;
	 text-color = mkLiteral colors.foreground;
       };

       "#textbox" = {
         text-color = mkLiteral colors.foreground;
	 border = mkLiteral "3px";
	 border-color = mkLiteral colors.mainAccent;
	 cursor-color = mkLiteral colors.highlight;
       };

       "window" = {
         background-color = mkLiteral "transparent";
	 border = 3;
	 border-color = mkLiteral colors.mainAccent;
	 border-radius = 6;
	 padding = 0;
	 width = mkLiteral "40%";
       };

       "#message" = {
	 padding = mkLiteral "3px 6px";
         border = mkLiteral "1px dash 0px 0px";
         text-color = mkLiteral colors.foreground;
	 background-color = mkLiteral colors.surface;
       };

       "#listview" = {
	 fixed-height = mkLiteral "0px";
	 background-color = mkLiteral colors.background;
	 border = mkLiteral "3px 0px 0px 0px";
	 border-radius = 1;
	 border-color = mkLiteral colors.mainAccent;
	 spacing = mkLiteral "2px";
	 padding = mkLiteral "2px 0px 0px";
       };


       "#element" = {
         padding = mkLiteral "2px 4px";
	 text-color = mkLiteral colors.foreground;
       };
       "#element selected" = {
	 border-size = mkLiteral "1px";
         border-color = mkLiteral colors.mainAccent;
       };

       "#inputbar" = {
         spacing = mkLiteral "1px";
	 text-color = mkLiteral colors.foreground;
	 padding = mkLiteral "0px -0.4%";
	 border-top = mkLiteral "1px dash 0px 0px";
	 border-color = mkLiteral colors.mainAccent;
	 children = mkLiteral " [ prompt, case-indicator, textbox-prompt-colon, entry ]";
       };

       "#prompt" = { 
         text-color = colors.background; 
	 enabled = false;
	 spacing = 0;
       };

       "#case-indicator" = {
         spacing = 0;
	 text-color = mkLiteral colors.foreground;
       };

       "#textbox-prompt-colon" = {
	 expand = false;
	 str =  "";
	 spacing = 0;
	 margin = mkLiteral "0px 0px 0px 0px";
         text-color = mkLiteral colors.foreground;
       };

       "#entry" = {
         spacing = 0;
	 text-color = mkLiteral colors.mainAccent;
	 hide-cursor-on-empty = true;
	 cursor-color = mkLiteral colors.background;
       };




      };
    };
  };
}
