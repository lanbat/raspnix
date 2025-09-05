{ pkgs, vars, ... }:
{
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = vars.paths.sonarrData;
  };

  users.users.sonarr.extraGroups = [ "media" ];
}
