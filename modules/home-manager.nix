{...}:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "05dabb7239254c0d9b2f314d7aa73923917bd1cd";
    ref = "master";
  };
in
{
  imports =
    [
      "${home-manager}/nixos"
    ];

  home-manager.users.kalipso =
  {
    programs.git = {
      enable = true;
      userName = "kalipso";
      userEmail = "kalipso@c3d2.de";
    };

    xdg.configFile."../.zshrc".source = ../dotfiles/zshrc;
    xdg.configFile."../.vimrc".source = ../dotfiles/vimrc;
    xdg.configFile."../.Xresources".source = ../dotfiles/Xresources;
    xdg.configFile."../.spacemacs".source = ../dotfiles/spacemacs;
    xdg.configFile."i3".source = ../dotfiles/i3;
    xdg.configFile."self".source = ../dotfiles/self;

  };

  home-manager.users.root =
  {
    programs.git = {
      enable = true;
      userName = "kalipso";
      userEmail = "kalipso@c3d2.de";
    };

    xdg.configFile."../.vimrc".source = ../dotfiles/vimrc;
  };


}
