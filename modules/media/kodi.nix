{ pkgs, vars, ... }:
let
  seedDir = vars.paths.kodiSeed;
in
{
  systemd.tmpfiles.rules = [
    "d ${seedDir}                       0755 root  root  - -"
    "d /home/media/.kodi/addons         0755 media users - -"
    "d /home/media/.kodi/userdata       0755 media users - -"
  ];

  systemd.services.seed-kodi-addons = {
    description = "Seed Kodi addons from ${seedDir}";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" "display-manager.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -e
      [ -d "${seedDir}" ] || exit 0
      shopt -s nullglob
      for z in ${seedDir}/*.zip; do
        ${pkgs.unzip}/bin/unzip -o "$z" -d /home/media/.kodi/addons
      done
      chown -R media:users /home/media/.kodi
    '';
  };
}
