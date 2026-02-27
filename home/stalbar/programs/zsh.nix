{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      palette = "nord";

      format = ''
$os$directory$git_branch$git_status$c$dart$dotnet$golang$java$lua$nodejs$php$python$rust$zig$fill$time
$character
'';

      palettes.nord = {
        nord0 = "#2E3440";
        nord1 = "#3B4252";
        nord2 = "#434C5E";
        nord3 = "#4C566A";
        nord4 = "#D8DEE9";
        nord5 = "#E5E9F0";
        nord6 = "#ECEFF4";
        nord7 = "#8FBCBB";
        nord8 = "#88C0D0";
        nord9 = "#81A1C1";
        nord10 = "#5E81AC";
        nord11 = "#BF616A";
        nord12 = "#D08770";
        nord13 = "#EBCB8B";
        nord14 = "#A3BE8C";
        nord15 = "#B48EAD";
      };

      os = {
        disabled = false;
        style = "bold fg:nord8";
        format = "[$symbol ]($style)";
      };

      os.symbols.NixOS = "";

      directory = {
        style = "bold fg:nord9";
        format = "[$path ]($style)";
        truncation_length = 5;
        truncation_symbol = "";
      };

      git_branch = {
        symbol = "";
        style = "bold fg:nord7";
        format = "[$symbol $branch ]($style)";
      };

      git_status = {
        style = "bold fg:nord7";
        format = "[$all_status$ahead_behind ]($style)";
        conflicted = "󰕚 ";
        ahead = "󰜷 ";
        behind = "󰜮 ";
        diverged = "󰃻 ";
        up_to_date = "";
        untracked = "󰞋 ";
        stashed = "󰏗 ";
        modified = "󰏫 ";
        staged = "󰐗 ";
        renamed = "󰏪 ";
        deleted = "󰍶 ";
      };

      c = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      dart = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      dotnet = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      golang = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      java = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      lua = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      nodejs = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      php = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      python = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      rust = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      zig = {
        symbol = " ";
        style = "bold fg:nord10";
        format = "[$symbol($version) ]($style)";
      };

      fill.symbol = " ";

      time = {
        disabled = false;
        time_format = "%H:%M";
        style = "bold fg:nord8";
        format = "[ $time ]($style)";
      };

      character = {
        success_symbol = "[❯](bold fg:nord8)";
        error_symbol = "[❯](bold fg:nord11)";
        vimcmd_symbol = "[❮](bold fg:nord8)";
        vimcmd_replace_one_symbol = "[❮](bold fg:nord15)";
        vimcmd_replace_symbol = "[❮](bold fg:nord15)";
        vimcmd_visual_symbol = "[❮](bold fg:nord13)";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions";
      }
      {
        name = "zsh-syntax-highlighting";
        src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
        "extract"
        "colored-man-pages"
        "docker"
        "kubectl"
      ];
    };

    shellAliases = {
      ".." = "cd ..";
      mkdir = "mkdir -p";
      vi = "nvim";
      ls = "eza --icons --group-directories-first";
      ll = "eza -lbF --git --icons";
      la = "eza -abghHliS --git --icons";
      lt = "eza --tree --level=2 --icons";
      rm = "trash";
      dc = "cd";

      cat = "bat --paging=never";
      preview = "bat --style=numbers --color=always";

      neofetch = "fastfetch";

      gs = "git status -sb";
      rebuild = "sudo nixos-rebuild switch --flake .#laptop";

      boost = "sudo tlp performance";
      quiet = "sudo tlp balanced";

      nv = "nvidia-offload";
      nvac = "nvidia_ac";
    };

    initContent = ''
      export PATH="$PATH:$HOME/.dotnet/tools"
      export PATH="$PATH:$HOME/.cargo/bin"
      export PATH="$PATH:$HOME/go/bin"
      export PATH="$PATH:$HOME/code/bash"

      export PNPM_HOME="/home/stalbar/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      export PATH="$HOME/.local/bin:$PATH"
      export PSQLRC="$HOME/.config/psql/psqlrc"

      nvidia_ac() {
        local ac_online=0
        local power_file

        for power_file in /sys/class/power_supply/AC*/online /sys/class/power_supply/ADP*/online /sys/class/power_supply/AC/online; do
          [ -f "$power_file" ] || continue
          if [ "$(cat "$power_file")" = "1" ]; then
            ac_online=1
            break
          fi
        done

        if [ "$ac_online" -ne 1 ]; then
          echo "On battery: refusing dGPU launch (use AC or run 'nv' manually)."
          return 1
        fi

        nvidia-offload "$@"
      }

      _up_or_accept_suggestion() {
        if [[ -n "$POSTDISPLAY" ]]; then
          zle autosuggest-accept
        else
          zle up-line-or-history
        fi
      }
      zle -N _up_or_accept_suggestion
      bindkey '^[[A' _up_or_accept_suggestion
    '';
  };
}
