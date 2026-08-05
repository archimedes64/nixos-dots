{
 inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 };

 outputs =  { self, nixpkgs, home-manager, ... }: 
 let
  constants = import ./constants.nix;
 in
 {
   nixosConfigurations."${constants.system.hostName}" = nixpkgs.lib.nixosSystem {
     system = "${constants.system.arch}-linux"; 

     specialArgs = { inherit constants; };

     modules = [
       ./configuration.nix

       home-manager.nixosModules.home-manager
       {
         home-manager = {
           useGlobalPkgs = true;
           useUserPackages = true;
           extraSpecialArgs = { inherit constants; };
           users."${constants.user.username}" = import ./home.nix;
           backupFileExtension = "backup";

         };  
       }
     ];
    };
  };
}
