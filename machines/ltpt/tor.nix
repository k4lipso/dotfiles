{ config, lib, pkgs, ... }:

{
  services.tor.settings.ClientOnionAuthDir = "/home/kalipso/.config/tor/keys";
}
