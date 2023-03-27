{ pkgs, ... }: {
  # TODO: set things up
  home.packages = with pkgs; [
    yubikey-agent
    yubikey-manager
    # yubico-yubikey-manager
  ];
}
