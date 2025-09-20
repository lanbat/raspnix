{ lib, vars, ... }:
{
  users.groups.media = { };

  users.users = lib.mkMerge [
    # 1) the media kiosk user
    {
      media = {
        isNormalUser = true;
        home = "/home/media";
        description = "Media kiosk user";
        extraGroups = [ "audio" "video" "media" "users" ];
        password = "changeme";
      };
    }

    # 2) regular users from vars.users
    (lib.genAttrs vars.users (u: {
      isNormalUser = true;
      extraGroups = [ "users" "media" ];
      password = "changeme";
    }))

    # 3) service accounts — add them to the media group
    {
      jellyfin     = { extraGroups = [ "media" ]; };
      deluge       = { extraGroups = [ "media" ]; };
      smbd         = { extraGroups = [ "media" ]; };
      homeassistant= { extraGroups = [ "media" ]; };
    }
  ];
}

