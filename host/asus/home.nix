{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sniego";
  home.homeDirectory = "/home/sniego";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sniego/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
 
  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp
      luajitPackages.lua-lsp
      rustup
      libclang
    ];

    plugins = with pkgs.vimPlugins; [

      # Git
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      #Detect tabstop and shiftwidth automatically 
      vim-sleuth
      
      #LSP
      nvim-lspconfig
      fidget-nvim
      neodev-nvim

      #CMP
      nvim-cmp
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      friendly-snippets
      cmp-path

      #telescope
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim

      #treesitter
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-rust
          p.tree-sitter-c
          p.tree-sitter-json
        ]));
      }
      nvim-treesitter-textobjects

      #stuff
      undotree
      tokyonight-nvim
      lualine-nvim
      which-key-nvim
      vim-nix
      comment-nvim
      nvim-web-devicons
    
    ];
    
    extraLuaConfig = ''
       ${builtins.readFile ./nvim/options.lua}
       ${builtins.readFile ./nvim/keymap.lua}
       ${builtins.readFile ./nvim/plugin/lsp.lua}
       ${builtins.readFile ./nvim/plugin/cmp.lua}
       ${builtins.readFile ./nvim/plugin/telescope.lua}
       ${builtins.readFile ./nvim/plugin/treesitter.lua}
       ${builtins.readFile ./nvim/plugin/gitsigns.lua}
       ${builtins.readFile ./nvim/plugin/other.lua}
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
