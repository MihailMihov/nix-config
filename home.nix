{ inputs, config, pkgs, ... }:
{
  imports = [ 
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nix-index-database.hmModules.nix-index
  ];
  
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.emacs ];

  home.username = "mihail";
  home.homeDirectory = "/home/mihail";

  programs.firefox = {
    enable = true;
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    options = {
      number = true;
      shiftwidth = 2;
    };
    clipboard.providers.wl-copy.enable = true;
    colorschemes.kanagawa.enable = true;
    plugins = {
      treesitter.enable = true;
      luasnip.enable = true;
      nvim-cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-cmdline.enable = true;
      cmp-latex-symbols.enable = true;
      neorg.enable = true;
      nvim-autopairs.enable = true;
      vimtex = {
        enable = true;
	installTexLive = true;
      };
      lsp = {
        enable = true;
        servers = {
	  lua-ls.enable = true;
	  nixd.enable = true;
	};
      };
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git;
  };

  programs.git = {
    enable = true;
    userName = "Mihail Mihov";
    userEmail = "mihovmihailp@gmail.com";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.home-manager.enable = true;

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/download";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    publicShare = "${config.home.homeDirectory}/public";
    templates = "${config.home.homeDirectory}/templates";
    videos = "${config.home.homeDirectory}/videos";
  };

  home.stateVersion = "23.11";
}
