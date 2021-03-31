{ config, lib, pkgs, ... }:

let
mfsync = with pkgs; stdenv.mkDerivation {
  name = "mfsync";
  src = pkgs.fetchFromGitHub {
    owner = "k4lipso";
    repo = "mfsync";
    rev = "master";
    sha256 = "0ddav88qa5lnqbwmhvj491l358as50wqdagmlk57fza5czlrgi6a";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgs.pkgconfig pkgs.cmake pkgs.gnumake42 ];
  depsBuildBuild = [ ];
  buildInputs = [ pkgs.spdlog pkgs.fmt pkgs.sqlite pkgs.openssl pkgs.boost172 pkgs.boost-build pkgs.doxygen pkgs.catch2 ];

  installPhase = ''
    mkdir -p $out/bin
    cp mfsync $out/bin/
  '';
};
in
{
  environment.systemPackages = with pkgs; [ mfsync ];

  systemd.services.mfsync-daemon =
  {
    description = "mfsync daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${mfsync}/bin/mfsync sync 239.255.0.1 /home/kalipso/test";
      ExecStop = "killall mfsync";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
}
