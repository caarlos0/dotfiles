{ pkgs, config, ... }: {
  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ./init.fish;
    interactiveShellInit = builtins.readFile ./init-interactive.fish;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAliases = {
      # docker
      d = "docker";
      dp = "podman";

      # git
      g = "git";
      gl = "git pull --prune";
      glg = "git log --graph --decorate --oneline --abbrev-commit";
      glga = "glg --all";
      gp = "git push origin HEAD";
      gpa = "git push origin --all";
      gd = "git diff";
      gc = "git commit -s";
      gca = "git commit -sa";
      gco = "git checkout";
      gb = "git branch -v";
      ga = "git add";
      gaa = "git add -A";
      gcm = "git commit -sm";
      gcam = "git commit -sam";
      gs = "git status -sb";
      glnext = "git log --oneline (git describe --tags --abbrev=0 @^)..@";
      gw = "git switch";
      gm = "git switch (git main-branch)";
      gms = "git switch (git main-branch); and git sync";
      egms = "e; git switch (git main-branch); and git sync";
      gwc = "git switch -c";

      # go
      gmt = "go mod tidy";
      grm = "go run ./...";

      # kubectl
      kx = "kubectx";
      kn = "kubens";
      k = "kubectl";
      sk = "kubectl -n kube-system";
      kg = "kubectl get";
      kgp = "kubectl get po";
      kga = "kubectl get --all-namespaces";
      kd = "kubectl describe";
      kdp = "kubectl describe po";
      krm = "kubectl delete";
      ke = "kubectl edit";
      kex = "kubectl exec -it";
      kdebug = ''
        kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never
      '';
      knrunning = "kubectl get pods --field-selector=status.phase!=Running";
      kfails = ''
        kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l
      '';
      kimg = ''
        kubectl get deployment --output=jsonpath='{.spec.template.spec.containers[*].image}'
      '';
      kvs = "kubectl view-secret";
      kgno = "kubectl get no --sort-by=.metadata.creationTimestamp";
      kdrain = "kubectl drain --ignore-daemonsets --delete-local-data";

      # neovim
      e = "nvim";
      v = "nvim";
      vim = "nvim";

      # terraform
      tf = "terraform";

      # tmux
      ta = "tmux-new";
    };
  };

  xdg.configFile."fish/functions" = {
    source = config.lib.file.mkOutOfStoreSymlink ./functions;
  };
}
