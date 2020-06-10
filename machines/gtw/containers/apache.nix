{ config, pkgs, ... }:
{
  services.httpd.enable = true;
  services.httpd.adminAddr = "alice@example.org";
  #services.httpd.documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
  services.httpd.virtualHosts.test.documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
  networking.firewall.allowedTCPPorts = [ 80 ];
}
