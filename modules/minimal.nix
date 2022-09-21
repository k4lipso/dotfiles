{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    binutils
    perf-tools
    #binwalk
    foremost
    imagemagick
    sqlmap
    dhcp
    dhcpcd
    inetutils
    tcpdump
    bind
    wireguard-tools
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
    clang
    clang-tools
    gcc
    cmake
    zsh
    oh-my-zsh
    rsync
    pass
    nmap
    openssl
    screen-message
    stdman
    traceroute
    tigervnc
    unzip
    whois
    zip
    killall
    direnv
    nix-direnv
    youtube-dl
    unzip
    zip
    cryptsetup
    weechat
    jq
    python3
    inotify-tools
    calc
    cloc
    ffmpeg
    ddate
    dnstracer
    iotop
    mpv
    nixops
  ];


  nix = {
    package = pkgs.nixFlakes;
    extraOptions = 
    ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  environment.variables = { EDITOR = "vim"; VISUAL = "vim"; };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "colored-man-pages" ];
      theme = "fino-time";
    };
  };

  environment.variables = {
      MODE_INDICATOR = "%F{red}fnord%f";
      VI_MODE_RESET_PROMPT_ON_MODE_CHANGE = "true";
      VI_MODE_SET_CURSOR = "true";
  };

  programs.gnupg.agent = { enable = true; };

  #TimeZone
  time.timeZone = "Europe/Berlin";
}
