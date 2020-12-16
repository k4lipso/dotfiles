{pkgs, ...}:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "c1faa848c5224452660cd6d2e0f4bd3e8d206419";
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
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ spacevim ];
        
      #plugins = with pkgs.vimPlugins; [
      #  nerdtree vim-nerdtree-tabs nerdtree-git-plugin syntastic fugitive vim-pathogen airline rainbow_parentheses vim-colorschemes ];
      settings = { ignorecase = true; };
    };

    programs.git = {
      enable = true;
      userName = "kalipso";
      userEmail = "kalipso@c3d2.de";
    };

    xdg.configFile."../.zshrc".source = ../dotfiles/zshrc;
    xdg.configFile."../.vimrc".source = ../dotfiles/vimrc;
    xdg.configFile."nvim/init.vim".source = ../dotfiles/vimrc;
    xdg.configFile."../.Xresources".source = ../dotfiles/Xresources;
    #xdg.configFile."../.spacemacs".source = ../dotfiles/spacemacs;
    xdg.configFile."../.doom.d".source = ../dotfiles/doom_emacs;
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
