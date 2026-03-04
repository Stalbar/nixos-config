{ ... }:

{
  xdg.configFile."psql/psqlrc".text = ''
    \set ON_ERROR_STOP on
    \set ON_ERROR_ROLLBACK interactive

    \set PROMPT '%[%033[1;35m%]%/%[%033[0m%] %[%033[1;34m%]%n%[%033[0m%]%x %# '

    \x auto
    \pset null '¤'
    \pset linestyle unicode
    \pset unicode_border_linestyle single
    \pset unicode_column_linestyle single
    \pset unicode_header_linestyle double
    \pset pager on

    SET intervalstyle TO 'postgres_verbose';

    \setenv PAGER 'less -iMFXRS'
    \setenv EDITOR 'nvim'
  '';

  home.sessionVariables.PSQLRC = "$HOME/.config/psql/psqlrc";
}
