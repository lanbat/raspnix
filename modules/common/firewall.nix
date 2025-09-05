{ vars, ... }:
{
  networking.firewall.allowedTCPPorts =
    [ vars.ports.jellyfin
      vars.ports.delugeWeb
      vars.ports.homeAssistant
      vars.ports.sonarr
      vars.ports.radarr
      vars.ports.photoprism
      vars.ports.bitmagnetUI
      vars.ports.bitmagnetAPI
    ] ++ vars.ports.smbTCP;

  networking.firewall.allowedUDPPorts =
    vars.ports.smbUDP ++ [ vars.ports.delugeDHT ];
}
