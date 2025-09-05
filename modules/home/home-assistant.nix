{ vars, ... }:
{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = vars.timezone;
      };
      default_config = {};
      http = { server_port = vars.ports.homeAssistant; };
      discovery = {};
    };
    extraComponents = [ "esphome" "hue" "upnp" "mobile_app" ];
  };
}
