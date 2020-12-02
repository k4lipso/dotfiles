{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wireguard
    wget
    vim
    git
    htop
    bmon
    wavemon
    emacs
    tree
    gnupg
    emacs
    gcc
    cmake
    zsh
    oh-my-zsh
    rsync
    pass
    nmap
    killall
    direnv
    youtube-dl
    unzip
    zip
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "man" ];
      theme = "robbyrussell";
    };
  };

  programs.gnupg.agent = { enable = true; };

  #TimeZone
  time.timeZone = "Europe/Berlin";
}
