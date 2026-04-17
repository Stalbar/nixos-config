{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  home = config.home.homeDirectory;
  opencodeSkill = source: {
    inherit source;
    force = true;
  };

  anthropicsSkills = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "690f15cac7f7b4c055c5ab109c79ed9259934081";
    hash = "sha256-GMXFJSePrpEvhzMQ82YI9Z10BDkuFK/lXUDELclvQ4c=";
  };
  mattPocockSkills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "b8be62ffacb0118fa3eaa29a0923c87c8c11985c";
    hash = "sha256-Qwuu27f95xgAJ4hdv/4TNahHhprCMIxl1H9f9ymEsno=";
  };
  superpowersSkills = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "f2cbfbefebbfef77321e4c9abc9e949826bea9d7";
    hash = "sha256-3E3rO6hR87JUfS3XV1Eaoz6SDWOftleWvN9UPNFEMjw=";
  };
  supabaseSkills = pkgs.fetchFromGitHub {
    owner = "supabase";
    repo = "agent-skills";
    rev = "4e69c80e213f315c02c9ebef9c28dd6e43a4707e";
    hash = "sha256-rtjuMnaUlDE5979eBuFvDYwuMA+95dUjY2San42E77Q=";
  };
  vercelAgentSkills = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-skills";
    rev = "18a24346600009dc3fcb99e4b2cd83b301601775";
    hash = "sha256-JgnV4iymr62+tgviz8ojrCKO1CAPLPe8Vhdb0CVVzUg=";
  };
  vercelNextSkills = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "next-skills";
    rev = "dc1de9caf7612d73f56a8dec3cb1bd6c9ec096b9";
    hash = "sha256-w9sdMOFGuDnGULNTaZ8QU92YkvYebevc5Xg+87NHAI0=";
  };
  codeReviewSkill = pkgs.fetchFromGitHub {
    owner = "awesome-skills";
    repo = "code-review-skill";
    rev = "65079305d9e996f02a0e56421d7c6d2b623fe587";
    hash = "sha256-ym+v5HMdl42rcLQPYrox1px3pntd+5txj32xFq6wDJ4=";
  };

  agentmemorySrc = inputs.agentmemory;

  agentmemoryPluginJs = pkgs.stdenv.mkDerivation {
    name = "agentmemory-capture.js";
    src = "${agentmemorySrc}/plugin/opencode/agentmemory-capture.ts";
    dontUnpack = true;
    buildInputs = [ pkgs.typescript ];

    buildPhase = ''
      mkdir -p node_modules/@opencode-ai/plugin
      cat > node_modules/@opencode-ai/plugin/index.d.ts << TYPESEOF
      export interface PluginInput {
        worktree?: string;
        project?: { id?: string };
        sessionID?: string;
        agent?: string;
        model?: { providerID: string; id: string; api?: { url?: string }; limit?: { output?: number; context?: number }; cost?: { input?: number; output?: number } };
        tool?: string;
      }
      export type Plugin = (input: PluginInput) => Promise<Record<string, any>>;
      TYPESEOF
      cat > node_modules/@opencode-ai/plugin/package.json << PKGEOF
      { "name": "@opencode-ai/plugin", "types": "index.d.ts" }
      PKGEOF

      mkdir -p node_modules/@types/node
      cat > node_modules/@types/node/index.d.ts << NTEOF
      declare var process: {
        env: { [key: string]: string | undefined };
        cwd(): string;
      };
      NTEOF
      cat > node_modules/@types/node/package.json << NPKGEOF
      { "name": "@types/node", "types": "index.d.ts" }
      NPKGEOF

      cat > tsconfig.json << TSEOF
      {
        "compilerOptions": {
          "target": "ES2022",
          "module": "ES2022",
          "moduleResolution": "node",
          "strict": false,
          "skipLibCheck": true,
          "outDir": "out",
          "declaration": false,
          "typeRoots": ["./node_modules/@types"]
        },
        "include": ["."]
      }
      TSEOF

      cp $src ./plugin.ts
      tsc
    '';

    installPhase = ''
      cp out/plugin.js $out
    '';
  };

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    model = "deepseek/deepseek-v4-flash";
    small_model = "deepseek/deepseek-v4-flash";
    autoupdate = true;
    share = "manual";
    lsp = true;
    formatter = true;

    plugin = [
      "superpowers@git+https://github.com/obra/superpowers.git"
      "openslimedit@latest"
      "opencode-pty"

    ];

    provider = {
      openrouter = {
        options = {
          apiKey = "{file:~/.config/opencode/openrouter-key}";
        };
        models = {
          "deepseek/deepseek-v4-flash" = {
            name = "DeepSeek V4 Flash";
          };
        };
      };
      openai = {
        options = {
          apiKey = "{env:OPENAI_API_KEY}";
        };
      };
      deepseek = {
        options = {
          apiKey = "{file:~/.config/opencode/deepseek-key}";
        };
        models = {
          "deepseek-v4-flash" = {
            name = "DeepSeek V4 Flash";
          };
          "deepseek-v4-pro" = {
            name = "DeepSeek V4 Pro";
          };
        };
      };
    };

    enabled_providers = [
      "deepseek"
      "openrouter"
      "openai"
    ];

    agent = {
      plan = {
        temperature = 0.1;
      };
      build = {
        temperature = 0.3;
      };
      "code-reviewer" = {
        description = "Reviews code for security, performance, maintainability, missing tests, behavioral gaps, and edge cases without editing files.";
        mode = "primary";
        temperature = 0.1;
        prompt = ''
          You are a focused code reviewer. Review with findings first, ordered by severity, with concrete file and line references when available.

          Focus on security risks, performance regressions, maintainability problems, behavioral gaps, missing tests, broken contracts, and edge cases. Do not edit files. Do not spend review budget on style-only issues unless they hide a real risk.

          For each finding, explain the impact, why the current code permits it, and the smallest practical fix. If there are no findings, say that clearly and call out residual risk or unverified areas.
        '';
        permission = {
          read = "allow";
          glob = "allow";
          grep = "allow";
          list = "allow";
          lsp = "allow";
          skill = {
            "*" = "allow";
          };
          edit = "deny";
          bash = "ask";
          task = "deny";
        };
      };
      "refactor-planner" = {
        description = "Creates a full refactoring plan from live code context without editing files.";
        mode = "primary";
        temperature = 0.2;
        prompt = ''
          You are a refactoring planner. Inspect the live codebase before proposing a plan. Do not edit files.

          Produce a complete, staged refactoring plan that preserves behavior and keeps risk controlled. Identify the current architecture, the friction points, the target shape, dependency ordering, files or modules likely to change, tests to add or update, validation commands, rollback points, and what should explicitly stay out of scope.

          Prefer small verifiable phases over broad rewrites. Call out unknowns and decisions that need user approval before implementation.
        '';
        permission = {
          read = "allow";
          glob = "allow";
          grep = "allow";
          list = "allow";
          lsp = "allow";
          skill = {
            "*" = "allow";
          };
          edit = "deny";
          bash = "ask";
          task = "deny";
        };
      };
    };

    compaction = {
      auto = true;
      prune = true;
      reserved = 10000;
    };

    watcher = {
      ignore = [
        ".git/**"
        ".direnv/**"
        ".devenv/**"
        ".next/**"
        ".turbo/**"
        ".venv/**"
        "__pycache__/**"
        "bin/**"
        "build/**"
        "coverage/**"
        "dist/**"
        "node_modules/**"
        "obj/**"
        "target/**"
        "tmp/**"
      ];
    };

    permission = {
      read = "allow";
      edit = "allow";
      glob = "allow";
      grep = "allow";
      list = "allow";
      lsp = "allow";
      skill = {
        "*" = "allow";
      };
      task = "allow";
      todowrite = "allow";
      webfetch = "allow";
      websearch = "allow";
      external_directory = {
        "*" = "ask";
        "${home}/code/**" = "allow";
        "${home}/nixos-config/**" = "allow";
      };
      bash = {
        "*" = "ask";
        "cat *" = "allow";
        "find *" = "allow";
        "git diff*" = "allow";
        "git log*" = "allow";
        "git show*" = "allow";
        "git status*" = "allow";
        "ls *" = "allow";
        "rg *" = "allow";
        "sed *" = "allow";
      };
    };
  };

in
{
  home.packages = [
    pkgs.opencode
  ];

  home.activation.agentmemoryInstall = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # Install iii-engine binary (agentmemory runtime dependency)
    III_BIN="${home}/.local/bin/iii"
    if [ ! -x "$III_BIN" ]; then
      mkdir -p "${home}/.local/bin"
      ${pkgs.curl}/bin/curl -fsSL \
        https://github.com/iii-hq/iii/releases/download/iii/v0.11.2/iii-x86_64-unknown-linux-gnu.tar.gz \
        | ${pkgs.gzip}/bin/gzip -d \
        | ${pkgs.gnutar}/bin/tar -x -C "${home}/.local/bin/"
      chmod +x "$III_BIN" 2>/dev/null || true
    fi

    # Install agentmemory globally for the server CLI
    if ! command -v agentmemory &>/dev/null; then
      ${pkgs.nodejs}/bin/npm install -g @agentmemory/agentmemory 2>/dev/null || true
    fi

    # Install agentmemory native skills (8 skills: recall, remember, recap, handoff, forget, commit-context, commit-history, session-history)
    if ! [ -d "${home}/.config/opencode/skills/agentmemory-recall" ]; then
      ${pkgs.nodejs}/bin/npx -y skills add rohitg00/agentmemory -a opencode 2>/dev/null || true
    fi
  '';

  xdg.configFile = {
    "opencode/opencode.json".text = (builtins.toJSON opencodeConfig) + "\n";

    # ── agentmemory plugin ──
    "opencode/plugins/agentmemory-capture.js".source = agentmemoryPluginJs;

    # ── agentmemory slash commands ──
    "opencode/commands/recall.md".source = "${agentmemorySrc}/plugin/opencode/commands/recall.md";
    "opencode/commands/remember.md".source = "${agentmemorySrc}/plugin/opencode/commands/remember.md";

    # ── existing skills ──
    "opencode/skills/brainstorming" = opencodeSkill "${superpowersSkills}/skills/brainstorming";
    "opencode/skills/frontend-design" = opencodeSkill "${anthropicsSkills}/skills/frontend-design";
    "opencode/skills/grill-me" = opencodeSkill "${mattPocockSkills}/skills/productivity/grill-me";
    "opencode/skills/improve-codebase-architecture" =
      opencodeSkill "${mattPocockSkills}/skills/engineering/improve-codebase-architecture";
    "opencode/skills/next-best-practices" =
      opencodeSkill "${vercelNextSkills}/skills/next-best-practices";
    "opencode/skills/supabase-postgres-best-practices" =
      opencodeSkill "${supabaseSkills}/skills/supabase-postgres-best-practices";
    "opencode/skills/using-superpowers" = opencodeSkill "${superpowersSkills}/skills/using-superpowers";
    "opencode/skills/vercel-react-best-practices" =
      opencodeSkill "${vercelAgentSkills}/skills/react-best-practices";
    "opencode/skills/code-review-skill" = opencodeSkill "${codeReviewSkill}";
  };
}
