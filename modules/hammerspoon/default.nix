{ config, ... }: {
  home.file.".hammerspoon/init.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./init.lua;
  };
}
