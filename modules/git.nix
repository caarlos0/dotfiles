{ pkgs, ... }: {
  home.packages = with pkgs; [
    git-lfs
  ];
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Carlos Alexandro Becker";
    userEmail = "caarlos0@users.noreply.github.com";
    signing = {
      key = "C4AEF954837E820358B990C4E61E2F7DC14AB940";
      signByDefault = true;
    };
    aliases = {
      co = "checkout";
      count = "shortlog -sn";
      g = "grep --break --heading --line-number";
      gi = "grep --break --heading --line-number -i";
      changed = ''show --pretty="format:" --name-only'';
      fm = "fetch-merge";
      please = "push --force-with-lease";
      commit = "commit -s";
      commend = "commit -s --amend --no-edit";
      lt = "log --tags --decorate --simplify-by-decoration --oneline";
    };
    extraConfig = {
      lfs = { enable = true; };
      core = {
        editor = "nvim";
        compression = -1;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        precomposeunicode = true;
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = true;
      };
      advice = { addEmptyPathspec = false; };
      apply = { whitespace = "nowarn"; };
      help = { autocorrect = 1; };
      grep = {
        extendRegexp = true;
        lineNumber = true;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      submodule = { fetchJobs = 4; };
      log = { showSignature = false; };
      format = { signOff = true; };
      rerere = { enabled = true; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
    };
    ignores = [
      ".DS_Store"
      ".svn"
      "*~"
      "*.swp"
      "*.orig"
      "*.rbc"
      ".idea"
      "*.iml"
      ".classpath"
      ".project"
      ".settings"
      ".ruby-version"
      ".vscode/"
      "Session.vim"
      "dump.rdb"
      "main.tfvars"
      "coverage.out"
      "coverage.txt"
      ".luarc.json"
      "*.log"
      ".env"
    ];

  };
}
