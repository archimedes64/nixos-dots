{ config, pkgs, home, lib, self, helpers, ... }: 
let
  
  mkOptionalOption = helpers.mkOptionalOption;
  notNull = helpers.notNull;
  cfg = config.usr.git;
in
{
  options.usr.git = with lib; {
    enable = mkEnableOption "git";
    name  = mkOptionalOption types.str "The name git will use.";
    email = mkOptionalOption types.str "The email git will use.";
    githubUsername = mkOptionalOption types.str "Your github user name.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ 
    	gh 
        git-credential-manager
    ];

    assertions = let
      makeAssertion = isEnabled: value: fieldName: {
        assertion = isEnabled -> (notNull value);
        message = "Option ${fieldName} in module: git, must be set";
      };
    in
    [
      (makeAssertion cfg.enable cfg.name "name")
      (makeAssertion cfg.enable cfg.email "email")
      (makeAssertion cfg.enable cfg.githubUsername "githubUsername")
    ];

    programs.git = {
      enable = true;
      settings = {
        user = {
          name  = cfg.name;
          email = cfg.email;
        };
        init.defaultBranch = "main";
      };

      extraConfig.credential = {
        helper = "manager";
        "https://github.com".username = cfg.githubUsername;
        credentialStore = "cache";
        enable = true;
      }; # https://discourse.nixos.org/t/git-credential-manager-on-nixos/25742/6
    };
  };
}
