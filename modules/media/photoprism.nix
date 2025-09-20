{ vars, lib, ... }:
let
  pp = vars.paths.photoprism;
in
{
  services.photoprism = {
    enable = true;

    # Bind + port (change if you prefer localhost-only)
    address       = "0.0.0.0";
    port          = 2342;

    # Correct top-level paths
    originalsPath = pp.originals;
    storagePath   = pp.storage;

    settings = {
      AdminUser    = "admin";
      Public       = false;
      Experimental = false;
    };
  };

  # Manually open the port (remove if you keep address = "127.0.0.1")
  networking.firewall.allowedTCPPorts = [ 2342 ];

  users.users.photoprism.extraGroups = [ "media" ];
}

