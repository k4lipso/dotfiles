{ config, pkgs, ... }:

{
  services.postfix = {
    enable = true;
    setSendmail = true;
  };

  services.hydra = {
    enable = true;
    hydraURL = "localhost:3000";
    buildMachinesFiles = [];
    useSubstitutes = true;
    notificationSender = "hydra@localhost";

    extraConfig = ''
      store_uri = file:///var/lib/hydra/cache?secret-key=/etc/nix/htznr/secret
      binary_cache_secret_key_file = /etc/nix/htznr/secret
      binary_cache_dir = /var/lib/hydra/cache
    '';
  };

  systemd.services.hydra-manual-setup = {
    description = "Create Admin User for Hydra";
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    wantedBy = [ "multi-user.target" ];
    requires = [ "hydra-init.service" ];
    after = [ "hydra-init.service" ];
    environment = builtins.removeAttrs (config.systemd.services.hydra-init.environment) ["PATH"];
    script = ''
      if [ ! -e ~hydra/.setup-is-complete ]; then
        # create signing keys
        /run/current-system/sw/bin/install -d -m 551 /etc/nix/htznr
        /run/current-system/sw/bin/nix-store --generate-binary-cache-key htznr /etc/nix/htznr/secret /etc/nix/htznr/public
        /run/current-system/sw/bin/chown -R hydra:hydra /etc/nix/htznr
        /run/current-system/sw/bin/chmod 440 /etc/nix/htznr/secret
        /run/current-system/sw/bin/chmod 444 /etc/nix/htznr/public
        # create cache
        /run/current-system/sw/bin/install -d -m 755 /var/lib/hydra/cache
        /run/current-system/sw/bin/chown -R hydra-queue-runner:hydra /var/lib/hydra/cache
        # done
        touch ~hydra/.setup-is-complete
      fi
    '';
  };

  nix.gc = {
    automatic = true;
    dates = "15 3 * * *"; # [1]
  };

  nix.autoOptimiseStore = true;

  nix.trustedUsers = ["hydra" "hydra-evaluator" "hydra-queue-runner"];

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nix/htznr/secret";
  };

    #nix.buildMachines = [
    #  {
    #    hostName = "localhost";
    #    systems = [ "x86_64-linux" "i686-linux" ];
    #    maxJobs = 6;
    #    # for building VirtualBox VMs as build artifacts, you might need other
    #    # features depending on what you are doing
    #    supportedFeatures = [ ];
    #  }
    #];

  nix.extraOptions = ''
    allowed-uris = https://github.com/nixos/nixpkgs
  '';

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
