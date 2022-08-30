{ config, lib, pkgs, ... }:

let
libindicators = with pkgs; stdenv.mkDerivation {
  name = "indicators";
  src = pkgs.fetchFromGitHub {
    owner = "p-ranav";
    repo = "indicators";
    rev = "a5bc05f32a9c719535054b7fa5306ce5c8d055d8";
    sha256 = "05n714i9d65m5nrfi2xibdpgzbp0b0x6i1n4r3mirz1ydaz9fvxd";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgs.pkgconfig pkgs.cmake pkgs.gnumake ];
  depsBuildBuild = [ ];
  buildInputs = [ ];

  installPhase = '''';
};

mfsync = with pkgs; stdenv.mkDerivation {
  name = "mfsync";
  src = pkgs.fetchFromGitHub {
    owner = "k4lipso";
    repo = "mfsync";
    rev = "master";
    sha256 = "02k69gi494xci6n9ch36v1yfbllmmhjnxh4dr1g9jnng1ghcpzvc";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgs.git pkgs.pkgconfig pkgs.cmake pkgs.gnumake ];
  depsBuildBuild = [ ];
  buildInputs = [ pkgs.spdlog pkgs.fmt pkgs.sqlite pkgs.openssl pkgs.boost174 libindicators
                  pkgs.boost-build pkgs.doxygen pkgs.catch2 ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  buildPhase = "make -j $NIX_BUILD_CORES";

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
      ExecStart = "${mfsync}/bin/mfsync sync -i wlan0 eth0 -- /mnt";
      Restart = "on-failure";
      ExecStartPre="${pkgs.coreutils}/bin/sleep 30";
      After=["systemd-networkd-wait-online.service"];
      Wants=["systemd-networkd-wait-online.service"];
    };
    wantedBy = [ "default.target" ];
  };
}
