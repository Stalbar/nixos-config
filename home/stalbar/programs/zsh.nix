{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
        "colored-man-pages"
        "docker"
        "kubectl"
      ];
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
      ];
    };

    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
    ];

    shellAliases = {
      ".." = "cd ..";
      m = "make";
      md = "mkdir -p";
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
      rebuild = "sudo nixos-rebuild switch --flake path:$HOME/nixos-config#laptop";
      upgrade = "cd $HOME/nixos-config && sudo nix flake update && sudo nixos-rebuild switch --flake path:$HOME/nixos-config#laptop";
      upgrade-dev = "cd $HOME/nixos-config && sudo nix flake lock --update-input nixpkgs --update-input home-manager && sudo nixos-rebuild switch --flake path:$HOME/nixos-config#laptop";

      gaming = "sudo tlp performance";
      quiet = "sudo tlp balanced";
      powersave = "sudo tlp power-saver";
      tlpstat = "sudo tlp-stat -s -p -t";
      devdown = "free_dev_ram";

      nvh = "nvim-dev-health";
      nvsync = "nvim-plugin-sync";
      tg-theme-nord = "xdg-open \"$HOME/Downloads/nord.tdesktop-theme\"";
      snap-root-list = "sudo snapper -c root list";
      snap-home-list = "sudo snapper -c home list";
      snap-root-now = "sudo snapper -c root create -d manual";
      snap-home-now = "sudo snapper -c home create -d manual";
      snap-root-rollback = "sudo snapper -c root rollback";

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

        for power_file in /sys/class/power_supply/AC*/online(N) /sys/class/power_supply/ADP*/online(N) /sys/class/power_supply/AC/online(N); do
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

      free_dev_ram() {
        local had_work=0
        local docker_ids profiles_json profiles profile

        if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
          docker_ids="$(docker ps -q)"
          if [ -n "$docker_ids" ]; then
            echo "Stopping running Docker containers..."
            printf '%s\n' "$docker_ids" | xargs -r docker stop >/dev/null
            had_work=1
          fi
        fi

        if command -v minikube >/dev/null 2>&1; then
          profiles_json="$(minikube profile list -o json 2>/dev/null || true)"
          if [ -n "$profiles_json" ] && command -v jq >/dev/null 2>&1; then
            profiles="$(printf '%s' "$profiles_json" | jq -r '.valid[]?.Name // empty' 2>/dev/null || true)"
            while IFS= read -r profile; do
              [ -n "$profile" ] || continue
              echo "Stopping minikube profile: $profile"
              minikube stop -p "$profile" >/dev/null 2>&1 || true
              had_work=1
            done <<< "$profiles"
          fi
        fi

        if [ "$had_work" -eq 0 ]; then
          echo "No running Docker containers or minikube profiles found."
        else
          echo "Runtime workloads stopped. Docker and Kubernetes tooling remain enabled."
        fi
      }

      _stalbar_apply_runtime_zsh_theme() {
        local theme_file="$HOME/.config/stalbar-theme/generated/zsh-theme.zsh"

        if [ -r "$theme_file" ]; then
          source "$theme_file"
        fi
      }

      autoload -Uz add-zsh-hook
      _stalbar_apply_runtime_zsh_theme
      add-zsh-hook precmd _stalbar_apply_runtime_zsh_theme

      _bind_history_arrows() {
        local up_widget="up-line-or-beginning-search"
        local down_widget="down-line-or-beginning-search"

        bindkey '^[[A' "$up_widget"
        bindkey '^[OA' "$up_widget"
        bindkey '^[[B' "$down_widget"
        bindkey '^[OB' "$down_widget"
        bindkey -M main '^[[A' "$up_widget"
        bindkey -M main '^[OA' "$up_widget"
        bindkey -M main '^[[B' "$down_widget"
        bindkey -M main '^[OB' "$down_widget"
        bindkey -M emacs '^[[A' "$up_widget"
        bindkey -M emacs '^[OA' "$up_widget"
        bindkey -M emacs '^[[B' "$down_widget"
        bindkey -M emacs '^[OB' "$down_widget"
        bindkey -M viins '^[[A' "$up_widget"
        bindkey -M viins '^[OA' "$up_widget"
        bindkey -M viins '^[[B' "$down_widget"
        bindkey -M viins '^[OB' "$down_widget"
        bindkey -M vicmd '^[[A' "$up_widget"
        bindkey -M vicmd '^[OA' "$up_widget"
        bindkey -M vicmd '^[[B' "$down_widget"
        bindkey -M vicmd '^[OB' "$down_widget"
      }

      _bind_history_arrows
      unfunction _bind_history_arrows
    '';
  };
}
