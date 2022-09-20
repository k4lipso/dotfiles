{ config, pkgs, ... }:

{
  sops.secrets.wireguard_host = {};
  # Enable Wireguard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "50.100.0.2/24" ];

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/kalipso/wireguard-keys/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "Anme1N482rGSZ14wqtZQbzUHvX4oFhoVct0d187H0iM=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "50.100.0.0/24" ];
          # Or forward only particular subnets
          #allowedIPs = [ "50.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = config.sops.secrets.wireguard_host.path;
          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
