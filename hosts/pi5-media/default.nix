# hosts/pi5-media/default.nix
{ lib, pkgs, nixos-raspberrypi, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/users/traph.nix
    # keep your existing role modules here if you prefer:
    ../../modules/storage/storage-and-quotas.nix
    ../../modules/users/users.nix
    ../../modules/desktop/lightdm.nix
    ../../modules/media/kodi.nix
    ../../modules/media/retroarch.nix
    ../../modules/media/jellyfin.nix
    ../../modules/media/deluge.nix
    ../../modules/media/sonarr.nix
    ../../modules/media/radarr.nix
    ../../modules/media/photoprism.nix
    ../../modules/media/bitmagnet.nix
    ../../modules/network/samba.nix
    ../../modules/common/firewall.nix
    ../../modules/home/home-assistant.nix
  ] ++ (with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.display-vc4   # or raspberry-pi-5.display-rp1
    raspberry-pi-5.bluetooth
  ]);

  system.stateVersion = "25.05";
  networking.hostName = "pi5-media";

  # Firmware mount override (replaces autofs from hardware.nix)
  fileSystems."/boot/firmware" = lib.mkForce {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    neededForBoot = true;
  };

  # If you’re using kernelboot already and it’s stable for you:
  boot.loader.raspberryPi.bootloader = "kernelboot";

  # QoL: vim system-wide
  environment.systemPackages = [ pkgs.vim ];
  programs.vim.defaultEditor = true;
}

