{ pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "stalbar";
    userEmail = "aleksey.smorshyok@gmail.com";
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      cm = "commit";
      last = "log -1 HEAD";
    };

    delta = {
      enable = true;
      options = {
	navigate = true;
	line-numbers = true;
	side-by-side = true;
      };
    };

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      #gpg.format = "ssh";
      #commit.gpgsign = "true";
      #user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
