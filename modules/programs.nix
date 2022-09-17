{ config, pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = (builtins.readFile ./neovim/init.lua);
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            (nvim-treesitter.withPlugins (
              (plugins: pkgs.tree-sitter.allGrammars)
            ))
            tokyonight-nvim
            nvim-lspconfig
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-cmdline
            nvim-cmp
            luasnip
            friendly-snippets
            cmp_luasnip
            lspkind-nvim
            lualine-nvim
            nvim-web-devicons
            nvim-tree-lua
          ];
          opt = [ ];
        };
      };
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
    adb.enable = true;
    tmux.enable = true;
    fish.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    wireshark.enable = true;
    file-roller.enable = true;
  };
}
