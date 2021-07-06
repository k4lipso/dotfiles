{ config, lib, pkgs, ... }:

let
  DeploymentSecrets = import ../../deployment_secrets.nix;
in
{
  services.nginx.upstreams."django" = {
    extraConfig = ''
      server unix:/var/www/report.dynamicdiscord.de/wesbite/kgp/run/gunicorn.sock
      fail_timeout=0;
    '';
  };

  services.nginx.virtualHosts."report.dynamicdiscord.de" = {
    basicAuth = DeploymentSecrets.report_login;
    forceSSL = true;
    enableACME = true;
    root = "/var/www/report.dynamicdiscord.de/wesbite/kgp/";
    locations."/media/".alias = "/var/www/report.dynamicdiscord.de/wesbite/kgp/media/";
    locations."/static/".alias = "/var/www/report.dynamicdiscord.de/wesbite/kgp/static/";

    locations."/".extraConfig = ''
      # an HTTP header important enough to have its own Wikipedia entry:
      #   http://en.wikipedia.org/wiki/X-Forwarded-For
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      # enable this if and only if you use HTTPS, this helps Rack
      # set the proper protocol for doing redirects:
      # proxy_set_header X-Forwarded-Proto https;
      # pass the Host: header from the client right along so redirects
      # can be set properly within the Rack application
      proxy_set_header Host $host;
      # we don't want nginx trying to do something clever with
      # redirects, we set the Host: header above already.
      proxy_redirect off;
      # set "proxy_buffering off" *only* for Rainbows! when doing
      # Comet/long-poll stuff.  It's also safe to set if you're
      # using only serving fast clients with Unicorn + nginx.
      # Otherwise you _want_ nginx to buffer responses to slow
      # clients, really.
      # proxy_buffering off;
      # Try to serve static files from nginx, no point in making an
      # *application* server like Unicorn/Rainbows! serve static files.
      if (!-f $request_filename) {
      proxy_pass http://django;
      break;
      }
    '';

    extraConfig = ''
      client_max_body_size 4G;
      #access_log /var/www/report.dynamicdiscord.de/wesbite/kgp/logs/nginx-access.log;
      #error_log /var/www/report.dynamicdiscord.de/wesbite/kgp/logs/nginx-error.log;
    '';
  };
}
