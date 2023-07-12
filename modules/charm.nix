{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    gitty
    glow
    gum
    melt
    nur.repos.caarlos0.mods
    tasktimer
    tz
    vhs
    nur.repos.charmbracelet.wishlist
  ];
}
