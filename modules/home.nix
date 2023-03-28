{ pkgs, ... }: {
  home.username = "carlos";
  home.homeDirectory = (if pkgs.stdenv.isDarwin then "/Users/" else "/home/")
    + "carlos";
  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    age
    comma
    cosign
    curl
    fd
    gh
    go-task
    htmltest
    htop
    httpstat
    hugo
    hyperfine
    inetutils
    jq
    kubectl
    kubectx
    kubernetes-helm
    moreutils
    nmap
    nodejs
    p7zip
    ripgrep
    sqlite
    sshpass
    stern
    terraform
    timer
    tldr
    vegeta

    # TODO:
    # rar # unfree
    # fork-cleaner
    # jsonschema
    # jsonfmt
    # markscribe
    # svu

    # gui apps
    # 1password-gui
    # airflow
    # blackhole-2ch
    # cleanshot
    # dash5
    # deckset
    # discord
    # font-jetbrains-mono-nerd-font
    # google-chrome
    # iina
    # imageoptim
    # keybase
    # kitty
    # ledger-live
    # monodraw
    # postico
    # rectangle
    # sensei
    # signal
    # slack
    # soulver
    # subtitles
    # telegram
    # vlc
    # whatsapp-beta
    # zoom

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs = {
    fzf = {
      enable = true;
      colors = {
        "bg+" = "#1e1e2e";
        "fg+" = "#cdd6f4";
        "hl+" = "#f38ba8";
        bg = "#000000";
        fg = "#cdd6f4";
        header = "#f38ba8";
        hl = "#f38ba8";
        info = "#cba6f7";
        marker = "#f5e0dc";
        pointer = "#f5e0dc";
        prompt = "#cba6f7";
        spinner = "#f5e0dc";
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/carlos/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PROJECTS = "$HOME/Developer";
  };

  # imports = [] ++ (optionals isLinux [./linux.nix]);
  # imports = [ ] ++ (optionals isDarwin [ ./darwin.nix ]);
}
