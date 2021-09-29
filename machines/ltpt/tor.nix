{ config, lib, pkgs, ... }:

{
  services.tor.settings.ClientOnionAuthDir = "/var/lib/tor/keys";
}
