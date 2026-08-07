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
  laptopConstants = import ./systems/laptop/constants.nix;
  serverConstants = import ./systems/server/constants.nix;
  helpers = import ./helpers.nix {inherit (nixpkgs) lib; };
  

  makeSystem = path: constants: nixpkgs.lib.nixosSystem {
     system = "${constants.system.arch}-linux"; 

     specialArgs = { inherit constants; inherit helpers; };

     modules = [
       (path + "/configuration.nix")


       home-manager.nixosModules.home-manager
       {
         home-manager = {
           useGlobalPkgs = true;
           useUserPackages = true;
           users."${constants.user.username}" = {
    	     imports = [
    	       (path + "/home.nix")
               ./modules/usr
    	     ];
	   };
           backupFileExtension = "backup";
	   extraSpecialArgs = { inherit constants; inherit helpers; };

         };  
       }
     ];
 };
 in
 {
   nixosConfigurations."${laptopConstants.system.hostName}" = makeSystem ./systems/laptop laptopConstants;
   nixosConfigurations."${serverConstants.system.hostName}" = makeSystem ./systems/server serverConstants;

 };
}
