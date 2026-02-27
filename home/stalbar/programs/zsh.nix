{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status -sb";
      rebuild = "sudo nixos-rebuild switch --flake .#laptop";
      boost = "sudo tlp performance";
      quite = "sudo tlp balanced";
    };

    initExtra = ''
      fastfetch
    '';
  };
}
