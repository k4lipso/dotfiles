{ config, lib, pkgs, ... }:

let
mfsync = with pkgs; stdenv.mkDerivation {
  name = "mfsync";
  src = pkgs.fetchFromGitHub {
    owner = "k4lipso";
    repo = "mfsync";
    rev = "master";
    sha256 = "1picg8igs6dnci7i7m50srxjr79rfpi28ra5rfd0fx9bdsw1hwbb";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgs.pkgconfig pkgs.cmake pkgs.gnumake ];
  depsBuildBuild = [ ];
  buildInputs = [ pkgs.spdlog pkgs.fmt pkgs.sqlite pkgs.openssl pkgs.boost172
                  pkgs.boost-build pkgs.doxygen pkgs.catch2 ];

  installPhase = ''
    mkdir -p $out/bin
    cp mfsync $out/bin/
  '';
};
in
{
  environment.systemPackages = with pkgs; [ mfsync ];

  #networking.firewall.enable = false;

  systemd.services.mfsync-daemon =
  {
    description = "mfsync daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${mfsync}/bin/mfsync sync 239.255.0.1 -i wlan0 eth0 -- /mnt";
      Restart = "on-failure";
      ExecStartPre="${pkgs.coreutils}/bin/sleep 30";
      After=["systemd-networkd-wait-online.service"];
      Wants=["systemd-networkd-wait-online.service"];
    };
    wantedBy = [ "default.target" ];
  };
}
