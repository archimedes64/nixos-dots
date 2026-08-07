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

	  style = {
	    colors = {
	      focused = colorScheme.rose;
	      unfocused = colorScheme.highlights.med;
	    };

	    gapsInner = 25;
	    gapsOuter = 30;
	    border = 1;
	  };

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


	



        home.packages = with pkgs; [
                neovim  
                wl-clipboard
        ];
}

