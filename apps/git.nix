{ config, pkgs, home, ... }: 
{
  home.packages = with pkgs; [ 
  	gh 
	git-credential-manager
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "John Doe";
        email = "johndoe@example.com";
      };
      init.defaultBranch = "main";
    };

    extraConfig.credential = {
      helper = "manager";
      "https://github.com".username = "archimedes64";
      credentialStore = "cache";
      enable = true;
    }; # https://discourse.nixos.org/t/git-credential-manager-on-nixos/25742/6
  };
}
