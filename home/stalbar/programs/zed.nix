{ pkgs, lib, ... }:

let
  jsonFormat = pkgs.formats.json { };
  ph = value: "$" + "{" + value + "}";
  zedPackage =
    if builtins.hasAttr "zed-editor-fhs" pkgs then
      pkgs."zed-editor-fhs"
    else if builtins.hasAttr "zed-editor" pkgs then
      pkgs."zed-editor"
    else
      throw "Neither pkgs.\"zed-editor-fhs\" nor pkgs.\"zed-editor\" exists in this nixpkgs revision.";

  zedSettings = {
    vim_mode = true;
    base_keymap = "VSCode";
    autosave = "on_focus_change";
    theme = "Nord";
    auto_install_extensions = {
      nord = true;
      nix = true;
      csharp = true;
      ruff = true;
      "docker-compose" = true;
    };

    buffer_font_family = "JetBrainsMono Nerd Font Mono";
    buffer_font_size = 14;
    ui_font_size = 14;
    relative_line_numbers = "enabled";
    scroll_beyond_last_line = "vertical_scroll_margin";
    vertical_scroll_margin = 10;

    tab_bar = {
      show = false;
      show_nav_history_buttons = false;
      show_tab_bar_buttons = false;
    };

    toolbar = {
      breadcrumbs = true;
      quick_actions = true;
      selections_menu = true;
      agent_review = true;
      code_actions = true;
    };

    file_types = {
      SQL = [
        "psql"
        "pgsql"
      ];
    };

    languages = {
      Go = {
        formatter = "language_server";
        format_on_save = "on";
        hard_tabs = true;
        tab_size = 4;
      };

      CSharp = {
        formatter = "language_server";
        format_on_save = "on";
        tab_size = 4;
      };

      Python = {
        tab_size = 4;
        code_actions_on_format = {
          "source.organizeImports.ruff" = true;
        };
        formatter = {
          language_server = {
            name = "ruff";
          };
        };
      };

      Lua = {
        tab_size = 2;
        formatter = {
          external = {
            command = "stylua";
            arguments = [ "-" ];
          };
        };
      };

      Nix = {
        tab_size = 2;
        formatter = {
          external = {
            command = "nixfmt";
            arguments = [ ];
          };
        };
      };

      "Shell Script" = {
        tab_size = 2;
        formatter = {
          external = {
            command = "shfmt";
            arguments = [
              "-i"
              "2"
              "-ci"
              "-sr"
            ];
          };
        };
      };

      JavaScript = {
        tab_size = 2;
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      TypeScript = {
        tab_size = 2;
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      HTML = {
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      CSS = {
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      JSON = {
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      YAML = {
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      Markdown = {
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--stdin-filepath"
              "{buffer_path}"
            ];
          };
        };
      };

      SQL = {
        tab_size = 4;
        formatter = {
          external = {
            command = "pg_format";
            arguments = [
              "--no-rcfile"
              "--spaces"
              "2"
            ];
          };
        };
      };
    };

    lsp = {
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true;
              shadow = true;
            };
            staticcheck = true;
            gofumpt = true;
          };
        };
      };

      roslyn = {
        settings = {
          "csharp|code_style.formatting.indentation_and_spacing" = {
            tab_width = 4;
            indent_size = 4;
            indent_style = "space";
          };
          "csharp|background_analysis" = {
            dotnet_analyzer_diagnostics_scope = "fullSolution";
            dotnet_compiler_diagnostics_scope = "fullSolution";
          };
        };
      };
    };
  };

  zedKeymap = [
    {
      context = "Editor && vim_mode == insert";
      bindings = {
        "j k" = "vim::NormalBefore";
        "k j" = "vim::NormalBefore";
      };
    }
    {
      context = "Workspace";
      bindings = {
        "ctrl-s" = "workspace::Save";
        "ctrl-h" = "workspace::ActivatePaneLeft";
        "ctrl-j" = "workspace::ActivatePaneDown";
        "ctrl-k" = "workspace::ActivatePaneUp";
        "ctrl-l" = "workspace::ActivatePaneRight";
        "ctrl-up" = "workspace::IncreaseOpenDocksSize";
        "ctrl-down" = "workspace::DecreaseOpenDocksSize";
        "ctrl-left" = "workspace::DecreaseOpenDocksSize";
        "ctrl-right" = "workspace::IncreaseOpenDocksSize";
      };
    }
    {
      context = "EmptyPane || SharedScreen || vim_operator == none && !VimWaiting && vim_mode != insert";
      bindings = {
        "space n t t" = "project_panel::ToggleFocus";
        "space n t f" = "pane::RevealInProjectPanel";

        "space t f" = "file_finder::Toggle";
        "space t g" = "workspace::NewSearch";
        "space t b" = "tab_switcher::Toggle";
        "space t h" = "zed::OpenDocs";
        "space t p" = "projects::OpenRecent";

        "space d e" = "diagnostics::DeployCurrentFile";
        "space d q" = "diagnostics::Deploy";

        "space t t" = "editor::ToggleDiagnostics";
        "space t q" = "diagnostics::Deploy";
        "space x x" = "editor::ToggleDiagnostics";
        "space x shift-x" = "diagnostics::DeployCurrentFile";
        "space x q" = "diagnostics::Deploy";

        "space s o" = "outline_panel::ToggleFocus";
        "space s r" = [
          "pane::DeploySearch"
          {
            replace_enabled = true;
          }
        ];

        "space o t" = "workspace::NewTerminal";
        "space o s" = "terminal_panel::ToggleFocus";
        "space o v" = "terminal_panel::ToggleFocus";
        "space o shift-t" = "workspace::NewCenterTerminal";
        "f12" = "terminal_panel::ToggleFocus";

        "space t n" = "editor::SpawnNearestTask";
        "space t l" = "task::Rerun";
        "space t a" = "task::Spawn";
        "space t r" = [
          "task::Rerun"
          {
            reevaluate_context = true;
          }
        ];
      };
    }
    {
      context = "Editor && VimControl && !VimWaiting && !menu";
      bindings = {
        "space s h" = "pane::SplitHorizontal";
        "space s v" = "pane::SplitVertical";

        "space w h" = "workspace::MovePaneLeft";
        "space w j" = "workspace::MovePaneDown";
        "space w k" = "workspace::MovePaneUp";
        "space w l" = "workspace::MovePaneRight";
        "space w =" = "workspace::ResetOpenDocksSize";

        "tab" = "pane::ActivateNextItem";
        "shift-tab" = "pane::ActivatePreviousItem";
        "space b c" = "pane::CloseOtherItems";
        "space b d" = "pane::CloseActiveItem";

        "space g d" = "editor::GoToDefinition";
        "space g shift-d" = "editor::GoToDeclaration";
        "space g i" = "editor::GoToImplementation";
        "space g r" = "editor::FindAllReferences";
        "space r n" = "editor::Rename";
        "space r r" = "editor::Rename";
        "space c a" = "editor::ToggleCodeActions";
        "g a" = "editor::ToggleCodeActions";
        "shift-k" = "editor::Hover";

        "space f" = "editor::Format";

        "[ d" = "editor::GoToPreviousDiagnostic";
        "] d" = "editor::GoToDiagnostic";
        "[ x" = "editor::GoToPreviousDiagnostic";
        "] x" = "editor::GoToDiagnostic";

        "space s n" = "editor::GoToNextSymbol";
        "space s p" = "editor::GoToPreviousSymbol";

        "space /" = "editor::ToggleComments";
        "space ?" = "editor::ToggleComments";

        "] h" = "editor::GoToHunk";
        "[ h" = "editor::GoToPreviousHunk";
        "space g p" = "editor::ToggleSelectedDiffHunks";
        "space g b" = "editor::ToggleGitBlameInline";

        "space u e" = "editor::ToggleDiagnostics";
        "space u v" = "editor::ToggleInlineDiagnostics";
        "space u s" = "diagnostics::ToggleWarnings";
      };
    }
  ];

  snippets = {
    "zed/snippets/csharp.json" = {
      "Console.WriteLine" = {
        prefix = "cw";
        body = [ "Console.WriteLine($1);" ];
      };
      "Console.WriteLine Interpolated" = {
        prefix = "cwi";
        body = [ "Console.WriteLine($\"${ph "1:{value}"}\");" ];
      };
      "Property" = {
        prefix = "prop";
        body = [ "public ${ph "1:string"} ${ph "2:Name"} { get; set; }" ];
      };
      "Constructor" = {
        prefix = "ctor";
        body = [
          "public ${ph "1:ClassName"}(${ph "2"})"
          "{"
          "    $0"
          "}"
        ];
      };
      "Class" = {
        prefix = "class";
        body = [
          "public class ${ph "1:ClassName"}"
          "{"
          "    public ${ph "1:ClassName"}()"
          "    {"
          "        $0"
          "    }"
          "}"
        ];
      };
      "Try/Catch" = {
        prefix = "tryc";
        body = [
          "try"
          "{"
          "    $1"
          "}"
          "catch (Exception ex)"
          "{"
          "    ${ph "2:Console.Error.WriteLine(ex);"}"
          "}"
        ];
      };
    };

    "zed/snippets/nix.json" = {
      "Module" = {
        prefix = "nmod";
        body = [
          "{ config, lib, pkgs, ... }:"
          ""
          "{"
          "  $0"
          "}"
        ];
      };
      "mkIf" = {
        prefix = "mkif";
        body = [
          "lib.mkIf ${ph "1:condition"} {"
          "  $0"
          "};"
        ];
      };
      "mkEnableOption" = {
        prefix = "mken";
        body = [ "${ph "1:feature"} = lib.mkEnableOption \"${ph "2:Enable feature"}\";" ];
      };
      "mkOption" = {
        prefix = "mkopt";
        body = [
          "${ph "1:myOption"} = lib.mkOption {"
          "  type = lib.types.${ph "2:str"};"
          "  default = ${ph "3:\"\""};"
          "  description = \"${ph "4:Description"}\";"
          "};"
        ];
      };
      "Package" = {
        prefix = "pkg";
        body = [ "pkgs.${ph "1:packageName"}" ];
      };
    };

    "zed/snippets/sql.json" = {
      "Select" = {
        prefix = "sel";
        body = [
          "SELECT ${ph "1:*"}"
          "FROM ${ph "2:table_name"}"
          "WHERE ${ph "3:condition"};"
        ];
      };
      "Insert" = {
        prefix = "ins";
        body = [
          "INSERT INTO ${ph "1:table_name"} (${ph "2:column1, column2"})"
          "VALUES (${ph "3:value1, value2"});"
        ];
      };
      "Update" = {
        prefix = "upd";
        body = [
          "UPDATE ${ph "1:table_name"}"
          "SET ${ph "2:column = value"}"
          "WHERE ${ph "3:condition"};"
        ];
      };
      "Delete" = {
        prefix = "del";
        body = [
          "DELETE FROM ${ph "1:table_name"}"
          "WHERE ${ph "2:condition"};"
        ];
      };
      "CTE" = {
        prefix = "cte";
        body = [
          "WITH ${ph "1:cte_name"} AS ("
          "  ${ph "2:SELECT * FROM table_name"}"
          ")"
          "SELECT ${ph "3:*"}"
          "FROM ${ph "4:cte_name"};"
        ];
      };
    };

    "zed/snippets/typescript.json" = {
      "Import Named" = {
        prefix = "imp";
        body = [ "import { ${ph "1:name"} } from \"${ph "2:module"}\";" ];
      };
      "Import Default" = {
        prefix = "imd";
        body = [ "import ${ph "1:name"} from \"${ph "2:module"}\";" ];
      };
      "Function" = {
        prefix = "fn";
        body = [
          "const ${ph "1:fnName"} = (${ph "2"}) => {"
          "  $0"
          "};"
        ];
      };
      "Exported Function" = {
        prefix = "expfn";
        body = [
          "export const ${ph "1:fnName"} = (${ph "2"}) => {"
          "  $0"
          "};"
        ];
      };
      "Interface" = {
        prefix = "iface";
        body = [
          "interface ${ph "1:TypeName"} {"
          "  $0"
          "}"
        ];
      };
      "Console Log" = {
        prefix = "clg";
        body = [ "console.log(${ph "1:value"});" ];
      };
    };
  };
in
{
  home.packages = [ zedPackage ];

  xdg.configFile =
    {
      "zed/settings.json".source = jsonFormat.generate "zed-settings.json" zedSettings;
      "zed/keymap.json".source = jsonFormat.generate "zed-keymap.json" zedKeymap;
    }
    // lib.mapAttrs' (
      path: value:
      lib.nameValuePair path {
        source = jsonFormat.generate (builtins.baseNameOf path) value;
      }
    ) snippets;
}
