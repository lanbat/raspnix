{ vars, ... }:
{
  services.deluge = {
    enable = true;
    web.enable = true;
    declarative = true;
    config = {
      "download_location" = vars.paths.torrents;
      "listen_ports" = [ 58946 58946 ];
      "random_port" = false;
      "allow_remote" = true;
      "move_completed" = true;
      "move_completed_path" = vars.paths.torrents;
      "max_active_downloading" = 8;
      "max_active_seeding" = 16;
    };
  };
}
