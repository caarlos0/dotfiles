{ config, ... }: {
  xdg.configFile."wezterm/wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
  };
}
