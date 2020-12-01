{ pkgs, lib, ...}:
{

  services.xserver = {
    enable = true;
    layout = "us";
    # xkbOptions = "eurosign:e";
    libinput.enable = true;

    displayManager.defaultSession = "none+i3";

    desktopManager = {
      #default = "none";
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
	      i3blocks
      ];
    };
  };
}
