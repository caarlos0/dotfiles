{ pkgs, ... }: {
  home.packages = with pkgs; [ gitty glow gum melt tasktimer tz vhs wishlist ];
}
