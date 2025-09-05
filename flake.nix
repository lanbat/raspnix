{
  description = "Pi 5 media box";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.pi5-media = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { vars = import ./hosts/pi5-media/vars.nix; };
      modules = [
        ./hosts/pi5-media/configuration.nix
        ./modules/storage/storage-and-quotas.nix
        ./modules/users/users.nix
        ./modules/desktop/lightdm.nix
        ./modules/media/kodi.nix
        ./modules/media/retroarch.nix
        ./modules/media/jellyfin.nix
        ./modules/media/deluge.nix
        ./modules/media/sonarr.nix
        ./modules/media/radarr.nix
        ./modules/media/photoprism.nix
        ./modules/media/bitmagnet.nix
        ./modules/network/samba.nix
        ./modules/common/firewall.nix
        ./modules/home/home-assistant.nix
      ];
    };
  };
}
