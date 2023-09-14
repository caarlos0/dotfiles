{ pkgs, ... }: {
  home.packages = with pkgs; [
    gitty
    glow
    gum
    melt
    tasktimer
    tz
    # nur.repos.charmbracelet.mods
    nur.repos.charmbracelet.vhs
    nur.repos.charmbracelet.wishlist
    nur.repos.charmbracelet.pop
  ];
}
