{ config, lib, pkgs, vars, ... }:

let
  mediaRoot   = vars.mediaRoot;
  usersRoot   = vars.usersRoot;

  moviesDir   = vars.paths.movies;
  tvDir       = vars.paths.tv;
  musicDir    = vars.paths.music;
  torrentsDir = vars.paths.torrents;

  # Helper: GiB -> KiB for setquota
  toKiB = g: toString (g * 1024 * 1024);

  # Get quota for a user or fall back to default
  quotaKiB = u: let
    q = lib.attrByPath [u] vars.quotas.perUser (vars.quotas.default);
  in { soft = toKiB q.softGiB; hard = toKiB q.hardGiB; };

  # Generate per-user setquota lines
  quotaLines = lib.concatStringsSep "\n" (map (u:
    let q = quotaKiB u;
    in "setquota -u " + u + " " + q.soft + " " + q.hard + " 0 0 "$DEV" || true"
  ) vars.users);
in
{
  # LUKS devices (unlock at boot on console)
  boot.initrd.luks.devices = {
    ${vars.luks.nvme1.name} = {
      device = "/dev/disk/by-uuid/${vars.luks.nvme1.deviceUUID}";
      allowDiscards = true;
    };
    ${vars.luks.nvme2.name} = {
      device = "/dev/disk/by-uuid/${vars.luks.nvme2.deviceUUID}";
      allowDiscards = true;
    };
  };

  # Filesystems on the mapped devices
  fileSystems.${mediaRoot} = {
    device = "/dev/mapper/${vars.luks.nvme1.name}";
    fsType = "ext4";
    options = [ "noatime" "usrquota" "grpquota" ];
  };

  fileSystems.${usersRoot} = {
    device = "/dev/mapper/${vars.luks.nvme2.name}";
    fsType = "ext4";
    options = [ "noatime" "usrquota" "grpquota" ];
  };

  services.quota.enable = true;

  # Directory layout
  systemd.tmpfiles.rules = [
    "d ${mediaRoot}               0775 root   media  - -"
    "d ${mediaRoot}/media         0775 root   media  - -"
    "d ${moviesDir}               0775 root   media  - -"
    "d ${tvDir}                   0775 root   media  - -"
    "d ${musicDir}                0775 root   media  - -"
    "d ${torrentsDir}             0775 deluge media  - -"

    "d ${usersRoot}               0770 root   media  - -"
    "d ${usersRoot}/users         0770 root   media  - -"

    # App data folders
    "d ${vars.paths.sonarrData}   0755 sonarr users - -"
    "d ${vars.paths.radarrData}   0755 radarr users - -"
    "d ${vars.paths.photoprism.dataDir} 0755 photoprism users - -"
    "d ${vars.paths.photoprism.originals} 0755 photoprism users - -"
    "d ${vars.paths.photoprism.storage}   0755 photoprism users - -"
    "d ${vars.paths.bitmagnet.dataDir}    0755 root   users - -"
    "d ${vars.bitmagnetDB.postgres.dataDir} 0755 postgres users - -"
    "d ${vars.bitmagnetDB.redis.dataDir}    0755 redis    users - -"
  ];

  # Ensure Deluge target is writable
  systemd.services.prep-deluge-perms = {
    description = "Ensure Deluge dirs are writable";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''install -d -m 0775 -o deluge -g media ${torrentsDir}'';
  };

  # Apply per-user quotas from vars.quotas
  systemd.services.apply-quotas = {
    description = "Apply filesystem quotas for Samba users (per-user settings)";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -e
      DEV=$(findmnt -n -o SOURCE ${usersRoot})
      [ -n "$DEV" ] || exit 0

      # Set quotas
      ${quotaLines}

      # Ensure per-user private dirs exist
      for u in ${lib.concatStringsSep " " vars.users}; do
        id "$u" >/dev/null 2>&1 || continue
        install -d -m 0700 -o "$u" -g users ${usersRoot}/users/"$u"
      done
    '';
  };
}
