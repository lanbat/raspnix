{ vars, lib, ... }:
let
  pp = vars.paths.photoprism;
in
{
  services.photoprism = {
    enable = true;
    openFirewall = true;

    settings = {
      OriginalsPath = pp.originals;
      StoragePath   = pp.storage;
      AdminUser     = "admin";
      Public        = false;
      Experimental  = false;
    };

    dataDir = pp.dataDir;
  };

  users.users.photoprism.extraGroups = [ "media" ];
}
