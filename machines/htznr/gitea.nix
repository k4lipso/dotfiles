{ config, lib, pkgs, ... }:

{

  services.gitea = {
    enable = true;
    appName = "GoDD: Git of Dynamic Discord";
    domain = "git.dynamicdiscord.de";
    rootUrl = "https://git.dynamicdiscord.de/";
    httpPort = 3001;
  };

  services.nginx.virtualHosts."git.dynamicdiscord.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://localhost:3001";
  };
}
