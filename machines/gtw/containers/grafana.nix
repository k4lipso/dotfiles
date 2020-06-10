{ config, pkgs, ... }:
{
  services.grafana = {
    enable   = true;
    port     = 3000;
    domain   = "localhost";
    addr     = "";
    protocol = "http";
    dataDir  = "/var/lib/grafana";
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
