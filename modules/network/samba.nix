{ vars, ... }:
let
  mediaRoot   = vars.mediaRoot;
  usersRoot   = vars.usersRoot;
  torrentsDir = vars.paths.torrents;
in
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      "global" = {
        "workgroup" = "WORKGROUP";
        "server string" = "Pi5 Media Server";
        "map to guest" = "Bad User";
        "security" = "user";
        "guest account" = "nobody";
        "vfs objects" = "acl_xattr";
        "store dos attributes" = "yes";
        "quota backend" = "rpc";
      };

      "media" = {
        "path" = "${mediaRoot}/media";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "@media";
        "force group" = "media";
        "create mask" = "0664";
        "directory mask" = "0775";
      };

      "torrents" = {
        "path" = torrentsDir;
        "browseable" = "yes";
        "read only" = "no";
        "valid users" = "@media";
        "force group" = "media";
        "create mask" = "0664";
        "directory mask" = "0775";
      };

      "homes" = {
        "comment" = "Home Directories with quotas";
        "browseable" = "no";
        "read only" = "no";
        "valid users" = "%S";
        "path" = "${usersRoot}/users/%S";
        "create mask" = "0600";
        "directory mask" = "0700";
      };
    };
  };
}
