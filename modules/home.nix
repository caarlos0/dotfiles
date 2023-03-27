{ config, pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "carlos";
  home.homeDirectory = "/Users/carlos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    age
    cosign
    curl
    fd
    ffmpeg
    fzf
    gh
    gitty
    glow
    go-task
    gum
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
    melt
    moreutils
    nmap
    nodejs
    p7zip
    pinentry
    ripgrep
    sqlite
    sshpass
    stern
    stylua
    tasktimer
    terminal-notifier
    terraform
    tldr
    tz
    vegeta
    wishlist
    yamllint
    yubikey-agent
    yubikey-manager

    # TODO:
    # fork-cleaner
    # jsonschema
    # jsonfmt
    # markscribe
    # svu
    # timer

    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # gui apps
    # vlc

    #     1password
    # airflow
    # alacritty
    # amethyst
    # blackhole-2ch
    # cleanshot
    # dash5
    # deckset
    # discord
    # firefox
    # font-jetbrains-mono-nerd-font
    # font-sf-mono
    # font-sf-mono-for-powerline
    # google-chrome
    # iina
    # imageoptim
    # keybase
    # kitty
    # ledger-live
    # monodraw
    # ngrok
    # notion
    # postico
    # rar
    # rectangle
    # sensei
    # signal
    # slack
    # soulver
    # subtitles
    # telegram
    # vlc
    # whatsapp-beta
    # yubico-yubikey-manager
    # zoom

    # pkgs.wezterm
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile."yamllint/config" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config/yamllint.yml;
  };

  # imports = [] ++ (optionals isLinux [./linux.nix]);
  # imports = [ ] ++ (optionals isDarwin [ ./darwin.nix ]);
}
