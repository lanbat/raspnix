{ lib, vars, ... }:
{
  users.groups.media = { };

  users.users = lib.mkMerge ([
    {
      media = {
        isNormalUser = true;
        home = "/home/media";
        description = "Media kiosk user";
        extraGroups = [ "audio" "video" "media" "users" ];
        password = "changeme";
      };
    }
  ] ++ map (u: {
    ${u} = {
      isNormalUser = true;
      extraGroups = [ "users" "media" ];
      password = "changeme";
    };
  }) vars.users);

  # Give service accounts access to the media group
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.deluge.extraGroups = [ "media" ];
  users.users.smbd.extraGroups = [ "media" ];
  users.users.homeassistant.extraGroups = [ "media" ];
}
