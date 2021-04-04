let

  get_id = id : "10.5.5.1${id}";

  networkConfig = ip :
    ''
      [Match]
      Name = eth0
      [Network]
      Address =  10.5.5.1${ip}
      Gateway = 10.5.5.1
    '';

  createDeployment = identifier : { ... }:
    {
      imports =
      [
        machines/mfsync_cluster/configuration.nix
        #machines/mfsync_cluster/camera.nix
      ];

      networking = {
        usePredictableInterfaceNames = false;
        interfaces.eth0.ipv4.addresses = [{
          address = get_id "${identifier}";
          prefixLength = 24;
        }];
        defaultGateway = "10.5.5.1";

        nameservers = [ "1.1.1.1" "1.0.0.1" ];
        hostName = "mfsync_${identifier}";
      };

      #deployment =
      #{
      #  targetHost = get_id "${identifier}";
      #};
    };
in
{
  network.description = "mfsync cluster";

  "mfsync_01" =
    { ... }:
    {
      imports =
      [
        (createDeployment "01")
      ];

      fileSystems."/mnt" =
        { device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_010126adf14433b0a891d37bf530a1501e8c2301a241d7f31dd71d6a819ac29b92a40000000000000000000096c91a110084200083558107b4a8fb22-0:0-part1";
        };

      deployment =
      {
        targetHost = get_id "01";
      };
    };

  "mfsync_02" =
    { ... }:
    {
      imports =
      [
        (createDeployment "02")
      ];

      fileSystems."/mnt" =
        { device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_0101aad90290bd0631bb24838c2f4c8e611e42d4a420bea04dceaeea674fee675dee000000000000000000003fb3fcd1ff94230083558107b4a8f91e-0:0-part1";
        };

      deployment =
      {
        targetHost = get_id "02";
      };
    };

  "mfsync_03" =
    { ... }:
    {
      imports =
      [
        (createDeployment "03")
      ];

      fileSystems."/mnt" =
        { device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_0101eed463449041b6ad5f8b6acc227c8b54dd89c03a3bcc84669945568716cf53c200000000000000000000a2f4039bff01210083558107b4a8fb48-0:0-part1";
        };


      deployment =
      {
        targetHost = get_id "03";
      };
    };

  "mfsync_04" =
    { ... }:
    {
      imports =
      [
        (createDeployment "04")
      ];

      fileSystems."/mnt" =
        { device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_01010c410eae7ceffcae07a453d3269345641f8c2372e73657c3a30c59c9a366d6c80000000000000000000068866e6e0007200083558107b4a9003a-0:0-part1";
        };

      deployment =
      {
        targetHost = get_id "04";
        #targetHost = "10.5.5.25";
      };
    };

  "mfsync_05" =
    { ... }:
    {
      imports =
      [
        (createDeployment "05")
      ];

      fileSystems."/mnt" =
        { device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_0101237bbc148bedccdefb7bf09f01f2a4894edcf1943f063fa958292fad07fd85f20000000000000000000018cc7470008e200083558107b4a8fb29-0:0-part1";
        };


      deployment =
      {
        targetHost = get_id "05";
      };
    };


  #"mfsync_02" =
  #  { ... }:
  #  {
  #    imports =
  #    [
  #      machines/mfsync_cluster/configuration.nix

  #    ];

  #    systemd.network = {
  #      enable = true;
  #      networks."eth0".extraConfig = networkConfig(get_id "02");
  #    };

  #    networking.dhcpcd.enable = false;
  #    networking.nameservers = [ "1.1.1.1" ];

  #    networking.hostName = "mfsync_02";
  #    deployment =
  #    {
  #      targetHost = get_id "02";
  #    };
  #  };
}
