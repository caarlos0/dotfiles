{ config, ... }: {
  home.file.".bin" = {
    source = config.lib.file.mkOutOfStoreSymlink ./bins;
    recursive = true;
  };
}
