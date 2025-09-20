{ lib, pkgs, vars, ... }:
let
  bitmag = vars.paths.bitmagnet;
  dbCfg  = vars.bitmagnetDB;
in
{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers =
    (lib.optionalAttrs dbCfg.enable {
      "bitmagnet-postgres" = {
        image = "docker.io/library/postgres:16";
        ports = [ "${toString dbCfg.postgres.port}:5432" ];
        volumes = [ "${dbCfg.postgres.dataDir}:/var/lib/postgresql/data" ];
        environment = {
          POSTGRES_DB = dbCfg.postgres.db;
          POSTGRES_USER = dbCfg.postgres.user;
        };
        # Provide POSTGRES_PASSWORD from an env file if needed:
        # environmentFiles = [ "/path/to/postgres.env" ];
        extraOptions = [ "--name=bitmagnet-postgres" "--restart=always" ];
      };
    }) //
    {
      "bitmagnet" = {
        image = "ghcr.io/bitmagnet-io/bitmagnet:latest";
        ports = [
          "${toString vars.ports.bitmagnetUI}:3333"
          "${toString vars.ports.bitmagnetAPI}:3080"
        ];
        volumes = [
          "${bitmag.dataDir}:/data"
        ];
        # Provide Postgres settings via env file at vars.paths.bitmagnet.envFile (no Redis)
        environmentFiles = [ vars.paths.bitmagnet.envFile ];
        extraOptions = [ "--name=bitmagnet" "--restart=always" ];
        dependsOn = lib.optional dbCfg.enable [ "bitmagnet-postgres" ];
      };
    };

  systemd.tmpfiles.rules = [
    "d ${bitmag.dataDir} 0755 root users - -"
  ];
}
