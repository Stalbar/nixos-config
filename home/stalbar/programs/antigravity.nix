{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  superpowersSkills = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "f2cbfbefebbfef77321e4c9abc9e949826bea9d7";
    hash = "sha256-3E3rO6hR87JUfS3XV1Eaoz6SDWOftleWvN9UPNFEMjw=";
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
  cavemanSrc = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "655b7d9c5431f822264b7732e9901c5578ac84cf";
    hash = "sha256-BydREt/vai3j7kO5+e1OxsjXf6Vy+jSY1yA/yyxjHbI=";
  };
  ponytailSrc = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "dedc97ca7c8a1e7463ac5b36f7fe4b28c3c435a2";
    hash = "sha256-YUHjZfCTOIWrHJUUvnuoRSNG/l7wBuMQx/EdRdbLO3w=";
  };
  cavemanAgentsMd =
    let
      cavemanRules = builtins.readFile "${cavemanSrc}/src/rules/caveman-activate.md";
    in
    ''
      <!-- caveman-begin -->
      ${cavemanRules}<!-- caveman-end -->
    '';

  mkSkill = source: {
    inherit source;
    force = true;
  };

  skills = {
    "brainstorming" = "${superpowersSkills}/skills/brainstorming";
    "frontend-design" = "${anthropicsSkills}/skills/frontend-design";
    "grill-me" = "${mattPocockSkills}/skills/productivity/grill-me";
    "improve-codebase-architecture" = "${mattPocockSkills}/skills/engineering/improve-codebase-architecture";
    "next-best-practices" = "${vercelNextSkills}/skills/next-best-practices";
    "supabase-postgres-best-practices" = "${supabaseSkills}/skills/supabase-postgres-best-practices";
    "using-superpowers" = "${superpowersSkills}/skills/using-superpowers";
    "vercel-react-best-practices" = "${vercelAgentSkills}/skills/react-best-practices";
    "code-review-skill" = codeReviewSkill;
    "caveman" = "${cavemanSrc}/skills/caveman";
    "caveman-commit" = "${cavemanSrc}/skills/caveman-commit";
    "caveman-compress" = "${cavemanSrc}/skills/caveman-compress";
    "caveman-help" = "${cavemanSrc}/skills/caveman-help";
    "caveman-review" = "${cavemanSrc}/skills/caveman-review";
    "caveman-stats" = "${cavemanSrc}/skills/caveman-stats";
    "cavecrew" = "${cavemanSrc}/skills/cavecrew";
    "ponytail" = "${ponytailSrc}/skills/ponytail";
    "ponytail-review" = "${ponytailSrc}/skills/ponytail-review";
  };

  cliSkills = lib.mapAttrs' (name: path: lib.nameValuePair ".gemini/antigravity-cli/skills/${name}" (mkSkill path)) skills;
  globalSkills = lib.mapAttrs' (name: path: lib.nameValuePair ".gemini/config/skills/${name}" (mkSkill path)) skills;
in
{
  home.file = {
    ".gemini/antigravity-cli/AGENTS.md" = {
      text = cavemanAgentsMd;
      force = true;
    };
  } // cliSkills // globalSkills;
}
