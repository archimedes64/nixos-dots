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
      focused = mkOptionalOption str "The color (hex code) used on focused things.";
      unfocused = mkOptionalOption str "The color (hex code) used on unfocused things.";
    };

    gapsInner = mkOptionalOption int "The amount of space (pixels) between windows.";

    gapsOuter = mkOptionalOption int "The amount of space (pixels) between a window and the edge of the monitor.";
         
    border = mkOptionalOption int "How large the border on windows are in pixles.";

    swayBar = {
    	enable = lib.mkEnableOption "Sway bar.";
	colors = {
	  background = mkOptionalOption str "Background color of the bar";
	  statusline = mkOptionalOption str "Text color to be used for the statusline";
	  separator = mkOptionalOption str "Text color to be used for the separator";
	  good = mkOptionalOption str "Color for good things";
	  degraded = mkOptionalOption str "Color for degraded things";
	  bad = mkOptionalOption str "Color for bad things";
	};
    };
  };

  config.wayland.windowManager.sway.config = {
    window = { titlebar = false; }
        // (ifSet cfg.border  { border = cfg.border; });

    gaps = (ifSet cfg.gapsInner  { inner = cfg.gapsInner; })
        // (ifSet cfg.gapsOuter  { outer = cfg.gapsOuter; });


    colors = (ifSet cfg.colors.focused { 
      focused = createColorSet cfg.colors.focused; 
    })
    //       (ifSet cfg.colors.unfocused {
      unfocused       = createColorSet cfg.colors.unfocused;
      focusedInactive = createColorSet cfg.colors.unfocused;
      urgent          = createColorSet cfg.colors.unfocused;
      placeholder     = createColorSet cfg.colors.unfocused;
    });

    bars = (if cfg.swayBar.enable then [{
      colors = (ifSet cfg.swayBar.colors.background {
        background = cfg.swayBar.colors.background;
      })
      //   (ifSet cfg.swayBar.colors.statusline {
        statusline = cfg.swayBar.colors.statusline;
      })
      //   (ifSet cfg.swayBar.colors.separator {
        separator = cfg.swayBar.colors.separator;
      })
      //   (ifSet cfg.colors.focused {
        focusedWorkspace = {
	  border = cfg.colors.unfocused;
	  background = cfg.colors.focused;
	  text = cfg.swayBar.colors.background;
	};
      })
      //   (ifSet cfg.colors.focused {
        inactiveWorkspace = {
	  border = cfg.swayBar.colors.separator;
	  background = cfg.colors.unfocused;
	  text = cfg.swayBar.colors.statusline;
	};
      });


      mode = "dock";
      trayOutput = "primary";
      statusCommand = "${pkgs.i3status}/bin/i3status";
      position = "top";

    }] else []);



  }; 
  config.programs.i3status = (lib.mkIf cfg.swayBar.enable {
    enable = true;
    general = {
      colors = true;
      output_format = "i3bar";
      color_good = ifSet cfg.swayBar.colors.good cfg.swayBar.colors.good;
      color_degraded = ifSet cfg.swayBar.colors.degraded cfg.swayBar.colors.degraded;
      color_bad = ifSet cfg.swayBar.colors.bad cfg.swayBar.colors.bad;
      markup = "pango";
      interval = 1;
    };
    modules = let
    stringWithColor = string: color: "<span color='${color}'>${string}</span>";
    stringWithAccent = string: stringWithColor string cfg.colors.focused;
    modules = [
      {
        name = "battery all";
	settings = {
          format = "%status %percentage (%emptytime | %consumption)";
	  status_chr = stringWithAccent "CHR:";
	  status_bat = stringWithAccent "BAT:";
	  status_unk = stringWithAccent "UNK:";
	  status_full = stringWithColor "FULL:" cfg.swayBar.colors.good;
	  last_full_capacity = true;
	  integer_battery_capacity = true; 
	  hide_seconds = true;
	  low_threshold = 30;
	  threshold_type = "percentage";
        };
      }

      {
        name = "memory";
	settings = {
	  format = stringWithAccent "MEM: " + "%used / %total";
	  threshold_degraded = "4G";
	  threshold_critical = "2G";
	  unit = "G";
	  decimals = 0;
	};
      }

      {
        name = "cpu_usage";
	settings = {
	  format = stringWithAccent "CPU: " + "%usage";
	  max_threshold = 90;
	  degraded_threshold = 50;
	};
      }

      {
        name = "cpu_temperature 0";
	settings = {
	  format = stringWithAccent "TEMP: " + "%degrees C";
	  max_threshold = 40;
	};
      }

      {
        name = "disk /";
	 settings = {
	   format = stringWithAccent "DISK: " + "%percentage_used";
	   threshold_type = "percentage_free";
	   low_threshold = 10;
         };
       }

       {
        name = "wireless _first_";
        settings = {
          format_up = stringWithAccent "WIFI: " + stringWithColor  "%essid (%frequency) %bitrate" cfg.swayBar.colors.statusline;
          format_down = stringWithAccent "WIFI: " + "DOWN";
        };
       }

       {
        name = "wireless wlp108s0";
	settings = {
	  format_up = stringWithAccent "IP: " + stringWithColor "%ip" cfg.swayBar.colors.statusline;
	  format_down = stringWithAccent "IP: " + "NONE";
	};
       }

       {
         name = "volume master";
         settings = {
           format = stringWithAccent "VOL: " + "%volume";
           format_muted = stringWithAccent "VOL: " + "MUTED (%volume)";
           device = "default";
           mixer = "Master";
           mixer_idx = 0;
	 };
       }

       {
         name = "time";
         settings = {
           format = stringWithAccent "DATE: " + "%b %e";
	 };
       }

            
       {
         name = "tztime local";
	  settings = {
  	    format = stringWithAccent "TIME: " + "%H:%M";
	  };
       }
    ];

    in
    builtins.listToAttrs (lib.imap1 (index: module: {
      name = module.name;
      value = {
        position = index;
      	settings = module.settings;
      };
    }) modules) // {
      "ethernet _first_".enable = false; 
      "ipv6".enable = false;
      "load".enable = false;
    };

  });
}
