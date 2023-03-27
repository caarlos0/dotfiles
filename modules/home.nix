{ config, pkgs, ... }: {
  home.username = "carlos";
  home.homeDirectory = "/Users/carlos";
  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    age
    cosign
    curl
    fd
    fzf
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
    terminal-notifier
    terraform
    tldr
    vegeta
    yamllint

    # TODO:
    # rar # unfree
    # fork-cleaner
    # jsonschema
    # jsonfmt
    # markscribe
    # svu
    # timer

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

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

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
    PROJECTS = "~/Developer";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile."yamllint/config" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config/yamllint.yml;
  };

  # imports = [] ++ (optionals isLinux [./linux.nix]);
  # imports = [ ] ++ (optionals isDarwin [ ./darwin.nix ]);
}
