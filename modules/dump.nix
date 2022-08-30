{ config, lib, pkgs, ... }:

let
  repo = pkgs.fetchFromGitea {
    domain = "git.dynamicdiscord.de";
    owner = "kalipso";
    repo = "evidence_dump";
    rev = "master";
    sha256 = "1pajndg5hn2l1yp5pbh9djz6jd2143rabrb28vndxqn6bgghqagj";
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
