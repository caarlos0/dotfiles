{ pkgs, ... }: {
  home.packages = with pkgs; [
    glow
    gum
    tz
    nur.repos.charmbracelet.freeze
    nur.repos.charmbracelet.mods
    nur.repos.charmbracelet.vhs
    nur.repos.charmbracelet.wishlist
  ];
}
