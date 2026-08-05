{ config, pkgs, constants, ... }: 
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


	imports = [
	    ./apps/alacritty.nix
	    ./apps/swayfx/swayfx.nix
	    ./apps/git.nix
	];

		
	home.packages = [
		pkgs.neovim	
		pkgs.wl-clipboard
	};
}
