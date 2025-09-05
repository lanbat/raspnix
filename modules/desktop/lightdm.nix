{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xterm.enable = false;

    windowManager.session = [
      { name = "Kodi"; start = ''exec ${pkgs.kodi}/bin/kodi-standalone''; }
      { name = "RetroArch"; start = ''exec ${pkgs.retroarch}/bin/retroarch''; }
    ];

    xkb.layout = "gb";
    displayManager.lightdm.autoLogin.enable = false;
  };

  environment.systemPackages = with pkgs; [ kodi retroarch ];
}
