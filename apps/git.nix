{ config, pkgs, home, ... }: 
{
  home.packages = [ pkgs.gh ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "John Doe";
        email = "johndoe@example.com";
      };
      init.defaultBranch = "main";
    };
  };
}
