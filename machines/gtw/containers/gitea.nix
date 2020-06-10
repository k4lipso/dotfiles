{ config, pkgs, ... }:
{
  services.gitea.enable = true;
  services.gitea.httpPort = 3000;
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
