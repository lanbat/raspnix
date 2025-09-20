{
  hostname   = "pi5-media";
  timezone   = "Europe/London";

  # LUKS containers (set these to your actual LUKS UUIDs from `blkid`)
  luks = {
    nvme1 = { deviceUUID = "216f28c4-e49d-4f47-93ab-4c21210364b6"; name = "crypt-nvme1"; };
    nvme2 = { deviceUUID = "89a420ac-d70a-4311-83d0-3f529fc0f833"; name = "crypt-nvme2"; };
  };

  # Decrypted mount points
  mediaRoot  = "/mnt/nvme1";
  usersRoot  = "/mnt/nvme2";

  paths = {
    movies     = "/mnt/nvme1/media/movies";
    tv         = "/mnt/nvme1/media/tv";
    music      = "/mnt/nvme1/media/music";
    torrents   = "/mnt/nvme1/torrents";
    kodiSeed   = "/srv/kodi-addons";

    # App data and libraries
    sonarrData = "/mnt/nvme2/apps/sonarr";
    radarrData = "/mnt/nvme2/apps/radarr";
    photoprism = {
      originals = "/mnt/nvme2/photos/originals";
      storage   = "/mnt/nvme2/photos/storage";
      dataDir   = "/mnt/nvme2/apps/photoprism";
    };
    bitmagnet = {
      dataDir = "/mnt/nvme2/apps/bitmagnet";
      # A simple env file you will create with:
      #   BITMAGNET_POSTGRES_DSN=postgres://bitmagnet:supersecret@127.0.0.1:5432/bitmagnet?sslmode=disable
      #   REDIS_ADDR=127.0.0.1:6379
      envFile = "/mnt/nvme2/secret/bitmagnet.env";
    };
  };

  users = [ "traph" "alex" ];

  # Adjustable per-user quotas (GiB). Users not listed here fall back to `default`.
  quotas = {
    default = { softGiB = 50;  hardGiB = 60;  };
    perUser = {
      traph = { softGiB = 200; hardGiB = 250; };
      alex  = { softGiB = 100; hardGiB = 120; };
    };
  };

  # Service ports
  ports = {
    jellyfin      = 8096;
    delugeWeb     = 8112;
    homeAssistant = 8123;
    sonarr        = 8989;
    radarr        = 7878;
    photoprism    = 2342;
    bitmagnetUI   = 3333;
    bitmagnetAPI  = 3080;
    smbTCP        = [ 445 139 ];
    smbUDP        = [ 137 138 ];
    delugeDHT     = 6881;
  };

  # Backing services for Bitmagnet (local containers)
  bitmagnetDB = {
    enable = true;
    postgres = {
      port    = 5432;
      db      = "bitmagnet";
      user    = "bitmagnet";
      dataDir = "/mnt/nvme2/apps/postgres-bitmagnet";
    };
  };
}
