# modules/users/traph.nix
{ lib, pkgs, ... }:
{
  users.users.traph = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA3wOGtqxlVpVcR3BpVT5dAgOvo2x6c/F/skA8ULA2uGBYw1HhzKCizrqaQFMP6dxdmQrc7pCke4yoZ68fHRXo5ZJbhEFnCMOJMuksTHGwlrQh9vY6hiXU/Pm2mfse3WYn/k3hnU602IWfxmK/8opJmN2Sow6g5fg0/k2WrZ1mVWrCBfHA1Nvm+xdZQ7a7n2Tj2fUehN6HKQE0kA+jF8h3hYwc/dQCytvwk7ha3d9pYmBVU0xaE1KKvKXH+WhAYfzVRmO1cHYwgBcF/qPYp9svLYFgJ2sc8nfEYbfw9t1Wvt1SEregGvec3joFFvY8xhAHDo7Pp7IIEMifb2BF0bdCPl6uUA7d0eVvfo50tQLjsHArdshrC4LzV42s7EsnztEhlZvmKpYq2OClvAbUKogvnpzsF3b56Vl592dhu+4yKinhndisc8YGtAMR9YbQu5p172vWNX2t66drfAt43ghNeqkA0s0RPE1/KGeCNpcwTwjFD3scIJMAmKp9LXW5hCc= traph@inna"
    ];
  };

  security.sudo.enable = true;
  security.sudo.extraRules = [
    { users = [ "traph" ]; commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }]; }
  ];

  services.openssh = {
    enable = true;
    # keep these together under `settings` for 24.05/25.05+
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = [ pkgs.vim ];
  programs.vim.defaultEditor = true;
}

