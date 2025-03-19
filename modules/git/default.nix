{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    git-lfs
  ];
  home.file.".ssh/allowed_signers".text =
    "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxWe2rXKoiO6W14LYPVfJKzRfJ1f3Jhzxrgjc/D4tU7";
  programs.git = {
    enable = true;
    userName = "Carlos Alexandro Becker";
    userEmail = "caarlos0@users.noreply.github.com";
    lfs = {
      enable = true;
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
      unshallow = "fetch --prune --tags --unshallow";
    };
    extraConfig = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingKey = "~/.ssh/id_ed25519";
      column.ui = "auto";
      core = {
        editor = "nvim";
        compression = -1;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        precomposeunicode = true;
      };
      branch = {
        sort = "-commiterdate";
      };
      tag = {
        sort = "version:refname";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = true;
      };
      advice = {
        addEmptyPathspec = false;
      };
      apply = {
        whitespace = "nowarn";
      };
      help = {
        autocorrect = 1;
      };
      grep = {
        extendRegexp = true;
        lineNumber = true;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };
      merge = {
        conflictStyle = "zdiff3";
      };
      submodule = {
        fetchJobs = 4;
      };
      log = {
        showSignature = false;
      };
      format = {
        signOff = true;
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
    ignores = lib.splitString "\n" (builtins.readFile ./gitignore_global);
  };
}
