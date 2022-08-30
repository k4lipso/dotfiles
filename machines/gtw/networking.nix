{ config, lib, pkgs, ... }:

{
  networking = {
	  hostId = "d4040ec7";
  	hostName = "gtw";
    nameservers = [ "1.1.1.1" ];
    useDHCP = false;

    hosts = lib.mkForce {
      "127.0.0.1" = ["localhost"];
      "::1" = [ "localhost" ];
    };

    #vlans = {
    #  lan = {
    #    interface = "eth0";
    #    id = 23;
    #  };

    #  #iot = {
    #  #  interface = "eth0";
    #  #  id = 42;
    #  #};
    #};

    interfaces = {
      eth1 = {
        name = "eth1";
        useDHCP = true;
        #ipv4.addresses = [{
        #  address = "20.0.2.2";
        #  prefixLength = 24;
        #}];
      };

      #lan = {
      eth0 = {
        name = "eth0";
        ipv4.addresses = [{
          address = "10.0.1.1";
          prefixLength = 24;
        }];
      };

      #iot = {
      #  ipv4.addresses = [{
      #    address = "10.0.5.1";
      #    prefixLength = 24;
      #  }];
      #};
    };


    nat = {
      enable = true;
      externalInterface = "eth1";
      internalIPs = [ "10.0.1.0/24" "10.0.5.0/24" ];
      internalInterfaces = [ "eth0" ];
      #forwardPorts = [
      #  { sourcePort = 32400; destination = "10.40.33.20:32400"; proto = "tcp"; }
      #  { sourcePort = 80; destination = "10.40.33.165:8081"; proto = "tcp"; }
      #];
    };

    #enableIPv6 = true;
    #dhcpcd.persistent = true;

    firewall = {
      enable = true;
      allowPing = true;
    };

  };

  #services.dnsmasq = {
  #  enable = true;
  #  servers = [ "1.1.1.1" "1.0.0.1" ];
  #  extraConfig = ''
  #    domain=lan
  #    interface=eth0
  #    bind-interfaces
  #    dhcp-range=10.0.1.23,10.0.1.254,24h
  #  '';
  #};
  services = {

    dnsmasq = {
      enable = true;
      extraConfig = ''
      '';
    };

    dhcpd4 = {
      interfaces = [ "eth0" ];
      enable = true;
      #machines = [
      #  { hostName = "optina"; ethernetAddress = "d4:3d:7e:4d:c4:7f"; ipAddress = "10.40.33.20"; }
      #  { hostName = "printer"; ethernetAddress = "a4:5d:36:d6:22:d9"; ipAddress = "10.40.33.50"; }
      #];

      extraConfig = ''
        # option arch code 93 = unsigned integer 16;
        # option rpiboot code 43 = text;

        # Allow UniFi devices to locate the controller from a separate VLAN
        # option space ubnt;
        # option ubnt.UNIFI-IP-ADDRESS code 1 = ip-address;
        # option ubnt.UNIFI-IP-ADDRESS 10.40.33.20;
        # class "ubnt" {
        #   match if substring (option vendor-class-identifier, 0, 4) = "ubnt";
        #   option vendor-class-identifier "ubnt";
        #   vendor-option-space ubnt;
        # }

        subnet 10.0.1.0 netmask 255.255.255.0 {
          option domain-search "pwhq.lan";
          option subnet-mask 255.255.255.0;
          option broadcast-address 10.0.1.255;
          option routers 10.0.1.1;
          option domain-name-servers 1.1.1.1;
          range 10.0.1.100 10.0.1.200;
          next-server 10.0.1.1;
          #if exists user-class and option user-class = "iPXE" {
          #  filename "http://netboot.wedlake.lan/boot.php?mac=''${net0/mac}&asset=''${asset:uristring}&version=''${builtin/version}";
          #} else {
          #  if option arch = 00:07 or option arch = 00:09 {
          #    filename = "x86_64-ipxe.efi";
          #  } else {
          #    filename = "undionly.kpxe";
          #  }
          #}
          #option rpiboot "Raspberry Pi Boot   ";
        }

        #subnet 10.0.5.0 netmask 255.255.255.0 {
        #  option subnet-mask 255.255.255.0;
        #  option broadcast-address 10.0.5.255;
        #  option routers 10.0.5.1;
        #  option domain-name-servers 10.0.5.1;
        #  range 10.0.5.100 10.0.5.200;
        #}
      '';
    };
  };
}
