{ pkgs, ... }:

let
  rofiTheme = pkgs.writeText "rosepine-dark-hc.rasi" ''
    * {
        /* Rose Pine Dark High Contrast Palette */
        base:           #191724;
        surface:        #1f1d2e;
        overlay:        #26233a;
        muted:          #6e6a86;
        subtle:         #908caa;
        text:           #e0def4;
        love:           #eb6f92;
        gold:           #f6c177;
        rose:           #ebbcba;
        pine:           #31748f;
        foam:           #9ccfd8;
        iris:           #c4a7e7;

        /* Mapping variables from your template */
        bg-main:        @base;
        bg-element:     @surface;
        fg-main:        @text;
        accent:         #f6c177; /* Gold for high contrast */
        
        background-color: transparent;
        highlight: underline bold #f6c177;
        transparent: rgba(0,0,0,0);
        font: "JetBrainsMono Nerd Font 14";
    }

    configuration {
        modi: "drun,run,window";
        show-icons: true;
        display-drun: "   Apps ";
        display-run: "   Run ";
        display-window: "     Window ";
        drun-display-format: "{icon} {name}";
    }

    window {
        location: center;
        anchor:   center;
        border-radius: 10px;
        height: 560px;
        width: 600px;
        background-color: @transparent;
        spacing: 0;
        children:  [mainbox];
        orientation: horizontal;
    }

    mainbox {
        spacing: 0;
        children: [ inputbar, message, listview ];
    }

    message {
        padding: 10px;
        border:  0px 2px 2px 2px;
        border-color: @bg-main;
        background-color: @subtle;
        text-color: @base;
    }

    inputbar {
        color: @text;
        padding: 14px;
        background-color: @bg-main;
        border-color: @bg-main;
        border: 1px;
        border-radius: 10px 10px 0px 0px;
    }

    entry, prompt, case-indicator {
        text-font: inherit;
        text-color: inherit;
    }

    prompt {
        margin: 0px 1em 0em 0em;
        color: @gold;
    }

    listview {
        padding: 8px;
        border-radius: 0px 0px 10px 10px;
        border: 2px 2px 2px 2px;
        border-color: @bg-main;
        background-color: @bg-main;
        dynamic: false;
        lines: 7;
    }

    element {
        padding: 8px;
        vertical-align: 0.5;
        border-radius: 10px;
        background-color: @bg-element;
        text-color: @text;
    }

    element.normal.active {
        background-color: @foam;
        text-color: @base;
    }

    element.normal.urgent {
        background-color: @love;
        text-color: @base;
    }

    element.selected.normal {
        background-color: @gold; /* High contrast select */
        text-color: @base;
    }

    element.selected.active {
        background-color: @pine;
        text-color: @base;
    }

    element.selected.urgent {
        background-color: @rose;
        text-color: @base;
    }

    element.alternate.normal {
        background-color: @transparent;
    }

    element-text, element-icon {
        size: 3ch;
        margin: 0 10px 0 0;
        vertical-align: 0.5;
        background-color: inherit;
        text-color: inherit;
    }

    button {
        padding: 6px;
        color: @text;
        horizontal-align: 0.5;
        border: 2px;
        border-radius: 10px;
        border-color: @pine;
    }

    button.selected.normal {
        border: 2px;
        border-color: @gold;
        background-color: @overlay;
    }
  '';
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "${rofiTheme}";
  };
}

