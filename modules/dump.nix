{ config, lib, pkgs, ... }:

let
  repo = pkgs.fetchFromGitea {
    domain = "git.dynamicdiscord.de";
    owner = "kalipso";
    repo = "evidence_dump";
    rev = "master";
    sha256 = "0y6ay9hjykmgcy566iqr1p9nh5dyjmg21zwfxpw6m6q84whwca2c";
  };

  evDump = (pkgs.callPackage "${repo}/default.nix" {}).package;
in
{
  environment.systemPackages = with pkgs; [ nodejs ];

  systemd.services.evdump-daemon =
  {
    description = "ev dump daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.nodejs}/bin/node ${evDump}/lib/node_modules/EvidenceDump/server.js";
      Restart = "on-failure";
      ExecStartPre="${pkgs.coreutils}/bin/sleep 30";
      After=["systemd-networkd-wait-online.service"];
      Wants=["systemd-networkd-wait-online.service"];
    };
    wantedBy = [ "default.target" ];
  };
}
