{ config, pkgs, constants, ... }:
{
 imports =
 [ 
  ./hardware-configuration.nix
 ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = constants.system.hostName;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  security.polkit.enable = true;

  services.pipewire = {
  	enable = true;	
	pulse.enable = true;
	alsa.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  users.users."${constants.user.username}" = {
    isNormalUser = true;
    description ="Main user account.";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
     vim 
     wget
     git
     alacritty
     bluetuith
     lshw
  ];


  services.greetd = {                                                      
    enable = true;                                                         
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";                                                  
      };                                                                   
    };                                                                     
  };

  fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	corefonts
  ];
  fonts.fontconfig = {
 	    defaultFonts = {
 	      serif = [  "Jetbrains Mono" ];
 	      sansSerif = [ "Jetbrains Mono"  ];
 	      monospace = [ "Jetbrains Mono" ];
 	    };
 	  };

  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = constants.system.stateVersion;
	environment.sessionVariables.XDG_DATA_DIRS = [
		"${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
		"${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
	];

}
