{ pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      vi = "nvim";
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
	"sudo"
      ];
    };
    autosuggestion.enable = true;

    initExtra = ''
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#31748f,bold'
    '';
  };
}
