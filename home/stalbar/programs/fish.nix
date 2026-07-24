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
      c = "clear";
      v = "neovide --no-fork";
      vim = "nvim";
      ls = "eza --icons";
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      lt = "eza --tree --icons";
      cat = "bat";
      
      # Git Aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add -A";
      gc = "git commit -m";
      gp = "git push";
      gpl = "git pull";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";

      # NixOS System Aliases
      rebuild = "sudo nixos-rebuild switch --flake /home/stalbar/nixos-config#laptop";
      nrs = "sudo nixos-rebuild switch --flake /home/stalbar/nixos-config#laptop";
      nrb = "sudo nixos-rebuild boot --flake /home/stalbar/nixos-config#laptop";
      nhs = "nh os switch /home/stalbar/nixos-config#laptop";
      nclean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
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
