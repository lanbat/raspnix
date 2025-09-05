{ vars, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.prep-jellyfin-media-perms = {
    description = "Ensure media folders are group readable by Jellyfin";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      chgrp -R media ${toString (builtins.dirOf vars.paths.movies)} || true
      chmod -R 775 ${toString (builtins.dirOf vars.paths.movies)} || true
    '';
  };
}
