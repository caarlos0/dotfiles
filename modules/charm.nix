{ pkgs, ... }: {

  home.packages = with pkgs; [ gitty gum melt tasktimer tz wishlist glow ];
}
