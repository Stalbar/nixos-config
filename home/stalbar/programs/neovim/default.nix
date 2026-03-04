{ pkgs, lib, ... }:

let
  nvimDevHealth = pkgs.writeShellApplication {
    name = "nvim-dev-health";
    runtimeInputs = with pkgs; [ coreutils gnugrep ];
    text = ''
      set -euo pipefail

      required_bins=(
        nvim
        git
        rg
        fd
        nixd
        lua-language-server
        bash-language-server
        pyright-langserver
        ruff
        typescript-language-server
        vscode-json-language-server
        vscode-css-language-server
        vscode-html-language-server
        docker-langserver
        tailwindcss-language-server
        protols
        qmlls6
        postgres-language-server
        roslyn-ls
        tree-sitter
        stylua
        shfmt
        prettierd
        prettier
        csharpier
        pg_format
        nixfmt
      )

      missing=0
      echo "Neovim dev tool health check"
      echo "----------------------------"

      for bin in "''${required_bins[@]}"; do
        if command -v "$bin" >/dev/null 2>&1; then
          printf "OK      %s\n" "$bin"
        else
          printf "MISSING %s\n" "$bin"
          missing=$((missing + 1))
        fi
      done

      echo
      if [ "$missing" -eq 0 ]; then
        echo "All required tools are available."
      else
        echo "$missing tool(s) missing from PATH."
        exit 1
      fi
    '';
  };

  nvimPluginSync = pkgs.writeShellApplication {
    name = "nvim-plugin-sync";
    runtimeInputs = with pkgs; [ neovim ];
    text = ''
      set -euo pipefail
      exec nvim --headless "+Lazy! sync" +qa
    '';
  };
in
{
  home.packages = with pkgs; [
    nixfmt
    nvimDevHealth
    nvimPluginSync
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim/init.lua".source = ./config/nvim/init.lua;
  xdg.configFile."nvim/lua/core/lsp.lua".source = ./config/nvim/lua/core/lsp.lua;
  xdg.configFile."nvim/lua/core/options.lua".source = ./config/nvim/lua/core/options.lua;
  xdg.configFile."nvim/lua/core/keymaps.lua".source = ./config/nvim/lua/core/keymaps.lua;
  xdg.configFile."nvim/lua/core/diagnostics.lua".source = ./config/nvim/lua/core/diagnostics.lua;
  xdg.configFile."nvim/lua/core/autosave.lua".source = ./config/nvim/lua/core/autosave.lua;

  xdg.configFile."nvim/lua/config/lazy.lua".text =
    builtins.replaceStrings [ "@lazyPath@" ] [ "${pkgs.vimPlugins.lazy-nvim}" ]
      (builtins.readFile ./config/nvim/lua/config/lazy.lua);

  xdg.configFile."nvim/lua/plugins/init.lua".source = ./config/nvim/lua/plugins/init.lua;
  xdg.configFile."nvim/lua/plugins/editing/init.lua".source = ./config/nvim/lua/plugins/editing/init.lua;
  xdg.configFile."nvim/lua/plugins/editing/treesitter.lua".source = ./config/nvim/lua/plugins/editing/treesitter.lua;
  xdg.configFile."nvim/lua/plugins/editing/text.lua".source = ./config/nvim/lua/plugins/editing/text.lua;
  xdg.configFile."nvim/lua/plugins/editing/snippets.lua".source = ./config/nvim/lua/plugins/editing/snippets.lua;
  xdg.configFile."nvim/lua/plugins/refactor/init.lua".source = ./config/nvim/lua/plugins/refactor/init.lua;
  xdg.configFile."nvim/lua/plugins/refactor/rename.lua".source = ./config/nvim/lua/plugins/refactor/rename.lua;
  xdg.configFile."nvim/lua/plugins/refactor/outline.lua".source = ./config/nvim/lua/plugins/refactor/outline.lua;
  xdg.configFile."nvim/lua/plugins/workflow/init.lua".source = ./config/nvim/lua/plugins/workflow/init.lua;
  xdg.configFile."nvim/lua/plugins/workflow/sessions.lua".source = ./config/nvim/lua/plugins/workflow/sessions.lua;
  xdg.configFile."nvim/lua/plugins/workflow/buffers.lua".source = ./config/nvim/lua/plugins/workflow/buffers.lua;
  xdg.configFile."nvim/lua/plugins/workflow/search_replace.lua".source = ./config/nvim/lua/plugins/workflow/search_replace.lua;
  xdg.configFile."nvim/lua/plugins/workflow/terminal.lua".source = ./config/nvim/lua/plugins/workflow/terminal.lua;
  xdg.configFile."nvim/lua/plugins/navigation/init.lua".source = ./config/nvim/lua/plugins/navigation/init.lua;
  xdg.configFile."nvim/lua/plugins/navigation/flash.lua".source = ./config/nvim/lua/plugins/navigation/flash.lua;
  xdg.configFile."nvim/lua/plugins/navigation/trouble.lua".source = ./config/nvim/lua/plugins/navigation/trouble.lua;
  xdg.configFile."nvim/lua/plugins/navigation/todo_comments.lua".source = ./config/nvim/lua/plugins/navigation/todo_comments.lua;
  xdg.configFile."nvim/lua/snippets/nix.lua".source = ./config/nvim/lua/snippets/nix.lua;
  xdg.configFile."nvim/lua/snippets/cs.lua".source = ./config/nvim/lua/snippets/cs.lua;
  xdg.configFile."nvim/lua/snippets/typescript.lua".source = ./config/nvim/lua/snippets/typescript.lua;
  xdg.configFile."nvim/lua/snippets/sql.lua".source = ./config/nvim/lua/snippets/sql.lua;
  xdg.configFile."nvim/lua/plugins/ui/init.lua".source = ./config/nvim/lua/plugins/ui/init.lua;
  xdg.configFile."nvim/lua/plugins/ui/theme.lua".source = ./config/nvim/lua/plugins/ui/theme.lua;
  xdg.configFile."nvim/lua/plugins/ui/lualine.lua".source = ./config/nvim/lua/plugins/ui/lualine.lua;
  xdg.configFile."nvim/lua/plugins/ui/smooth_scroll.lua".source = ./config/nvim/lua/plugins/ui/smooth_scroll.lua;
  xdg.configFile."nvim/lua/plugins/ui/neotree.lua".source = ./config/nvim/lua/plugins/ui/neotree.lua;
  xdg.configFile."nvim/lua/plugins/ui/incline.lua".source = ./config/nvim/lua/plugins/ui/incline.lua;
  xdg.configFile."nvim/lua/plugins/ui/telescope.lua".source = ./config/nvim/lua/plugins/ui/telescope.lua;
  xdg.configFile."nvim/lua/plugins/ui/which_key.lua".source = ./config/nvim/lua/plugins/ui/which_key.lua;
  xdg.configFile."nvim/lua/plugins/ui/notify.lua".source = ./config/nvim/lua/plugins/ui/notify.lua;
  xdg.configFile."nvim/lua/plugins/ui/noice.lua".source = ./config/nvim/lua/plugins/ui/noice.lua;
  xdg.configFile."nvim/lua/plugins/ui/alpha.lua".source = ./config/nvim/lua/plugins/ui/alpha.lua;
  xdg.configFile."nvim/lua/plugins/ui/toggles.lua".source = ./config/nvim/lua/plugins/ui/toggles.lua;
  xdg.configFile."nvim/lua/plugins/ui/bufferline.lua".source = ./config/nvim/lua/plugins/ui/bufferline.lua;
  xdg.configFile."nvim/lua/plugins/ui/dressing.lua".source = ./config/nvim/lua/plugins/ui/dressing.lua;

  xdg.configFile."nvim/lua/plugins/lsp/init.lua".source = ./config/nvim/lua/plugins/lsp/init.lua;
  xdg.configFile."nvim/lua/plugins/lsp/mason.lua".source = ./config/nvim/lua/plugins/lsp/mason.lua;
  xdg.configFile."nvim/lua/plugins/lsp/lspconfig.lua".source = ./config/nvim/lua/plugins/lsp/lspconfig.lua;
  xdg.configFile."nvim/lua/plugins/lsp/roslyn.lua".source = ./config/nvim/lua/plugins/lsp/roslyn.lua;
  xdg.configFile."nvim/lua/plugins/lsp/actions.lua".source = ./config/nvim/lua/plugins/lsp/actions.lua;
  xdg.configFile."nvim/lua/plugins/lsp/fidget.lua".source = ./config/nvim/lua/plugins/lsp/fidget.lua;
  xdg.configFile."nvim/lua/plugins/lsp/cmp.lua".source = ./config/nvim/lua/plugins/lsp/cmp.lua;
  xdg.configFile."nvim/lua/plugins/lsp/conform.lua".source = ./config/nvim/lua/plugins/lsp/conform.lua;

  home.activation.neovimLazyLockMigration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    state_lock="$HOME/.local/state/nvim/lazy-lock.json"
    old_lock="$HOME/.config/nvim/lazy-lock.json"

    mkdir -p "$HOME/.local/state/nvim"
    if [ -f "$old_lock" ] && [ ! -f "$state_lock" ]; then
      cp "$old_lock" "$state_lock" || true
    fi
    rm -f "$old_lock" || true
  '';
}
