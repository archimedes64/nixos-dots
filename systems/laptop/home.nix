{ config, pkgs, constants, ... }: 
let
  colorScheme = constants.user.colorScheme;
in
{
	home.username = constants.user.username;
	home.homeDirectory = constants.user.homeDir;
	home.stateVersion = constants.system.stateVersion;
	programs.bash = {
		enable = true;
		shellAliases = {
			update = "sudo nixos-rebuild switch --flake ${constants.user.nixConfigDir}#${constants.system.hostName}";
		};
	};


	usr.sway = {
	  enable = true;
	  enableRofi = true;
	  swayosd.enable = true;

	  style = {
	    colors = {
	      focused = colorScheme.rose;
	      unfocused = colorScheme.highlights.med;
	    };

	    swayBar = {
	      enable = true;
	      colors = {
	      	background = "${colorScheme.surface}";
		statusline = colorScheme.text;
		separator = colorScheme.text;
		good = colorScheme.pine;
		degraded = colorScheme.iris;
		bad = colorScheme.love;
	      };

	    };

	    gapsInner = 25;
	    gapsOuter = 30;
	    border = 3;
	  };

	};

	usr.rofi = {
	  enable = true;
	  colors = {
	    background = colorScheme.surface;
	    surface = colorScheme.overlay;
	    foreground = colorScheme.text;
	    muted = colorScheme.muted;
	    highlight = colorScheme.gold;
	    mainAccent = colorScheme.rose;
	    extraAccent1 = colorScheme.pine;
	    extraAccent2 = colorScheme.iris;
	  };

	  font = "Jetbrains Mono 12";
	};

	usr.alacritty = {
	  enable = true; 
	  colorScheme = colorScheme;
	};
	
	usr.git = {
	  enable = true;
	  name = "archimedes64";
	  githubUsername = "archimedes64";
	  email = "archimedesow@gmail.com";
	};

	usr.cursor.enable = true;

	# usr.librewolf.enable = false;
		
	home.packages = with pkgs; [
		neovim	
		wl-clipboard
	];

}
