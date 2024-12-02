{ ... }:
{
  programs.fish.interactiveShellInit = ''
    fish_add_path -p ~/.cargo/bin/
  '';
}
