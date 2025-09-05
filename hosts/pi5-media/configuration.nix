{ pkgs, lib, vars, ... }:
{
  networking.hostName = vars.hostname;
  time.timeZone = vars.timezone;

  nixpkgs.hostPlatform = "aarch64-linux";

  hardware.graphics.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  environment.systemPackages = with pkgs; [ ffmpeg mediainfo vim htop wget ];
}
