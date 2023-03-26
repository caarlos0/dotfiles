{ config, ... }: {
  home.file.".bin" = {
    source = config.lib.file.mkOutOfStoreSymlink ./bin;
    recursive = true;
  };
}
