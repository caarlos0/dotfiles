{ config, ... }: {
  xdg.configFile."rio/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config.toml;
  };
}
