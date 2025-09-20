{
  description = "Raspnix – Pi 5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, ... }: {
    nixosConfigurations.pi5-media = nixos-raspberrypi.lib.nixosSystem {
      specialArgs = { vars = import ./hosts/pi5-media/vars.nix; inherit nixos-raspberrypi; };
      modules = [ ./hosts/pi5-media ];  # or ./hosts/pi5-media/default.nix
    };
  };
}

