{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
      if command -v zoxide >/dev/null 2>&1
        zoxide init fish | source
      end
    '';
    shellAliases = {
      cd = "z";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$line_break$character";
      character = {
        success_symbol = "[❯](bold #9ece6a)";
        error_symbol = "[❯](bold #f7768e)";
      };
      directory = {
        style = "bold #7dcfff";
      };
      git_branch = {
        style = "bold #bb9af7";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
