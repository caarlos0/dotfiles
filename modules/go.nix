{ pkgs, ... }: {
  programs.fish.interacticeShellInit = ''
    fish_add_path -p ~/Developer/Go/bin
  '';
  programs.go = {
    enable = true;
    package = pkgs.go_1_22;
    goPath = "Developer/Go";
    goPrivate = [
      "github.com/caarlos0"
      "github.com/charmbracelet"
      "github.com/goreleaser"
    ];
  };
}
