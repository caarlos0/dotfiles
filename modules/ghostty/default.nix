{ config, ... }:
{
  xdg.configFile."ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
