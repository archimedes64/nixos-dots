{ config, pkgs, constants, ... }: 
let
 colors = constants.user.colorScheme;
in
{
 programs.alacritty = {
   enable = true;
   settings = {
     colors = {
     	primary = {
	  background = colors.base;
	  foreground = colors.text;
	};

	cursor = {
	  text = colors.text;
	  cursor = colors.highlights.high;
	};

	vi_mode_cursor = {
	  text = colors.text;
	  cursor = colors.highlights.high;
	};

	selection = {
	  text = colors.text;
	  background = colors.highlights.med;
	};

	normal = {
	  black = colors.overlay;
	  red = colors.love;
	  green = colors.pine;
	  yellow = colors.gold;
	  blue = colors.foam;
	  magenta = colors.iris;
	  cyan = colors.rose;
	  white = colors.text;
	};

	bright = {
	  black = colors.muted;
	  red = colors.love;
	  green = colors.pine;
	  yellow = colors.gold;
	  blue = colors.foam;
	  magenta = colors.iris;
	  cyan = colors.rose;
	  white = colors.text;
	};

     };
   };
 };
}
