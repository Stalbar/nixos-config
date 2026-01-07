{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      palette = "rose_pine";

      format = 
        "[](rose)" +
        "$os" +
        "[](bg:gold fg:rose)" +
        "$directory" +
        "[](fg:gold bg:foam)" +
        "$git_branch" +
        "$git_status" +
        "[](fg:foam bg:pine)" +
        "$dart" +
        "$lua" +
        "$dotnet" +
        "$nodejs" +
        "$python" +
        "[](fg:pine bg:muted)" +
        "$cmd_duration" +
        "[](fg:muted)" +
        "$line_break" +
        "$character";

      palettes.rose_pine = {
        base   = "#1f1d2e";
        rose   = "#ebbcba";
        gold   = "#f6c177";
        foam   = "#9ccfd8";
        pine   = "#31748f";
        muted  = "#524f67";
        text   = "#e0def4";
      };

      os = {
        disabled = false;
        style = "bg:rose fg:base";
        symbols.NixOS = " ";
      };

      directory = {
        style = "bg:gold fg:base";
        format = "[ $path ]($style)";
        truncation_length = 6;
        truncate_to_repo = false;
      };

      git_branch = {
        symbol = " ";
        style = "bg:foam fg:base";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:foam fg:base";
        format = "[($all_status$ahead_behind )]($style)";
      };

      dart = {
        symbol = " ";
        style = "bg:pine fg:base";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        symbol = " ";
        style = "bg:pine fg:base";
        format = "[ $symbol ($version) ]($style)";
      };

      lua = {
        symbol = " ";
        style = "bg:pine fg:base";
        format = "[ $symbol ($version) ]($style)";
      };

      nodejs = {
        symbol = " ";
        style = "bg:pine fg:base";
        format = "[ $symbol ($version) ]($style)";
      };

      dotnet = {
        symbol = " ";
        style = "bg:pine fg:base";
        format = "[ $symbol ($version) ]($style)";
      };

      cmd_duration = {
        min_time = 500;
        style = "bg:muted fg:text";
        format = "[  $duration ]($style)";
      };

      character = {
        success_symbol = "[➜](bold #31748f)"; 
        error_symbol   = "[✗](bold #ebbcba)";
      };
    };
  };
}

