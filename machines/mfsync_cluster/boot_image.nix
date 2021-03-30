{ ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
  ];

  networking.usePredictableInterfaceNames = false;
  #systemd.network = {
  #  enable = true;
  #  networks."eth0".extraConfig = ''
  #    [Match]
  #    Name = eth0
  #    [Network]
  #    # Add your own assigned ipv6 subnet here here!
  #    # optionally you can do the same for ipv4 and disable DHCP (networking.dhcpcd.enable = false;)
  #    Address =  192.168.1.10
  #    Gateway = 192.168.1.1 
  #  '';
  #};
  networking.dhcpcd.enable = true;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfDz5teTvRorVtpMj7i3pffD8W4Dn3Aiqre5L4WZq8Wc4bh2OjabGnIcDWpeToKf38n5m0d95OkIbARJwFN7KlbuQbmnIJ5n6pUj/zzRQ3dQTeSsUjkvdbSXVvTcDczMWwLixc/UKP1DMbiLHz5ZSywPTSH2l40lg74q7tSFGBwMy8uy4tsdp2d2sUIDfpvgGj3Pq+zkQHWyFR5BYyCLDfJMTQvGO0bEsbRIDOjkH8YVni46ds6sQKMgc+L2vPo8S3neFZBQRlERVRvIAzdLiBWqGkiw4YgWQA8ocTfWp9DVzW+BZiatc34+AX3KtLEF1Oz76YsKjBttSQL4myUucuskz2Bs7UYvAsDFlWyiJ43ayZNzvG63m1UVsAoq84IhNYsdkPhd+G1rtnG0KxPVAtn7RkAGt8t7ObU+6xWayHcpSteNeE+QyH9nNmJcXNNKfoOeP4vHUBrBTeURafw527yuZDOYknJmg3O+nkeGseIgBYgq/As4+dD6vhp03Y5chjU4/FC6nEjsGPRdfe2RZx+0cqJkLgdd1paGByUfPfaUKykw4TsCUAiDucRwBjU32MLslUbyzeEkjzOJzOD5Frif3jZZLxaNP2QcHRbTiiKkdn+WFJmjr3BdC60pm7hqvmDxl0UZcz9hDv3wZUALUc92TQXnWc8GicKdpQgRYDRQ== kalipso@c3d2.de"
  ];
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfDz5teTvRorVtpMj7i3pffD8W4Dn3Aiqre5L4WZq8Wc4bh2OjabGnIcDWpeToKf38n5m0d95OkIbARJwFN7KlbuQbmnIJ5n6pUj/zzRQ3dQTeSsUjkvdbSXVvTcDczMWwLixc/UKP1DMbiLHz5ZSywPTSH2l40lg74q7tSFGBwMy8uy4tsdp2d2sUIDfpvgGj3Pq+zkQHWyFR5BYyCLDfJMTQvGO0bEsbRIDOjkH8YVni46ds6sQKMgc+L2vPo8S3neFZBQRlERVRvIAzdLiBWqGkiw4YgWQA8ocTfWp9DVzW+BZiatc34+AX3KtLEF1Oz76YsKjBttSQL4myUucuskz2Bs7UYvAsDFlWyiJ43ayZNzvG63m1UVsAoq84IhNYsdkPhd+G1rtnG0KxPVAtn7RkAGt8t7ObU+6xWayHcpSteNeE+QyH9nNmJcXNNKfoOeP4vHUBrBTeURafw527yuZDOYknJmg3O+nkeGseIgBYgq/As4+dD6vhp03Y5chjU4/FC6nEjsGPRdfe2RZx+0cqJkLgdd1paGByUfPfaUKykw4TsCUAiDucRwBjU32MLslUbyzeEkjzOJzOD5Frif3jZZLxaNP2QcHRbTiiKkdn+WFJmjr3BdC60pm7hqvmDxl0UZcz9hDv3wZUALUc92TQXnWc8GicKdpQgRYDRQ== kalipso@c3d2.de"
  ];

}
