{ pkgs, vars, ... }:
{
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = vars.paths.radarrData;
  };

  users.users.radarr.extraGroups = [ "media" ];
}
